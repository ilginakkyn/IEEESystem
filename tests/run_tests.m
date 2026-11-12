function T = run_tests(quick)
%RUN_TESTS  Modelin doğruluk ve tutarlılık testleri.
%   T = run_tests        % tüm testler (~20-30 dk)
%   T = run_tests(true)  % uzun benzetimler hariç (~5 dk)
%
%   Her test bir kabul ölçütüyle karşılaştırılır; sonuç ekrana ve
%   results/test_report.csv dosyasına yazılır. Testler üç gruptadır:
%     A) Yayınlanmış referanslar  (güç akışı, Sauer & Pai öz değerleri, SFR kapalı formu)
%     B) Fizik / analitik tutarlılık (başlangıç RoCoF'u, kalıcı durum droop dengesi,
%        SOC-enerji dengesi, 50/60 Hz ölçeklemesi, toplama ve sıfır-BESS limitleri)
%     C) Sayısal ve regresyon (denge artığı, zaman adımı, kayıtlı sonuçlarla aynılık)
if nargin < 1, quick = false; end
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(fullfile(root,'scenarios')); addpath(fullfile(root,'analytic'));
T = struct('id',{},'grp',{},'name',{},'value',{},'limit',{},'pass',{},'note',{});

%% ---------------------------------------------------------------- A) referanslar
% A1 Güç akışı: Anderson & Fouad Şekil 2.18 (|V| 3 basamak, açı 0,1°, P/Q 0,1 MW)
sc = struct('name','LF','f0',60);
[~, ~, V] = build_model(sc);
Vpub = [1.040 1.025 1.025 1.026 0.996 1.013 1.026 1.016 1.032];
Apub = [0 9.3 4.7 -2.2 -4.0 -3.7 3.7 0.7 2.0];
d = sysdata(); Y = ybus(d); Sinj = V .* conj(Y*V) * 100;
eV = max(abs(abs(V(:))' - Vpub)); eA = max(abs(angle(V(:))'*180/pi - Apub));
PQ = [real(Sinj(1)) imag(Sinj(1)) imag(Sinj(2)) imag(Sinj(3))]; PQpub = [71.6 27.0 6.7 -10.9];
eS = max(abs(PQ - PQpub));
T = add(T,'A1','A','Güç akışı |V| (pu), A&F Şekil 2.18', eV, 0.0006, 'yayın 3 basamak');
T = add(T,'A2','A','Güç akışı açı (°)', eA, 0.06, 'yayın 0,1° çözünürlük');
T = add(T,'A3','A','Güç akışı P1, Q1, Q2, Q3 (MW/Mvar)', eS, 0.1, sprintf('P1=%.2f Q1=%.2f Q2=%.2f Q3=%.2f', PQ));

% A4 Sauer & Pai Örnek 8.3 öz değerleri (60 Hz, sabit güç yükü, regülatörsüz)
sc = struct('name','SP','f0',60); sc.gov = {'none','none','none'};
sc.load = struct('ap',0,'aq',0,'kpf',0,'kqf',0);
L = linearize(sc);
SP = [-0.7209 12.7486; -0.1908 8.3672; -5.4875 7.9487; -5.3236 7.9220; -5.2218 7.8161; ...
      -0.4445 1.2104; -0.4394 0.7392; -0.4260 0.4960; -5.1761 0; -3.3995 0; -3.2258 0];
er = 0;
for k = 1:size(SP,1)
    tg = complex(SP(k,1), SP(k,2)); [~, j] = min(abs(L.lam - tg));
    er = max(er, abs(L.lam(j) - tg)/abs(tg));
end
nz = sum(abs(L.lam) < 1e-6);
T = add(T,'A4','A','Sauer & Pai öz değerleri, en büyük bağıl hata', er, 0.01, ...
    sprintf('%d sıfırdan farklı kök çifti/kök karşılaştırıldı; %d sıfır kök', size(SP,1), nz));

% A5 SFR kapalı formu = aynı denklemin sayısal çözümü
H = 4; D = 1; Rs = 0.05; FH = 0.3; TR = 7; dP = 0.1; t = (0:0.001:20)';
S1 = sfr_am(H, D, Rs, FH, TR, dP, 50, t);
w = 0; xr = 0; Wn = zeros(size(t));
for k = 1:numel(t)-1           % RK4: 2H dw/dt = Pm - D w - dP ; TR dPm/dt = -(w/R)(1 + FH TR s)...
    f1 = sfrode([w xr], H, D, Rs, FH, TR, dP); f2 = sfrode([w xr] + 0.0005*f1, H, D, Rs, FH, TR, dP);
    f3 = sfrode([w xr] + 0.0005*f2, H, D, Rs, FH, TR, dP); f4 = sfrode([w xr] + 0.001*f3, H, D, Rs, FH, TR, dP);
    y = [w xr] + 0.001/6*(f1 + 2*f2 + 2*f3 + f4); w = y(1); xr = y(2); Wn(k+1) = w;
end
e5 = max(abs(S1.f(:)/50 - 1 - Wn(:)))/max(abs(Wn));
T = add(T,'A5','A','SFR kapalı form ↔ sayısal çözüm (bağıl)', e5, 1e-4, '');

%% ---------------------------------------------------------------- B) fizik
% B1 Başlangıç RoCoF'u = salınım denklemi: df/dt(0+) = -ΣΔPe(0+) f0 / (2 Ek)
%    ΣΔPe(0+), olay anında makinelerin elektriksel gücündeki ani artıştır. Gerilime bağlı
%    yükler gerilim düşünce azaldığından ΣΔPe, 31,5 MW'tan biraz küçüktür; not sütununda verilir.
for s = {'S0','S2'}
    sc = scenario_lib(s{1}, 50, 'E1');
    [M, ~, V0] = build_model(sc);
    R = sim_run(sc, struct('t_end', 1.02, 'rec', 0.002));
    i0 = find(R.t >= 1.0 - 1e-9, 1);
    dPe = sum(R.Pe(i0+1,:)) - sum(R.Pe(i0-1,:));
    sl = (R.f(i0+3) - R.f(i0+1))/(R.t(i0+3) - R.t(i0+1));
    Ek = sum(M.mH)*100;                              % MWs (sistem bazında H)
    an = -dPe*50/(2*Ek);
    an0 = -31.5*50/(2*Ek);                           % yük gerilimi sabit varsayımıyla
    T = add(T,['B1-' s{1}],'B',sprintf('%s başlangıç RoCoF: benzetim / salınım denklemi', s{1}), ...
        abs(sl/an - 1), 0.02, sprintf('benzetim %.4f, analitik %.4f Hz/s; ΣΔPe(0+) = %.2f MW (31,5 MW ile %.4f)', ...
        sl, an, dPe, an0));
end

% B2-B3 Kalıcı durum: droop dengesi ve analitik oturma frekansı
if ~quick
    for s = {'S0','S5'}
        sc = scenario_lib(s{1}, 50, 'E1');
        [M, ~, V0] = build_model(sc);
        R = sim_run(sc, struct('t_end', 120, 'rec', 0.05));
        df = R.f(end) - 50; dfpu = df/50;
        beta = 0;                                     % pu güç / pu frekans (100 MVA bazı)
        for k = 1:M.nm, beta = beta + M.m(k).Srat/0.05; end
        if strcmp(s{1},'S5'), beta = beta + 0.40/0.02; end
        % Kalıcı durum güç dengesi:  β Δf = -(ΔP_yük(V) + ΔP_kayıp(V) + Kpf ΣP_yük Δf)
        %   ΔP_yük(V): olay + son gerilimlerle yük değişimi (yük modeli formülünden),
        %   ΔP_kayıp : ağ kayıplarındaki değişim, son gerilim fazörleri ve Y0'dan bağımsız hesap.
        b = d.loads(:,1); P0 = d.loads(:,2); P0e = P0; P0e(b == 6) = P0e(b == 6) + 0.315;
        Vf = (R.Vm(end,:) .* exp(1i*R.ang(end,:))).'; ap = M.sc.load.ap;
        Vr = abs(Vf(b))./abs(V0(b));                 % yük modeli: P = P0 (V/V0)^ap (1 + Kpf Δf)
        dPV = sum(P0e .* Vr.^ap) - sum(P0);
        loss = @(V) real(sum(V .* conj(Y*V)));       % ağ kaybı (pu): Y0 = hat + trafo
        dPloss = loss(Vf) - loss(V0(:));
        an = -(dPV + dPloss)/(beta + M.sc.load.kpf*sum(P0e .* Vr.^ap)) * 50;
        an0 = -0.315/(beta + M.sc.load.kpf*sum(P0e)) * 50;   % gerilim ve kayıp ihmal
        T = add(T,['B2-' s{1}],'B',sprintf('%s oturma frekansı: benzetim / güç dengesi analitiği', s{1}), ...
            abs(df/an - 1), 0.01, sprintf(['benzetim %.4f Hz, analitik %.4f Hz (120 s); yük gerilimi etkisi %.2f MW, ' ...
            'kayıp değişimi %+.2f MW; ikisi ihmal edilirse %.4f Hz'], df, an, 100*(dPV - 0.315), 100*dPloss, an0));
        % her makinenin ΔPm'si = -(S/R) Δf
        e = 0;
        for k = 1:M.nm
            dPm = R.Pm(end,k) - R.Pm(1,k); ex = -M.m(k).Srat/0.05*dfpu*100;
            e = max(e, abs(dPm - ex)/abs(ex));
        end
        T = add(T,['B3-' s{1}],'B',sprintf('%s regülatör kalıcı droop: ΔPm / (-(S/R)Δf)', s{1}), e, 0.02, '');
    end
end

% B4 SOC ↔ enerji dengesi (S5, E2)
sc = scenario_lib('S5', 50, 'E2');
R = sim_run(sc, struct('t_end', 10));
m = R.met; Eo = m.E_conv_MWh(end); dsoc = 0.5 - R.soc(end, end);
ex = Eo/(40*0.95);
T = add(T,'B4','B','SOC değişimi / (E_çıkış/(E·η))', abs(dsoc/ex - 1), 0.01, ...
    sprintf('ΔSOC %.5f, beklenen %.5f', dsoc, ex));

% B5 50/60 Hz ölçeklemesi
sc5 = scenario_lib('S5', 50, 'E1'); sc6 = scenario_lib('S5', 60, 'E1');
R5 = sim_run(sc5, struct('t_end', 8)); R6 = sim_run(sc6, struct('t_end', 8));
r1 = (60 - R6.met.nadir)/(50 - R5.met.nadir); r2 = R6.met.rocof500/R5.met.rocof500;
% pu eşdeğerlik COI frekansı için tamdır; makineler arası salınım frekansı sqrt(f0) ile
% ölçeklendiğinden 500 ms pencereli RoCoF'ta küçük (%1'in altında) bir sapma beklenir.
T = add(T,'B5a','B','60/50 Hz: nadir sapması oranı / 1,2 − 1', abs(r1/1.2 - 1), 0.001, sprintf('oran %.5f', r1));
T = add(T,'B5b','B','60/50 Hz: RoCoF500 oranı / 1,2 − 1', abs(r2/1.2 - 1), 0.01, ...
    sprintf('oran %.5f (salınım bileşeni f0 ile ölçeklenmez)', r2));

% B6 Toplama tutarlılığı: aynı barada 2 × 20 MVA = 1 × 40 MVA
sc = scenario_lib('S5', 50, 'E1'); sc.bess = [sc.bess sc.bess]; sc.bess(1).S = 20; sc.bess(2).S = 20;
Ra = sim_run(sc, struct('t_end', 6));
Rb = sim_run(scenario_lib('S5', 50, 'E1'), struct('t_end', 6));
T = add(T,'B6','B','2×20 MVA ↔ 1×40 MVA aynı barada, |Δnadir| (Hz)', abs(Ra.met.nadir - Rb.met.nadir), 1e-4, '');

% B7 Sıfır-BESS limiti: 0,001 MVA BESS = BESS yok
sc = scenario_lib('S5', 50, 'E1'); sc.bess.S = 0.001;
Rc = sim_run(sc, struct('t_end', 6)); Rd = sim_run(scenario_lib('S2', 50, 'E1'), struct('t_end', 6));
T = add(T,'B7','B','0,001 MVA BESS ↔ BESS yok, |Δnadir| (Hz)', abs(Rc.met.nadir - Rd.met.nadir), 1e-3, '');

% B8 Sentetik ataletsiz rüzgar = aynı güçte PV (S9a = S2)
Re = sim_run(scenario_lib('S9a', 50, 'E1'), struct('t_end', 6));
T = add(T,'B8','B','S9a (rüzgar, SI yok) ↔ S2 (PV), |Δnadir| (Hz)', abs(Re.met.nadir - Rd.met.nadir), 1e-3, '');

% B9 Düşük mertebeli doğrusal model ile tam model (nadir sapmasında)
sc = scenario_lib('S2', 50, 'E1'); Lm = lom_sim(sc, 10, 0.001);
e9 = abs((50 - Lm.met.nadir)/(50 - Rd.met.nadir) - 1);
T = add(T,'B9','B','Düşük mertebeli model ↔ tam model, nadir sapması (bağıl)', e9, 0.06, ...
    sprintf('DMM %.4f, tam %.4f Hz (ağ, gerilim, PLL farkı beklenir)', Lm.met.nadir, Rd.met.nadir));

%% ---------------------------------------------------------------- C) sayısal
% C1 Denge artığı
ids = {'S0','S1','S2','S3','S4','S5','S6','S7','S8b','S8c','S9b','S9c','S10'}; e = 0;
for i = 1:numel(ids)
    [M, x, V] = build_model(scenario_lib(ids{i}, 50, 'none'));
    e = max(e, max(abs(deriv(0, x, M, V, 1e-11, 60))));
end
T = add(T,'C1','C','Başlangıç denge artığı max|dx/dt| (13 senaryo)', e, 1e-6, '');

% C2 Zaman adımı: 1 ms ↔ 2 ms
Rf = sim_run(scenario_lib('S5', 50, 'E1'), struct('t_end', 6, 'dt', 0.001));
T = add(T,'C2','C','dt 1 ms ↔ 2 ms, |Δnadir| (Hz)', abs(Rf.met.nadir - Rb.met.nadir), 1e-5, '');

% C3 Regresyon: kayıtlı ana sonuçlarla aynılık
F = fullfile(root,'results','summary_all.csv');
if exist(F,'file')
    fid = fopen(F,'r'); hd = strsplit(fgetl(fid), ','); rows = {};
    while true, l = fgetl(fid); if ~ischar(l), break; end, rows{end+1} = strsplit(l, ','); end %#ok<AGROW>
    fclose(fid);
    jn = find(strcmp(hd,'nadir')); jr = find(strcmp(hd,'rocof500'));
    e = 0; R0 = struct('S2', Rd, 'S5', Rb);
    R0.S6 = sim_run(scenario_lib('S6', 50, 'E1'), struct('t_end', 6));
    for s = {'S2','S5','S6'}
        for i = 1:numel(rows)
            if strcmp(rows{i}{1}, ['A_' s{1} '_E1'])
                e = max(e, abs(str2double(rows{i}{jn}) - R0.(s{1}).met.nadir));
                e = max(e, abs(str2double(rows{i}{jr}) - R0.(s{1}).met.rocof500));
            end
        end
    end
    T = add(T,'C3','C','Kayıtlı sonuçlarla fark (S2/S5/S6 nadir ve RoCoF500)', e, 2e-4, 'kodun değişmediğinin kontrolü');
end

%% ---------------------------------------------------------------- rapor
np = sum([T.pass]);
fprintf('\n%-6s %-62s %12s %10s %s\n', 'Test', 'Açıklama', 'Değer', 'Sınır', 'Sonuç');
for k = 1:numel(T)
    st = 'GEÇTİ'; if ~T(k).pass, st = 'KALDI'; end
    fprintf('%-6s %-62s %12.3g %10.3g %s  %s\n', T(k).id, T(k).name, T(k).value, T(k).limit, st, T(k).note);
end
fprintf('\n%d / %d test geçti.\n', np, numel(T));
fid = fopen(fullfile(root,'results','test_report.csv'),'w');
fprintf(fid,'id,group,name,value,limit,pass,note\n');
for k = 1:numel(T)
    fprintf(fid,'%s,%s,"%s",%.6g,%.6g,%d,"%s"\n', T(k).id, T(k).grp, T(k).name, T(k).value, T(k).limit, T(k).pass, T(k).note);
end
fclose(fid);
end

function T = add(T, id, grp, name, v, lim, note)
T(end+1) = struct('id',id,'grp',grp,'name',name,'value',v,'limit',lim,'pass',v <= lim,'note',note);
fprintf('%-6s %s: %.3g (sınır %.3g)\n', id, name, v, lim);
end

function dy = sfrode(y, H, D, R, FH, TR, dP)
% Anderson-Mirheydar SFR: Pm = -(1/R)(1 + FH TR s)/(1 + TR s) w
w = y(1); xr = y(2);                 % xr: ara ısıtma durumu
Pm = -(FH/R)*w + xr;
dxr = (-(1-FH)/R*w - xr)/TR;
dw = (Pm - D*w - dP)/(2*H);
dy = [dw dxr];
end

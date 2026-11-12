function J = job_list()
%JOB_LIST  Rapordaki tüm zaman bölgesi koşularının listesi (id, senaryo, seçenekler).
J = struct('id',{},'grp',{},'sc',{},'opt',{});
L = struct('t_end',30);      % ana senaryolar
Sw = struct('t_end',15);     % taramalar

% ---- A. Senaryo matrisi (50 Hz, E1) ve ağır olay (E2)
ids = {'S0','S1','S2','S3','S4','S5','S6','S7','S8a','S8b','S8c','S9a','S9b','S9c','S10'};
for i = 1:numel(ids), J = add(J, ['A_' ids{i} '_E1'], 'A', scenario_lib(ids{i},50,'E1'), L); end
for i = {'S0','S2','S5','S6','S10'}, J = add(J, ['A_' i{1} '_E2'], 'A2', scenario_lib(i{1},50,'E2'), L); end
% G3 açması (N-1) baz durumda
sc = scenario_lib('S0',50,'none'); sc.events = struct('t',1,'type','gtrip','bus',3); sc.name = 'S0-G3trip';
J = add(J, 'A_S0_G3trip', 'A2', sc, L);

% ---- B. 60 Hz eşdeğerliği
for i = {'S0','S2','S5','S6'}, J = add(J, ['B_' i{1} '_60'], 'B', scenario_lib(i{1},60,'E1'), L); end

% ---- C. SNSP taraması
for p = 0:0.1:0.7
    for b = {'none','gfl','gfm'}
        J = add(J, sprintf('C_%02d_%s_prop', round(100*p), b{1}), 'C', snsp_case(p, b{1}, 'prop'), Sw);
    end
    J = add(J, sprintf('C_%02d_none_keep', round(100*p)), 'C', snsp_case(p, 'none', 'keep'), Sw);
end

% ---- D. GFL Hv x R ızgarası (S2 tabanı)
Hs = [0 4 8 16 32]; Rs = [Inf 0.08 0.04 0.02 0.01];
for h = Hs
    for r = Rs
        sc = scenario_lib('S2',50,'E1');
        if h > 0 || isfinite(r)
            sc.bess = struct('type','gfl','bus',2,'S',40,'Hv',h,'R',r);
        end
        sc.name = sprintf('D-GFL-H%d-R%g', h, r);
        J = add(J, sprintf('D_GFL_H%02d_R%s', h, rtag(r)), 'D', sc, Sw);
    end
end
for h = [1.25 4 8 16 32]                         % GFM: R = %2, Hv taraması
    sc = scenario_lib('S2',50,'E1'); sc.bess = struct('type','gfm','bus',2,'S',40,'Hv',h,'R',0.02);
    sc.name = sprintf('D-GFM-H%g', h);
    J = add(J, sprintf('D_GFM_H%s', strrep(sprintf('%g',h),'.','p')), 'D', sc, Sw);
end

% ---- E. Konum (tek 40 MVA BESS)
for b = 2:9
    for t = {'gfl','gfm'}
        sc = scenario_lib('S2',50,'E1'); sc.bess = struct('type',t{1},'bus',b,'S',40,'Hv',16,'R',0.02);
        sc.name = sprintf('E-%s-bus%d', t{1}, b);
        J = add(J, sprintf('E_%s_b%d', t{1}, b), 'E', sc, Sw);
    end
end

% ---- F. GFL ölçüm/kontrol gecikmesi (S5 tabanı)
for fn = [2 5 10 20]
    sc = scenario_lib('S5',50,'E1'); sc.bess.fn = fn; sc.name = sprintf('F-pll%g', fn);
    J = add(J, sprintf('F_pll%02d', fn), 'F', sc, Sw);
end
for Tr = [0.02 0.1 0.2]
    sc = scenario_lib('S5',50,'E1'); sc.bess.Tr = Tr; sc.name = sprintf('F-Tr%g', Tr);
    J = add(J, sprintf('F_Tr%03d', round(1000*Tr)), 'F', sc, Sw);
end
for Ti = [0.1 0.2 0.5]
    sc = scenario_lib('S5',50,'E1'); sc.bess.Ti = Ti; sc.name = sprintf('F-Ti%g', Ti);
    J = add(J, sprintf('F_Ti%03d', round(1000*Ti)), 'F', sc, Sw);
end
for db = [0.010 0.020 0.050]                     % ölü bant (Hz, 50 Hz bazında)
    sc = scenario_lib('S4',50,'E1'); sc.bess.db = db/50; sc.name = sprintf('F-db%g', db);
    J = add(J, sprintf('F_db%03d', round(1000*db)), 'F', sc, Sw);
end

% ---- G. Regülatör tipi, yük modeli
for i = {'S0','S2'}
    sc = scenario_lib(i{1},50,'E1'); sc.gov = {'steam','steam','steam'}; sc.name = [i{1} '-G1steam'];
    J = add(J, ['G_' i{1} '_G1steam'], 'G', sc, L);
end
lm = {'P', 0, 0; 'I', 1, 0; 'Z', 2, 0; 'Pf', 0, 1};
for k = 1:size(lm,1)
    sc = scenario_lib('S2',50,'E1'); sc.load = struct('ap',lm{k,2},'aq',2,'kpf',lm{k,3},'kqf',0);
    sc.name = ['S2-load' lm{k,1}];
    J = add(J, ['G_S2_load' lm{k,1}], 'G', sc, Sw);
end

% ---- H. BESS güç değeri (E2: akım sınırı devrede)
for S = [10 20 30 60]
    for t = {'gfl','gfm'}
        sc = scenario_lib('S2',50,'E2');
        sc.bess = struct('type',t{1},'bus',2,'S',S,'Hv',16*40/S,'R',0.02*S/40);  % sabit kazanç
        sc.name = sprintf('H-%s-S%d', t{1}, S);
        J = add(J, sprintf('H_%s_S%02d', t{1}, S), 'H', sc, Sw);
    end
end
for t = {'gfl','gfm'}                              % 40 MVA E2 de bu gruba
    sc = scenario_lib('S2',50,'E2'); sc.bess = struct('type',t{1},'bus',2,'S',40,'Hv',16,'R',0.02);
    sc.name = sprintf('H-%s-S40', t{1}); J = add(J, sprintf('H_%s_S40', t{1}), 'H', sc, Sw);
end

% ---- I. Bozulma büyüklüğü (doğrusallık)
for dP = [15 47 79]
    for i = {'S2','S5','S6'}
        sc = scenario_lib(i{1},50,'E1'); sc.events.dP = dP; sc.name = sprintf('%s-dP%d', i{1}, dP);
        J = add(J, sprintf('I_%s_dP%02d', i{1}, dP), 'I', sc, Sw);
    end
end

% ---- K. Zaman adımı yakınsaması
for dt = [0.004 0.001 0.0005]
    for i = {'S5','S6'}
        sc = scenario_lib(i{1},50,'E1'); sc.name = sprintf('%s-dt%g', i{1}, dt);
        J = add(J, sprintf('K_%s_dt%04d', i{1}, round(1e4*dt)), 'K', sc, struct('t_end',6,'dt',dt));
    end
end
for i = {'S5','S6'}
    sc = scenario_lib(i{1},50,'E1'); sc.name = sprintf('%s-dt0.002', i{1});
    J = add(J, sprintf('K_%s_dt0020', i{1}), 'K', sc, struct('t_end',6,'dt',0.002));
end
end

function J = add(J, id, grp, sc, opt)
J(end+1) = struct('id', id, 'grp', grp, 'sc', sc, 'opt', opt);
end
function s = rtag(r)
if isinf(r), s = 'inf'; else, s = sprintf('%03d', round(1000*r)); end
end

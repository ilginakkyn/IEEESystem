function T = collect_results(make_figs)
%COLLECT_RESULTS  results/*.mat dosyalarını tek tabloya toplar, CSV ve şekil üretir.
%   T = collect_results(true)
if nargin < 1, make_figs = true; end
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
rd = fullfile(root,'results'); fd = fullfile(root,'figures');
if ~exist(fd,'dir'), mkdir(fd); end
F = dir(fullfile(rd,'*.mat'));
F = F(~strncmp({F.name}, 'ss_', 3));
T = struct('id',{},'grp',{},'S',{});
hdr = {'Ek_MWs','rocof100','rocof500','rocof500max','nadir','t_nadir','f_qss','rocof_loc_max', ...
       'bus_loc_max','dPconv_max_MW','E_conv_MWh','soc_min','Vmin','cpu_s'};
X = nan(numel(F), numel(hdr)); ids = cell(numel(F),1);
for k = 1:numel(F)
    q = load(fullfile(rd, F(k).name)); S = q.S;
    T(k).id = S.id; T(k).grp = S.grp; T(k).S = S; ids{k} = S.id;
    m = S.met;
    [rl, bl] = max(abs(m.rocof_bus));
    dPm = NaN; Ec = NaN; sm = NaN;
    P = [S.Pg S.Pf]; npv = numel(S.sc.pv);
    if size(P,2) > npv
        cols = npv+1:size(P,2);                 % BESS ve rüzgar sütunları (PV hariç)
        dP = sum(P(:,cols) - repmat(P(1,cols), size(P,1), 1), 2);
        dPm = max(abs(dP)); Ec = trapz(S.t, dP)/3600;
        sm = min(min(S.soc(:,cols)));
    end
    X(k,:) = [S.Ek, m.rocof100, m.rocof500, m.rocof500max, m.nadir, m.t_nadir, m.f_qss, ...
              -rl, bl, dPm, Ec, sm, m.Vmin, S.cpu];
end
fid = fopen(fullfile(rd,'summary_all.csv'),'w');
fprintf(fid, 'id,%s\n', strjoin(hdr, ','));
for k = 1:numel(F)
    fprintf(fid, '%s,%s\n', ids{k}, strjoin(arrayfun(@(v) sprintf('%.6g', v), X(k,:), 'UniformOutput', false), ','));
end
fclose(fid);
fprintf('%d sonuç toplandı -> results/summary_all.csv\n', numel(F));
if make_figs, make_figures(T, fd); end
end

% ------------------------------------------------------------------------
function make_figures(T, fd)
if exist('OCTAVE_VERSION','builtin'), try, graphics_toolkit('gnuplot'); catch, end, end
get = @(id) T(strcmp({T.id}, id)).S;
has = @(id) any(strcmp({T.id}, id));
c = lines(8);
% F1: ana senaryolar
ids = {'A_S0_E1','A_S2_E1','A_S3_E1','A_S4_E1','A_S5_E1','A_S6_E1'};
lab = {'S0 baz','S2 PV (G2 yerine)','S3 GFL atalet','S4 GFL droop','S5 GFL atalet+droop','S6 GFM VSM'};
fig_traj(get, has, ids, lab, [0 15], fullfile(fd,'F1_ana_senaryolar.png'), 'E1: Bara 6 +31.5 MW, 50 Hz');
% F2: E2 (ağır olay)
ids = {'A_S0_E2','A_S2_E2','A_S5_E2','A_S6_E2','A_S10_E2'};
lab = {'S0 baz','S2 PV','S5 GFL','S6 GFM','S10 senkron kompansatör'};
fig_traj(get, has, ids, lab, [0 15], fullfile(fd,'F2_E2_agir_olay.png'), 'E2: Bara 6 +63 MW, 50 Hz');
% F3: BESS gücü GFL vs GFM
h = figure('visible','off'); hold on; grid on;
pairs = {'A_S5_E1','GFL (S5)'; 'A_S6_E1','GFM (S6)'; 'A_S5_E2','GFL E2'; 'A_S6_E2','GFM E2'};
for i = 1:size(pairs,1)
    if ~has(pairs{i,1}), continue; end
    S = get(pairs{i,1}); P = [S.Pg S.Pf]; p = P(:,end) - P(1,end);
    plot(S.t, p, 'LineWidth', 1.5, 'Color', c(i,:));
end
xlim([0.8 4]); xlabel('Zaman (s)'); ylabel('BESS gücü (MW)'); legend(pairs(:,2), 'Location','southeast');
title('BESS tepkisi: GFL ölçüm gecikmesi vs GFM anlık tepki'); print(h, fullfile(fd,'F3_bess_guc.png'), '-dpng', '-r110'); close(h);
% F4: SNSP taraması
h = figure('visible','off');
ps = 0:10:70; ty = {'none_prop','gfl_prop','gfm_prop','none_keep'};
tl = {'BESS yok (üniteler kapanır)','GFL-BESS','GFM-BESS','BESS yok (üniteler açık)'};
N = nan(numel(ps), 4); Rr = N;
for i = 1:numel(ps)
    for j = 1:4
        id = sprintf('C_%02d_%s', ps(i), ty{j});
        if has(id), S = get(id); N(i,j) = S.met.nadir; Rr(i,j) = S.met.rocof500; end
    end
end
subplot(2,1,1); plot(ps, N, '-o', 'LineWidth', 1.5); hold on; plot([0 70],[49.2 49.2],'k--'); grid on;
ylabel('Nadir (Hz)'); legend(tl, 'Location','southwest'); title('Yenilenebilir payı taraması (E1)');
subplot(2,1,2); plot(ps, Rr, '-o', 'LineWidth', 1.5); grid on; xlabel('SNSP (%)'); ylabel('RoCoF_{500} (Hz/s)');
print(h, fullfile(fd,'F4_snsp.png'), '-dpng', '-r110'); close(h);
% F5: rüzgar ve ikincil düşüş
ids = {'A_S2_E1','A_S9b_E1','A_S9c_E1'}; lab = {'S9a/S2 rüzgar, SI yok','S9b rüzgar sentetik atalet','S9c rüzgar + GFL-BESS'};
fig_traj(get, has, ids, lab, [0 30], fullfile(fd,'F5_ruzgar.png'), 'Tip-4 rüzgar: sentetik atalet ve ikincil düşüş');
% F6: G1 düşük atama
ids = {'A_S8a_E1','A_S8b_E1','A_S8c_E1','A_S2_E1'}; lab = {'S8a G1 %50, BESS yok','S8b + GFL','S8c + GFM','S2 (G1 tam)'};
fig_traj(get, has, ids, lab, [0 15], fullfile(fd,'F6_dusuk_atama.png'), 'G1 ünitelerinin yarısı kapalı');
end

function fig_traj(get, has, ids, lab, xl, f, ttl)
h = figure('visible','off'); hold on; grid on; k = 0; L = {};
for i = 1:numel(ids)
    if ~has(ids{i}), continue; end
    S = get(ids{i}); plot(S.t, S.f, 'LineWidth', 1.5); L{end+1} = lab{i}; %#ok<AGROW>
end
plot(xl, [49.2 49.2], 'k--'); L{end+1} = 'Tasarım sınırı 49,2 Hz';
xlim(xl); xlabel('Zaman (s)'); ylabel('f_{COI} (Hz)'); title(ttl); legend(L, 'Location','southeast');
print(h, f, '-dpng', '-r110'); close(h);
end

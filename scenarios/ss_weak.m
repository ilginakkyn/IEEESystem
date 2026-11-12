function ss_weak()
%SS_WEAK  Zayıf şebeke ve PLL bant genişliği küçük sinyal çalışması (GFL'lerde Q-V desteği açık).
%   Bara 2'nin şebekeye bağlantısı (T2 reaktansı) k kat büyütülür; PV 163 MW + BESS 40 MVA.
%   Her k için: kısa devre oranı (SCR), en sağdaki öz değer ve onu belirleyen durum.
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
out = fullfile(root,'results');
ks = 1:8;
cfg = {'S2','PV yalnız'; 'S5','GFL-BESS'; 'S6','GFM-BESS'};
W = []; lab = {};
for q = 1:numel(ks)
    for c = 1:size(cfg,1)
        sc = scenario_lib(cfg{c,1},50,'none'); sc.trafo_scale = [1 ks(q) 1]; sc.Kv = 2;
        [r, st] = analyze(sc);
        W(end+1,:) = [ks(q), c, scr_bus2(ks(q)), r]; %#ok<AGROW>
        lab{end+1} = st; %#ok<AGROW>
    end
end
write_csv(fullfile(out,'ss_weakgrid.csv'), {'k_T2','cfg','SCR_bus2','maxreal','f_Hz','zeta_min','lf_ok'}, W);
fid = fopen(fullfile(out,'ss_weakgrid_states.txt'),'w');
for i = 1:size(W,1), fprintf(fid,'k=%d cfg=%s SCR=%.2f maxRe=%.3f state=%s\n', W(i,1), cfg{W(i,2),2}, W(i,3), W(i,4), lab{i}); end
fclose(fid);
% PLL bant genişliği: güçlü (k=1) ve zayıf (k=6) şebeke
fns = [2 5 10 20 30 40];
P = [];
for q = 1:numel(fns)
    for k = [1 6]
        sc = scenario_lib('S5',50,'none'); sc.trafo_scale = [1 k 1]; sc.Kv = 2;
        sc.pll.fn = fns(q); sc.bess.fn = fns(q);
        r = analyze(sc);
        P(end+1,:) = [fns(q), k, r]; %#ok<AGROW>
    end
end
write_csv(fullfile(out,'ss_pll.csv'), {'fn_Hz','k_T2','maxreal','f_Hz','zeta_min','lf_ok'}, P);
fprintf('ss_weak tamam.\n');
end

function [r, st] = analyze(sc)
lastwarn('');
L = linearize(sc);
[~, id] = lastwarn(); lfok = ~strcmp(id, 'build_model:lf');
lam = L.lam; keep = abs(lam) > 1e-4;
lam2 = lam; lam2(~keep) = -Inf;
[mx, j] = max(real(lam2));
osc = abs(imag(lam)) > 1e-3 & keep;
[~, s] = max(L.PF(:, j)); st = L.names{s};
r = [mx, abs(imag(lam(j)))/(2*pi), min(L.zeta(osc)), lfok];
end

function s = scr_bus2(k)
d = sysdata(); d.trafos(2,3) = d.trafos(2,3)*k;
Y = ybus(d);
for gi = [1 3], b = d.gen(gi).bus; Y(b,b) = Y(b,b) + 1/(1i*d.gen(gi).xdp); end
Z = inv(Y);
s = (100/abs(Z(2,2)))/(163 + 40);
end

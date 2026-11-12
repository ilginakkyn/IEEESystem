function ss_study()
%SS_STUDY  Küçük sinyal çalışmaları: (a) Sauer & Pai doğrulaması, (b) senaryo öz değerleri.
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
out = fullfile(root,'results'); if ~exist(out,'dir'), mkdir(out); end

%% (a) Sauer & Pai Örnek 8.3: 60 Hz, sabit güç yükü, regülatörsüz, D = 0
sc = struct('name','SP-validation','f0',60); sc.gov = {'none','none','none'};
sc.load = struct('ap',0,'aq',0,'kpf',0,'kqf',0);
La = linearize(sc);
SP = [-0.7209 12.7486; -0.1908 8.3672; -5.4875 7.9487; -5.3236 7.9220; -5.2218 7.8161; ...
      -0.4445 1.2104; -0.4394 0.7392; -0.4260 0.4960; -5.1761 0; -3.3995 0; -3.2258 0];
lam = La.lam;
tab = zeros(size(SP,1), 4);
for k = 1:size(SP,1)
    tgt = complex(SP(k,1), SP(k,2));
    [~, j] = min(abs(lam - tgt));
    tab(k,:) = [SP(k,:) real(lam(j)) abs(imag(lam(j)))];
end
write_csv(fullfile(out,'ss_validation_SP.csv'), {'SP_real','SP_imag','model_real','model_imag'}, tab);

%% (b) 50 Hz senaryo öz değerleri
ids = {'S0','S2','S5','S6','S10','S9a','S9b'};
rows = []; names = {};
for i = 1:numel(ids)
    L = linearize(scenario_lib(ids{i},50,'none'));
    [em, z] = em_modes(L);
    rows(end+1,:) = [i, min(z), em]; %#ok<AGROW>
    names{end+1} = ids{i}; %#ok<AGROW>
    S.(ids{i}) = struct('lam', L.lam, 'names', {L.names}, 'PF', L.PF);
end
write_csv(fullfile(out,'ss_scenarios.csv'), {'idx','zeta_min_osc','f1_Hz','z1','f2_Hz','z2'}, rows);
save_struct(fullfile(out,'ss_scenarios.mat'), S);

% (c) ve (d) zayıf şebeke / PLL çalışmaları ss_weak.m içindedir (GFL Q-V desteği açık).
fprintf('ss_study tamam.\n');
end

function [em, z] = em_modes(L)
% elektromekanik modlar: 0.5-3 Hz aralığındaki en az sönümlü iki mod
lam = L.lam; z = L.zeta; f = L.fHz;
osc = f > 0.1 & imag(lam) > 0;
z = z(osc & f < 50);
sel = find(osc & f > 0.5 & f < 3);
[~, o] = sort(f(sel), 'descend'); sel = sel(o);
em = nan(1,4);
for k = 1:min(2, numel(sel)), em(2*k-1:2*k) = [f(sel(k)) L.zeta(sel(k))]; end
end

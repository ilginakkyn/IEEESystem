function ieee9v2_same_assumptions()
%IEEE9V2_SAME_ASSUMPTIONS  ANDES çapraz doğrulaması için bu modelin aynı varsayımlı koşusu.
%   S0, üç makine TGOV1, yük P ~ V, Q ~ V^2, Kpf = 0, E1 (Bara 6 +31,5 MW), 50 Hz, 30 s.
%   Çıktı: results/andes_ref_traj.csv (t, f_COI), results/andes_ref_modes.csv (öz değerler). Ardından: python3 validation/andes_crosscheck.py
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(fullfile(root,'scenarios'));
sc = scenario_lib('S0', 50, 'E1');
sc.gov = {'steam','steam','steam'};
sc.load = struct('ap',1,'aq',2,'kpf',0,'kqf',0);
R = sim_run(sc, struct('t_end', 30, 'rec', 0.005));
write_csv(fullfile(root,'results','andes_ref_traj.csv'), {'t','f_coi'}, [R.t(:) R.f(:)]);
sc.events = struct('t',{},'type',{});
L = linearize(sc); s = L.fHz > 0.5 & L.fHz < 3 & imag(L.lam) > 0;
write_csv(fullfile(root,'results','andes_ref_modes.csv'), {'f_Hz','zeta'}, [L.fHz(s) L.zeta(s)]);
end

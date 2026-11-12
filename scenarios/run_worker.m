function run_worker(wid, nw, grp)
%RUN_WORKER  İş listesinin bir dilimini koşar (paralel: farklı MATLAB/Octave oturumları).
%   run_worker(1,1)          -> hepsi, tek oturum
%   run_worker(1,2); run_worker(2,2)  -> iki oturuma bölünmüş
%   run_worker(1,1,'A')      -> yalnızca A grubu
%   Sonuçlar results/<id>.mat dosyalarına yazılır; var olanlar atlanır.
if nargin < 3, grp = ''; end
here = fileparts(mfilename('fullpath'));
root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
out = fullfile(root,'results'); if ~exist(out,'dir'), mkdir(out); end
J = job_list();
for k = 1:numel(J)
    if mod(k-1, nw) ~= wid-1, continue; end
    if ~isempty(grp) && ~any(strcmp(J(k).grp, strsplit(grp, ','))), continue; end
    f = fullfile(out, [J(k).id '.mat']);
    if exist(f,'file'), continue; end
    t0 = tic;
    try
        R = sim_run(J(k).sc, J(k).opt);
        S = slim(R); S.id = J(k).id; S.grp = J(k).grp; S.cpu = toc(t0);
        save_struct(f, S);
        fprintf('[%d] %-22s rocof=%7.4f nadir=%8.4f qss=%8.4f  (%.0fs)\n', wid, J(k).id, ...
            S.met.rocof500, S.met.nadir, S.met.f_qss, S.cpu);
    catch err
        fprintf('[%d] %-22s HATA: %s\n', wid, J(k).id, err.message);
    end
end
end

function S = slim(R)
% kayıtları 20 ms'ye indir (dosya boyutu)
i = 1:2:numel(R.t);
S.name = R.name; S.t = R.t(i); S.f = R.f(i); S.Pg = R.Pg(i,:); S.Pf = R.Pf(i,:);
S.Pm = R.Pm(i,:); S.soc = R.soc(i,:); S.wr = R.wr(i,:); S.Vm = R.Vm(i,:); S.ilim = R.ilim(i,:);
S.met = R.met; S.eq_res = R.eq_res;
S.Ek = sum(R.M.mH(R.M.mon))*100;                % devredeki senkron kinetik enerji (MWs)
S.sc = R.sc;
end

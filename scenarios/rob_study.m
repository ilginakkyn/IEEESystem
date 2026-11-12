function rob_study(wid, nw, extra)
%ROB_STUDY  Dayanıklılık: BESS'in faydası farklı bozulma tiplerinde ve yük seviyelerinde de geçerli mi?
%   Yapılar: S2 (BESS yok), S5 (GFL, Bara 2), S6 (GFM, Bara 2), S7 (3 grup: 5-6-8) + extra (yerleşim)
%   Olaylar: yük +31,5 MW Bara 5 / 8; PV kısmi açma 30 MW; G3 açması; yük seviyesi %80 ve %120 (E1)
if nargin < 1, wid = 1; nw = 1; end
if nargin < 3, extra = []; end
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
cfg = {'S2','S5','S6','S7'};
ev = {'L5','L8','PVtrip','G3trip','Lo80','Lo120'};
f = fullfile(root,'results',sprintf('rob_runs_w%d.csv',wid));
fid = fopen(f,'w'); fprintf(fid,'cfg,ev,rocof500,nadir,t_nadir,f_qss,rocof_loc_max,Vmin\n'); fclose(fid);
k = 0;
for c = 1:numel(cfg) + ~isempty(extra)
    for e = 1:numel(ev)
        k = k + 1; if mod(k-1, nw) ~= wid-1, continue; end
        if c <= numel(cfg)
            sc = scenario_lib(cfg{c}, 50, 'E1'); nm = cfg{c};
        else
            sc = scenario_lib('S2', 50, 'E1'); nm = ['P' strjoin(arrayfun(@num2str, extra, 'UniformOutput', false), '-')];
            for i = 1:numel(extra), b(i) = struct('type','gfl','bus',extra(i),'S',40/numel(extra),'Hv',16,'R',0.02); end %#ok<AGROW>
            sc.bess = b;
        end
        switch ev{e}
            case 'L5', sc.events.bus = 5;
            case 'L8', sc.events.bus = 8;
            case 'PVtrip', sc.events = struct('t',1,'type','convtrip','idx',1,'dP',30);
            case 'G3trip', sc.events = struct('t',1,'type','gtrip','bus',3);
            case 'Lo80', sc.load_scale = 0.8;
            case 'Lo120', sc.load_scale = 1.2;
        end
        sc.name = [nm '-' ev{e}];
        R = sim_run(sc, struct('t_end', 15));
        m = R.met; rl = max(abs(m.rocof_bus));
        fid = fopen(f,'a');
        fprintf(fid,'%s,%s,%.5f,%.5f,%.3f,%.5f,%.5f,%.4f\n', nm, ev{e}, m.rocof500, m.nadir, m.t_nadir, m.f_qss, -rl, m.Vmin);
        fclose(fid);
    end
end
fprintf('rob_study %d tamam\n', wid);
end

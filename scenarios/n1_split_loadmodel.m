function n1_split_loadmodel()
%N1_SPLIT_LOADMODEL  N-1 (G3 açması) için 80 MVA'nın yerleşimi: yük modeline duyarlılık.
%   80 MVA tek grup (Bara 2), 50+30 ve 40+40 (Bara 2 ve 3); yük P ~ V^ap, ap = 1 (baz) ve 0 (sabit güç).
%   Sabit akım yükünde tek grup daha iyi görünür; bunun nedeni yük gerilimlerinin düşmesiyle
%   yükün azalmasıdır. Sabit güç yükünde sıralama tersine döner. Çıktı: results/n1_split_loadmodel.csv
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
cfg = {[80 0],[50 30],[40 40]};
fid = fopen(fullfile(root,'results','n1_split_loadmodel.csv'),'w');
fprintf(fid,'ap,S_bus2,S_bus3,nadir,t_nadir,Vmin_load,P_gen_mean_1_3s\n');
for ap = [1 0]
    for c = 1:3
        s = cfg{c}; sc = scenario_lib('S2',50,'E1'); sc.load = struct('ap',ap,'aq',2,'kpf',1,'kqf',0);
        if s(2) == 0
            sc.bess = struct('type','gfl','bus',2,'S',s(1),'Hv',16,'R',0.02);
        else
            sc.bess = [struct('type','gfl','bus',2,'S',s(1),'Hv',16,'R',0.02) struct('type','gfl','bus',3,'S',s(2),'Hv',16,'R',0.02)];
        end
        sc.events = struct('t',1,'type','gtrip','bus',3);
        R = sim_run(sc, struct('t_end',6));
        w = R.t > 1.01 & R.t <= 3;
        Pg = mean(sum(R.Pe(w,:),2) + sum(R.Pg(w,:),2) + sum(R.Pf(w,:),2));
        fprintf(fid,'%d,%d,%d,%.5f,%.3f,%.4f,%.2f\n', ap, s(1), s(2), R.met.nadir, R.met.t_nadir, ...
            min(min(R.Vm(R.t > 1.05, [5 6 8]))), Pg);
    end
end
fclose(fid);
end

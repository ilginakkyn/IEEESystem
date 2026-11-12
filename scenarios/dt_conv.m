function dt_conv()
%DT_CONV  Zaman adımı yakınsaması: S2, S5, S6 (E1, 10 s), dt = 0,5 / 1 / 2 / 4 ms.
%   Çıktı: results/dt_conv.csv (rapor Bölüm 5.6)
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
fid = fopen(fullfile(root,'results','dt_conv.csv'),'w');
fprintf(fid,'scen,dt_ms,rocof100,rocof500,nadir,t_nadir,qss,wall_s\n');
for s = {'S2','S5','S6'}
    for dt = [0.0005 0.001 0.002 0.004]
        sc = scenario_lib(s{1}, 50, 'E1'); tic; R = sim_run(sc, struct('t_end',10,'dt',dt)); w = toc; m = R.met;
        fprintf(fid,'%s,%g,%.5f,%.5f,%.5f,%.3f,%.5f,%.1f\n', s{1}, dt*1e3, m.rocof100, m.rocof500, m.nadir, m.t_nadir, m.f_qss, w);
    end
end
fclose(fid);
end

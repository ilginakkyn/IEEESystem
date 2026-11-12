function n1_sizing(wid, nw)
%N1_SIZING  N-1 tasarım olayı (G3 açması, 85 MW) için BESS gücü taraması.
%   S2 (G2 yerine 163 MW PV) + Bara 2'de GFL veya GFM BESS, S = 40..120 MVA,
%   Hv = 16 s ve R = %2 (kendi bazında) sabit; enerji S x 1 h.
%   Çıktı: results/n1_sizing_w<wid>.csv
if nargin < 1, wid = 1; nw = 1; end
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
Ss = [0 40 60 80 100 120]; ty = {'gfl','gfm'};
f = fullfile(root,'results',sprintf('n1_sizing_w%d.csv',wid));
fid = fopen(f,'w'); fprintf(fid,'type,S,rocof500,nadir,t_nadir,f_qss,dP_max,E_MWh,soc_min,Vmin\n'); fclose(fid);
k = 0;
for t = 1:2
    for S = Ss
        if S == 0 && t == 2, continue; end
        k = k + 1; if mod(k-1, nw) ~= wid-1, continue; end
        sc = scenario_lib('S2', 50, 'E1');
        if S > 0, sc.bess = struct('type',ty{t},'bus',2,'S',S,'Hv',16,'R',0.02); end
        sc.events = struct('t',1,'type','gtrip','bus',3);
        sc.name = sprintf('N1-%s-%d', ty{t}, S);
        R = sim_run(sc, struct('t_end', 20));
        m = R.met;
        if S > 0, dP = m.dP_conv_max(end); E = m.E_conv_MWh(end); sm = m.soc_min(end); else, dP = NaN; E = NaN; sm = NaN; end
        fid = fopen(f,'a');
        fprintf(fid,'%s,%d,%.5f,%.5f,%.3f,%.5f,%.3f,%.4f,%.4f,%.4f\n', ty{t}, S, m.rocof500, m.nadir, m.t_nadir, m.f_qss, dP, E, sm, m.Vmin);
        fclose(fid);
    end
end
fprintf('n1_sizing %d tamam\n', wid);
end

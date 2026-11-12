function snsp_qss30()
%SNSP_QSS30  SNSP taramasının oturma frekansı için 30 s'lik tekrarı (rapor 7.1).
%   15 s'lik taramada TGOV1 ara ısıtması (T3 = 10 s) oturmadığından oturma frekansı
%   ~15 mHz düşük çıkar. Oturma kriterine göre izin verilen pay bu dosyadan hesaplanır.
%   Çıktı: results/snsp_qss30.csv
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
fid = fopen(fullfile(root,'results','snsp_qss30.csv'),'w');
fprintf(fid,'snsp,btype,nadir,f_qss,rocof500\n'); fclose(fid);
for b = {'none','gfl'}
    for p = 0:0.1:0.7
        R = sim_run(snsp_case(p, b{1}, 'prop'), struct('t_end', 30));
        fid = fopen(fullfile(root,'results','snsp_qss30.csv'),'a');
        fprintf(fid,'%d,%s,%.5f,%.5f,%.5f\n', round(100*p), b{1}, R.met.nadir, R.met.f_qss, R.met.rocof500);
        fclose(fid);
    end
end
end

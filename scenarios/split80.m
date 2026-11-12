function split80(wid)
%SPLIT80  N-1 için 80 MVA'nın Bara 2 ve 3'e bölünmesi (40+40, 50+30), G3 açması ve E1.
%   Paralel: split80(1) ve split80(2). Çıktı: results/split80_w*.csv
here = fileparts(mfilename('fullpath')); root = fileparts(here); addpath(fullfile(root,'core')); addpath(here);
cases = {[40 40],[50 30]}; evs = {'G3trip','E1'};
f = fullfile(root,'results',sprintf('split80_w%d.csv',wid)); fid=fopen(f,'w'); fprintf(fid,'S2bus,S3bus,ev,rocof500,nadir,f_qss,rloc,Vmin,dP2,dP3\n'); fclose(fid);
k=0;
for c=1:2, for e=1:2
  k=k+1; if mod(k-1,2)~=wid-1, continue; end
  s=cases{c}; sc=scenario_lib('S2',50,'E1');
  sc.bess=[struct('type','gfl','bus',2,'S',s(1),'Hv',16,'R',0.02) struct('type','gfl','bus',3,'S',s(2),'Hv',16,'R',0.02)];
  if e==1, sc.events=struct('t',1,'type','gtrip','bus',3); end
  R=sim_run(sc,struct('t_end',20)); m=R.met;
  fid=fopen(f,'a'); fprintf(fid,'%d,%d,%s,%.5f,%.5f,%.5f,%.5f,%.4f,%.2f,%.2f\n',s(1),s(2),evs{e},m.rocof500,m.nadir,m.f_qss,-max(abs(m.rocof_bus)),m.Vmin,m.dP_conv_max(end-1),m.dP_conv_max(end)); fclose(fid);
end, end
end

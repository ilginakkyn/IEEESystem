function place_study(wid, nw)
%PLACE_STUDY  BESS konumu ve grup sayısı optimizasyonu (tam sayım).
%   Toplam 40 MVA GFL-BESS (Hv = 16 s, R = %2, kendi bazında; toplam kazançlar sabit)
%   N = 1, 2, 3 grup için baralar 2..9'un TÜM kombinasyonları; N = 4 için 21 kombinasyon
%   (yük baraları + PV barası ve 20 rastgele); N = 8 her baraya bir grup.
%   Her yerleşim üç bozulma yerinde test edilir: Bara 5, 6, 8'e +31,5 MW.
%   Çıktı: results/place_runs_w<wid>.csv (koşu başına satır), results/place_ss.csv (sönüm)
%   Paralel: place_study(1,2) ve place_study(2,2)
if nargin < 1, wid = 1; nw = 1; end
here = fileparts(mfilename('fullpath')); root = fileparts(here);
addpath(fullfile(root,'core')); addpath(here);
C = place_configs();
evb = [5 6 8];
f = fullfile(root,'results',sprintf('place_runs_w%d.csv',wid));
done = {};
if exist(f,'file')
    fid = fopen(f,'r'); fgetl(fid);
    while true, l = fgetl(fid); if ~ischar(l), break; end, p = strsplit(l, ','); done{end+1} = [p{2} '|' p{3}]; end %#ok<AGROW>
    fclose(fid);
else
    fid = fopen(f,'w'); fprintf(fid,'N,buses,evbus,rocof100,rocof500,nadir,t_nadir,rocof_loc_max,bus_loc,dP_tot\n'); fclose(fid);
end
k = 0;
for c = 1:numel(C)
    for e = evb
        k = k + 1;
        if mod(k-1, nw) ~= wid-1, continue; end
        key = [strjoin(arrayfun(@num2str, C{c}, 'UniformOutput', false), '-') '|' num2str(e)];
        if any(strcmp(done, key)), continue; end
        sc = make_sc(C{c}, e);
        R = sim_run(sc, struct('t_end', 5.5, 'rec', 0.01));
        m = R.met; [rl, bl] = max(abs(m.rocof_bus));
        fid = fopen(f,'a');
        fprintf(fid,'%d,%s,%d,%.5f,%.5f,%.5f,%.3f,%.5f,%d,%.3f\n', numel(C{c}), ...
            strjoin(arrayfun(@num2str, C{c}, 'UniformOutput', false), '-'), e, m.rocof100, m.rocof500, ...
            m.nadir, m.t_nadir, -rl, bl, sum(m.dP_conv_max(2:end)));
        fclose(fid);
    end
end
% küçük sinyal (yalnızca 1. işçi)
if wid == 1
    g = fullfile(root,'results','place_ss.csv');
    fid = fopen(g,'w'); fprintf(fid,'N,buses,zeta_min_em,f_em\n');
    for c = 1:numel(C)
        L = linearize(make_sc(C{c}, 0));
        sel = L.fHz > 0.5 & L.fHz < 3 & imag(L.lam) > 0;
        [z, j] = min(L.zeta(sel)); ff = L.fHz(sel);
        fprintf(fid,'%d,%s,%.5f,%.4f\n', numel(C{c}), strjoin(arrayfun(@num2str, C{c}, 'UniformOutput', false), '-'), z, ff(j));
    end
    fclose(fid);
end
fprintf('place_study %d tamam\n', wid);
end

function sc = make_sc(buses, evbus)
sc = scenario_lib('S2', 50, 'none');
N = numel(buses); s = 40/N;
for i = 1:N
    b(i) = struct('type','gfl','bus',buses(i),'S',s,'Hv',16,'R',0.02); %#ok<AGROW>
end
sc.bess = b;
if evbus > 0, sc.events = struct('t',1,'type','load','bus',evbus,'dP',31.5); end
sc.name = sprintf('P-%s-ev%d', strjoin(arrayfun(@num2str, buses, 'UniformOutput', false), '-'), evbus);
end

function C = place_configs()
B = 2:9; C = {};
for N = 1:3
    K = nchoosek(B, N);
    for i = 1:size(K,1), C{end+1} = K(i,:); end %#ok<AGROW>
end
% N = 4: yük baraları + PV barası [2 5 6 8] ve 70 kombinasyondan rastgele seçilmiş 20 tanesi.
% Seçim, MATLAB ve Octave'ın farklı rastgele sayı üreteçlerinden etkilenmesin diye sabit yazıldı.
K4 = [2 5 6 8; 2 3 5 9; 2 3 5 7; 3 4 7 9; 2 3 4 8; 2 3 5 6; 2 3 4 5; 3 6 8 9; 3 4 8 9; 3 4 5 9; ...
      3 5 8 9; 2 6 8 9; 2 4 8 9; 2 4 6 9; 3 5 6 7; 3 5 7 8; 2 4 5 9; 3 5 6 8; 2 4 5 6; 4 5 6 9; 5 6 7 8];
for i = 1:size(K4,1), C{end+1} = K4(i,:); end %#ok<AGROW>
C{end+1} = B;
end

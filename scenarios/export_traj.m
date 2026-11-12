function export_traj(ids, f, dt, tmax, what)
%EXPORT_TRAJ  Seçilen koşuların zaman serilerini tek CSV'ye yazar (rapor grafikleri için).
%   export_traj({'A_S0_E1','A_S2_E1'}, 'results/traj_main.csv', 0.05, 15, 'f')
%   what: 'f' (COI frekansı) | 'pb' (BESS/rüzgar toplam ΔP, MW) | 'wr' (rüzgar rotor hızı)
here = fileparts(mfilename('fullpath')); root = fileparts(here);
fid = fopen(fullfile(root, f), 'w'); fprintf(fid, 'id,t,v\n');
tg = (0:dt:tmax)';
for i = 1:numel(ids)
    q = load(fullfile(root, 'results', [ids{i} '.mat'])); S = q.S;
    switch what
        case 'f', y = S.f;
        case 'pb'
            P = [S.Pg S.Pf]; npv = numel(S.sc.pv); cols = npv+1:size(P,2);
            y = sum(P(:,cols) - repmat(P(1,cols), size(P,1), 1), 2);
        case 'wr', y = S.wr(:, end);
    end
    v = interp1(S.t, y, tg);
    for k = 1:numel(tg), fprintf(fid, '%s,%.3f,%.5f\n', ids{i}, tg(k), v(k)); end
end
fclose(fid);
end

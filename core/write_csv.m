function write_csv(f, hdr, X)
%WRITE_CSV  Başlıklı CSV yazar (MATLAB/Octave uyumlu).
fid = fopen(f, 'w');
fprintf(fid, '%s\n', strjoin(hdr, ','));
for i = 1:size(X,1)
    fprintf(fid, '%s\n', strjoin(arrayfun(@(v) sprintf('%.6g', v), X(i,:), 'UniformOutput', false), ','));
end
fclose(fid);
end

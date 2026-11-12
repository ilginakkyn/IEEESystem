function M = refactor(M)
%REFACTOR  Genişletilmiş ağ matrisini (Norton şöntleri dahil) kurar ve LU ayrıştırır.
%   Topoloji değiştiğinde (jeneratör açması vb.) yeniden çağrılır.
Ya = M.Y0;
for k = 1:M.nm
    if M.mon(k), b = M.mbus(k); Ya(b,b) = Ya(b,b) + M.myn(k); end
end
for k = 1:M.nf
    b = M.fbus(k); Ya(b,b) = Ya(b,b) + M.fyv(k);
end
for k = 1:numel(M.lbus)
    b = M.lbus(k); Ya(b,b) = Ya(b,b) + M.lyl0(k);
end
M.Ya = Ya;
[M.L, M.U, M.P] = lu(Ya);
% enjeksiyon eşleme matrisleri (bara x cihaz)
M.Am = zeros(9, M.nm); for k = 1:M.nm, M.Am(M.mbus(k),k) = 1; end
M.Ag = zeros(9, M.ng); for k = 1:M.ng, M.Ag(M.gbus(k),k) = 1; end
M.Af = zeros(9, M.nf); for k = 1:M.nf, M.Af(M.fbus(k),k) = 1; end
M.Al = zeros(9, numel(M.lbus)); for k = 1:numel(M.lbus), M.Al(M.lbus(k),k) = 1; end
end

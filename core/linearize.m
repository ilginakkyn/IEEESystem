function L = linearize(sc, h)
%LINEARIZE  Denge noktasında sayısal (merkezi fark) Jakobyen ve modal analiz.
%   L = linearize(sc)
%   L.A      : durum matrisi (kullanılmayan durumlar çıkarılmış)
%   L.lam    : öz değerler
%   L.zeta   : sönüm oranları,  L.fHz : salınım frekansları (Hz)
%   L.PF     : katılım çarpanları (durum x mod)
%   L.names  : durum adları
if nargin < 2, h = 1e-6; end
[M, x0, V0] = build_model(sc);
[f0, V0] = deriv(0, x0, M, V0, 1e-13, 200);
n = numel(x0); A = zeros(n);
for k = 1:n
    xp = x0; xp(k) = xp(k) + h; xm = x0; xm(k) = xm(k) - h;
    fp = deriv(0, xp, M, V0, 1e-13, 200);
    fm = deriv(0, xm, M, V0, 1e-13, 200);
    A(:,k) = (fp - fm)/(2*h);
end
names = state_names(M);
act = any(A ~= 0, 1)' | any(A ~= 0, 2);
L.A = A(act, act); L.names = names(act); L.eq_res = max(abs(f0));
[Vr, D] = eig(L.A); lam = diag(D);
W = inv(Vr);
PF = abs(Vr .* W.');
PF = PF ./ repmat(max(PF, [], 1), size(PF,1), 1);
[~, o] = sort(-real(lam)); %#ok<ASGLU>
[~, o] = sort(abs(imag(lam)), 'descend');
L.lam = lam(o); L.PF = PF(:, o);
L.zeta = -real(L.lam)./abs(L.lam);
L.fHz = abs(imag(L.lam))/(2*pi);
L.M = M;
end

function nm = state_names(M)
nm = cell(M.nx,1);
mn = {'delta','omega','Eqp','Edp','Efd','VR','Rf','gov1','gov2','gov3'};
for k = 1:M.nm
    for j = 1:M.nxm, nm{M.im(k,j)} = sprintf('M%d(b%d).%s', k, M.mbus(k), mn{j}); end
end
gn = {'th_pll','xi_pll','Ip','Iq','df_m','x_rocof','soc','wr','v_f'};
for k = 1:M.ng
    for j = 1:M.nxg, nm{M.ig(k,j)} = sprintf('GFL%d(b%d).%s', k, M.gbus(k), gn{j}); end
end
fn = {'th_v','dw_v','E_v','soc'};
for k = 1:M.nf
    for j = 1:M.nxf, nm{M.ifm(k,j)} = sprintf('GFM%d(b%d).%s', k, M.fbus(k), fn{j}); end
end
end

function [V, S, ok] = loadflow(Y, btype, Vset, Psp, Qsp)
%LOADFLOW  Newton-Raphson güç akışı (polar, sayısal Jakobyen).
%   btype: 1 = salınım, 2 = PV (gerilim kontrollü), 3 = PQ
%   Vset : PV/salınım baralarının gerilim genliği
%   Psp, Qsp: net enjeksiyon (üretim - tüketim), pu
n = numel(btype);
Vm = ones(n,1); Vm(btype<=2) = Vset(btype<=2); th = zeros(n,1);
ns = find(btype ~= 1); pq = find(btype == 3);
nx = numel(ns);
x = [th(ns); Vm(pq)];
ok = false;
for it = 1:40
    f0 = mis(x);
    if max(abs(f0)) < 1e-11, ok = true; break; end
    J = zeros(numel(x)); h = 1e-7;
    for k = 1:numel(x)
        xk = x; xk(k) = xk(k) + h;
        J(:,k) = (mis(xk) - f0)/h;
    end
    x = x - J\f0;
end
[~, V] = mis(x);
S = V.*conj(Y*V);

    function [m, Vc] = mis(xx)
        t2 = th; v2 = Vm;
        t2(ns) = xx(1:nx); v2(pq) = xx(nx+1:end);
        Vc = v2.*exp(1i*t2);
        Sc = Vc.*conj(Y*Vc);
        m = [Psp(ns) - real(Sc(ns)); Qsp(pq) - imag(Sc(pq))];
    end
end

function L = lom_sim(sc, t_end, dt)
%LOM_SIM  Doğrusal düşük mertebeli frekans modeli (tek bara, ağ ihmal).
%   Tüm senkron makineler COI hızında birleşir; her makinenin gerçek regülatörü (hidro/buhar)
%   doğrusal olarak korunur. GFL-BESS ölçüm filtreleri ve akım döngüsüyle, PLL ideal (Δf_pll = Δω);
%   GFM-BESS ideal sanal makine (gecikmesiz) olarak eklenir.
%       2 Hs dΔω/dt = Σ ΔPm,i + ΔP_BESS - Dl Δω - ΔP_dist
%   Amaç: doğrusal olmayan ağ modelinin sonuçlarını bağımsız olarak sağlamak ve
%   farkın (PLL, gerilim, ağ, sınırlar) büyüklüğünü göstermek.
if nargin < 2, t_end = 15; end
if nargin < 3, dt = 0.001; end
[M, x0] = build_model(sc); %#ok<ASGLU>
sc = M.sc;
Hs = sum(M.mH);
Dl = M.lkpf*sum(M.lP0);                  % yük frekans sönümü
ev = sc.events(1); dP = ev.dP/100; t0 = ev.t;
tg = M.tg; hg = M.hg;
% GFM: atalet ve sönüm doğrudan eklenir (ideal)
for k = 1:M.nf
    Hs = Hs + M.fHv(k)*M.fSr(k);
    Dl = Dl + M.fDp(k)*M.fSr(k);
end
nm = M.nm; n = numel(0:dt:t_end);
w = 0; X = zeros(nm,3);                 % gov durumları (sapma)
B = zeros(max(M.ng,1),3);               % [dfm xr P]
T = zeros(n,1); F = T; PB = T;
for k = 1:n
    t = (k-1)*dt;
    dist = dP*(t >= t0);
    Pm = zeros(nm,1); dX = zeros(nm,3);
    for i = 1:nm
        if M.isSteam(i)
            K = M.mSrat(i)/tg.R;
            dX(i,1) = (-K*w - X(i,1))/tg.T1;
            dX(i,2) = (X(i,1) - X(i,2))/tg.T3;
            Pm(i) = X(i,2) + tg.T2/tg.T3*(X(i,1) - X(i,2));
        elseif M.isHydro(i)
            Ta = hg.TR; Tb = hg.TR*hg.RT/hg.Rp;
            y = (1/hg.Rp)*(X(i,1) + Ta/Tb*(-w - X(i,1)));
            dX(i,1) = (-w - X(i,1))/Tb;
            dX(i,2) = (y - X(i,2))/hg.TG;
            dX(i,3) = (X(i,2) - X(i,3))/(0.5*hg.Tw);
            Pm(i) = M.mSrat(i)*(3*X(i,3) - 2*X(i,2));
        end
    end
    Pb = 0; dB = zeros(size(B));
    for j = 1:M.ng
        if M.gtyp(j) ~= 2, continue; end
        dB(j,1) = (w - B(j,1))/M.gTm(j);
        roc = (B(j,1) - B(j,2))/M.gTr(j);
        dB(j,2) = roc;
        Pc = -M.gKd(j)*B(j,1) - M.gKh(j)*roc;
        Pc = max(min(Pc, M.gImax(j)), -M.gImax(j));
        dB(j,3) = (Pc - B(j,3))/M.gTi(j);
        Pb = Pb + B(j,3);
    end
    T(k) = t; F(k) = M.f0*(1 + w); PB(k) = Pb*100;
    dw = (sum(Pm) + Pb - Dl*w - dist)/(2*Hs);
    w = w + dt*dw; X = X + dt*dX; B = B + dt*dB;
end
L.t = T; L.f = F; L.Pb = PB; L.Hs = Hs; L.Dl = Dl;
L.met = metrics_lite(T, F, t0);
end

function m = metrics_lite(t, f, t0)
fi = @(tt) interp1(t, f, tt);
m.rocof500 = (fi(t0+0.5) - fi(t0))/0.5;
i0 = find(t >= t0, 1); [m.nadir, j] = min(f(i0:end)); m.t_nadir = t(i0+j-1) - t0;
m.f_qss = f(end);
end

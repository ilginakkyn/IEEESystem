function m = metrics_calc(R, t0, f0)
%METRICS_CALC  Frekans kararlılığı ölçütleri.
%   rocof500   : COI frekansının bozulmadan sonraki ilk 500 ms'deki ortalama eğimi (Hz/s)
%   rocof500max: bozulmadan sonra 5 s içinde herhangi bir 500 ms penceredeki en büyük |eğim|
%   rocof100   : ilk 100 ms (başlangıç eğimi yaklaşık)
%   nadir, t_nadir, f_qss (son 1 s ortalaması)
%   rocof_bus  : 9 bara için yerel RoCoF (açı türevinden, 100 ms ortalamalı frekans, 500 ms pencere)
%   BESS/GFM: tepe güç (MW), enerji (MWh), en düşük SOC
t = R.t; f = R.f;
m.t0 = t0;
if ~isfinite(t0), t0 = t(1); end
fi = @(tt) interp1(t, f, min(max(tt, t(1)), t(end)));
f0e = fi(t0);
m.rocof100 = (fi(t0+0.1) - f0e)/0.1;
m.rocof500 = (fi(t0+0.5) - f0e)/0.5;
tau = t(t >= t0 & t <= min(t0+5, t(end)-0.5));
if isempty(tau), m.rocof500max = m.rocof500;
else
    r = (fi(tau+0.5) - fi(tau))/0.5; [~, j] = max(abs(r)); m.rocof500max = r(j);
end
i0 = find(t >= t0, 1);
[m.nadir, j] = min(f(i0:end)); m.t_nadir = t(i0+j-1) - t0;
m.df_nadir = m.nadir - f0;
m.f_qss = mean(f(t >= t(end)-1));
m.zenith = max(f(i0:end));
% yerel (bara) RoCoF
ang = unwrap(R.ang);
h = 0.05;
fb = @(tt) f0 + (interp1(t, ang, tt+h) - interp1(t, ang, tt-h))/(2*pi*2*h);
tb = t(t >= t0+h & t <= min(t0+3, t(end)-0.5-h));
if numel(tb) > 2
    r = (fb(tb+0.5) - fb(tb))/0.5;
    [~, j] = max(abs(r), [], 1);
    m.rocof_bus = r(sub2ind(size(r), j, 1:9));
else
    m.rocof_bus = nan(1,9);
end
% dönüştürücü kullanımı
P = [R.Pg R.Pf];
if ~isempty(P)
    P0 = P(1,:);
    dP = P - repmat(P0, size(P,1), 1);
    m.dP_conv_max = max(abs(dP), [], 1);
    m.E_conv_MWh = trapz(t, dP)/3600;
    m.soc_min = min(R.soc, [], 1);
else
    m.dP_conv_max = []; m.E_conv_MWh = []; m.soc_min = [];
end
m.Vmin = min(min(R.Vm(i0:end,:)));
end

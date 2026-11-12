function S = sfr_am(H, D, R, FH, TR, dP, f0, t)
%SFR_AM  Anderson & Mirheydar (1990) düşük mertebeli sistem frekans yanıtı (SFR) modeli.
%   Tek eşdeğer ara ısıtmalı buhar ünitesi; regülatör zaman sabiti ihmal edilir.
%   H  : sistem atalet sabiti (s, sistem bazında)   D : yük sönümü (pu/pu)
%   R  : eşdeğer düşüm (pu, sistem bazında)          FH: HP türbin oranı (= T2/T3)
%   TR : ara ısıtma zaman sabiti (s)                 dP: bozulma (pu, yük artışı > 0)
%   Kapalı form:
%     Δω(t) = -(R dP/(D R + 1)) [1 + α e^{-ζ ωn t} sin(ωr t + φ)]
%     ωn^2 = (D R + 1)/(2 H R TR),  ζ = ωn (2 H R + (D R + FH) TR) / (2 (D R + 1))
%     α = sqrt((1 - 2 TR ζ ωn + TR^2 ωn^2)/(1 - ζ^2)),  ωr = ωn sqrt(1 - ζ^2)
%     φ = φ1 - φ2,  φ1 = atan2(ωr TR, 1 - ζ ωn TR),  φ2 = atan2(sqrt(1-ζ^2), -ζ)
Km = 1;
wn = sqrt((D*R + Km)/(2*H*R*TR));
ze = wn*(2*H*R + (D*R + Km*FH)*TR)/(2*(D*R + Km));
wr = wn*sqrt(1 - ze^2);
al = sqrt((1 - 2*TR*ze*wn + TR^2*wn^2)/(1 - ze^2));
p1 = atan2(wr*TR, 1 - ze*wn*TR); p2 = atan2(sqrt(1 - ze^2), -ze);
ph = p1 - p2;
dw = -(R*dP/(D*R + Km))*(1 + al*exp(-ze*wn*t).*sin(wr*t + ph));
S.t = t; S.f = f0*(1 + dw);
[S.dw_nadir, i] = min(dw); S.t_nadir = t(i);
S.nadir = f0*(1 + S.dw_nadir);
S.f_qss = f0*(1 - R*dP/(D*R + Km));
S.rocof0 = -dP*f0/(2*H);
S.wn = wn; S.zeta = ze; S.alpha = al; S.phi = ph;
end

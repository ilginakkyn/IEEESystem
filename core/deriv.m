function [dx, V, out] = deriv(t, x, M, Vw, tol, maxit)
%DERIV  Durum türevleri dx = f(x, V(x)); ağ cebirsel denklemleri her çağrıda çözülür.
%
%   Ağ:  Ya * V = I_inj(x, V)  (Ya: Ybus + Norton şöntleri + yüklerin başlangıç admitansı)
%   Çözüm: sabit nokta iterasyonu (sıcak başlangıç Vw), tol/maxit ile.
if nargin < 5, tol = 1e-7; end
if nargin < 6, maxit = 12; end
nm = M.nm; ng = M.ng; nf = M.nf;
dx = zeros(size(x));

%% ------------------------------------------------ durumlar
Xm = reshape(x(M.im), nm, M.nxm);
dl = Xm(:,1); w = Xm(:,2); Eqp = Xm(:,3); Edp = Xm(:,4);
Efd = Xm(:,5); VR = Xm(:,6); Rf = Xm(:,7); s1 = Xm(:,8); s2 = Xm(:,9); s3 = Xm(:,10);
rot = exp(1i*(dl - pi/2));
mon = M.mon;
wcoi = sum(M.mH.*w.*mon)/sum(M.mH.*mon);
dfc = wcoi - 1;

if ng > 0
    Xg = reshape(x(M.ig), ng, M.nxg);
    th = Xg(:,1); xi = Xg(:,2); Ipg = Xg(:,3); Iqg = Xg(:,4);
    dfm = Xg(:,5); xr = Xg(:,6); soc = Xg(:,7); wr = Xg(:,8); vf = Xg(:,9);
    Igfl = (Ipg - 1i*Iqg).*exp(1i*th);
    Ifix = M.Ag*Igfl;
else
    Ifix = zeros(9,1);
end
if nf > 0
    Xf = reshape(x(M.ifm), nf, M.nxf);
    thv = Xf(:,1); dwv = Xf(:,2); Ev = Xf(:,3); socf = Xf(:,4);
    Eph = Ev.*exp(1i*thv);
    Inorf = Eph.*M.fyv;
end

%% ------------------------------------------------ ağ çözümü
V = Vw;
for it = 1:maxit
    I = Ifix + M.Al*loadinj(V, M, dfc) + M.Am*geninj(V, M, rot, Eqp, Edp, mon);
    if nf > 0
        Idev = (Eph - V(M.fbus)).*M.fyv;
        sc = min(1, M.fImax./max(abs(Idev),1e-9));
        I = I + M.Af*(Inorf + Idev.*(sc - 1));
    end
    Vn = M.U\(M.L\(M.P*I));
    err = max(abs(Vn - V)); V = Vn;
    if err < tol, break; end
end

%% ------------------------------------------------ senkron makineler
Vg = V(M.mbus); vdq = Vg.*conj(rot);
Vd = real(vdq); Vq = imag(vdq);
Id = (Eqp - Vq)./M.mxdp; Iq = (Vd - Edp)./M.mxqp;
Pe = (Vd.*Id + Vq.*Iq).*mon;
Vt = abs(Vg);
% türbin gücü
Pm = M.Pm0;
tg = M.tg; hg = M.hg;
xmax = tg.Vmax*M.mSrat; xmin = tg.Vmin*M.mSrat;
x1c = min(max(s1, xmin), xmax);
st = M.isSteam; hy = M.isHydro;
Pm(st) = s2(st) + (tg.T2/tg.T3)*(x1c(st) - s2(st));
Pm(hy) = M.mSrat(hy).*(3*s3(hy) - 2*s1(hy));
e = M.exc;
SE = e.Ax*exp(e.Bx*Efd);
dm = zeros(nm, M.nxm);
dm(:,1) = M.ws*(w - 1);
dm(:,2) = (Pm - Pe - M.mD.*(w - 1))./(2*M.mH);
dm(:,3) = (-Eqp - (M.mxd - M.mxdp).*Id + Efd)./M.mTd0;
dm(:,4) = M.hasTq.*(-Edp + (M.mxq - M.mxqp).*Iq)./M.mTq0s;
dm(:,5) = (-(e.KE + SE).*Efd + VR)/e.TE;
dm(:,6) = (-VR + e.KA*Rf - e.KA*e.KF/e.TF*Efd + e.KA*(M.Vref - Vt))/e.TA;
dm(:,7) = (-Rf + e.KF/e.TF*Efd)/e.TF;
% buhar: TGOV1
if any(st)
    u = M.Pref - (M.mSrat/tg.R).*(w - 1);
    d1 = (u - s1)/tg.T1;
    d1(s1 >= xmax & d1 > 0) = 0; d1(s1 <= xmin & d1 < 0) = 0;
    dm(st,8) = d1(st);
    dm(st,9) = (x1c(st) - s2(st))/tg.T3;
end
% hidro: geçici düşümlü regülatör + su sütunu (1 - Tw s)/(1 + 0.5 Tw s)
if any(hy)
    Ta = hg.TR; Tb = hg.TR*hg.RT/hg.Rp;
    uu = -(w - 1);
    y = (1/hg.Rp)*(s2 + (Ta/Tb)*(uu - s2));
    dg = (M.g0 + y - s1)/hg.TG;
    dg(s1 >= hg.Gmax & dg > 0) = 0; dg(s1 <= hg.Gmin & dg < 0) = 0;
    dm(hy,8) = dg(hy);
    dm(hy,9) = (uu(hy) - s2(hy))/Tb;
    dm(hy,10) = (s1(hy) - s3(hy))/(0.5*hg.Tw);
end
dm(~mon,:) = 0;
dx(M.im) = dm;

%% ------------------------------------------------ GFL dönüştürücüler
if ng > 0
    Vb = V(M.gbus); Vmag = abs(Vb);
    ep = imag(Vb.*exp(-1i*th))./Vmag;
    dth = M.gKp.*ep + xi;
    dfp = dth/M.ws;                                % PLL frekans sapması (pu)
    rocof = (dfm - xr)./M.gTr;                     % filtrelenmiş df/dt (pu/s)
    Pout = real(Vb.*conj(Igfl));
    Pc = M.gP0;
    b2 = M.gtyp == 2; b3 = M.gtyp == 3;
    if any(b2)
        dfd = sign(dfm).*max(abs(dfm) - M.gdb, 0);
        Pb = M.gP0 - M.gKd.*dfd - M.gKh.*rocof;
        lo = soc <= 0.05 & Pb > 0; hi = soc >= 0.95 & Pb < 0;
        Pb(lo | hi) = 0;
        Pc(b2) = Pb(b2);
    end
    if any(b3)
        dPs = min(max(-M.gKdw.*dfm - M.gKhw.*rocof, 0), M.glim);
        dPs(wr < 0.7) = 0;
        Pw = M.gPrat.*(wr.^3 + dPs);
        Pc(b3) = Pw(b3);
    end
    Vc = max(Vmag, 0.3);
    Ipc = min(max(Pc./Vc, -M.gImax), M.gImax);
    Iqm = sqrt(max(M.gImax.^2 - Ipc.^2, 0));
    Iqc = min(max(M.gQ0./Vc + M.gKv.*M.gSr.*(M.gVref - vf), -Iqm), Iqm);
    dg = zeros(ng, M.nxg);
    dg(:,1) = dth;
    dg(:,2) = M.gKi.*ep;
    dg(:,3) = (Ipc - Ipg)./M.gTi;
    dg(:,4) = (Iqc - Iqg)./M.gTi;
    dg(:,5) = (dfp - dfm)./M.gTm;
    dg(:,6) = rocof;
    dg(:,9) = (Vmag - vf)/0.02;
    fin = isfinite(M.gE);
    if any(fin)
        dsoc = -100*Pout./(3600*M.gE).*( (Pout > 0)./M.geta + (Pout <= 0).*M.geta );
        dsoc(~fin) = 0; dg(:,7) = dsoc;
    end
    if any(b3)
        lam = M.lopt*wr*12./M.gv;
        li = 1./(1./lam - 0.035);
        cp = 0.5176*(116./li - 5).*exp(-21./li) + 0.0068*lam;
        Pa = cp/M.cpmax.*(M.gv/12).^3;
        dwr = (Pa - Pout./M.gPrat)./(2*M.gHt.*wr);
        dwr(~b3) = 0; dg(:,8) = dwr;
    end
    dx(M.ig) = dg;
end

%% ------------------------------------------------ GFM dönüştürücüler (VSM)
if nf > 0
    Vf = V(M.fbus);
    Idev = (Eph - Vf).*M.fyv;
    sc = min(1, M.fImax./max(abs(Idev),1e-9));
    Ia = Idev.*sc;
    Pf = real(Vf.*conj(Ia)); Qf = imag(Vf.*conj(Ia));
    df = zeros(nf, M.nxf);
    df(:,1) = M.ws*dwv;
    df(:,2) = (M.fPset - Pf - M.fDp.*M.fSr.*dwv)./(2*M.fHv.*M.fSr);
    df(:,3) = (M.fE0 - M.fmq.*(Qf - M.fQ0)./M.fSr - Ev)./M.fTq;
    df(:,4) = -100*Pf./(3600*M.fE).*( (Pf > 0)./M.feta + (Pf <= 0).*M.feta );
    dx(M.ifm) = df;
end

if nargout > 2
    out.wcoi = wcoi; out.Pe = Pe; out.Pm = Pm; out.w = w; out.Vt = Vt; out.Efd = Efd;
    if ng > 0, out.Pg = Pout; out.dfp = dfp; out.rocof = rocof; else, out.Pg = zeros(0,1); end
    if nf > 0, out.Pf = Pf; out.Ilim = sc < 1; else, out.Pf = zeros(0,1); end
    out.it = it;
end
end

% ------------------------------------------------------------------------
function Il = loadinj(V, M, dfc)
Vl = V(M.lbus); Vm = abs(Vl);
Sl = M.lP0.*(Vm./M.lV0).^M.lap.*(1 + M.lkpf*dfc) + 1i*M.lQ0.*(Vm./M.lV0).^M.laq.*(1 + M.lkqf*dfc);
Il = M.lyl0.*Vl - conj(Sl./Vl);
end

function Im = geninj(V, M, rot, Eqp, Edp, mon)
Vg = V(M.mbus); vdq = Vg.*conj(rot);
Id = (Eqp - imag(vdq))./M.mxdp; Iq = (real(vdq) - Edp)./M.mxqp;
Im = ((Id + 1i*Iq).*rot + M.myn.*Vg).*mon;
end

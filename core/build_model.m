function [M, x0, V0] = build_model(sc)
%BUILD_MODEL  Senaryodan dinamik modeli kurar, güç akışını çözer, durumları başlatır.
%   [M, x0, V0] = build_model(sc)
%   M  : sabit parametreler + durum indeksleri
%   x0 : başlangıç (denge) durum vektörü
%   V0 : başlangıç bara gerilimleri (kompleks)
sc = sc_fill(sc);
d = sysdata();
M.f0 = sc.f0; M.ws = 2*pi*sc.f0; M.sc = sc;
if isfield(sc,'load_scale') && ~isempty(sc.load_scale)     % yük seviyesi (ör. 0.8 / 1.2)
    d.loads(:,2:3) = d.loads(:,2:3)*sc.load_scale;
end
if isfield(sc,'trafo_scale') && ~isempty(sc.trafo_scale)   % zayıf şebeke çalışmaları
    d.trafos(:,3) = d.trafos(:,3).*sc.trafo_scale(:);
end
Y0 = ybus(d);

%% ---------------------------------------------------------- senkron makineler
m = struct('bus',{},'H',{},'xd',{},'xdp',{},'xq',{},'xqp',{},'Td0p',{},'Tq0p',{}, ...
           'Srat',{},'D',{},'gov',{},'Vset',{},'P',{});
for gi = sc.gens
    g = d.gen(gi); k = sc.k(gi);
    r.bus = g.bus; r.H = k*g.H; r.xd = g.xd/k; r.xdp = g.xdp/k; r.xq = g.xq/k;
    r.xqp = g.xqp/k; r.Td0p = g.Td0p; r.Tq0p = g.Tq0p; r.Srat = k*g.S/d.Sb;
    r.D = sc.D(gi)*r.Srat; r.gov = sc.gov{gi}; r.Vset = g.V; r.P = sc.Pg(gi);
    if ~isempty(sc.Vset) && ~isnan(sc.Vset(gi)), r.Vset = sc.Vset(gi); end
    m(end+1) = r; %#ok<AGROW>
end
% senkron kompansatörler (kendi bazında tipik veri)
for j = 1:numel(sc.sc)
    c = sc.sc(j); s = c.S/d.Sb;
    if ~isfield(c,'H') || isempty(c.H), c.H = 2.0; end
    r.bus = c.bus; r.H = c.H*s; r.xd = 1.60/s; r.xdp = 0.25/s; r.xq = 1.00/s;
    r.xqp = 0.45/s; r.Td0p = 7.0; r.Tq0p = 0.7; r.Srat = s; r.D = 0;
    r.gov = 'none'; r.Vset = 1.025; r.P = 0;
    m(end+1) = r; %#ok<AGROW>
end
nm = numel(m);
M.m = m; M.nm = nm;
M.mbus = [m.bus]'; M.mH = [m.H]'; M.mxd = [m.xd]'; M.mxdp = [m.xdp]';
M.mxq = [m.xq]'; M.mxqp = [m.xqp]'; M.mTd0 = [m.Td0p]'; M.mTq0 = [m.Tq0p]';
M.mSrat = [m.Srat]'; M.mD = [m.D]';
M.mxn = (M.mxdp + M.mxqp)/2;                % Norton reaktansı (iterasyon için)
M.myn = 1./(1i*M.mxn);
M.hasTq = M.mTq0 > 0;
M.mTq0s = M.mTq0; M.mTq0s(~M.hasTq) = 1;     % sıfıra bölmeyi önle
M.isSteam = strcmp({m.gov},'steam')'; M.isHydro = strcmp({m.gov},'hydro')';
M.isNone = strcmp({m.gov},'none')';
M.mon = true(nm,1);

%% ---------------------------------------------------------- dönüştürücüler
% GFL: PV (typ 1), BESS-GFL (typ 2), rüzgar Tip-4 (typ 3)
fn = sc.pll.fn; ze = sc.pll.zeta;
G = struct('bus',{},'typ',{},'Sr',{},'Imax',{},'Kp',{},'Ki',{},'Ti',{},'Tm',{},'Tr',{}, ...
    'Kd',{},'Kh',{},'db',{},'P0',{},'Q0',{},'E',{},'soc0',{},'eta',{}, ...
    'Prat',{},'Ht',{},'lim',{},'Kdw',{},'Khw',{},'Kv',{},'Vref',{});
for j = 1:numel(sc.pv)
    p = sc.pv(j);
    G(end+1) = gflrec(p.bus,1,p.S/d.Sb,1.1,fn,ze,0.02,0.02,0.05,0,0,0,p.P/d.Sb,Inf,0.5,1,0,1,0,0,0); %#ok<AGROW>
end
for j = 1:numel(sc.bess)
    b = sc.bess(j);
    if ~strcmp(b.type,'gfl'), continue; end
    s = b.S/d.Sb; fnb = fn; if ~isempty(b.fn), fnb = b.fn; end
    Kd = 0; if isfinite(b.R), Kd = s/b.R; end
    G(end+1) = gflrec(b.bus,2,s,b.Imax,fnb,ze,b.Ti,b.Tm,b.Tr,Kd,2*b.Hv*s,b.db, ...
        b.P0/d.Sb,b.E,b.soc0,b.eta,0,1,0,0,0); %#ok<AGROW>
end
for j = 1:numel(sc.wind)
    w = sc.wind(j);
    G(end+1) = gflrec(w.bus,3,w.S/d.Sb,1.1,fn,ze,0.02,0.02,0.05,0,0,0,w.P/d.Sb,Inf,0.5,1, ...
        w.Prated/d.Sb,w.Ht,w.lim,w.Kd,w.Kh); %#ok<AGROW>
end
if isfield(sc,'Kv') && ~isempty(sc.Kv) && sc.Kv > 0   % GFL gerilim desteği (Q-V)
    for j = 1:numel(G), G(j).Kv = sc.Kv; end
end
M.ng = numel(G); M.G = G;
if M.ng > 0
    fns = fieldnames(G);
    for q = 1:numel(fns), M.(['g' fns{q}]) = [G.(fns{q})]'; end
else
    M.gbus = zeros(0,1);
end
% rüzgar aerodinamiği (Heier Cp(λ,β=0)); λopt ve Cpmax sayısal bulunur
lam = linspace(2,14,4001); cp = cpfun(lam);
[M.cpmax, i] = max(cp); M.lopt = lam(i);

% GFM: BESS-VSM
F = struct('bus',{},'Sr',{},'Hv',{},'Dp',{},'Xv',{},'Imax',{},'mq',{},'Tq',{}, ...
           'Pset',{},'Q0',{},'E',{},'soc0',{},'eta',{});
for j = 1:numel(sc.bess)
    b = sc.bess(j);
    if ~strcmp(b.type,'gfm'), continue; end
    s = b.S/d.Sb; Dp = 0; if isfinite(b.R), Dp = 1/b.R; end
    F(end+1) = struct('bus',b.bus,'Sr',s,'Hv',b.Hv,'Dp',Dp,'Xv',b.Xv/s,'Imax',b.Imax*s, ...
        'mq',b.mq,'Tq',b.Tq,'Pset',b.P0/d.Sb,'Q0',0,'E',b.E,'soc0',b.soc0,'eta',b.eta); %#ok<AGROW>
end
M.nf = numel(F); M.F = F;
if M.nf > 0
    fns = fieldnames(F);
    for q = 1:numel(fns), M.(['f' fns{q}]) = [F.(fns{q})]'; end
    M.fyv = 1./(1i*M.fXv);
else
    M.fbus = zeros(0,1);
end

%% ---------------------------------------------------------- güç akışı
btype = 3*ones(9,1); Vset = ones(9,1); Psp = zeros(9,1); Qsp = zeros(9,1);
for k = 1:size(d.loads,1)
    Psp(d.loads(k,1)) = Psp(d.loads(k,1)) - d.loads(k,2);
    Qsp(d.loads(k,1)) = Qsp(d.loads(k,1)) - d.loads(k,3);
end
for k = 1:nm
    b = m(k).bus;
    if b == 1, btype(b) = 1; else, btype(b) = 2; Psp(b) = Psp(b) + m(k).P; end
    Vset(b) = m(k).Vset;
end
if btype(1) ~= 1, error('G1 (salınım barası) devrede olmalı.'); end
for k = 1:numel(G)
    if G(k).Kv > 0 && btype(G(k).bus) == 3, btype(G(k).bus) = 2; Vset(G(k).bus) = G(k).Vref; end
end
for k = 1:M.ng, Psp(G(k).bus) = Psp(G(k).bus) + G(k).P0; end
for k = 1:M.nf, Psp(F(k).bus) = Psp(F(k).bus) + F(k).Pset; end
[V0, Sbus, ok] = loadflow(Y0, btype, Vset, Psp, Qsp);
if ~ok, warning('build_model:lf', 'Güç akışı yakınsamadı: %s', sc.name); end
M.lf = struct('V',V0,'S',Sbus,'btype',btype);
Qld = zeros(9,1); for k = 1:size(d.loads,1), Qld(d.loads(k,1)) = Qld(d.loads(k,1)) + d.loads(k,3); end
for b = unique([G([G.Kv] > 0).bus])
    if any([m.bus] == b), continue; end
    jj = find([G.bus] == b & [G.Kv] > 0);
    Qb = imag(Sbus(b)) + Qld(b);
    for j = jj, G(j).Q0 = Qb*G(j).Sr/sum([G(jj).Sr]); end
end
if M.ng > 0, M.G = G; M.gQ0 = [G.Q0]'; M.gKv = [G.Kv]'; M.gVref = abs(V0(M.gbus)); end

%% ---------------------------------------------------------- yükler
M.lbus = d.loads(:,1); M.lP0 = d.loads(:,2); M.lQ0 = d.loads(:,3);
M.lV0 = abs(V0(M.lbus));
M.lap = sc.load.ap; M.laq = sc.load.aq; M.lkpf = sc.load.kpf; M.lkqf = sc.load.kqf;
M.lyl0 = (M.lP0 - 1i*M.lQ0)./M.lV0.^2;       % başlangıç empedans eşdeğeri (Y'ye)

%% ---------------------------------------------------------- durum indeksleri
M.nxm = 10; M.nxg = 9; M.nxf = 4;
o = 0;
M.im = reshape(o + (1:M.nxm*nm), nm, M.nxm);        o = o + M.nxm*nm;
M.ig = reshape(o + (1:M.nxg*M.ng), M.ng, M.nxg);    o = o + M.nxg*M.ng;
M.ifm = reshape(o + (1:M.nxf*M.nf), M.nf, M.nxf);   o = o + M.nxf*M.nf;
M.nx = o;
x0 = zeros(o,1);

%% ---------------------------------------------------------- makine başlatma
convS = zeros(9,1);
for k = 1:M.ng, convS(G(k).bus) = convS(G(k).bus) + G(k).P0 + 1i*G(k).Q0; end
for k = 1:M.nf, convS(F(k).bus) = convS(F(k).bus) + F(k).Pset; end
e = d.exc;
M.exc = e;
M.Pm0 = zeros(nm,1); M.Vref = zeros(nm,1);
for k = 1:nm
    b = m(k).bus;
    Sg = Sbus(b) - convS(b);
    V = V0(b); I = conj(Sg/V);
    dl = angle(V + 1i*m(k).xq*I);
    rot = exp(1i*(dl - pi/2));
    idq = I/rot; vdq = V/rot;
    Id = real(idq); Iq = imag(idq);
    Edp = (m(k).xq - m(k).xqp)*Iq;
    Eqp = imag(vdq) + m(k).xdp*Id;
    Efd = Eqp + (m(k).xd - m(k).xdp)*Id;
    SE = e.Ax*exp(e.Bx*Efd);
    VR = (e.KE + SE)*Efd; Rf = e.KF/e.TF*Efd;
    M.Vref(k) = abs(V) + VR/e.KA;
    Pm = real(Sg); M.Pm0(k) = Pm;
    gst = [0 0 0];
    switch m(k).gov
        case 'steam', gst = [Pm Pm 0];
        case 'hydro', g0 = Pm/m(k).Srat; gst = [g0 0 g0];
    end
    x0(M.im(k,:)) = [dl 1 Eqp Edp Efd VR Rf gst];
end
M.Pref = M.Pm0;
M.g0 = zeros(nm,1); M.g0(M.isHydro) = M.Pm0(M.isHydro)./M.mSrat(M.isHydro);
M.tg = d.tgov; M.hg = d.hgov;

%% ---------------------------------------------------------- GFL başlatma
for k = 1:M.ng
    b = G(k).bus; V = V0(b);
    Ip = G(k).P0/abs(V); Iq = G(k).Q0/abs(V);
    wr = 1;
    if G(k).typ == 3
        wr = (G(k).P0/G(k).Prat)^(1/3);
    end
    x0(M.ig(k,:)) = [angle(V) 0 Ip Iq 0 0 G(k).soc0 wr abs(V)];
end
if M.ng > 0
    M.gv = zeros(M.ng,1);                   % rüzgar hızı (m/s), MPPT dengesinden
    M.gv(M.gtyp==3) = 12*x0(M.ig(M.gtyp==3,8));
end

%% ---------------------------------------------------------- GFM başlatma
for k = 1:M.nf
    b = F(k).bus; V = V0(b);
    I = conj((F(k).Pset + 1i*F(k).Q0)/V);
    E = V + 1i*F(k).Xv*I;
    x0(M.ifm(k,:)) = [angle(E) 0 abs(E) F(k).soc0];
    M.fE0(k,1) = abs(E);
end

%% ---------------------------------------------------------- ağ matrisi
M.Y0 = Y0;
M = refactor(M);
M.Vinit = V0;
end

% =========================================================================
function r = gflrec(bus,typ,Sr,Imax,fn,ze,Ti,Tm,Tr,Kd,Kh,db,P0,E,soc0,eta,Prat,Ht,lim,Kdw,Khw)
wn = 2*pi*fn;
r = struct('bus',bus,'typ',typ,'Sr',Sr,'Imax',Imax*Sr,'Kp',2*ze*wn,'Ki',wn^2,'Ti',Ti, ...
    'Tm',Tm,'Tr',Tr,'Kd',Kd,'Kh',Kh,'db',db,'P0',P0,'Q0',0,'E',E,'soc0',soc0,'eta',eta, ...
    'Prat',Prat,'Ht',Ht,'lim',lim,'Kdw',Kdw,'Khw',Khw,'Kv',0,'Vref',1.0);
end

function cp = cpfun(lam)
li = 1./(1./lam - 0.035);
cp = 0.5176*(116./li - 5).*exp(-21./li) + 0.0068*lam;
end

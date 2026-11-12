function sc = sc_fill(sc)
%SC_FILL  Senaryo yapısındaki eksik alanları varsayılanlarla doldurur.
%
% Senaryo alanları (hepsi opsiyonel):
%   name    : metin
%   f0      : 60 (benchmark) | 50
%   gens    : devredeki jeneratörler, örn. [1 2 3]
%   k       : 1x3 devredeki ünite oranı (agrega santral; k<1 => bazı üniteler kapalı)
%   Pg      : 1x3 dağıtım (pu, 100 MVA); Pg(1) yok sayılır (salınım barası)
%   gov     : {'hydro','steam','steam'}; 'none' => sabit Pm
%   D       : 1x3 mekanik sönüm (pu, makine bazında) [0 0 0]
%   pv      : struct dizisi (bus, P [MW], S [MVA])
%   bess    : struct dizisi (type 'gfl'|'gfm', bus, S [MVA], E [MWh], Hv [s], R [pu, Inf=kapalı], ...)
%   wind    : struct dizisi (bus, P [MW], Prated [MW], Ht [s], Kh, Kd, lim)
%   sc      : senkron kompansatör dizisi (bus, S [MVA], H [s])
%   load    : struct(ap, aq, kpf, kqf)  P ~ V^ap (1+kpf*df), Q ~ V^aq (1+kqf*df)
%   events  : struct dizisi (t, type 'load'|'gtrip'|'convtrip', bus|gen|idx, dP [MW])
%   pll     : struct(fn [Hz], zeta)
if ~isfield(sc,'name'), sc.name = 'senaryo'; end
if ~isfield(sc,'f0'), sc.f0 = 60; end
if ~isfield(sc,'gens'), sc.gens = [1 2 3]; end
if ~isfield(sc,'k'), sc.k = [1 1 1]; end
if ~isfield(sc,'Pg'), sc.Pg = [NaN 1.63 0.85]; end
if ~isfield(sc,'gov'), sc.gov = {'hydro','steam','steam'}; end
if ~isfield(sc,'D'), sc.D = [0 0 0]; end
if ~isfield(sc,'pv'), sc.pv = struct('bus',{},'P',{},'S',{}); end
if ~isfield(sc,'bess'), sc.bess = struct('type',{},'bus',{},'S',{}); end
if ~isfield(sc,'wind'), sc.wind = struct('bus',{},'P',{}); end
if ~isfield(sc,'sc'), sc.sc = struct('bus',{},'S',{},'H',{}); end
if ~isfield(sc,'load'), sc.load = struct(); end
L = sc.load;
if ~isfield(L,'ap'), L.ap = 1.0; end
if ~isfield(L,'aq'), L.aq = 2.0; end
if ~isfield(L,'kpf'), L.kpf = 1.0; end
if ~isfield(L,'kqf'), L.kqf = 0.0; end
sc.load = L;
if ~isfield(sc,'events'), sc.events = struct('t',{},'type',{}); end
if ~isfield(sc,'pll'), sc.pll = struct(); end
if ~isfield(sc.pll,'fn'), sc.pll.fn = 5; end
if ~isfield(sc.pll,'zeta'), sc.pll.zeta = 0.707; end
if ~isfield(sc,'Vset'), sc.Vset = []; end

% --- BESS varsayılanları
for k = 1:numel(sc.bess)
    b = sc.bess(k);
    b = dflt(b,'type','gfl'); b = dflt(b,'E',[]); b = dflt(b,'Hv',0);
    b = dflt(b,'R',Inf); b = dflt(b,'db',0); b = dflt(b,'Tm',0.02);
    b = dflt(b,'Tr',0.05); b = dflt(b,'Ti',0.02); b = dflt(b,'Imax',1.0);
    b = dflt(b,'soc0',0.5); b = dflt(b,'eta',0.95); b = dflt(b,'P0',0);
    b = dflt(b,'Xv',0.15); b = dflt(b,'mq',0.05); b = dflt(b,'Tq',0.1);
    b = dflt(b,'fn',[]);
    if isempty(b.E), b.E = b.S*1.0; end          % varsayılan 1 saatlik (TR pratiği)
    bb(k) = b; %#ok<AGROW>
end
if ~isempty(sc.bess), sc.bess = bb; end
for k = 1:numel(sc.pv)
    p = sc.pv(k);
    if ~isfield(p,'S') || isempty(p.S), p.S = 1.1*p.P; end
    pp(k) = p; %#ok<AGROW>
end
if ~isempty(sc.pv), sc.pv = pp; end
for k = 1:numel(sc.wind)
    w = sc.wind(k);
    w = dflt(w,'Prated',w.P/0.67); w = dflt(w,'Ht',4.0);
    w = dflt(w,'Kh',0); w = dflt(w,'Kd',0); w = dflt(w,'lim',0.10);
    w = dflt(w,'S',1.1*w.Prated);
    ww(k) = w; %#ok<AGROW>
end
if ~isempty(sc.wind), sc.wind = ww; end
end

function s = dflt(s, f, v)
if ~isfield(s, f) || isempty(s.(f)), s.(f) = v; end
end

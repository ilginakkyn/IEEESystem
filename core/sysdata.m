function d = sysdata()
%SYSDATA  WSCC 3 makine 9 baralı sistem (Anderson & Fouad 2003, Tablo 2.1;
%         Sauer & Pai 1998, Örnek 7.1). Tüm empedanslar 100 MVA bazında pu.
%
%   Jeneratör dinamik verisi (100 MVA bazında):
%     G1: hidro, 247.5 MVA, 16.5 kV, 180 dev/dk
%     G2: buhar, 192 MVA, 18 kV, 3600 dev/dk
%     G3: buhar, 128 MVA, 13.8 kV, 3600 dev/dk
d.f0 = 60;      % Hz (benchmark). 50 Hz çalışmalar için scenario.f0 kullanılır.
d.Sb = 100;     % MVA

% Hatlar: [from to R X B_toplam]
d.lines = [4 5 0.0100 0.0850 0.176;
           4 6 0.0170 0.0920 0.158;
           5 7 0.0320 0.1610 0.306;
           6 9 0.0390 0.1700 0.358;
           7 8 0.0085 0.0720 0.149;
           8 9 0.0119 0.1008 0.209];
% Transformatörler: [from to X]
d.trafos = [1 4 0.0576; 2 7 0.0625; 3 9 0.0586];
% Yükler: [bara P Q] (pu, 100 MVA)
d.loads = [5 1.25 0.50; 6 0.90 0.30; 8 1.00 0.35];

g = struct([]);
%            bus  S     H      xd     xdp    xq     xqp    Td0p  Tq0p   V     P      gov
g = addg(g,  1, 247.5, 23.64, 0.1460, 0.0608, 0.0969, 0.0969, 8.96, 0.310, 1.040, NaN,  'hydro');
g = addg(g,  2, 192.0,  6.40, 0.8958, 0.1198, 0.8645, 0.1969, 6.00, 0.535, 1.025, 1.63, 'steam');
g = addg(g,  3, 128.0,  3.01, 1.3125, 0.1813, 1.2578, 0.2500, 5.89, 0.600, 1.025, 0.85, 'steam');
d.gen = g;

% IEEE DC1A uyarma sistemi (Sauer & Pai Örnek 7.1, üç makinede aynı)
d.exc = struct('KA',20,'TA',0.2,'KE',1.0,'TE',0.314,'KF',0.063,'TF',0.35, ...
               'Ax',0.0039,'Bx',1.555);
% Buhar regülatörü TGOV1 (PSS/E tipik değerleri), makine bazında
d.tgov = struct('R',0.05,'T1',0.5,'T2',3.0,'T3',10.0,'Vmax',1.0,'Vmin',0.0);
% Hidro regülatör: geçici düşümlü (Kundur 1994, Böl. 9.2), Tw = 1.5 s
Tw = 1.5; TM = 2*23.64*100/247.5;                       % TM = 2H (makine bazı)
d.hgov = struct('Rp',0.05,'Tw',Tw,'TG',0.2, ...
                'RT',(2.3-(Tw-1)*0.15)*Tw/TM, 'TR',(5.0-(Tw-1)*0.5)*Tw, ...
                'Gmax',1.0,'Gmin',0.0);
end

function g = addg(g, bus, S, H, xd, xdp, xq, xqp, Td0p, Tq0p, V, P, gov)
k = numel(g) + 1;
g(k).bus = bus; g(k).S = S; g(k).H = H; g(k).xd = xd; g(k).xdp = xdp;
g(k).xq = xq; g(k).xqp = xqp; g(k).Td0p = Td0p; g(k).Tq0p = Tq0p;
g(k).V = V; g(k).P = P; g(k).gov = gov;
end

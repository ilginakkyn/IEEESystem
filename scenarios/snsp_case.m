function sc = snsp_case(p, btype, commit, f0, dP)
%SNSP_CASE  Yenilenebilir payı (SNSP) taraması için senaryo.
%   p      : PV üretiminin yüke oranı (0 ... 0.7); PV, baz dağıtım oranında baralar 1-2-3'e
%            yerleşir ve senkron üretimi aynı oranda azaltır
%   btype  : 'none' | 'gfl' | 'gfm'  (40 MVA, Bara 2, Hv = 16 s, R = %2)
%   commit : 'prop' -> devredeki ünite sayısı üretimle orantılı azalır (atalet ve rezerv düşer)
%            'keep' -> tüm üniteler devrede kalır, sadece yükleri azalır (atalet sabit)
%   SNSP = P_PV / P_yük (bu sistemde ithalat/ihracat yok)
if nargin < 4, f0 = 50; end
if nargin < 5, dP = 31.5; end
P0 = [0.716 1.63 0.85];               % baz dağıtım (pu), Sauer & Pai Tablo 7.1
Pl = 315;                             % toplam yük (MW)
pv = p*Pl*P0/sum(P0);                 % MW, bara 1,2,3
sc = struct('f0', f0);
sc.name = sprintf('SNSP-%02d-%s-%s', round(100*p), btype, commit);
sc.gens = [1 2 3];
sc.Pg = [NaN, P0(2) - pv(2)/100, P0(3) - pv(3)/100];
if strcmp(commit,'prop')
    sc.k = max(0.1, 1 - pv./(100*P0));
else
    sc.k = [1 1 1];
end
if p > 0
    sc.pv = struct('bus',{1,2,3},'P',num2cell(pv),'S',num2cell(1.1*pv));
end
switch btype
    case 'gfl', sc.bess = struct('type','gfl','bus',2,'S',40,'Hv',16,'R',0.02);
    case 'gfm', sc.bess = struct('type','gfm','bus',2,'S',40,'Hv',16,'R',0.02);
end
sc.events = struct('t',1,'type','load','bus',6,'dP',dP);
end

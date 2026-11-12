function sc = scenario_lib(id, f0, ev)
%SCENARIO_LIB  Rapordaki senaryo matrisi (S0–S10). Şebekeye ekleme/çıkarma burada tanımlanır.
%   sc = scenario_lib('S5', 50, 'E1')
%   id : 'S0' ... 'S10' (alt harfli varyantlar dahil, ör. 'S8b')
%   f0 : 50 (varsayılan, Türkiye) | 60 (Anderson & Fouad / MathWorks şablonu)
%   ev : 'E1' = Bara 6'ya +31.5 MW (yükün %10'u), 'E2' = +63 MW (%20), 'none'
%
%   Kendi senaryonuzu eklemek için bir 'case' kopyalayıp alanları değiştirin:
%     sc.gens  -> devredeki senkron jeneratörler (çıkarmak için listeden silin)
%     sc.pv    -> PV santrali ekle  : struct('bus',b,'P',MW,'S',MVA)
%     sc.bess  -> BESS ekle         : struct('type','gfl'|'gfm','bus',b,'S',MVA,'Hv',s,'R',pu)
%     sc.wind  -> rüzgar ekle       : struct('bus',b,'P',MW,'Prated',MW,'Kh',..,'Kd',..)
%     sc.sc    -> senkron kompansatör: struct('bus',b,'S',MVA,'H',s)
if nargin < 2 || isempty(f0), f0 = 50; end
if nargin < 3 || isempty(ev), ev = 'E1'; end

PV2  = struct('bus',2,'P',163,'S',180);           % G2 yerine PV (163 MW)
PV3  = struct('bus',3,'P',85,'S',95);             % G3 yerine PV (85 MW)
GFL  = @(b,S,Hv,R) struct('type','gfl','bus',b,'S',S,'Hv',Hv,'R',R);
GFM  = @(b,S,Hv,R) struct('type','gfm','bus',b,'S',S,'Hv',Hv,'R',R);
Hv0 = 16; S0b = 40; R0 = 0.02;                    % 40 MVA, Hv = 16 s (=640 MWs = G2), R = %2

sc = struct('name', id, 'f0', f0);
switch id
    case 'S0'                                       % baz: 3 senkron makine
    case 'S1', sc.gens = [1 2]; sc.pv = PV3;
    case 'S2', sc.gens = [1 3]; sc.pv = PV2;
    case 'S3', sc.gens = [1 3]; sc.pv = PV2; sc.bess = GFL(2,S0b,Hv0,Inf);
    case 'S4', sc.gens = [1 3]; sc.pv = PV2; sc.bess = GFL(2,S0b,0,R0);
    case 'S5', sc.gens = [1 3]; sc.pv = PV2; sc.bess = GFL(2,S0b,Hv0,R0);
    case 'S6', sc.gens = [1 3]; sc.pv = PV2; sc.bess = GFM(2,S0b,Hv0,R0);
    case 'S7'                                       % dağıtık: 3 x 13.33 MVA, yük baralarında
        sc.gens = [1 3]; sc.pv = PV2;
        s = S0b/3; sc.bess = [GFL(5,s,Hv0,R0) GFL(6,s,Hv0,R0) GFL(8,s,Hv0,R0)];
    case {'S8a','S8b','S8c'}                        % G1 ünitelerinin yarısı kapalı
        sc.gens = [1 3]; sc.pv = PV2; sc.k = [0.5 1 1];
        if strcmp(id,'S8b'), sc.bess = GFL(2,S0b,Hv0,R0); end
        if strcmp(id,'S8c'), sc.bess = GFM(2,S0b,Hv0,R0); end
    case {'S9a','S9b','S9c'}                        % G2 yerine Tip-4 rüzgar (163 MW, 243 MW anma)
        sc.gens = [1 3];
        w = struct('bus',2,'P',163,'Prated',243,'Kh',0,'Kd',0,'lim',0.10);
        if strcmp(id,'S9b'), w.Kh = 2*5; w.Kd = 1/0.05; end  % H_si = 5 s, %5 düşüm
        sc.wind = w;
        if strcmp(id,'S9c'), sc.bess = GFL(2,S0b,Hv0,R0); end
    case 'S10'                                      % S2 + senkron kompansatör (160 MVA, H = 4 s)
        sc.gens = [1 3]; sc.pv = PV2; sc.sc = struct('bus',2,'S',160,'H',4);
    otherwise
        error('Bilinmeyen senaryo: %s', id);
end
switch ev
    case 'E1', sc.events = struct('t',1,'type','load','bus',6,'dP',31.5);
    case 'E2', sc.events = struct('t',1,'type','load','bus',6,'dP',63);
    case 'none'
    otherwise, error('Bilinmeyen olay: %s', ev);
end
sc.name = sprintf('%s-%s-%dHz', id, ev, f0);
end

function [M, x] = apply_event(ev, M, x, V)
%APPLY_EVENT  Bozucu olayı uygular.
%   'load'     : ev.bus barasındaki yüke ev.dP [MW] (ve ev.dQ [Mvar]) eklenir
%   'gtrip'    : ev.bus barasındaki senkron makine açılır (ağdan çıkar)
%   'convtrip' : ev.idx numaralı GFL cihazının üretimi ev.dP [MW] azalır (ör. PV kısmi açma)
switch ev.type
    case 'load'
        j = find(M.lbus == ev.bus, 1);
        if isempty(j), error('Bara %d''da yük yok.', ev.bus); end
        M.lP0(j) = M.lP0(j) + ev.dP/100;
        if isfield(ev,'dQ') && ~isempty(ev.dQ), M.lQ0(j) = M.lQ0(j) + ev.dQ/100; end
    case 'gtrip'
        j = find(M.mbus == ev.bus & M.mon, 1);
        M.mon(j) = false;
        M = refactor(M);
    case 'convtrip'
        j = ev.idx;
        M.gP0(j) = M.gP0(j) - ev.dP/100;
        x(M.ig(j,3)) = x(M.ig(j,3)) - ev.dP/100/abs(V(M.gbus(j)));
    otherwise
        error('Bilinmeyen olay tipi: %s', ev.type);
end
end

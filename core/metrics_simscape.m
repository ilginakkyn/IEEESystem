function m = metrics_simscape(t, w_pu, HS, f0, t_dist, win)
%METRICS_SIMSCAPE  Simscape (ya da başka) sonuçlarından frekans ölçütlerini hesaplar.
%
%   m = metrics_simscape(t, w_pu, HS, f0, t_dist, win)
%     t      : Nx1 zaman (s)
%     w_pu   : NxG rotor hızları (pu); her sütun bir senkron makine
%     HS     : 1xG her makinenin kinetik enerjisi H_i*S_i (MWs) — COI ağırlığı
%              (IEEE 9 bara: G1 2364, G2 640, G3 301 MWs)
%     f0     : nominal frekans (60 ya da 50 Hz)
%     t_dist : bozulma anı (s); MathWorks şablonunda 10 s
%     win    : RoCoF penceresi (s), varsayılan 0.5
%
%   m.f_coi (Hz), m.rocof (Hz/s), m.nadir (Hz), m.t_nadir (s, bozulmadan sonra),
%   m.f_ss (Hz, son değer)
%
%   Simscape logging'den hız almak için örnek (blok yolları modelinize göre değişir):
%     sscexplore(simlog_IEEE9Bus)          % ağacı gezip doğru düğümü bulun
%     n  = simlog_IEEE9Bus.Generator_1.Synchronous_Machine.<hız düğümü>;
%     t  = n.series.time;  w1 = n.series.values;
%   Hız rad/s olarak gelirse w_pu = w / (2*pi*f0/p) ile pu'ya çevirin (p: kutup çifti).

if nargin < 6 || isempty(win), win = 0.5; end
t = t(:); HS = HS(:)';
% farklı zaman adımlarıyla kaydedildiyse önce ortak t'ye interpole edin
f_coi = f0 * (w_pu * HS') / sum(HS);
i0 = find(t >= t_dist, 1);
f_start = interp1(t, f_coi, t_dist);
f_win   = interp1(t, f_coi, t_dist + win);
m.f_coi = f_coi;
m.rocof = (f_win - f_start)/win;
[m.nadir, im] = min(f_coi(i0:end));
m.t_nadir = t(i0+im-1) - t_dist;
m.f_ss = f_coi(end);
fprintf('RoCoF = %.3f Hz/s | nadir = %.3f Hz (%.2f s sonra) | son = %.3f Hz\n', ...
        m.rocof, m.nadir, m.t_nadir, m.f_ss);
end

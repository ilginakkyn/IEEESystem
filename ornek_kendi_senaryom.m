%% ORNEK_KENDI_SENARYOM  Şebekeye ekleme/çıkarma yapıp tek bir benzetim koşturma örneği
%  MATLAB'de bu klasördeyken çalıştırın:  >> ornek_kendi_senaryom
%  Süre: ~1-2 dk (20 s benzetim). Octave'da da çalışır.
clear; clc;
addpath('core'); addpath('scenarios'); addpath('analytic');

%% 1) Hazır bir senaryodan başla (S2: G2 çıkarıldı, yerine 163 MW PV)
sc = scenario_lib('S2', 50, 'E1');      % 50 Hz, Bara 6'ya +31.5 MW

%% 2) Ekle / çıkar
% G3'ü de çıkarmak isterseniz:            sc.gens = [1];   (G1 salınım barası, hep kalmalı)
% Bara 3'e 85 MW PV eklemek:              sc.pv(end+1) = struct('bus',3,'P',85,'S',95);
% Bara 5'e 20 MVA GFM-BESS eklemek:
sc.bess = struct('type','gfm','bus',5,'S',20,'Hv',8,'R',0.02);
% Bara 8'e 20 MVA GFL-BESS eklemek (ikinci batarya grubu):
sc.bess(2) = struct('type','gfl','bus',8,'S',20,'Hv',8,'R',0.02);
% G1'in ünitelerinin %70'i devrede olsun (atalet ve rezerv azalır):
sc.k = [0.7 1 1];
% Bozulmayı değiştirmek: G3 açması
% sc.events = struct('t',1,'type','gtrip','bus',3);
sc.name = 'benim-senaryom';

%% 3) Koş ve ölçütleri yazdır
R = sim_run(sc, struct('t_end', 20));
m = R.met;
fprintf('\n%s\n', sc.name);
fprintf('  RoCoF (500 ms, COI) : %.3f Hz/s\n', m.rocof500);
fprintf('  Nadir               : %.3f Hz  (%.2f s sonra)\n', m.nadir, m.t_nadir);
fprintf('  Oturma frekansı     : %.3f Hz\n', m.f_qss);
fprintf('  En kötü yerel RoCoF : %.3f Hz/s\n', -max(abs(m.rocof_bus)));
fprintf('  Dönüştürücü tepe ΔP : %s MW (sıra: PV, GFL-BESS, rüzgar, GFM-BESS)\n', mat2str(round(m.dP_conv_max)));

%% 4) Çiz
figure; subplot(2,1,1); plot(R.t, R.f, 'LineWidth', 1.5); grid on; hold on;
plot([0 20], [49.2 49.2], 'k--'); ylabel('f_{COI} (Hz)'); title(sc.name);
subplot(2,1,2); plot(R.t, [R.Pg R.Pf] - repmat([R.Pg(1,:) R.Pf(1,:)], numel(R.t), 1), 'LineWidth', 1.2);
grid on; xlabel('Zaman (s)'); ylabel('\DeltaP dönüştürücüler (MW)');

%% 5) Doğrusal düşük mertebeli modelle karşılaştır (ağ ihmal)
L = lom_sim(sc, 20, 0.001);
fprintf('  DMM nadir           : %.3f Hz (ağ modeli: %.3f)\n', L.met.nadir, m.nadir);

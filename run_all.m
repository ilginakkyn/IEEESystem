%% RUN_ALL  Rapordaki tüm sonuçları yeniden üretir.
%  Tek oturumda: >> run_all            (~5-6 saat; yerleşim taraması en uzun adım)
%  Paralel: iki MATLAB oturumu açıp birinde run_worker(1,2), diğerinde run_worker(2,2)
%  çalıştırın; sonra bu dosyanın son iki adımını koşun.
clear; clc;
addpath('core'); addpath('scenarios'); addpath('analytic');

%% 1) Doğrulama: Sauer & Pai öz değerleri + zayıf şebeke + PLL (küçük sinyal)
ss_study();     % results/ss_validation_SP.csv, ss_scenarios.csv
ss_weak();      % results/ss_weakgrid.csv, ss_pll.csv

%% 2) Zaman bölgesi: 149 koşu (senaryo matrisi + taramalar)
run_worker(1, 1);          % results/<id>.mat

%% 3) Topla, tablo ve şekiller
T = collect_results(true); % results/summary_all.csv, figures/*.png

%% 4) Zaman adımı yakınsaması (Bölüm 5.6)
dt_conv();                 % results/dt_conv.csv

%% 5) Konum ve grup sayısı: 114 yerleşim x 3 bozulma yeri (Bölüm 7.3, ~1,5 saat/2 çekirdek)
place_study(1, 1);         % results/place_runs_w1.csv, place_ss.csv
%  özet: sistem kabuğunda  python3 scenarios/place_analyze.py  -> results/place_summary.csv

%% 6) Dayanıklılık (Bölüm 7.9) ve N-1 boyutlandırma (Bölüm 9)
rob_study(1, 1, [2 3]);    % results/rob_runs_w1.csv
n1_sizing(1, 1);           % results/n1_sizing_w1.csv
split80(1); split80(2);    % results/split80_w*.csv

%% 6b) Oturma kriteri için SNSP (30 s) ve N-1 yerleşiminin yük modeline duyarlılığı
snsp_qss30();              % results/snsp_qss30.csv
n1_split_loadmodel();      % results/n1_split_loadmodel.csv

%% 6c) Testler
addpath('tests'); run_tests();   % results/test_report.csv

%% 7) Türkçe etiketli PNG şekiller (MATLAB'siz ortam için):  python3 scenarios/make_figures.py

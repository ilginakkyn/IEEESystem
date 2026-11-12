# IEEE 9 Baralı Sistem — BESS ile Sanal Atalet ve Frekans Kararlılığı (v2)

Mühendislik tasarım projesi için fazör (RMS) zaman bölgesi ve küçük sinyal modeli.
**MATLAB (R2019b+) ve GNU Octave (8.x) ile aynı şekilde çalışır.** Toolbox gerekmez.

## Hızlı başlangıç

```matlab
>> ornek_kendi_senaryom     % şebekeye ekle/çıkar, tek benzetim, grafik (~1-2 dk)
>> run_all                  % rapordaki tüm sonuçları yeniden üretir (~5-6 saat)
```

## Klasörler

| Klasör / dosya | İçerik |
|---|---|
| `core/sysdata.m` | Anderson & Fouad / Sauer & Pai sistem verisi (makine, uyarma, regülatör) |
| `core/build_model.m` | Senaryodan model kurar, güç akışını çözer, durumları dengede başlatır |
| `core/deriv.m` | Tüm dinamik denklemler + ağ çözümü (raporun 3. bölümü) |
| `core/sim_run.m` | RK4 benzetim, olaylar, kayıt |
| `core/metrics_calc.m` | RoCoF (100/500 ms, COI ve bara), nadir, oturma, BESS güç/enerji/SOC |
| `core/linearize.m` | Sayısal Jakobyen, öz değer, sönüm, katılım çarpanları |
| `core/metrics_simscape.m` | Simscape'ten alınan rotor hızlarından aynı ölçütler |
| `scenarios/scenario_lib.m` | Senaryo matrisi S0–S10 (ekleme/çıkarma burada) |
| `scenarios/snsp_case.m` | Yenilenebilir payı taraması (ünite ataması seçenekli) |
| `scenarios/job_list.m` | Rapordaki 149 zaman bölgesi koşusu |
| `scenarios/run_worker.m` | İşleri koşar (paralel bölünebilir) |
| `scenarios/ss_study.m`, `ss_weak.m` | Sauer & Pai doğrulaması, senaryo öz değerleri, zayıf şebeke, PLL |
| `scenarios/collect_results.m` | Sonuçları `results/summary_all.csv` ve `figures/*.png` olarak toplar |
| `scenarios/dt_conv.m` | Zaman adımı yakınsaması (rapor 5.6) |
| `scenarios/place_study.m`, `place_analyze.py` | Konum ve grup sayısı tam sayımı: 114 yerleşim × 3 bozulma yeri + sönüm (rapor 7.3) |
| `scenarios/rob_study.m` | Dayanıklılık: 6 bozulma/yük durumu × 5 yapı (rapor 7.9) |
| `scenarios/n1_sizing.m`, `split80.m` | N-1 (G3 açması) için BESS gücü taraması ve 80 MVA'nın bölünmesi (rapor 9) |
| `scenarios/snsp_qss30.m` | SNSP taramasının oturma frekansı için 30 s'lik tekrarı (rapor 7.1) |
| `scenarios/n1_split_loadmodel.m` | N-1 yerleşiminin yük modeline duyarlılığı (rapor 9.1) |
| `tests/run_tests.m` | Otomatik test paketi |
| `validation/` | ANDES ile bağımsız çapraz doğrulama |
| `scenarios/make_figures.py` | Türkçe etiketli PNG şekiller (Python/matplotlib; MATLAB'siz ortam için) |
| `analytic/sfr_am.m` | Anderson & Mirheydar SFR kapalı formu |
| `analytic/lom_sim.m` | Doğrusal düşük mertebeli model (ağ ihmal, gerçek regülatörler) |
| `results/` | Tüm koşuların sonuçları (.mat ve .csv) |
| `figures/` | Rapordaki şekillerin PNG'leri |

## Şebekeye ekleme / çıkarma

```matlab
sc = scenario_lib('S2', 50, 'E1');                         % G2 çıkarılmış, yerine 163 MW PV
sc.gens = [1 3];                                           % devredeki senkron jeneratörler
sc.pv(end+1)  = struct('bus',3,'P',40,'S',44);             % PV ekle
sc.bess = struct('type','gfm','bus',2,'S',40,'Hv',16,'R',0.02);   % GFM-BESS
sc.bess(2) = struct('type','gfl','bus',8,'S',20,'Hv',8,'R',0.02); % ikinci grup, GFL
sc.wind = struct('bus',2,'P',100,'Prated',150,'Kh',10,'Kd',20);   % Tip-4 rüzgar
sc.sc   = struct('bus',2,'S',100,'H',4);                   % senkron kompansatör
sc.k    = [0.5 1 1];                                       % G1 ünitelerinin yarısı kapalı
sc.events = struct('t',1,'type','gtrip','bus',3);          % G3 açması
sc.f0 = 60;                                                % 60 Hz (MathWorks şablonu)
R = sim_run(sc, struct('t_end',20));  disp(R.met)
L = linearize(sc);                    disp(L.lam(1:10))
```

BESS alanları: `type` ('gfl'|'gfm'), `bus`, `S` [MVA], `E` [MWh, varsayılan = S×1 h], `Hv` [s, kendi
bazında], `R` [pu, `Inf` = droop kapalı], `db` [pu ölü bant], `Tm`, `Tr`, `Ti` [s], `fn` [Hz PLL],
`Imax` [pu], `soc0`; GFM için ek olarak `Xv`, `mq`, `Tq`.

## Testler ve doğrulama (rapor Bölüm 5)

```matlab
>> addpath('tests'); run_tests        % 21 otomatik test (~25 dk); run_tests(true) hızlı sürüm (~5 dk)
```
Sonuç `results/test_report.csv` dosyasına yazılır. Testler: yayınlanmış güç akışı ve öz değerler,
SFR kapalı formu, başlangıç RoCoF'u = salınım denklemi, kalıcı durum güç dengesi, droop, SOC-enerji
dengesi, 50/60 Hz ölçeklemesi, toplama/sıfır-BESS limitleri, denge artığı, zaman adımı, regresyon.

Bağımsız yazılımla çapraz doğrulama (ANDES, Python):
```
octave --eval "addpath('validation'); ieee9v2_same_assumptions"   % bu modelin aynı varsayımlı koşusu
pip install andes && python3 validation/andes_crosscheck.py        % ANDES koşusu ve karşılaştırma
```


- Sauer & Pai Örnek 8.3'ün 21 öz değeri 3–4 anlamlı basamakla yeniden üretilir (`results/ss_validation_SP.csv`).
- SFR kapalı formu = sayısal çözüm; düşük mertebeli model ile tam model nadirde ~%4 içinde.
- 60 Hz ve 50 Hz sonuçları pu olarak aynıdır (Hz cinsinden 1,2 oranı).
- Zaman adımı yakınsaması: 0,5 / 1 / 2 ms beş basamakta aynı (`results/dt_conv.csv`).

## Öne çıkan sonuç dosyaları

| Dosya | İçerik |
|---|---|
| `results/summary_all.csv` | 149 ana koşunun ölçütleri |
| `results/place_summary.csv` | Her yerleşim için en kötü nadir, RoCoF100/500, yerel RoCoF ve sönüm |
| `results/rob_runs_w*.csv` | Dayanıklılık koşuları |
| `results/n1_sizing_w1.csv`, `split80_w*.csv` | N-1 boyutlandırma |
| `results/ss_*.csv` | Öz değer, zayıf şebeke ve PLL analizleri |

## Simscape ile karşılaştırma

1. MathWorks IEEE 9-Bus örneğini değiştirmeden çalıştırın; üç makinenin hızını alın.
2. `m = metrics_simscape(t, [w1 w2 w3], [2364 640 301], 60, 10);`
3. Aynı olayı bu modelde `sc.f0 = 60; sc.events = struct('t',10,'type','load','bus',6,'dP',<MW>);` ile koşun.
4. Fark %10'u aşarsa önce regülatör/AVR parametrelerini ve yük modelini eşleştirin.

## Bilinen sınırlamalar

Fazör (RMS) model; PSS, AGC ve yük atma rölesi yok; PV ana senaryolarda birim güç faktöründe;
DC bara ve batarya hücre dinamiği yok. Ayrıntı: rapor Bölüm 10.

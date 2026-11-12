# Turkey-side brief: grid inertia, frequency rules, BESS, analysts

**How I verified:** I opened every source below myself. Most went through WebFetch. Some PDFs and HTML pages that WebFetch could not read were downloaded with curl and converted to text: the ENTSO-E report, the METU thesis, two DergiPark papers, the Lexpera consolidated regulations, Law 6446 on mevzuat.gov.tr, and Sanlı's 2023 PDF. Anything I could not open is in the final section.

## 1. Analysts and commentators

- **Barış Sanlı.** His blog is [barissanli.com](https://www.barissanli.com/) and his Substack is "Enerji Güncesi" at [barissanli.substack.com](https://barissanli.substack.com/). The Substack archive only goes back to 2026. Searching it for atalet, frekans, batarya and karartma found no post specifically on Turkish grid inertia.
  - [Kış Döneminde Güneş ve Depolama (Bölüm 2)](https://barissanli.com/calismalar/2023/20230105-gunes2.pdf), 5 Jan 2023. Uses EPİAŞ hourly solar data: winter capacity factor "%5'lerin altına", 45-day winter average "%9.6". His most useful inertia lines, verbatim:
    - "Sistem işletiminde en önemli değişen nokta sistemdeki anlık atalet(inertia) miktarıdır."
    - "Sistemdeki atalet(inertia) düşüşü etkisi, elektrik kesintilerine sebep olabilir. Atalet yönetimi teknolojik araçlar kadar kullanma becerisi ve bilgi birikimi istiyor, bunları erken tesis etmek gerekecektir."
    - Says batteries cover short-term flexibility, not multi-day gaps.
  - [Tartışma Notu – Enerji Güvenliğini Elektrikten Öğrenmek](https://barissanli.substack.com/p/tartsma-notu-enerji-guvenligini-elektrikten), 2 Apr 2026. Only a passing mention: "atalet-inertia aslında, kısa dönemli mekanik depolamadır". Also: "Yenilenebilir artışı, sistem performansını tek başına belirleyemez ama esneklik belirler."
  - [Enerji İstatistik Notu 39: Depolama Rüzgar ve Güneşe Ne Kadar Eşlik Edebilir?](https://barissanli.com/calismalar/2024/20241123-ein39-rgyokken.pdf), undated, Nov 2024 series. About German Dunkelflaute, not Turkey. Estimates "70000 MW/15 TWh" of storage would be needed.
- **"Caner Can".** He is real, but he does not write on electricity grids.
  - [His University of Groningen CV](https://www.rug.nl/staff/caner.can/cv?lang=en) says he is "Adviser to Alparslan Bayraktar… Minister of Energy and Natural Resources of Türkiye". He was formerly Energy Counselor at Türkiye's EU Delegation (2022–24) and in Houston (2015–19), and is a PhD student. The [Energy Council speaker profile](https://energycouncil.com/?p=42867) (Dec 2023) says the PhD is on the European energy transition and critical minerals.
  - His Substack is "[Enerji ve Kritik Hammaddeler](https://canercan.substack.com/)", 8 posts in 2026 plus a 2022 placeholder. They cover gas, geopolitics and the EU, for example [Bu da mı Gol Değil!](https://canercan.substack.com/p/bu-da-m-gol-degil) (10 Apr 2026, EU/Russia gas) and [25 Milyar Dolar ve 5 Yıl](https://canercan.substack.com/p/25-milyar-dolar-ve-5-yl) (26 Mar 2026, Gulf infrastructure).
  - Searching it for şebeke, batarya, depolama and frekans returned nothing. He is not a source on inertia.
- **SHURA.**
  - [SHURA Gündem Sayı 7 – İber Yarımadası Elektrik Kesintisi](https://shura.org.tr/wp-content/uploads/2025/07/SHURA-GUNDEM-Sayi-7.pdf), July 2025. States "Olayın temel nedeni düşük sistem ataletinden ziyade gerilim kontrol mekanizmalarının yetersizliğiydi." Says batteries should provide grid-forming capability. Lists 8 lessons for Türkiye, including voltage-control criteria for inverter-based plants.
  - [Increasing the Share of Renewables in Turkey's Power System](https://www.agora-energiewende.org/fileadmin/Partnerpublikationen/2018/SHURA_Partnerpublikationen/SHURA_Increasing-the-Share-of-Renewables-in-Turkeys-Power-System_Report.pdf), 2018. Notes arc-furnace swings: interconnector flows "sometimes exceeds 900 MW in less than 30 seconds", "balanced by overall ENTSO-E rotating inertia" until AGC acts.
- **Robokami / eptr2.** [eptr2 v1.3.6 – Yan Hizmetler kompozit fonksiyonu](https://robokami.substack.com/p/eptr2-v136-yan-hizmetler-kompozit), 12 Mar 2026, adds ancillary-service price and quantity data to the tool. [Üretimde Esneklik](https://robokami.substack.com/p/uretimde-esneklik), 11 Mar 2024, is about batteries. Both are paywalled and I found no frequency-data analysis.
- **Mehmet Öğütçü** (London Energy Club), [İspanya-Portekiz kesintisi: Türkiye'ye dersler](https://yetkinreport.com/2025/05/04/ispanya-portekiz-kesintisi-turkiyeye-dersler-ve-yesil-enerji-riskleri/amp/), 4 May 2025. General policy piece with no inertia content.

## 2. Turkish technical rules (TEİAŞ/EPDK)

- **Elektrik Şebeke Yönetmeliği**, consolidated text on [Lexpera](https://www.lexpera.com.tr/mevzuat/yonetmelikler/elektrik-sebeke-yonetmeligi). The free part covers Articles 1–51.
  - Art. 7: "Sistemin 50 Hertz (Hz) olan nominal frekansı, TEİAŞ tarafından 49,8-50,2 Hz aralığında kontrol edilir."
  - Art. 4 definitions, primary reserve: "Azami primer rezerv kapasitesi: 200 mHz'lik basamak frekans değişimi durumunda en geç 30 saniye içerisinde gerçekleştirilebilecek azami çıkış gücü değişimi".
  - New Art. 4 definitions (RG 17/12/2024-32755) for the limited frequency sensitivity (SFH) modes, triggered below 49,8 Hz and above 50,2 Hz.
  - Art. 20(8), as amended in 2024: plants of 1 MW or more must stay connected for these minimum times:

    | Frequency band | Minimum time connected |
    |---|---|
    | 51–51,5 Hz | 30 dk |
    | 49–51 Hz | sürekli |
    | 48,5–49 Hz | 1 saat |
    | 47,5–48,5 Hz | 30 dk |

  - Governor deadband ("duyarsızlık") must not exceed ±0,010 Hz.
  - Art. 25: units must protect themselves against frequencies outside 47,5–52,5 Hz.
  - Wind and PV are governed by Ek-18 (Art. 19(f) and Art. 20(13)).
- **[2024 amendment, RG 32755, 17 Dec 2024](https://www.alomaliye.com/2024/12/17/elektrik-sebeke-yonetmeliginde-degisiklik-18-12-2024/).**
  - New Art. 67, under-frequency load shedding: shedding starts at 49,0 Hz with at least 5% of demand; 6 to 10 steps, each at most 10% of load; optional df/dt function between 49,8 and 49,0 Hz; total operating time at most 300 ms; relay sensitivity at most 30 mHz.
  - Ek-18 E.18.4 gives wind and PV the same ride-through bands as the table above.
  - Transitional Art. 1: TEİAŞ had to publish technical criteria for storage monitoring, control, ancillary-service use and connection by 1/1/2025.
  - The text has **no RoCoF withstand requirement and no synthetic-inertia or grid-forming requirement**.
- **[Elektrik Piyasası Yan Hizmetler Yönetmeliği](https://www.lexpera.com.tr/mevzuat/yonetmelikler/elektrik-piyasasi-yan-hizmetler-yonetmeligi-1).**
  - Primary reserve capacity is the reserve to be fully activated "sistem frekansında ±200 mHz'lik frekans sapması oluşması durumunda".
  - Art. 12 and Art. 20: "müstakil elektrik depolama tesisleri" can supply primary and secondary reserve once certified.
  - Secondary control receives AGC signals at 4-second intervals.
- **[Ancillary-services amendment news](https://www.ekonomigazetesi.com/sektor-haberleri/elektrik-piyasasinda-yan-hizmet-performans-testlerini-teias-yapacak-76638)**, 9 Apr 2026. TEİAŞ takes over performance tests "1 Eylül 2026'dan itibaren". Plants licensed after 1 Jan 2025 must pass the SFH test.
- **[Elektrik Piyasası Kanunu 6446, Art. 7(10)–(11)](https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=6446&MevzuatTur=1&MevzuatTertip=5)** (added 1/7/2022, Law 7417). Wind/solar pre-licences are granted "kurmayı taahhüt ettikleri elektrik depolama tesisinin kurulu gücüne kadar". So the plant's MW can be at most the storage MW. The law sets no duration; the ~1-hour norm is Ember's market observation (section 4).
- **Storage regulation**, Elektrik Piyasasında Depolama Faaliyetleri Yönetmeliği, RG 09.05.2021.
  - [Erdem & Erdem](https://www.erdem-erdem.av.tr/bilgi-bankasi/elektrik-depolama-faaliyetine-iliskin-guncel-duzenlemeler) (May 2021): standalone storage may take part in ancillary services and the balancing market; minimum 2 MW.
  - [EMO İzmir summary](https://www.emo.org.tr/ekler/d245bff344be2c9_ek.pdf?dergi=1257) (June 2021): no frequency-response, inertia or RoCoF criteria.
- **Battery PFC eligibility**: [Emre Tüfek, "Batarya Depolama Teknolojilerinin Yan Hizmetler Piyasasında Kullanımı…"](https://www.emo.org.tr/ekler/86103ebf466eebc_ek.pdf), EMO slides, about 2023. These are secondary slides; I did not find the TEİAŞ primary document.
  - Requirements: at least 10 MWe; MWh/MW at least 1,25; 10 mHz deadband; 1 s to activate.
  - Average PFC price 18.98 USD/MW (2020) to 40 USD/MW (2024 estimate).

## 3. Academic work and real events

- **[ENTSO-E, Report on Blackout in Turkey on 31st March 2015](https://eepublicdownloads.entsoe.eu/clean-documents/SOC%20documents/Regional_Groups_Continental_Europe/20150921_Black_Out_Report_v10_w.pdf)**, Project Group Turkey, 21 Sep 2015.
  - The western island lost 4700 MW, 21% of its 21870 MW load.
  - Load shedding (UFLS) operated "from 49 Hz to 48.4 Hz" and shed about 4800 MW, plus 377 MW by the special protection scheme (SPS).
  - The 2015 scheme had 4 steps (49 / 48.8 / 48.6 / 48.4 Hz), 35.5% in total.
  - Generators tripped above 47.5 Hz and the island collapsed in about 10 s.
  - The eastern island rose to 52.3 Hz "with gradients of about 1 Hz/s"; the western gradient was about 500 mHz/s.
  - It recommends df/dt shedding steps at "–0.4 – 0.5 Hz/s if… ≤49.7 Hz".
- **Yeşil M., Irmak E., [Estimation of inertia constant in Turkish power system and its analysis during real system disturbances](https://avesis.gazi.edu.tr/yayin/f81cfdcb-2e64-4f79-8612-6e5bcea3d8ea/estimation-of-inertia-constant-in-turkish-power-system-and-its-analysis-during-real-system-disturbances)**, IJEES/ITEES 31(11), 2021, DOI 10.1002/2050-7038.13106.
  - Hourly inertia estimates for Jan–Oct 2019 and RoCoF analysis from PMU data for six 2019 disturbances.
  - Described as the "first realistic" Turkish inertia study. The H values are not verified (paywalled).
- **Yeşil, Tör, Küçükler, Irmak, [Optimal Sizing of BESS Participating in Primary Frequency Control in Turkish Power Grid](https://avesis.gazi.edu.tr/yayin/9c363d44-e0d6-4e27-941c-4ca9e391d21d/optimal-sizing-of-battery-energy-storage-systems-participating-in-primary-frequency-control-in-turkish-power-grid)**, IEEE GPECOM 2024, pp. 554–562, DOI 10.1109/GPECOM61896.2024.10582682. Sizes the battery using depth of discharge, C-rate and a deadband set from a year of frequency data.
- **Özdemirci & Cebeci (Fırat), [Primer Frekans Kontrolünde Batarya Enerji Depolama Sistemleri Kullanımının Analizi](https://dergipark.org.tr/en/pub/ejosat/article/710993)**, EJOSAT 2020, DOI 10.31590/ejosat.araconf37.
  - Turkish system modelled at 15190 MW, Kp = 120 Hz/MWpu, Tp = 20 s.
  - For a 600 MW loss, the deviation is 0.26 / 0.24 / 0.22 Hz (no battery / 50 MW / 100 MW battery). For 900 MW it is 0.38 / 0.36 / 0.34 Hz.
- **Erencan Duymaz (advisor Ozan Keysan), METU MSc, Jan 2019, [Investigation of inertial support limits in wind turbines…](https://open.metu.edu.tr/bitstream/handle/11511/27967/index.pdf)**.
  - Turbines can add 40% of rated power. Turkish wind capacity was 7012 MW (July 2018), 54% of it on full-scale converters.
  - Emulating H = 10 s on full-converter turbines "can compensate the degradation in the effective inertia constant" of the Turkish grid, using 2018 hourly data.
- **Mertcan Acar (advisor V. M. İ. Genç), İTÜ MSc 2025, [Sentetik atalet destekli rüzgar türbinlerinin frekans tepkisi üzerindeki etkilerinin modellenmesi, kontrolü ve dinamik analizi](https://tezara.org/theses/931693)**. Tested on the **Anderson–Fouad 9-bus** and Kundur two-area systems, with 5 MW turbines. Very close to your topic.
- **Cenk Andiç (İTÜ), [Real-Time Inertia Estimation and Adaptive-MPC-Based Virtual Inertia Support…](https://research.itu.edu.tr/tr/publications/real-time-inertia-estimation-and-adaptive-model-predictive-contro/)**, Applied Sciences 16(4):2161, 2026, DOI 10.3390/app16042161.
  - System inertia drops from 5.00 s to 4.54 s at 10% PV.
  - With the adaptive BESS, the nadir improves from 49.6892 to 49.9635 Hz, an 88.25% improvement.
  - Stays stable down to H = 3.33 s.
- **Tör O. B. et al., [Damping measures against prospective oscillations between Turkish grid and ENTSO-E system](https://avesis.tedu.edu.tr/yayin/c87d421d-1152-4a2d-b93e-879780baaeae/damping-measures-against-prospective-oscillations-between-turkish-grid-and-entso-e-system)**, POWERCON 2010, DOI 10.1109/powercon.2010.5666448. Finds an inter-area mode of about 0.15 Hz; tested PSS, SVC, a ±50 MVAr STATCOM and braking resistors.
- **Bulut & Öz, [Operational challenges and multiple solutions for high renewable energy penetration in the Turkish power grid](https://dergipark.org.tr/tr/pub/ijes/article/1888994)**, IJES 11(1), 17 Mar 2026. PV 25,109 MW and wind 14,774 MW at end-2025; instantaneous renewables share above 55%; evening ramps of 8–10 GW in 3–4 h.
- **Kaygusuz et al. (İnönü), [effects of distributed-uncertain production… on power system stability](https://dergipark.org.tr/tr/download/article-file/1592831)**, J. Fac. Eng. Arch. Gazi 40:2 (2025), DOI 10.17341/gazimmfd.884439. IEEE 14-bus study of the total inertia constant, funded by TÜBİTAK 1002 project 118E863.
- **Kurucan M., [Accurate Frequency Control of Energy Storage Systems with a Symbolic Game Theory Approach](https://dergipark.org.tr/tr/download/article-file/5669929)**, Çukurova Üniv. Müh. Fak. Derg. 41(1), 2026. Frequency control that enforces state-of-charge limits.

## 4. Turkish storage market

- **[Ember, Türkiye Electricity Review 2026 – Storage](https://ember-energy.org/latest-insights/turkiye-electricity-review-2026/storage)** (page modified 5 May 2026).
  - "Türkiye's battery project pipeline has reached 33 GW", allocated since late 2022 out of 221 GW of applications. That equals 83% of the 40 GW of wind+solar.
  - **208 MW commissioned across 23 projects** as of Feb 2026.
  - Licensed projects hold 37 GWh, about 1.1 h average.
  - Rule: battery MW at least equal to plant MW; investors favour 1-hour systems.
  - 2035 target: 7.5 GW of 2-hour storage.
  - Frequency services are not mentioned.
- **[Daily Sabah/AA](https://www.dailysabah.com/business/energy/turkiyes-battery-storage-push-in-focus-as-war-strains-energy-supply)**, 19 Apr 2026. First systems were commissioned in 2025; 2,000–3,000 MW expected in 2026.
- **[Ekonomi Gazetesi](https://www.ekonomigazetesi.com/sirket-haberleri/ilk-depolamali-res-uretim-yatirimi-kabul-edildi-faaliyete-basliyor-67443)**, 17 Dec 2025. Polat Enerji's Ege RES in İzmir is "Türkiye'nin ilk depolamalı Rüzgâr Enerji Santrali": phase 1 is "15,17 MWh", rising to "28,16 MWh" in phase 2.
- **[DonanımHaber](https://www.donanimhaber.com/enerjisa-uretim-batarya-depolama-tesisi-ni-devreye-aldi--196916)**, 5 Oct 2025. Enerjisa Üretim, Bandırma: 2 MW / 4 MWh, coupled to PV.
- **[Forbes Türkiye](https://www.forbes.com.tr/dergi/yenilenebilirdeki-artis-depolamada-buyumeyi-hizlandiriyor)**, Nov 2024. 5,968 applications by Dec 2023; 658 pre-licence applications totalling 34 GW by Sep 2024. SHURA's 2053 net-zero scenario needs 30 GW / 120 GWh.
- **Frequency services from storage:** I found **no verified Turkish storage project explicitly providing primary or secondary frequency control**. The rules allow it (section 2).

## Most useful 6 for the report

1. The ENTSO-E 2015 blackout report: real RoCoF (0.5–1 Hz/s), the UFLS steps, and the df/dt shedding recommendation.
2. The Şebeke Yönetmeliği with the 2024 amendment: the 49,8–50,2 Hz band, the new UFLS rules, and the fact that no RoCoF or grid-forming rule exists.
3. The Yan Hizmetler regulation's ±200 mHz primary-reserve definition and storage eligibility.
4. Yeşil & Irmak 2021: the Turkish inertia estimate.
5. Özdemirci & Cebeci 2020: Turkish model parameters and battery results.
6. Ember 2026: 33 GW allocated, 208 MW in operation, ~1 h duration. Acar (İTÜ 2025, 9-bus) is a close runner-up for your method.

## Not verified / dead ends

- The 2024 amendment gives no numbers for primary-control activation time, duration (for example 15 min) or droop. The only timing found is the 30 s inside the reserve definition. Grid code Articles 52 onward, including the Ek-18 details, are paywalled on Lexpera. I could not locate the grid code on mevzuat.gov.tr, and the alomaliye PDF was blocked by Cloudflare.
- The H values from Yeşil & Irmak: the Wiley page failed to load.
- The TEİAŞ storage technical-criteria document required by 1/1/2025: not found.
- A primary TEİAŞ source for the 10 MW, 1,25 MWh/MW and 10 mHz battery PFC rules: I only have the EMO slides.
- A Sanlı post on the 31 March 2015 blackout: none found.
- Haluk Direskeneli, Volkan Özdemir/EPPEN and Enerji Günlüğü pieces on frekans/atalet: nothing relevant found.
- Any TÜBİTAK MAM study of Turkish inertia: not found.
- The Atılım repository page for Bulut & Öz was blocked by an anti-bot page; I used the DergiPark page instead.

# Devir notu: IEEE 9 baralı sistemde BESS ile sanal atalet ve frekans kararlılığı

*Hazırlanma: 30 Ekim 2026. Bu not, projeye başka bir Claude hesabında devam edebilmek içindir.*

**Nasıl kullanılır:** Yeni sohbetin ilk mesajına bu dosyayı ve `ieee9v2.zip` paketini ekleyin, şunu yazın: *"Bu bitirme projeme devam ediyoruz. Devir notunu oku, paketi aç, `run_tests(true)` ile testleri çalıştır ve kaldığımız yerden devam et."*

---

## 1. Proje ve bağlam

- **Kim:** Hasan Tatar, elektrik mühendisliği bitirme projesi (mühendislik tasarım projesi). Danışman hoca çalışmanın "göründüğü kadar kolay olmadığını" belirtti; titiz ve doktora düzeyinde incelemeye dayanıklı bir çalışma bekleniyor.
- **Konu:** IEEE 9 baralı sistemde (Anderson & Fouad / MathWorks Simscape şablonu) G2'nin yerine güneş (PV) konduğunda bataryalı depolama (BESS) gruplarının şebeke ataletine ve frekans kararlılığına etkisi. Ayrıca rüzgar karşılaştırması, GFL/GFM kontrolü, konum ve grup sayısı, boyutlandırma ve Türkiye uygulaması.
- **Tercihler:** Türkçe çalışılıyor. Dokümanlar hocaya ve sektörden kişilere gönderilecek. Kullanıcı dürüst değerlendirme ve "neyi sormalıyım, neyi eklemeliyim" türünde yönlendirme istiyor.
- **Frekans:** Ana sonuçlar 50 Hz'te (Türkiye kriterleri için). Model pu olduğundan `sc.f0 = 60` ile benchmark'a dönülür (nadir oranı 1,199–1,200, RoCoF'ta en fazla %0,4 fark).

## 2. Dokümanlar (claude.ai'deki artifact'lar)

Bu bağlantılar yalnızca eski hesapta açılır. Sahibi paylaşmadıkça yeni hesap bunlara erişemez; içeriğin özeti aşağıda.

| Doküman | Bağlantı | İçerik |
|---|---|---|
| Mühendislik tasarım raporu (ana, v2) | https://claude.ai/artifact/1EhFZm3LChYD4jLqoKghL3 | Bölüm 1–10 + kaynakça (~67 kaynak); modelleme denklemleri, doğrulama, sonuçlar, tasarım önerisi |
| Yol haritası, okuma listesi, parametreler, açık sorular + hoca görüşmesi hazırlığı | https://claude.ai/artifact/TGLnsV3kkQU1HABD6EUuUQ | e-posta taslağı, hocaya sorulacaklar, eklenebilecekler |
| İlk araştırma dokümanı (v1, eski) | https://claude.ai/artifact/H1d5iptJ1T3b5n4VYcQoep | ilk literatür taraması; v2 bunun yerini aldı |

**Raporun bölümleri:**
- Yönetici özeti
- 1 Problem ve kriterler
- 2 Sektör ve literatür: saha projeleri, işletmeciler, akademik, Türkiye, açık kaynak
- 3 Modelleme (denklemler)
- 4 Analitik çerçeve: RoCoF, SFR, düşük mertebeli model, rampalı FFR, enerji, küçük sinyal
- 5 Doğrulama, 5.7 dahil: testler ve ANDES
- 6 Ana senaryolar
- 7 Duyarlılık: SNSP, Hv×R, konum ve grup sayısı, gecikme, varsayımlar, rüzgar, BESS boyutu, doğrusallık, dayanıklılık
- 8 Küçük sinyal ve zayıf şebeke
- 9 Tasarım önerisi
- 10 Zorluklar, sınırlar, sorular, Simscape planı

## 3. Model (ieee9v2 paketi, MATLAB R2019b+ / GNU Octave 8)

Kendi yazdığımız fazör (RMS) DAE modeli. Ağ denklemi `Ya·V = I(x,V)` sabit nokta iterasyonuyla çözülüyor; RK4 ile dt = 2 ms, 100 MVA baz.

- **Senkron makineler:** iki eksenli model (Sauer & Pai verisi, G1 T'q0 = 0,31). H değerleri 100 MVA bazında: 23,64 / 6,40 / 3,01 s. Ek: S0'da 3 305 MWs, S2'de 2 665 MWs.
- **Uyarma:** IEEE DC1A (KA = 20, TA = 0,2, KE = 1, TE = 0,314, KF = 0,063, TF = 0,35, SE = 0,0039·e^(1,555·Efd)).
- **Regülatörler:**
  - G2 ve G3: TGOV1 (R = 0,05 makine bazında, T1 = 0,5, T2 = 3, T3 = 10).
  - G1: hidro, Kundur geçici düşümlü (Rp = 0,05, Tw = 1,5).
- **Yükler:** P = P0·(V/V0)^αp·(1 + Kpf·Δf), Q ∝ (V/V0)^αq. Baz değerler αp = 1, αq = 2, Kpf = 1.
- **GFL-BESS:**
  - SRF-PLL: 5 Hz, ζ = 0,707.
  - Filtreler: Tm = 20 ms, Tr = 50 ms; akım döngüsü Ti = 20 ms.
  - Güç komutu: P* = P0 − (S/R)·Δf − 2HvS·RoCoF.
  - Akım sınırı 1 pu, öncelik P'de; SOC modeli η = 0,95.
- **GFM-BESS (VSM):**
  - 2HvS·dω/dt = P* − Pe − (S/R)Δω.
  - Xv = 0,15 pu (kendi bazında), akım doyması, Q-V droop.
- **Tip-4 rüzgar:** Heier Cp eğrisi, MPPT, sentetik atalet (0,1 pu sınırlı).
- **Senkron kompansatör.**
- **Varsayılan BESS:** 40 MVA / 40 MWh, Hv = 16 s, R = %2 (kendi bazında), Bara 2.
- **Olaylar:**
  - E1: Bara 6'ya +31,5 MW (yükün %10'u).
  - E2: +63 MW.
  - N-1: G3 açması (85 MW).
- **Kriterler (50 Hz):** RoCoF (500 ms) ≤ 1 Hz/s, nadir ≥ 49,2 Hz, oturma ≥ 49,8 Hz, akım ≤ 1 pu, sönüm ≥ %5.
- **Senaryolar** (`scenarios/scenario_lib.m`):
  - S0: baz.
  - S1: G3 yerine PV.
  - S2: G2 yerine 163 MW PV.
  - S3: GFL, yalnız atalet.
  - S4: GFL, yalnız droop.
  - S5: GFL, atalet + droop.
  - S6: GFM.
  - S7: 3 × 13,3 MVA, Bara 5-6-8.
  - S8a/b/c: G1'in yarısı kapalı.
  - S9a/b/c: rüzgar.
  - S10: senkron kompansatör.

## 4. Doğrulama durumu (30 Ekim itibarıyla)

- **Otomatik testler:** `tests/run_tests.m` ile 21 testin 21'i geçiyor. Hızlı sürüm `run_tests(true)` 17 test, yaklaşık 5 dk. Sonuç `results/test_report.csv` dosyasına yazılıyor. Testlerin kapsamı:
  - Anderson & Fouad güç akışı (0,0004 pu, 0,04°);
  - Sauer & Pai'nin sıfırdan farklı 19 öz değeri (%0,03);
  - SFR kapalı formu;
  - başlangıç RoCoF'unun salınım denklemine uyması;
  - kalıcı durum güç dengesi (droop + yük gerilimi + ağ kaybı, %0,04);
  - SOC ve enerji dengesi;
  - 50/60 Hz dönüşümü;
  - toplama ve sıfır-BESS limitleri;
  - zaman adımı ve regresyon.
- **Bağımsız yazılım:** ANDES 2.0 (`validation/andes_crosscheck.py`), senkron sistem, aynı varsayımlar:
  - COI frekans eğrileri arasındaki en büyük fark 4,3 mHz;
  - nadir ve oturmada sapmanın %1,1–1,2'si;
  - RoCoF'ta %1,5–2,7;
  - mod frekanslarında %1, sönümde 0,3 puan.

  Kalan fark, ANDES'teki GENROU makinesinin iki eksenli modele yaklaştırılmasından geliyor.
- **Rapor denetimi:** yaklaşık 680 sayısal iddia, çalışmayı hazırlamayan ayrı bir inceleme ile sonuç dosyalarına karşı kontrol edildi. Üç turda 41 tutarsızlık bulundu ve düzeltildi.
- **Doğrulanmayanlar:**
  - MATLAB'in kendisinde çalıştırılmadı; uyumluluk yalnızca kod taramasıyla kontrol edildi.
  - BESS modelleri bağımsız bir yazılımla doğrulanmadı.
  - Bölüm 1–2'deki literatür ve saha rakamları ikinci kez kontrol edilmedi.
  - Zayıf şebeke sonuçları EMT ile doğrulanmadı.

## 5. Ana bulgular (bunları değiştirmeden önce dosyalarla kontrol edin)

1. **BESS faydası:** E1'de 40 MVA BESS, nadiri 49,32'den 49,64 Hz'e, RoCoF500'ü 0,283'ten 0,221 Hz/s'ye taşıyor. Oturma frekansı 30. saniyede 49,799'dan 49,838 Hz'e çıkıyor. Fayda N-1 dışındaki olaylarda olay yerinden, tipinden ve %80–120 yük seviyesinden bağımsız.
2. **Yenilenebilir payı (SNSP):**
   - Oturma kriterine göre izin verilen pay %35'ten %53'e çıkıyor (30 s'lik koşular, `snsp_qss30.csv`).
   - Nadir kriterine göre %46'dan %70'in üzerine çıkıyor.
   - Ataleti düşüren PV'nin kendisi değil, yerine kapanan ünitelerdir.
3. **Droop ve atalet:**
   - Droop nadiri ve oturmayı, Hv RoCoF'u belirliyor; ikisi neredeyse bağımsız.
   - R'yi %1'e indirmek nadiri 420 mHz iyileştiriyor; Hv'nin katkısı 20–120 mHz.
   - Hv = 16 s (R = %2) RoCoF500'ü %14, 32 s %25 iyileştiriyor.
4. **GFL ve GFM:**
   - Yeterli boyutta sistem frekansında eşdeğerler (RoCoF500 %1, nadir 5–9 mHz). GFL, GFM'nin sanal atalet etkisinin yaklaşık %95'ini veriyor.
   - İlk 100 ms'de GFM daha yavaş (RoCoF100 −0,239'a karşı −0,222).
   - GFM yerel RoCoF'ta ve kendi barasındaki olaylarda daha iyi (PV kaybında 0,237'ye karşı 0,278 Hz/s).
   - **Akım sınırındaki GFM, GFL'den kötü:** E2'de 20 MVA ile 296 mHz, N-1'de 40 MVA ile 774 mHz daha düşük nadir. Kural: en az %20 akım payı.
   - GFM'nin zayıf şebeke üstünlüğü bu RMS modelinde görülmedi.
5. **Konum** (114 yerleşim × 3 bozulma yeri = 342 koşu):
   - Nadir 17 mHz'lik bir bant içinde kalıyor.
   - En kötü yerel RoCoF neredeyse hep Bara 3'te (G3, en hafif makine) çıkıyor. G3 tarafındaki baralar (2 ve 3), G1 tarafındakilerden (4 ve 5) %13 daha iyi.
   - Tek grubu Bara 4'e koymak sönümü %6,1'e düşürüyor.
   - S7'nin seçimi (5-6-8) üçlü yerleşimler arasında en kötü ikinci.
6. **Grup sayısı (toplam güç sabit):** performansı değil dayanıklılığı artırıyor: en iyi–en kötü farkı 0,033'ten 0,013 Hz/s'ye iniyor, en kötü sönüm %6,1'den %14,6'ya çıkıyor ve yedeklilik sağlıyor. Nadiri değiştiren toplam güç.
7. **N-1 boyutu:**
   - 49,2 Hz için yaklaşık 71 MVA (GFL), 76 MVA (GFM) gerekiyor.
   - **Öneri: 80–90 MW / 80–90 MWh, iki eşit grup (Bara 2 + 3, 40 + 40 MVA).** 90 MVA benzetilmedi, eğilimden tahmin.
   - Tek grubun N-1'deki görünür avantajı bir **yük modeli yanılsaması**: gerilim düşünce P ∝ V yükü azalıyor. Sabit güç yükünde sıralama tersine dönüyor ve gerilim 0,88 pu'ya iniyor.
8. **Enerji bağlayıcı değil:** N-1'de 20 s'de 0,25 MWh harcanıyor; 15 dakikalık destek için yaklaşık 26 MWh yetiyor.
9. **Varsayımlar sonucu kontrolden daha çok oynatıyor:** yük modeli 149 mHz, regülatör tipi 228 mHz, ünite ataması 236 mHz.
10. **Rüzgar:** sentetik atalet 18,7 MW ve rotordan yaklaşık 80 MJ sağlıyor. Ama ikincil düşüş yaratıyor ve droop rotoru MPPT'nin altında tutuyor; BESS ile eşleşince sorun kalkıyor.

## 6. Yapılmış düzeltmeler (geri alınmamalı)

| Eski ifade | Doğrusu |
|---|---|
| SNSP sınırı "%27 → %43" | %35 → %53 (15 s'lik koşular oturma için yetersizdi) |
| N-1 önerisi "50 + 30 MVA, kapasitenin çoğu Bara 2'de" | iki eşit grup (yük modeli artefaktı fark edildi) |
| "GFL ataletin çeyreğini kaybeder" | benzetimde yaklaşık %5 |
| Rüzgardan çekilen enerji "8 MJ" | 80 MJ |
| "21 öz değer" | sıfırdan farklı 19 öz değer |
| Bölüm 7.8, S2 için "11,2 mHz/MW" | 21,9 mHz/MW |
| Ti = 500 ms'de iyileşme kaybı "%47" | %54 |
| "GFM zayıf şebekede üstün" (bu modelin sonucu olarak) | literatür kaynaklı, EMT ile doğrulanmalı |
| 4 gruplu yerleşimlerin Octave'a özgü rastgele seçimi | sabit liste (MATLAB'de de aynı sonuç) |

## 7. Açık işler ve sıradaki adımlar

1. Kullanıcı MATLAB'de `addpath('tests'); run_tests(true)` komutunu çalıştırmalı.
2. **Dış incelemeye uygun sürüm** (sektörden birine göndermeden önce):
   - Bölüm 10.3 "Hocanın sorabileceği sorular" ile Bölüm 9 ve 10'daki "hoca" ifadeleri iç hazırlık niteliğinde; yol haritası dokümanına taşınmalı.
   - Kapak bilgisi eklenmeli: yazar, danışman, üniversite, tarih, sürüm.
   - Bir "inceleyiciden beklenen geri bildirim" bölümü eklenmeli.
   - Bölüm 1–2'deki saha ve literatür rakamları kaynaklarıyla yeniden kontrol edilmeli.
   - Yapay zekâ yardımının nasıl beyan edileceğine kullanıcı karar vermeli (üniversite kuralları).
3. Hocaya sorulacaklar (yol haritası dokümanında): tasarım olayı (%10, %20 veya N-1), Simscape/EMT zorunluluğu, yük modeli, ekonomi bölümü, bildiri.
4. Değer katacak eklemeler:
   1. Simscape fazör modunda S0, S2, S5 ve S6 (`core/metrics_simscape.m` hazır).
   2. GFM akım sınırlama stratejileri.
   3. Türkiye frekans kaydından gerçek bir olay analizi.
   4. EMT ile zayıf şebeke.
   5. Ekonomi.
   6. Biçimsel yerleşim optimizasyonu (H2 normu).
   7. Bildiri.

## 8. Paket haritası (ieee9v2.zip)

| Yol | İçerik |
|---|---|
| `README.md` | kurulum, klasörler, ekleme/çıkarma örneği, testler |
| `ornek_kendi_senaryom.m` | tek senaryo, grafik (1–2 dk) |
| `run_all.m` | tüm sonuçları yeniden üretir (~5–6 saat) |
| `core/` | model: `sysdata`, `build_model`, `deriv`, `sim_run`, `metrics_calc`, `linearize`, `metrics_simscape` |
| `scenarios/` | `scenario_lib`, `job_list`, `run_worker`, `place_study` + `place_analyze.py`, `rob_study`, `n1_sizing`, `split80`, `n1_split_loadmodel`, `snsp_qss30`, `dt_conv`, `ss_study`, `ss_weak`, `collect_results`, `make_figures.py` |
| `analytic/` | `sfr_am` (SFR kapalı form), `lom_sim` (düşük mertebeli model) |
| `tests/run_tests.m` | 21 otomatik test |
| `validation/` | ANDES çapraz doğrulaması |
| `results/` | `summary_all.csv` (149 ana koşu), `place_summary.csv`, `rob_runs_w*.csv`, `n1_*.csv`, `split80_w*.csv`, `snsp_qss30.csv`, `dt_conv.csv`, `ss_*.csv`, `test_report.csv`, `andes_*.csv`, `.mat` dosyaları |
| `figures/` | F1–F8 PNG |
| `notes/` | araştırma notları: Türkiye, araçlar, akademik, sektör |

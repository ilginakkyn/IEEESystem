# Brief: what industry and system operators do about BESS synthetic inertia, FFR and grid-forming

Every fact below comes from a page I opened with WebFetch. Some of those pages were secondary sources (trade press, consultancy reports, Neoen/SMA/Hitachi releases), and I say so where it matters.

## 1. Field projects and vendors

- **[HPRX VMM Modelled vs Actual Report](https://arena.gov.au/assets/2023/09/HPRX-VMM-Modelled-vs-Actual-Report.pdf)** — Neoen/Tesla for ARENA, released 06/02/2023
  - Plant: 100 MW/129 MWh plus a 50 MW/64.5 MWh expansion, 150 MW in total.
  - Trial and roll-out: a dual-inverter VMM trial started 15/02/2021. Virtual Machine Mode (VMM) was enabled on the full 150 MW on 22/07/2022.
  - Chosen setting: effective H = 11.02 MW·s/MVA, about **2,070 MW·s**.
  - Sensitivity cases: 5,165 MW·s (H=5) and 7,850 MW·s (H=10). Higher H gave better damping but slower power recovery.
  - Need: AEMO's South Australia requirement was 6,000 MW·s. For comparison, the 160 MW Pelican Point gas turbine provides 1,625 MW·s.
  - Overload: the inverter is limited to **1.2 pu**, against 5–10 pu for a synchronous machine.
  - 11/08/2022 event: peak RoCoF was −0.16 Hz/s and output stepped by **13.2 MW**. The swing equation predicts ΔP = 0.16×2×11.02/50 = 0.0705 pu, which matches. The report says the response was "very close to that predicted by the model."
- **[HPRX Operations Report H1 2023](https://arena.gov.au/assets/2023/10/Neoen-Hornsdale-Power-Reserve-Expansion-HPRX-Operations-Report-H12023.pdf)** — Neoen, 2023
  - VMM has run continuously since 22/07/2022 with no adverse impacts.
  - The inertial response collapses as the active-power setpoint approaches 1 pu. HPR normally runs below **0.53 pu** to keep headroom.
  - On 7 May 2023 (nadir 49.776 Hz), VMM responded to RoCoF before the droop response did.
- **[Neoen: inertia services at HPR](https://neoen.com/es/innovations/neoen-tesla-innovative-inertia-services-hornsdale-power-reserve-big-battery-australia/)** — Neoen, no date shown. Says HPR provides an estimated **2,000 MW of equivalent inertia**, about 15% of South Australia's predicted shortfall. AEMO approved the service.
- **[Tesla submission to AEMO on the Inertia Requirements Methodology](https://wa.aemo.com.au/-/media/files/stakeholder_consultation/consultations/nem-consultations/2024/amendments-to-the-inertia-requirements-methodology/tesla.pdf?la=en)** — Tesla, 2 Aug 2024
  - Says the "indirect swing-equation method" was used to verify HPR's inertia contribution.
  - Asks AEMO to study whether procuring 1-second FCAS could substitute for inertia.
- **[Transgrid: Wallgrove battery](https://transgrid.com.au/media-publications/major-milestone-with-nsw-first-grid-scale-battery-fully-operational)** — Transgrid, 17 Dec 2022. A 50 MW/75 MWh Tesla Megapack plant using VMM. It is the third Tesla grid-scale system worldwide to demonstrate synthetic inertia. No MW·s figure is given.
- **[Hitachi: Dalrymple BESS](https://www.hitachi.com/en-au/insights/articles/boosting-energy-reliability-lower-yorke-peninsula/)** and **[Energy-Storage.news on Dalrymple](https://www.energy-storage.news/grid-forming-lessons-at-end-of-the-line-in-south-australia-being-replicated-worldwide/)**
  - **30 MW/8 MWh**, operating in grid-forming mode. Built on Hitachi ABB e-mesh/PowerStore with a "Virtual Generator Mode". Energised April 2018.
  - Islands together with AGL's 90–91 MW Wattle Point wind farm and rooftop PV.
  - Outages fell 95% over the first 18 months. It earns FCAS for AGL and provides network services for ElectraNet.
- **[IEEE Spectrum: grid-forming inverters on Kauai](https://spectrum.ieee.org/electric-inverter)** — Kroposki & Hoke (NREL), 13 Apr 2024
  - 2 Apr 2023: the 26 MW unit carrying about 60% of load tripped. Two GFM solar+storage plants (Kapaia, Tesla, 52 MWh; and the US Navy's Pacific Missile Range Facility) roughly quadrupled and doubled their output within a fraction of a second. Frequency fell to just above 59 Hz in 3 s. EMT studies say the island would have blacked out without them.
  - 21 Nov 2021: a similar trip with only one GFM plant online produced oscillations at about 20 Hz and some customer disconnections. NREL attributed this to fast-tuned GFL inverters in a weak grid.
- **[ESS News: NREL/NLR Kauai study](https://www.ess-news.com/2026/01/14/grid-forming-inverters-significantly-enhance-grid-stability-us-national-lab-finds/)** — 14 Jan 2026
  - In 2021 the batteries gave FFR within **50 ms**, contained the frequency decline within 1.5 s and restored 60 Hz within 1 min, but with oscillations from the GFL plants.
  - KIUC then switched its plants to GFM, and a 2023 repeat trip produced no oscillation.
- **[SMA: Blackhillock](https://www.sma.de/en/newsroom/news-details/sma-solution-secures-grid-stability-in-europes-largest-battery-system)** — SMA, Mar 2025
  - Zenobē plant built by Wärtsilä: 200 MW in Phase 1, 300 MW/600 MWh total in 2026, using 62 SMA Sunny Central Storage power stations.
  - Provides **116 MVA of short-circuit level and 370 MWs of inertia**.
  - First plant through a GC0137 grid-forming compliance process. Part of the Stability Pathfinder.
- **[NESO: GB's first grid-forming battery connects](https://www.neso.energy/news/great-britains-first-grid-forming-battery-connects-scotland)** — NESO, 11 Mar 2025. Stability Pathfinder Phase 2 bought 11.55 GVA of short-circuit level in Scotland and **6.75 GVA·s** of inertia, through 5 synchronous condensers and 5 GFM batteries. Ten contracts, £323m.
- **[Frontier Economics: evolution of the GB inertia market](https://www.frontier-economics.com/media/oedeysce/evolution-of-the-gb-inertia-market.pdf)** — 27 May 2026
  - Phase 1 (2021): 12.5 GVA·s, physical inertia only.
  - Phase 2: 2.2 GVA·s from synchronous condensers and 4.4 GVA·s from five GFM batteries. This differs slightly from NESO's 6.75 total.
  - Phase 3: 15.6 GVA·s, physical inertia only.
  - Y‑1 stability market rounds 1 and 2: GFM batteries failed at technical assessment, which commentary links to the fixed-H and year-round GFM requirements.
  - GB minimum inertia: 140 GVA·s (2023), now 120 GVA·s, with 102 GVA·s awaiting Ofgem approval.
  - Over 47 GVA·s procured for about £2.3bn. Cost is £1.3–8.9m per GVA·s per year.
- **[Energy-Storage.news: German inertia procurement](https://www.energy-storage.news/germanys-tso-begin-inertia-procurement-with-long-term-contracts-for-grid-forming-bess/)** — Jan 2026
  - 50Hertz, Amprion, TenneT and TransnetBW launched a Momentanreserve (inertia) product on 22 Jan 2026, with 2–10 year contracts.
  - Premium product needs 90% availability, basic needs 30%. Maximum inertia constant 12.5 s. Prices are €805/MWs/a (premium) and €76/MWs/a (basic).
- **[Energy-Storage.news: Tomago BESS](https://www.energy-storage.news/fluence-lands-its-biggest-deal-globally-for-2000mwh-grid-forming-bess-in-australia/)** — 31 Jul 2025. AGL/Fluence, **500 MW/2,000 MWh** grid-forming, using Gridstack Pro. Operation targeted for late 2027. No inertia figure given.
- **[Hitachi Energy: SVC Light Enhanced](https://www.hitachienergy.com/offering/product-and-system/facts/statcom/svc-light-enhanced)** — a grid-forming STATCOM with supercapacitors offering voltage control, system strength and inertia. Reference installation at TransnetBW. No numbers given.
- **[Siemens Energy: Moneypoint](https://www.siemens-energy.com/global/en/home/stories/irelands-great-grid-stabilizer.html)** — Nov 2022. A synchronous condenser plus flywheel giving **4,000 MWs** (flywheel about 3,500 MWs, over 130 t, 3,000 rpm). This is the physical-inertia alternative to batteries.

## 2. TSO frameworks and requirements

- **[GC0137 modification page](https://www.neso.energy/industry-information/codes/gc/modifications/gc0137-minimum-specification-required-provision-gb-grid-forming-gbgf-capability-formerly-virtual-synchronous-machinevsm-capability)** and the **[Ofgem decision](https://www.ofgem.gov.uk/sites/default/files/2022-01/GC0137%20Authority%20Decision.pdf)**
  - Non-mandatory GB Grid Forming specification, "formerly VSM", implemented 14 Feb 2022.
  - Ofgem defines it as the ability "to exhibit similar characteristics to that of a conventional synchronous generator". No minimum magnitudes are set.
- **[GB Grid Forming Best Practice Guide](https://neso.energy/document/278491/download)** — ESO, Apr 2023
  - Definition: a voltage source behind a reactance. Virtual impedance is not permitted for GBGF‑I.
  - **Active Inertia Power is "inherent… within less than 5 ms"**. Active Phase Jump Power and damping also respond within 5 ms.
  - Active Frequency Response Power must reach its declared value within 1 s. Control-based power is limited to a 5 Hz bandwidth.
  - Phase jump: linear-response limit 5° recommended, withstand 60°.
  - RoCoF: ±1 Hz/s in normal mode, ±2 Hz/s in withstand mode. Frequency range 47–52 Hz.
  - Example H = 4 s.
- **[NESO DC/DM/DR testing guidance](https://neso.energy/document/347221/download)** — undated
  - Dynamic Containment (DC): deadband ±0.015 Hz; 5% delivery at 0.2 Hz (knee); 100% at ±0.5 Hz; **full delivery within 1 s**; response must start before 0.55 s; sustained 15 min.
  - Dynamic Moderation (DM): 100% at ±0.2 Hz; response within 0.5 s; 30 min.
  - Dynamic Regulation (DR): 100% at ±0.2 Hz; initial delay no more than 2 s; 60 min.
- **[EirGrid Operational Constraints Update v1.91](https://cms.eirgrid.ie/sites/default/files/publications/OperationalConstraintsUpdateVersion1_91_Feb_2020.pdf)** — EirGrid, Feb 2020
  - SNSP limit 65%, RoCoF limit 0.5 Hz/s.
  - **Inertia floor 23,000 MWs** (all-island).
  - Minimum 5 conventional units on load in Ireland and 3 in Northern Ireland.
  - Primary and secondary operating reserve (POR/SOR) each held at 75% of the largest infeed.
- **[EirGrid: RoCoF limit](https://renewables-grid.eu/app/uploads/2023/12/20242501_RoCoF_Limit_EirGrid.pdf)** — EirGrid slides hosted by RGI, 2023–24
  - RoCoF limit raised from ±0.5 to **±1 Hz/s**, effective May 2023.
  - During the trial, SNSP went 65% → 70% → **75%**. EirGrid says 95% SNSP is needed for its 80% renewable electricity target.
  - Distribution-connected anti-islanding RoCoF settings moved from 0.4 to 1 Hz/s.
- **[DS3 System Services Protocol recommendations paper](https://consult.eirgrid.ie/en/system/files/consultation-outcomes-reports/DS3-System-Services-Protocol-Recommendations-Paper_final_withresponses.pdf)** — EirGrid/SONI, Nov 2022
  - **FFR is "MW delivered between 0.15 and 10 seconds"**, not 2–10 s as in your brief.
  - Other windows: POR 5–15 s, SOR 15–90 s, TOR1 90 s–5 min.
  - SIR (synchronous inertial response) is paid on stored kinetic energy × (SIR Factor − 15).
- **[AEMO Voluntary Specification for Grid-forming Inverters](https://aemo.com.au/-/media/files/initiatives/primary-frequency-response/2023/gfm-voluntary-spec.pdf?la=en)** — v1.0, 29 May 2023
  - GFM "maintains a constant internal voltage phasor in a short time frame".
  - Voltage-step response in under 5 ms.
  - Inertia response "without measuring frequency or RoCoF".
  - Example overload: 150% for 2 s, against 250% for 0.5 s for a synchronous machine. Example of about 2,000 MWs at low setpoint.
- **[AEMO GFM core requirements test framework](https://aemo.com.au/-/media/files/initiatives/engineering-framework/2023/grid-forming-inverters-jan-2024.pdf?la=en)** — Jan 2024
  - Power must reach 90% of its change within 50 ms after a trip.
  - Phase-step test: a 10° step must change power by at least 0.2 pu, with 90% reached within 15 ms.
  - Must remain stable down to SCR 1.25. Frequency-ramp test at 4 Hz/s.
- **[AEMO 2024 Inertia Report](https://aemo.com.au/-/media/files/electricity/nem/security_and_reliability/system_security_planning/2024-inertia-report)** — 2 Dec 2024
  - Secure inertia levels: NSW 12,500, Queensland 13,700, South Australia 5,600, Tasmania 3,800, Victoria 15,400 MWs. Mainland minimum 36,200 MWs.
  - RoCoF criteria: mainland ≤1 Hz/s over 500 ms; Tasmania ≤3 Hz/s over 250 ms.
  - South Australia's shortfall was resolved mainly by new 1‑s FCAS registrations.
- **[WattClarity: Very Fast FCAS launch](https://wattclarity.com.au/?p=26892)** — Very Fast Raise/Lower FCAS started 9 Oct 2023 with a **1 s** delivery timeframe. Requirement initially capped at 50 MW.
- **[AEMC: Efficient provision of inertia (ERC0339)](https://www.aemc.gov.au/sites/default/files/2025-10/ERC0339%20Final%20determination%209%20October.pdf)** — 9 Oct 2025
  - No real-time inertia market will be created.
  - Synthetic inertia may count toward minimum inertia, and TNSPs may procure it.
  - The largest benefit identified came from substituting inertia for 1‑s FCAS.
- **[ERCOT: An Introduction to ERCOT's Ancillary Services](https://interchange.puc.texas.gov/Documents/53911_14_1236193.PDF)** — ERCOT, 2 Sep 2022
  - FFR triggers at **59.85 Hz** with **full response in 15 cycles**.
  - Sustained up to 15 min and restored within 15 min of recall.
  - At most 450 MW of Responsive Reserve Service (RRS) may come from FFR.
- **[ERCOT NPRR828 PRS report](https://www.ercot.com/files/docs/2017/11/10/828NPRR-16_PRS_Report_110917.doc)** — a rejected 2017 version: 59.8 Hz trigger, 30 cycles. Shown only as history.
- **[Svenska kraftnät FFR technical requirements v1.1](https://svk.se/siteassets/english/stakeholder-portal/prequalification/technical-requirements-for-ffr-v1.1.pdf)** — Nordic, 11 Jan 2021
  - Three trigger options: **49.7 Hz / 1.30 s, 49.6 Hz / 1.00 s, 49.5 Hz / 0.70 s**.
  - Support duration 30 s (long) or 5 s (short). Short-duration deactivation limited to 20% per second.
  - Must be ready to reactivate within 15 min. Logging at 10 Hz or faster with 10 mHz accuracy.
- **[Fingrid: Fast Frequency Reserve](https://fingrid.fi/en/electricity-market/reserves_and_balancing/fast-frequency-reserve)** — activation is local and automatic. Volumes depend on inertia and the reference incident, which must not push frequency below 49.0 Hz.
- **[Nordic minimum inertia requirement 2025](https://www.fingrid.fi/globalassets/dokumentit/fi/tiedotteet/2025---requirements-for-minimum-inertia-in-the-nordic-power-system.pdf)** — 1 Jun 2025
  - No minimum inertia is needed for now. FCR-D (disturbance reserve) design level is 150 GWs and its stability margin is 120 GWs; stability is challenged near 90 GWs.
  - About **300 MW of FFR at 100 GWs** keeps frequency above 49.0 Hz. The reference incident is 1,450 MW.
- **[ENTSO-E RoCoF withstand guidance (IGD)](https://docstore.entsoe.eu/Documents/Network%20codes%20documents/NC%20RfG/IGD_RoCoF_withstand_capability_final.pdf)** — 31 Jan 2018
  - Generators should stay connected at **±2 Hz/s over 500 ms, ±1.5 Hz/s over 1 s, and ±1.25 Hz/s over 2 s**.
  - HVDC systems: ±2.5 Hz/s over 1 s.
- **[ENTSO-E Project Inertia Phase II](https://eepublicdownloads.blob.core.windows.net/public-cdn-container/clean-documents/sdc-documents/231108_Project_Inertia_Phase_II_First_Report_FOR_PUBLICATION_clean.pdf)** — 8 Nov 2023
  - The RoCoF limit is 1 Hz/s. 358 of 452 possible split configurations risk blackout in at least one hour.
  - Up to **445 GWs** of additional kinetic energy is needed in 2030, which ENTSO-E equates to 255 synchronous condensers of 250 Mvar at H=7.
  - GFM power park modules and storage should be deployed "as soon as possible", but wide deployment is not expected before 2028.
- **[ENTSO-E grid forming capability report (TG GFC v2)](https://eepublicdownloads.blob.core.windows.net/public-cdn-container/clean-documents/Reports/2025/TG_GFC_Version_2.pdf)** — 3 Oct 2025
  - Inertia: ΔP = T_M·(df/dt)/f_rated·P_rated with T_M = 2H. For example, 2 Hz/s with T_M = 25 s gives 1 pu.
  - Phase jump: at least 50% of the calculated current within 10 ms.
  - Current clipping allowed for up to 40 ms. Effective impedance 0.35 pu (MV) to 0.50 pu (HV).

## 3. NERC, ESIG, UNIFI

- **[NERC Fast Frequency Response Concepts white paper](https://nerc.com/comm/PC/InverterBased%20Resource%20Performance%20Task%20Force%20IRPT/Fast_Frequency_Response_Concepts_and_BPS_Reliability_Needs_White_Paper.pdf)** — NERC IRPTF, Mar 2020
  - FFR is a response to measured frequency, and the paper gives no conversion between MW of FFR and GW·s of inertia.
  - Critical inertia "can be lowered by increasing… FFR", with diminishing returns.
  - Recommends retiring the term "synthetic inertia" in favour of "inertia-based FFR".
  - RoCoF is estimated over 0.1–0.5 s and "should be used with caution". In its simulation, a 1 s response delay deepens the nadir by about 50 mHz.
  - ERCOT: FFR at 59.85 Hz with 0.25 s to full response. If load-trip time exceeds 0.5 s, load FFR cannot prevent under-frequency load shedding below about **94 GW·s**.
- **[NERC GFM functional specification white paper](https://www.nerc.com/comm/RSTC_Reliability_Guidelines/White_Paper_GFM_Functional_Specification.pdf)** — Sep 2023
  - GFM holds "a nearly constant internal voltage phasor in the sub-transient time frame" (about 0–5 cycles).
  - Example test settings: 2% frequency droop and 0.03 Hz deadband.
  - Kauai inertia is about 0.5–2.7 MW·s/MVA.
  - Frequency-measurement artifacts appear during phase jumps.
- **[UNIFI Specifications for GFM IBRs v2](https://www.nrel.gov/docs/fy24osti/89269.pdf)** — UNIFI (NREL/UT-Austin/EPRI), 21 Mar 2024
  - Asks for inertia-like power within the sub-transient period, then droop. No numeric H is given.
  - Example short-term current: 1.5× rated for 2 s.
  - Recommends performance-based specifications over GFL/GFM labels.
- **[ESIG Grid-Forming Technology in Energy Systems Integration](https://www.esig.energy/wp-content/uploads/2024/10/ESIG-GFM-report-2022.pdf)** — Mar 2022
  - GFL relies on a PLL and can become unstable if the PLL loses track. GFM falls back to GFL behaviour once it hits its current limit.
  - IBR fault current is 1–1.5× rated, against 3–5× for synchronous machines.
  - GFM is needed beyond about 75–80% instantaneous IBR penetration.

## 4. How the two commercial approaches compare

- **(a) Grid-following "synthetic inertia"/FFR.** Operators buy it as a fast, trigger- or droop-based product:
  - Ireland: FFR 0.15–10 s.
  - Nordics: 0.7–1.3 s at 49.7–49.5 Hz.
  - ERCOT: 15 cycles at 59.85 Hz.
  - Australia: 1 s Very Fast FCAS.
  - GB: Dynamic Containment, 1 s.

  The weakness is that it depends on measurement. NERC warns about RoCoF estimated over 0.1–0.5 s and the delay that requires. ESIG flags PLL dependence. NERC and NREL saw measurement artifacts and GFL oscillation (Kauai 2021).
- **(b) Grid-forming/VSM "inherent" inertia.** It is defined by response without measuring frequency:
  - NESO: within 5 ms.
  - AEMO: "without measuring frequency or RoCoF".
  - ENTSO-E: phase-jump current within 10 ms.

  Operators now buy it as inertia in MW·s or GVA·s: GB Pathfinder Phase 2, German Momentanreserve, and AEMO counting synthetic inertia. It is limited by headroom and overcurrent (HPR at 1.2 pu, run below 0.53 pu).
- **Quantitative equivalence statements**
  - AEMO (2024) does not credit FFR as inertia. It shifts the inertia requirement along region-specific, non-linear inertia–FFR curves. A 1.7% droop battery's 1 s FCAS equals about 57% of its FFR capability; for example, South Australia's 315 MW of 1 s FCAS ≈ 532 MW of contracted FFR.
  - Nordic: about 300 MW of FFR substitutes for the shortfall at 100 GWs, and about 20 GWs of inertia moves the nadir by 0.1 Hz.
  - Everoze (for AES, [Batteries Beyond the Spin](https://info.fluenceenergy.com/hubfs/Collateral/Everoze%20-%20Batteries%20Beyond%20the%20Spin.pdf), Oct 2017): 360 MW of batteries gives the same power at 0.1 s as the inertial response of 3,000 MW of synchronous generation (about **1:8.3**). Batteries respond in about 0.1 s and must reach full output within 0.2 s; Kilroot measured 0.04–0.06 s.
  - NERC: no conversion given.

## Requirement table

| Requirement | Value | Source |
|---|---|---|
| RoCoF limit, Ireland | ±0.5 → ±1 Hz/s (from May 2023) | EirGrid RoCoF slides |
| SNSP, Ireland | 65% (2020) → 70% → 75% | EirGrid Ops Constraints; RoCoF slides |
| Inertia floor, Ireland | 23,000 MWs; ≥5 units (IE) + ≥3 (NI) | EirGrid Ops Constraints v1.91 |
| FFR window, Ireland | 0.15–10 s | DS3 Protocol paper 2022 |
| RoCoF criterion, NEM mainland | ≤1 Hz/s over any 500 ms | AEMO 2024 Inertia Report |
| RoCoF criterion, Tasmania | ≤3 Hz/s over 250 ms | AEMO 2024 Inertia Report |
| Very Fast FCAS, NEM | 1 s delivery | WattClarity |
| Secure inertia, South Australia | 5,600 MWs (2024); 6,000 MWs (2018 plan) | AEMO 2024; HPRX report |
| GFM voltage-step response, AEMO | <5 ms | AEMO voluntary spec |
| GB GFM inertia power | inherent, <5 ms | ESO Best Practice Guide |
| GB GFM RoCoF range | ±1 Hz/s normal, ±2 Hz/s withstand | ESO Best Practice Guide |
| GB min inertia | 140 → 120 GVA·s (102 pending) | Frontier 2026 |
| Dynamic Containment | ±0.015 Hz deadband; 100% at ±0.5 Hz; full in 1 s; start <0.55 s | NESO testing guidance |
| ERCOT FFR | 59.85 Hz; 15 cycles (0.25 s); ≤15 min; ≤450 MW of RRS | ERCOT 2022; NERC 2020 |
| ERCOT critical inertia (load FFR, >0.5 s trip) | ~94 GW·s | NERC FFR paper |
| Nordic FFR | 49.7/1.3 s, 49.6/1.0 s, 49.5/0.7 s; 5 s or 30 s support | SvK v1.1 |
| Nordic inertia levels | 150 GWs design / 120 GWs margin; ~300 MW FFR at 100 GWs; nadir ≥49.0 Hz | Nordic 2025 |
| RfG RoCoF withstand | 2 Hz/s over 500 ms; 1.5 Hz/s over 1 s; 1.25 Hz/s over 2 s | ENTSO-E IGD 2018 |
| CE RoCoF limit (split studies) | 1 Hz/s; +445 GWs needed for 2030 | ENTSO-E Project Inertia II |
| German Momentanreserve | H ≤12.5 s; 90%/30% availability; €805/€76 per MWs/a | Energy-Storage.news 2026 |

## Most useful 8 for the report

1. HPRX VMM Modelled vs Actual. It gives an H setting, MW·s values and a swing-equation validation that maps directly onto an IEEE 9-bus model.
2. ESO GB Grid Forming Best Practice Guide (definitions, <5 ms, RoCoF ranges).
3. AEMO 2024 Inertia Report (RoCoF criteria and the FFR–inertia trade-off curves).
4. NERC FFR Concepts 2020 (measurement-delay problem, critical inertia).
5. AEMO Voluntary GFM Spec 2023 together with the Jan 2024 test framework (test thresholds).
6. IEEE Spectrum Kauai article (field contrast between GFL and GFM).
7. ENTSO-E RoCoF IGD together with the TG GFC v2 report (ΔP = 2H·(df/dt)/f formula).
8. Nordic FFR requirements plus the 2025 minimum-inertia report (trigger and time tables, MW-of-FFR versus GWs).

## Not verified

- **GE Vernova:** no grid-forming project facts found.
- **Wärtsilä:** only appears as Blackhillock's builder, via the SMA release.
- **Fluence Ultrastack:** nothing opened.
- **Moss Landing:** no grid-forming evidence opened.
- **Germany's "Netzbooster" projects:** nothing opened.
- **Hitachi at Hornsea 4:** I did not fetch the press release.
- **UNIFI v1, NERC's 2021 grid-forming paper, ESIG's 2025 reports:** not opened.
- **The NESO GC0137 specification text itself:** I only opened the Ofgem decision and the Best Practice Guide.
- **EirGrid's 500 ms RoCoF measurement window:** not confirmed in any EirGrid document I opened.
- **SNSP at 50%:** only the 60–75% stages are confirmed.
- **EirGrid FFR "2–10 s" window:** an Everoze/AES report (2017) says FFR was paid for response 2–10 s after an event, but the EirGrid protocol paper states 0.15–10 s. Use 0.15–10 s.
- **ERCOT "~100 GW·s" critical inertia:** only NERC's ~94 GW·s, under a specific condition, is confirmed.
- **ENTSO-E RfG 2.0 RoCoF values:** only the 2018 implementation guidance was checked.
- **Kauai plant MW ratings and an "AES Lawai" link:** not confirmed.

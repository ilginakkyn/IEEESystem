# Verified catalogue of open tools, repositories, MATLAB examples, datasets and videos for an IEEE 9-bus BESS virtual-inertia (GFL/GFM) study

I opened every item below, either as a web page or, for GitHub, with a shallow `git clone` to list the files and read the last-commit date. The GitHub API and some GitHub tree pages were blocked from here, so cloning was the check I used. "Last commit" dates are for the default branch (today is 2026-10-28).

## 1. MATLAB / Simulink / Simscape

**Official MathWorks examples**
- [IEEE 9-Bus System](https://www.mathworks.com/help/simscape-electrical/ug/ieee-9-bus.html): MathWorks, Simscape Electrical. This is your baseline. It has 3 machines with AVR, exciter, PSS, governor and prime mover, and it initializes from a load flow. A load step at Bus 6 at t = 10 s gives rotor speed and terminal voltage plots, which is the disturbance template for frequency nadir and RoCoF. A companion [IEEE 9-Bus Loadflow](https://www.mathworks.com/help/simscape-electrical/ug/ieee-9-bus-loadflow.html) example also exists.
- [IEEE 39-Bus System](https://www.mathworks.com/help/simscape-electrical/ug/ieee-39-bus-system.html): 10 machines with full controls and a 3-phase fault at Bus 16. Useful for scaling up later.
- [Design and Analyze Grid-Forming Converter](https://www.mathworks.com/help/sps/ug/design-analyze-gridforming-converter.html) (R2026b docs): a 500 kVA GFM converter with **droop and VSM** active-power control (inertia and damping emulation), virtual-impedance and current limiting, and 13 test scenarios including 0.5 Hz and 2 Hz frequency changes and islanding. It is the best template for the GFM BESS inverter.
- [Evaluate Performance of Grid-Forming BESS in Solar PV Plants](https://www.mathworks.com/help/sps/ug/evaluate-performance-gfm-bess-in-solar-pv-plants.html): a **VSM-based GFM BESS** alongside GFL PV. It shows "inertial power" and primary response after a 50% PV drop, compares GFM and GFL across grid strengths, and checks IEEE 2800. This is the closest official match to your topic.
- [Phasor-Mode Simulation Using Simscape Components](https://www.mathworks.com/help/simscape-electrical/ug/phasor-mode-simulation-in-simscape-components.html): the frequency-time formulation, with about 10x larger steps. Useful for long frequency runs.
- Specialized Power Systems phasor examples:
  - [Improve Transient Stability Using SVC and PSS](https://au.mathworks.com/help/sps/powersys/ug/improve-transient-stability-using-svc-and-pss.html): a 2-machine phasor model with governors, showing machine speeds and rotor angles.
  - [Simplified Model of a Small Scale Micro-Grid](https://es.mathworks.com/help/sps/ug/simplified-model-of-a-small-scale-micro-grid.html): a phasor model with PV and battery, but no frequency control.
  - I did not find an official SPS example dedicated to synthetic inertia or primary frequency control.

**MathWorks GitHub / File Exchange projects**
- [Renewable Energy Integration Design with Simscape](https://www.mathworks.com/matlabcentral/fileexchange/123870-renewable-energy-integration-design-with-simscape), source at [github.com/simscape/Renewable-Energy-Integration-Simscape](https://github.com/simscape/Renewable-Energy-Integration-Simscape): MathWorks, BSD-style license, last commit 2026-09-16, R2022b–R2025a. It contains `BatteryStoragePVPlantGFM.slx`, `TestonBESSPVPlant.slx`, IEEE 2800 grid-code checks, and wind GFM models (`WindGFMTurbineInertia.slx`).
- [Power Converter Circuit and Control Design with Simscape](https://www.mathworks.com/matlabcentral/fileexchange/131783-power-converter-circuit-and-control-design-with-simscape): MathWorks, v25.2.1 (Mar 2026). It is tagged GFM, VSM, virtual inertia and droop, and is the source project for the GFM example above. Its GitHub link would not load from here.

**Community File Exchange**
- [Grid forming droop and virtual synchronous machine (#180383)](https://www.mathworks.com/matlabcentral/fileexchange/180383): Philippe Lefebvre, v1.0.1 (14 Mar 2025). A model comparing droop GFM with VSM GFM.
- [Microgrid Dynamic Operation (#93235)](https://www.mathworks.com/matlabcentral/fileexchange/93235-microgrid-dynamic-operation): Pierre Giroux, v1.0.2 (Oct 2023). An SPS BESS plus solar plant that switches between **GFL and GFM** modes. Good for comparing the two.
- [3 bus model for full grid-forming inverter system (#71565)](https://www.mathworks.com/matlabcentral/fileexchange/71565-3-bus-model-for-full-grid-forming-inverter-system): EU MIGRATE WP3 (Qoria, Jouini, Denis et al.), MIT license. It has droop, dVOC and matching GFM controls plus a grid-following VIM control.
- 9-bus models:
  - [IEEE 9 Bus (#45936)](https://www.mathworks.com/matlabcentral/fileexchange/45936-ieee-9-bus): 2014, 23.1K downloads, 4.4/5.
  - [WSCC 9-bus test system (#65385)](https://www.mathworks.com/matlabcentral/fileexchange/65385-wscc-9-bus-test-system-ieee-benchmark): SimPowerSystems, 3.1/5.
- Caution: [Robust Virtual Inertia Control of a Low Inertia Microgrid (#180428)](https://www.mathworks.com/matlabcentral/fileexchange/180428-robust-virtual-inertia-control-of-a-low-inertia-microgrid) is only 1.28 KB and comes from a commercial project vendor. It is probably just a link, not a model.

**MATLAB toolboxes**
- [PSTess](https://github.com/sandialabs/snl-pstess): Sandia National Laboratories and Montana Tech, MATLAB, MIT-style license. Release 1.1 (Feb 2024), last commit 2026-01-20. It is a fork of PST v3.0 and **includes the 3-machine 9-bus data (`data/data3m9b.m`, `d3m9bm.m`)**. It adds `ess.m` (energy storage), `reec.m` (a REEC-type controller), `gfma.m`/`mac_ivm.m` (grid-forming) and `lsc.m`.
- [Power System Oscillations book companion](https://github.com/powersystemoscillations/powersystemoscillations.github.io): Rogers, Chow et al., CC BY-NC 4.0. It distributes PST (`pst_aug_2020`, which is v3.0), legacy PST and PSTess.
  - **"PST 4.0 by Ryan Ghiocel" could not be verified.** No such repository turned up, and the newest PST I could find is the August 2020 v3.0.
- [PSAT](https://faraday1.ucd.ie/psat.html): Federico Milano, GPL, MATLAB with Octave support for the command line. Last update 6 Jan 2013. The page lists wind turbine and FACTS models. It does not list test systems, so I could not confirm a 9-bus case from the page.

## 2. Open-source dynamic simulators

- [ANDES](https://github.com/CURENT/andes): CURENT (Hantao Cui), Python, GPL-3.0, last commit 2026-03-11, 388 stars. **This is the strongest open match for your study.**
  - It ships `andes/cases/wscc9/wscc9.xlsx` and `.raw`, plus Kundur, IEEE 14, IEEE 39 and WECC 179 cases.
  - Models include `regca1`, `reeca1`, `reecb1`, **`regcv1`/`regcv2` (VSC with VSM control, inertia M and damping D)**, `regf1`, `regf2`, `regf3` (droop, VSM and dVOC GFM per the arXiv survey) and `esd1` (distributed storage).
- [PowerSimulationsDynamics.jl](https://github.com/NREL-Sienna/PowerSimulationsDynamics.jl): NREL Sienna, Julia, BSD-3, last commit 2026-08-12.
  - It has modular inverter models, with outer controls `VirtualInertia` (VSM), `ActivePowerDroop` and `ReactivePowerDroop`.
  - Tutorials ([docs](https://sienna-platform.github.io/PowerSimulationsDynamics.jl/stable/)) include Inverter Modeling, OMIB, Small-Signal and 240-bus WECC.
  - A `test/data_tests/9BusSystem.json` file exists in the tests, but no 9-bus tutorial.
- [OpenIPSL](https://github.com/OpenIPSL/OpenIPSL): Modelica, BSD-3, last commit 2026-10-25. It has `Examples/IEEE9` (base case plus a STATCOM variant), PSS/E-style renewables (REGC/REEC/REPC under `Electrical/Renewables/PSSE`) and a **GFM model `REGFMA1`** with droop and limiters. Runs in OpenModelica.
- [Dynaωo](https://github.com/dynawo/dynawo): RTE, C++/Modelica, MPL-2.0, last commit 2026-10-28. It has **GFM droop, matching, dVOC and EPRI GFM** models, WECC REGC/REEC/REPC, a WECC BESS model, and `examples/DynaSwing/GridForming_GridFollowing`. It has an IEEE 14-bus case but I found no 9-bus case.
- [PowerDynamics.jl](https://github.com/JuliaEnergy/PowerDynamics.jl): Julia, MIT (some files MPL), last commit 2026-10-01. It has a **`docs/examples/ieee9bus.jl` tutorial** using RTDS data, IEEE 39 tutorials, and `IdealDroopInverter`/`ComposableInverter` models.
- [GridCal, now VeraGrid](https://github.com/SanPen/GridCal): Python, MPL-2.0, last commit 2026-10-22. It includes `IEEE 9 Bus.gridcal` and `case9`, and has an RMS/EMT engine. Its docs show WSCC SG vs GFM vs GFL eigenvalue benchmarks.
- [pandapower](https://github.com/e2nIEE/pandapower): BSD-3, active. It is **steady-state only** (it has `case9`), so use it just for load flow and cross-checking.
- [ATayebi/GridFormingConverters](https://github.com/ATayebi/GridFormingConverters): Simulink, no license file, last commit 2020-05-30. It has **`IEEE9BusTestSystem.slx` with droop, VSM, matching and dVOC GFM models** from Tayyebi, Groß, Anta and Dörfler, "Interactions of Grid-Forming Power Converters and Synchronous Machines". **This is the best Simulink 9-bus GFM reference.** The README asks you to cite the paper.
- Smaller repositories:
  - [imhussain001/Three-Machine-9-Bus-Simulink-Model-Matlab](https://github.com/imhussain001/Three-Machine-9-Bus-Simulink-Model-Matlab): last commit 2026-10-22, a WSCC 9-bus load-frequency-control/governor model with frequency plots for a +20 MW step.
  - [TsMikeLiu/VSG_SVPWM](https://github.com/TsMikeLiu/VSG_SVPWM): a simple `VSG.slx`, no license.
  - Avoid `nextcombo/...` and `lonlonago/...` "VSG" repositories. They are paywalled listings, not code.
- Survey: [Su et al., arXiv:2412.08065](https://arxiv.org/abs/2412.08065) compares GFM support in ANDES, PSID, Dynawo, OpenDSS and GridLAB-D. Its numerical study uses IEEE 14-bus.

## 3. Datasets and data tools

- [PVGIS](https://joint-research-centre.ec.europa.eu/photovoltaic-geographical-information-system-pvgis_en): EC JRC, v5.3 with v6 in beta, worldwide coverage including Turkey. The [API](https://joint-research-centre.ec.europa.eu/photovoltaic-geographical-information-system-pvgis/getting-started-pvgis/api-non-interactive-service_en) `seriescalc` gives hourly irradiance and PV output, and `tmy` gives a typical year. Databases are SARAH3 and ERA5.
- [Renewables.ninja](https://www.renewables.ninja/): hourly PV and wind simulation. The [API](https://www.renewables.ninja/documentation) allows 50 requests/hour for registered users.
- [ERA5 hourly single levels](https://cds.climate.copernicus.eu/datasets/reanalysis-era5-single-levels): Copernicus, 1940 to present, CC-BY.
- [EPİAŞ Şeffaflık](https://seffaflik.epias.com.tr/): the Turkish market transparency platform. Python access is through [eptr2](https://pypi.org/project/eptr2/) (Tideseed, Apache-2.0, v1.3.9, Sep 2026, needs an EPİAŞ account). It offers 232 services, e.g. `rt-gen` (real-time generation by source) and `rt-cons`. I did not see a system-frequency service.
- [ENTSO-E Transparency API guide](https://transparency.entsoe.eu/content/static_content/Static%20content/web%20api/Guide.html), with the [entsoe-py](https://github.com/EnergieID/entsoe-py) client (MIT). I could not confirm from the page whether Turkey is covered.
- [Power grid frequency database](https://power-grid-frequency.org/database): Jumar, Schäfer, Rydin Gorjão et al. It **includes Istanbul**: 1 s GPS-synchronised data for 41 days in 2019. Free to use with a citation (arXiv:2006.01771). Use it for realistic Continental Europe/Turkey frequency traces.
- [FNET/GridEye](https://fnetpublic.utk.edu/): UTK (Yilu Liu). Its data pages are robots-blocked, and data access is described as by contact.
- Dynamic data reference: the [OPAL-RT IEEE 9-bus documentation](https://www2.kios.ucy.ac.cy/testsystems/wp-content/uploads/2020/03/IEEE9_model_documentation_R0.pdf) gives H, D and exciter parameters, but no governor data.

## 4. Videos, webinars and courses

- [Renewable Energy Integration Design with Simscape](https://www.mathworks.com/videos/renewable-energy-integration-design-with-simscape-1715700226243.html): MathWorks, 28:29, May 2024. Covers VSM GFM BESS with PV, GFL BESS and IEEE 2800 checks. It is the walkthrough for the example above.
- [Power Converter Circuit and Control Design with Simscape](https://www.mathworks.com/videos/power-converter-circuit-and-control-design-with-simscape-1715762897818.html): MathWorks, 36:56. Covers GFM converter design and testing.
- [Overview of the UNIFI Consortium](https://youtu.be/3TUAWTuxVcM): ESIG with Ben Kroposki (NREL), Mar 2022.
- [Understanding Grid-forming Inverter Specifications](https://youtu.be/zkJbbLu5rSQ): G-PST/ESIG with Kroposki, Feb 2023.
- [Requirements and Verification for GFM Units: the German approach](https://youtu.be/Ypqe4wVsJPA): ESIG, Aug 2025. Covers Germany's market-based inertia product, which is good motivation for your study.
- [GFM Control for Oscillation Damping (Iberian 2025 event)](https://www.youtube.com/watch?v=Op7APzo0XfQ): ESIG, Apr 2026. Includes VSG studies.
- [UNIFI Consortium site](https://unificonsortium.org/) and [YouTube channel](https://www.youtube.com/@unificonsortium): seminar-series archive, the "GFM 102: Stability" short course and the GFM specifications.
- NREL reading:
  - [Introduction to Grid Forming Inverters](https://docs.nlr.gov/docs/fy24osti/90256.pdf): Kroposki slides, 2024. Includes a WECC GFM frequency-response result.
  - [Research Roadmap on Grid-Forming Inverters](https://docs.nlr.gov/docs/fy21osti/73476.pdf): NREL/TP-5D00-73476, 2020.
- IEEE PES webinars:
  - [GFM vs GFL evaluation with RMS/EMT/small-signal](https://ieee-pes.org/calendar/ieee-pes-webinar-grid-forming-and-grid-following-inverters-evaluation-using-rms-emt-and-small-signal-analysis/): Fraunhofer IEE and EPRI, Dec 2025. Argues that well-tuned GFL can match GFM, a useful counterpoint for your discussion chapter.
  - [Converter Control Design Principles for IBRs](https://ieee-pes.org/calendar/ieee-pes-webinar-converter-control-design-principles-for-inverter-based-resources/): Lingling Fan. Recording is on the PES Resource Center, likely paid for non-members.
- Dörfler:
  - [Control of Low-Inertia Power Systems](https://www.birs.ca/events/2017/5-day-workshops/17w5165/videos/watch/201703061053-Dorfler.html): BIRS video, about 21 min.
  - [Fundamentals for IBR Control](https://speakerdeck.com/floriandoerfler/fundamentals-for-ibr-control): 103 slides, Imperial Summer School 2024.
- Milano: [IEEE DLP "Complex Frequency and Simple Control in Low Inertia Systems"](https://events.vtools.ieee.org/m/375745). This is an event page only; I found no recording link.
- Turkish:
  - **I could not verify any Turkish YouTube lecture.** YouTube search is robots-blocked, and the web searches returned only theses and articles.
  - Verified Turkish reading instead:
    - [Koray Aydın, "Modern Güç Sistemlerinde Şebeke Kararlılığı: Atalet…"](https://www.enerjivedogalgaz.com/yayin/1299/modern-guc-sistemlerinde-sebeke-kararliligi-atalet-inertia-guc-sistemi-stabilizasyonu-torsiyonel-etki-ve-senkron-kompansatorlere-genel-bir-bakis_39986.html): Enerji & Doğalgaz, 2026.
    - [Dr. Seda Kül, "Şebeke Takipçisi (Grid-Following) Eviriciler"](https://www.sektorumdergisi.com/sebeke-takipcisi-grid-following-eviriciler/): 2026, includes a Turkey SCR perspective.
  - The student could search YouTube by hand for EMO or university channels.

## Recommended toolchain (top 6)

1. **MathWorks IEEE 9-Bus System**: keep it as the main platform and add the BESS at a load bus.
2. **MathWorks "Evaluate Performance of GFM BESS" plus the Renewable-Energy-Integration-Simscape repo**: ready VSM GFM and GFL BESS controllers to transplant into the 9-bus model.
3. **ATayebi/GridFormingConverters**: an IEEE 9-bus Simulink model already set up with droop, VSM, matching and dVOC GFM. Use it to check results and borrow the method.
4. **ANDES (`wscc9` + REGCA1/REECA1 + REGCV1/REGF2)**: fast phasor-domain cross-validation of nadir and RoCoF, and parameter sweeps in Python.
5. **PSTess (`data3m9b` + ess/gfma/reec)**: a second MATLAB phasor tool with the same 3-machine 9-bus case and storage models. Good for many-case sweeps.
6. **PVGIS `seriescalc` + eptr2 + power-grid-frequency.org (Istanbul)**: Turkish PV profiles, generation mix and real frequency traces for realistic scenarios.

I removed the clones afterwards in my head only; they are in `/tmp/claude-0/-home-claude/350c73ba-70d9-53bf-b131-83f4a24517b9/scratchpad/repos/` if anyone wants to inspect the file listings.
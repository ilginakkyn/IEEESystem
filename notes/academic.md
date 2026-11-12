# Literature brief: BESS synthetic inertia and FFR on the IEEE 9-bus (GFL vs GFM, sizing)

**How each entry was checked.** I opened a landing page (publisher, arXiv, institutional repository, OSTI or a library catalogue) for every entry. Most DOIs were also checked against the Crossref DOI registry API (api.crossref.org/works/DOI). Entries marked **[Crossref-only]** have DOI metadata checked but no abstract opened. Their one-line summaries come from my background knowledge, not from a page I read. ★ marks the 10 most important items.

---

## A. Foundations and analytical frequency models

- ★ **Anderson, P.M. & Mirheydar, M.**, "A low-order system frequency response model," *IEEE Trans. Power Syst.* 5(3):720–729, 1990. DOI 10.1109/59.65898. [record](https://www.sciencegate.app/document/10.1109/59.65898)
  - The classic SFR model: an aggregate reheat-steam unit (inertia H, damping D, droop R, reheat F_H, T_R).
  - Its two time constants give a closed-form nadir and time-to-nadir. This is the natural analytic baseline for checking your 9-bus EMT/RMS nadir values.
- **Egido, I., Fernández-Bernal, F., Centeno, P. & Rouco, L.**, "Maximum frequency deviation calculation in small isolated power systems," *IEEE TPWRS* 24(4):1731–1738, 2009. DOI 10.1109/TPWRS.2009.2030399. [repo](https://repositorio.comillas.edu/xmlui/handle/11531/5176?show=full)
  - A simplified multi-technology governor/prime-mover model for the maximum Δf after an infeed loss. Parameters come from detailed models or field tests.
  - Validated on a real isolated system. No figures are given in the abstract.
- **Kundur, P.**, *Power System Stability and Control*, McGraw-Hill (EPRI Power System Engineering Series), 1994, ISBN 007035958X. [catalogue](https://library.bracu.ac.bd/vufind/Record/497/Description?lng=en)
  - The textbook reference for the swing equation, governor models and small-signal methods.
- **Ulbig, A., Borsche, T.S. & Andersson, G.**, "Impact of low rotational inertia on power system stability and operation," *IFAC Proc. Vol.* 47(3):7290–7297, 2014 (19th IFAC WC). DOI 10.3182/20140824-6-ZA-1003.02615. [arXiv](https://arxiv.org/abs/1312.6435) · [PDF](https://skoge.folk.ntnu.no/prost/proceedings/ifac2014/media/files/2615.pdf)
  - Continental Europe aggregated model, 3000 MW reference loss. At H=6 s the event is absorbed; at H=3 s the frequency drops below 49.5 Hz before primary control is fully active (~30 s).
  - German H fell below 4 s for 293 h (3.3%) in 2012.
  - In the two-area study, low inertia raises tie-line flows by more than 50% and their rate of change by up to 300%.
- ★ **Milano, F., Dörfler, F., Hug, G., Hill, D.J. & Verbič, G.**, "Foundations and challenges of low-inertia systems (Invited paper)," *PSCC 2018*, pp. 1–25. DOI 10.23919/PSCC.2018.8450880. [HKU repo](https://repository.hku.hk/handle/10722/263530)
  - The reference survey of stability, modelling and converter control in low-inertia grids, with industrial and academic demonstration experience.
- **Tielens, P. & Van Hertem, D.**, "The relevance of inertia in power systems," *Renew. Sustain. Energy Rev.* 55:999–1009, 2016. DOI 10.1016/j.rser.2015.11.016. [RePEc](https://ideas.repec.org/a/eee/rensus/v55y2016icp999-1009.html)
  - Proposes a broader definition of inertia that includes synthetic/virtual inertia. Concludes that frequency stability is the main casualty of low inertia.
- **Fernández-Guillamón, A., Gómez-Lázaro, E., Muljadi, E. & Molina-García, A.**, "Power systems with high renewable energy sources: A review of inertia and frequency control strategies over time," *RSER* 115:109369, 2019. DOI 10.1016/j.rser.2019.109369. [arXiv](https://arxiv.org/abs/2004.02951)
  - Historical review of inertia and damping values, "hidden/synthetic/virtual inertia" terminology, and how wind and PV contribute.
- **Kroposki, B., Johnson, B., Zhang, Y., Gevorgian, V., Denholm, P., Hodge, B.-M. & Hannegan, B.**, "Achieving a 100% renewable grid," *IEEE Power Energy Mag.* 15(2):61–73, 2017. DOI 10.1109/MPE.2016.2637122. [OSTI](https://www.osti.gov/biblio/1351586-achieving-renewable-grid-operating-electric-power-systems-extremely-high-levels-variable-renewable-energy) · [NREL](https://research-hub.nrel.gov/en/publications/achieving-a-100-renewable-grid-operating-electric-power-systems-w-4/)
  - Agenda paper on operating grids with very high shares of variable renewables (inverter-only operation, GFM need).
- **Paolone, M., Gaunt, T., Guillaud, X., Liserre, M., Meliopoulos, S., Monti, A., Van Cutsem, T., Vittal, V. & Vournas, C.**, "Fundamentals of power systems modelling in the presence of converter-interfaced generation," *EPSR* 189:106811, 2020 (PSCC 2020). DOI 10.1016/j.epsr.2020.106811. [ORBi](https://orbi.uliege.be/handle/2268/249144)
  - Questions phasor/RMS validity under converter-interfaced generation. Proposes revised GFL/GFM definitions and a control classification.
  - Useful for justifying an RMS-vs-EMT modelling choice.

## B. Virtual inertia placement and sizing

- **Poolla, B.K., Bolognani, S. & Dörfler, F.**, "Optimal placement of virtual inertia in power grids," *IEEE TAC* 62(12):6209–6220, 2017. DOI 10.1109/TAC.2017.2703302. [arXiv](https://arxiv.org/abs/1510.01497)
  - Uses an H2 (coherency) metric on a network-reduced linear model. The placement problem is non-convex: closed-form global optima exist for special cases, plus a local gradient method and a robust worst-case-disturbance variant.
  - Case study is a 3-region grid.
- ★ **Poolla, B.K., Groß, D. & Dörfler, F.**, "Placement and implementation of grid-forming and grid-following virtual inertia and fast frequency response," *IEEE TPWRS* 34(4):3035–3046, 2019. DOI 10.1109/TPWRS.2019.2892290. [arXiv](https://arxiv.org/abs/1807.01942)
  - Device models: GFL is PLL-estimated f and RoCoF driving a current source with a 100 ms lag; GFM is a swing-like voltage source behind an LC filter.
  - H2-optimal tuning and placement on the 14-generator, 59-bus SE-Australia model.
  - For a 200 MW step: max RoCoF goes 0.34 → 0.31 (GFL) / 0.27 Hz/s (GFM); nadir goes 128.6 → 112.1 / 104.3 mHz.
  - Peak total VI power is 68.1 MW (GFL) vs 41.1 MW (GFM). GFL peak injections are about 3× those of GFM.
  - The authors attribute GFL gain saturation to RoCoF estimation delay. **The closest published template for your GFL-vs-GFM comparison.**
- ★ **Knap, V., Chaudhary, S.K., Stroe, D.-I., Swierczynski, M., Craciun, B.-I. & Teodorescu, R.**, "Sizing of an energy storage system for grid inertial response and primary frequency reserve," *IEEE TPWRS* 31(5):3447–3456, 2016. DOI 10.1109/TPWRS.2015.2503565. [AAU PDF](https://vbn.aau.dk/ws/files/229560838/Sizing_of_an_Energy_Storage_System_for_Grid_Inertial_Response_and_Primary_Frequency_Reserve.pdf)
  - Sizes ESS power and energy from the target H (via a RoCoF limit of 0.5 Hz/s) and target λ (via |Δf_ss| ≤ 0.2 Hz). Test system is a 12-bus model at ~50% wind on RTDS, with a 175 MW trip.
  - H_target = 4.47 s (vs 4.13 s without ESS); λ_target = 875 MW/Hz.
  - Inertial response alone needs only 19.4 MW / 0.016 MWh (RoCoF 0.47 Hz/s).
  - Inertial response plus primary reserve needs 98.5 MW / 49.6 MWh (RoCoF 0.34 Hz/s, f_min 49.40 Hz).
  - **The direct sizing methodology to emulate.**
- **Teng, F., Trovato, V. & Strbac, G.**, "Stochastic scheduling with inertia-dependent fast frequency response requirements," *IEEE TPWRS* 31(2):1557–1566, 2016. DOI 10.1109/TPWRS.2015.2434837. [Crossref-only]
  - Frequency-constrained stochastic UC in which FFR requirements depend on inertia.
- **Badesa, L., Teng, F. & Strbac, G.**, "Simultaneous scheduling of multiple frequency services in stochastic unit commitment," *IEEE TPWRS* 34(5):3858–3868, 2019. DOI 10.1109/TPWRS.2019.2905037. [arXiv](https://arxiv.org/abs/1809.10391)
  - Co-optimises synchronous and synthetic inertia, EFR, PFR and a dynamically reduced largest infeed, with nadir/RoCoF/q-s-s constraints, on GB 2030.
  - The abstract reports "significant" savings without giving figures.
- **Ratnam, K.S., Palanisamy, K. & Yang, G.**, "Future low-inertia power systems: Requirements, issues, and solutions – A review," *RSER* 124:109773, 2020. DOI 10.1016/j.rser.2020.109773. [RePEc](https://ideas.repec.org/a/eee/rensus/v124y2020ics1364032120300691.html)
  - Review of inertia requirements and of emulation methods for inverters, wind, PV and microgrids.
- **Alonso Sørensen, D., Vázquez Pombo, D. & Torres Iglesias, E.**, "Energy storage sizing for virtual inertia contribution based on ROCOF and local frequency dynamics," *Energy Strategy Rev.* 47:101094, 2023. DOI 10.1016/j.esr.2023.101094. [DTU Orbit](https://orbit.dtu.dk/en/publications/energy-storage-sizing-for-virtual-inertia-contribution-based-on-r/)
  - Sizes ESS virtual inertia from a max-RoCoF limit for a reference fault, using local (bus) rather than COI dynamics, and distributes it across the network.
  - Validated on the **IEEE 9-bus**, then applied to Santiago (Cape Verde, ~20% RES).
  - Claims lower total power and energy. The sizing numbers could not be extracted because the PDF was blocked.

## C. Grid-forming vs grid-following

- **Zhong, Q.-C. & Weiss, G.**, "Synchronverters: Inverters that mimic synchronous generators," *IEEE TIE* 58(4):1259–1267, 2011. DOI 10.1109/TIE.2010.2048839. [Crossref-only]
  - The original synchronverter/VSM concept.
- **D'Arco, S. & Suul, J.A.**, "Equivalence of virtual synchronous machines and frequency-droops for converter-based microgrids," *IEEE Trans. Smart Grid* 5(1):394–395, 2014. DOI 10.1109/TSG.2013.2288000. [SINTEF](https://www.sintef.no/en/publications/publication/1049603)
  - Shows that a VSM with damping and inertia is equivalent to filtered P–f droop. This gives a physical basis for tuning J and D_p against droop R and filter time constant τ.
- **D'Arco, S., Suul, J.A. & Fosso, O.B.**, "A Virtual Synchronous Machine implementation for distributed control of power converters in SmartGrids," *EPSR* 122:180–197, 2015. DOI 10.1016/j.epsr.2015.01.001. [Crossref-only]
  - A detailed VSM with inner voltage/current loops and virtual impedance. A standard implementation reference.
- **Fang, J., Li, H., Tang, Y. & Blaabjerg, F.**, "On the inertia of future more-electronics power systems," *IEEE JESTPE* 7(4):2130–2146, 2019. DOI 10.1109/JESTPE.2018.2877766. [AAU](https://vbn.aau.dk/en/publications/on-the-inertia-of-future-more-electronics-power-systems)
  - Review of inertia sources: wind kinetic energy, DC-link capacitors, ultracapacitors, batteries and VSMs.
- **Lasseter, R.H., Chen, Z. & Pattabiraman, D.**, "Grid-forming inverters: A critical asset for the power grid," *IEEE JESTPE* 8(2):925–935, 2020. DOI 10.1109/JESTPE.2019.2959271. [Crossref-only]
  - Argues GFM operation is necessary at high IBR share.
- **Rosso, R., Wang, X., Liserre, M., Lu, X. & Engelken, S.**, "Grid-forming converters: Control approaches, grid-synchronization, and future trends—A review," *IEEE OJIA* 2:93–109, 2021. DOI 10.1109/OJIA.2021.3074028. [DOAJ](https://doaj.org/article/628b9fbee88a4344ab5b4571abd482c1)
  - Generalised GFM structure, with subsystems compared by function. Open issues: angle stability, fault ride-through, islanding transitions.
- ★ **Tayyebi, A., Groß, D., Anta, A., Kupzog, F. & Dörfler, F.**, "Frequency stability of synchronous machines and grid-forming power converters," *IEEE JESTPE* 8(2):1004–1018, 2020. DOI 10.1109/JESTPE.2020.2966524. [arXiv](https://arxiv.org/abs/2003.04715)
  - **IEEE 9-bus EMT:** an SM at node 1 (100 MVA, H=3.7 s, 1% droop, τ_g=5 s) and aggregated 100 MVA GFCs at nodes 2 and 3. Compares droop, VSM, matching and dVOC; RoCoF is measured over a 250 ms window.
  - All GFM controls lower nadir and RoCoF compared with an all-SM system; matching control improves least.
  - With dc saturation (1.2 pu, τ_dc=50 ms) and a 0.9 pu step, droop, VSM and dVOC lose stability; standard ac limiting does not save them (windup).
  - A modified limiter or a faster turbine (τ_g=1 s) restores stability. The all-GFC case survives where the mixed SM+GFC case fails.
  - No tabulated nadir values.
- ★ **Markovic, U., Stanojev, O., Aristidou, P., Vrettos, E., Callaway, D.S. & Hug, G.**, "Understanding small-signal stability of low-inertia systems," *IEEE TPWRS* 36(5):3997–4017, 2021. DOI 10.1109/TPWRS.2021.3061434. [page](https://sps.cut.ac.cy/publication/2021JMarkovicb/) · [PDF](https://sps.cut.ac.cy/publication/2021JMarkovicb/2021JMarkovicb.pdf)
  - Full-order modal analysis including line dynamics.
  - 2-bus limits: about 79% inverter share for SG+GFM and about 60% for SG+GFL.
  - **IEEE 9-bus:** at least about 47% synchronous generation is needed in the mixed case; two GFM plus one GFL reaches 93%.
  - The PLL-related loss of synchronisation appears at about 59% GFL share with no SG. Faster PLL gains help only a few percent.
- **Qoria, T., Gruson, F., Colas, F., Denis, G., Prevost, T. & Guillaud, X.**, "Critical clearing time determination and enhancement of grid-forming converters embedding virtual impedance as current limitation algorithm," *IEEE JESTPE* 8(2):1050–1061, 2020. DOI 10.1109/JESTPE.2019.2959085. Companion paper: Qoria et al., "Current limiting algorithms and transient stability analysis of grid-forming VSCs," *EPSR* 189:106726, 2020. [Crossref-only] (Related MIGRATE tuning paper: [ENSAM repo](https://sam.ensam.eu/handle/10985/15938))
  - Virtual-impedance current limiting and its effect on critical clearing time.
- **Fan, B., Liu, T., Zhao, F., Wu, H. & Wang, X.**, "A review of current-limiting control of grid-forming inverters under symmetrical disturbances," *IEEE OJPEL* 3:955–969, 2022. DOI 10.1109/OJPEL.2022.3227507. [AAU](https://vbn.aau.dk/en/publications/a-review-of-current-limiting-control-of-grid-forming-inverters-un/)
  - Compares current limiters, virtual impedance and voltage limiters. Failure modes covered: temporary overcurrent, undefined current angle, saturation and windup, transient overvoltage.
- **Kenyon, R.W., Sajadi, A., Bossart, M., Hoke, A. & Hodge, B.-M.**, "Interactive power to frequency dynamics between grid-forming inverters and synchronous generators in power electronics-dominated power systems," *IEEE Syst. J.* 17(3):3456–3467, 2023. DOI 10.1109/JSYST.2023.3257284. [arXiv](https://arxiv.org/abs/2102.12332)
  - Droop-GFM plus SG lowers the frequency-response order. On 9-bus and 39-bus systems, nadir and RoCoF become decoupled.
  - Damping of the dominant mode drops sharply above about 80% GFM share.

## D. PLL and measurement issues; FFR vs inertia

- ★ **Eriksson, R., Modig, N. & Elkington, K.**, "Synthetic inertia versus fast frequency response: a definition," *IET Renew. Power Gener.* 12(5):507–514, 2018. DOI 10.1049/iet-rpg.2017.0370. [IET issue](https://digital-library.theiet.org/content/journals/iet-rpg/12/5;jsessionid=acmnu3mduj41.x-iet-live-01)
  - Defines the terms, separating df/dt-proportional synthetic inertia from Δf-triggered FFR. The key reference for keeping "inertia" and "FFR" apart in the report. (Abstract not opened; only the issue listing with pages and DOI.)
- **Rezkalla, M., Pertl, M. & Marinelli, M.**, "Electric power system inertia: requirements, challenges and solutions," *Electr. Eng.* 100(4):2677–2693, 2018. DOI 10.1007/s00202-018-0739-z. [CORE PDF](https://core.ac.uk/download/189887839.pdf)
  - Synthetic inertia control needs a RoCoF measurement and is noise-sensitive; droop-like FFC gives a better nadir and steady state.
  - The same event reads 2.1 Hz/s over a 100 ms window but 0.9 Hz/s over 500 ms.
  - Ireland: 1 Hz/s over 500 ms withstand and a 20 GWs inertia floor.
  - Battery cost range quoted: €250–2600/kW.
- **Hong, Q., Nedd, M., Norris, S., Abdulhadi, I., Karimi, M., Terzija, V., Marshall, B., Bell, K. & Booth, C.**, "Fast frequency response for effective frequency control in power systems with low inertia," *14th IET ACDC*, 2018. [Strathprints](https://strathprints.strath.ac.uk/63971/) (DOI not verified)
  - Generic SFR model including NSG and FFR. Shows the effect of FFR delay and ramp on reserve needs, and describes GB's EFCC scheme.
- **Rakhshani, E., Remon, D., Cantarellas, A.M., Mehrjerdi, H. & Rodriguez, P.**, "Derivative based inertia emulation of interconnected systems considering phase-locked loop dynamics," *IEEE PESGM 2016*. DOI 10.1109/PESGM.2016.7741705. [QSpace](https://qspace.qu.edu.qa/handle/10576/18259)
  - Models the PLL as a 2nd-order transfer function inside the df/dt emulation loop. A good minimal GFL model for an RMS 9-bus study.
- **Baruzzi, V., Rosini, A., Lodi, M., Bonfiglio, A. & Oliveri, A.**, "Synthetic inertia estimation in the presence of measurement noise and delays: An application to wind turbine generators," *IJEPES* 166:110511, 2025. DOI 10.1016/j.ijepes.2025.110511. [record](https://library.kab.ac.ug/Record/doaj-art-14d61bad6a2c46f2a30e308f9fc08922/Description)
  - Quantifies how far the delivered inertia falls short of the intended inertia for a GFL RoCoF emulator, because of noise and delay. Uses simulation, a hardware prototype and real-time simulation.
- **Pattabiraman, D., Lasseter, R.H. & Jahns, T.M.**, "Impact of phase-locked loop control on the stability of a high inverter penetration power system," *IEEE PESGM 2019*. DOI 10.1109/PESGM40551.2019.8973657. Companion paper: "Comparison of grid following and grid forming control for a high inverter penetration power system," PESGM 2018, DOI 10.1109/PESGM.2018.8586162. [Crossref-only]

## E. IEEE 9-bus BESS / virtual-inertia studies (for checking your numbers)

- ★ **Datta, U., Kalam, A. & Shi, J.**, "Battery energy storage system for aggregated inertia-droop control and a novel frequency dependent state-of-charge recovery," *Energies* 13(8):2003, 2020. DOI 10.3390/en13082003. [VU PDF](https://vuir.vu.edu.au/41197/1/energies-13-02003.pdf)
  - Modified 9-bus: hydro 250 / gas 255 / coal 230 MW, plus PV at buses 5 and 9 and DFIG at buses 6 and 8 (22.5% RES). BESS of about 27 MW with H_BESS=20 s and R=0.006 pu.
  - Generation event: nadir 49.307 → 49.617 Hz; RoCoF 0.833 → 0.394 Hz/s.
  - Load event: RoCoF 0.627 → 0.43 Hz/s.
  - Caveats: inconsistent BESS bus (bus 4 vs G1 terminal) and an "MHz" unit typo.
- ★ **Lu, L., Saborío-Romano, O. & Cutululis, N.A.**, "Frequency control in power systems with large share of wind energy," *Energies* 15(5):1922, 2022. DOI 10.3390/en15051922. [MDPI](https://www.mdpi.com/1996-1073/15/5/1922)
  - **WSCC 9-bus EMT:** G1 and G3 are 30 MVA wind plants and G2 is thermal. Compares GFL+GFL, GFL+GFM and GFM+GFM under a 3 MW per-load step.
  - The GFL virtual-inertia pulse is about 0.05 pu, while GFM gives an instant response above 20%. With equal H=4 s, GFM beats the SM inertial response.
  - The PLL gives large frequency-estimate swings at event onset, which corrupts the RoCoF signal. No current limits were modelled.
- **Prastiantono, A., Ramadhan, U.F., Kim, D., Hur, D. & Yoon, M.**, "Evaluating frequency stability with a generic model for IBR penetration and the implementation of grid-forming control strategies," *Energies* 17(11):2779, 2024. DOI 10.3390/en17112779. [MDPI](https://mdpi.com/1996-1073/17/11/2779)
  - IEEE 9-bus PSCAD with WECC generic GFL models plus GFM. Sweeps IBR share 20–60%, H=2–6 s and GFM/GFL ratio; criterion is ≥59.7 Hz.
  - Above 50% IBR, GFL support is limited and a GFM share of about 35% or more is needed (the paper's wording is inconsistent).
  - Fits polynomial nadir predictors.
- **Parajuli, A., Gurung, S. & Chapagain, K.**, "Optimal placement and sizing of battery energy storage systems for improvement of system frequency stability," *Electricity* 5(3):662–683, 2024. DOI 10.3390/electricity5030033. [MDPI](https://www.mdpi.com/2673-4826/5/3/33)
  - PSO, firefly and bat algorithms maximise nadir subject to RoCoF ≤ ±1.5 Hz/s on IEEE 9-bus and 39-bus. The BESS uses droop only, with no df/dt term.
- **Madiba, N., Khoza, B. & Apata, O.**, "Mitigating frequency collapse in low-inertia systems: A case for optimal BESS placement," *Eng. Proc.* 140(1):49, 2026 (SAUPEC). DOI 10.3390/engproc2026140049. [MDPI](https://www.mdpi.com/2673-4591/140/1/49)
  - PowerFactory 9-bus with G2 and G3 replaced by RES at 10–40%, and a 100% load step at bus 5.
  - At 40% RES the case collapses (57.73 Hz, −1.24 Hz/s). Adding a 50 MW / 25 MWh BESS at bus 5 gives 59.35 Hz and −0.42 Hz/s.
- **Alharbi, M., Altarjami, I. & Alhazmi, Y.**, "Enhancing frequency stability in low-inertia grids through optimal BESS placement and AI-driven dispatch strategy," *Energies* 19(6):1464, 2026. DOI 10.3390/en19061464. [MDPI](https://www.mdpi.com/1996-1073/19/6/1464)
  - PSS/E 9-bus with PV plus BESS at bus 5 and a 10 MW mismatch. Uses a COI electrical-distance index (bus 4 = 0.009, bus 3 = 1.0) and gives dispatch thresholds under which keeping the BESS at the RES bus matches relocating it.
- Also on the 9-bus: Tayyebi 2020, Markovic 2021, Kenyon 2023 and Alonso Sørensen 2023 (above).

## F. Wind synthetic inertia and secondary frequency dip

- **Morren, J., de Haan, S.W.H., Kling, W.L. & Ferreira, J.A.**, "Wind turbines emulating inertia and supporting primary frequency control," *IEEE TPWRS* 21(1):433–434, 2006. DOI 10.1109/TPWRS.2005.861956. [TU Delft](https://repository.tudelft.nl/record/uuid:47df49bc-d128-4614-88ba-5aa8721718c8)
  - df/dt plus Δf control that draws on rotor kinetic energy.
- **Ullah, N.R., Thiringer, T. & Karlsson, D.**, "Temporary primary frequency control support by variable speed wind turbines—Potential and applications," *IEEE TPWRS* 23(2):601–612, 2008. DOI 10.1109/TPWRS.2008.920076. [Chalmers](https://research.chalmers.se/en/publication/65845)
  - The landing page has no abstract. The paper is commonly cited for a short-term (~10 s) extra-power capability, but I did not check that figure here.
- **Kang, M., Muljadi, E., Hur, K. & Kang, Y.C.**, "Stable adaptive inertial control of a doubly-fed induction generator," *IEEE Trans. Smart Grid* 7(6):2971–2979, 2016. DOI 10.1109/TSG.2016.2559506. [NREL](https://research-hub.nrel.gov/en/publications/stable-adaptive-inertial-control-of-a-doubly-fed-induction-genera/)
  - Adds an MPPT term during deceleration to suppress the second frequency dip (SFD), then a small power reduction to speed rotor recovery.
- **Kang, M., Kim, K., Muljadi, E., Park, J.-W. & Kang, Y.C.**, "Frequency control support of a doubly-fed induction generator based on the torque limit," *IEEE TPWRS* 31(6):4575–4583, 2016. DOI 10.1109/TPWRS.2015.2514240. [OSTI](https://www.osti.gov/biblio/1345721)
  - A torque-limit-based scheme that releases 2.9–3.7× the Hydro-Québec kinetic-energy requirement, with a small SFD.
- **Brisebois, J. & Aubut, N.**, "Wind farm inertia emulation to fulfill Hydro-Québec's specific need," *IEEE PES GM 2011*, pp. 1–7. DOI 10.1109/PES.2011.6039121. [Scilit](https://www.scilit.net/publications/4ff1a0957b8f1feaf900fafbd87719a0)
  - How HQT specified the first grid-code inertia-emulation requirement.
- **Pourbeik, P. (EPRI)**, *Specification of the Second Generation Generic Models for Wind Turbine Generators*, WECC, 2013/2014. [PDF](https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf)
  - Type-4 model built from REGC_A, REEC_A, WTGT_A and REPC_A. It has **no** synthetic-inertia block; only REPC_A droop. Any df/dt loop must be added by you.

## G. Benchmark data (WSCC 3-machine, 9-bus)

- ★ **Sauer, P.W. & Pai, M.A.**, *Power System Dynamics and Stability* (Prentice Hall 1998; authors' 2006 update hosted on the UIUC ECE576 course page). [PDF](https://courses.physics.illinois.edu/ece576/sp2018/Sauer%20and%20Pai%20book%20-%20Jan%202007.pdf)
  - **Example 7.1 / Table 7.1 load flow** (100 MVA base, 60 Hz):
    - Generation: P_G = 0.716 / 1.63 / 0.85 pu.
    - Voltages: V1 = 1.04; V2 = 1.0256∠9.3°; V3 = 1.0256∠4.7°.
    - Loads: 1.25+j0.5 (bus 5), 0.9+j0.3 (bus 6), 1.0+j0.35 (bus 8).
  - **Table 7.3 machine data:**
    - H = 23.64 / 6.4 / 3.01 s
    - X_d = 0.146 / 0.8958 / 1.3125
    - X'_d = 0.0608 / 0.1198 / 0.1813
    - X_q = 0.0969 / 0.8645 / 1.2578
    - X'_q = 0.0969 / 0.1969 / 0.25
    - T'_do = 8.96 / 6.0 / 5.89 s
    - T'_qo = 0.31 / 0.535 / 0.6 s
  - **Table 7.3 exciter data:** IEEE Type I, identical on all units: K_A=20, T_A=0.2, K_E=1.0, T_E=0.314, K_F=0.063, T_F=0.35, S_E = 0.0039·e^(1.555·E_fd).
  - **Example 8.3 / Table 8.1 eigenvalues** (two-axis model with IEEE-DC1-type exciter, D_i=0, constant-power loads, 21×21 A_sys):
    - Electromechanical: −0.7209 ± j12.7486 (≈2.03 Hz, gen 3 vs gen 2) and −0.1908 ± j8.3672 (≈1.33 Hz, gen 2 vs gen 1).
    - Exciter modes: −5.4875 ± j7.9487, −5.3236 ± j7.9220, −5.2218 ± j7.8161.
    - Real: −5.1761 and −3.3995.
    - Slow complex pairs: −0.4445 ± j1.2104, −0.4394 ± j0.7392, −0.4260 ± j0.4960.
    - Two zeros, from zero damping and angle reference.
    - Real: −3.2258.
  - Table 8.2 gives participation factors. It prints "−5.4875 ± j7.79487", which looks like a typo for j7.9487.
- **Anderson, P.M. & Fouad, A.A.**, *Power System Control and Stability*, 2nd ed., IEEE Press/Wiley-Interscience, 2003, ISBN 978-0-471-23862-1. [BibBase](https://bibbase.org/network/publication/anderson-fouad-powersystemcontrolandstability-2003) (DOI not verified)
  - The Table 2.1 values I could check through reproductions match Sauer & Pai: H, X_d, X'_d, X_q, X'_q, T'_do.
  - An O'Reilly appendix that reproduces the case lists 247.5 / 192 / 128 MVA, 16.5 / 18 / 13.8 kV, hydro (180 rpm) / steam / steam, and x_l = 0.0336 / 0.0521 / 0.0742. Its rows are partly scrambled. [O'Reilly appendix](https://www.oreilly.com/library/view/power-system-monitoring/9781118852477/b02.xhtml)
  - **Data inconsistency to flag:** gen-1 T'_qo is 0.31 s in Sauer & Pai but 0.6 s in Wang/Liu/Sun ([arXiv 1512.05185](https://www.arxiv.org/pdf/1512.05185), citing Anderson pp. 38–39, 44), which also prints X_q2 = 0.8465 instead of 0.8645. Some reproductions show a blank or zero T'_qo for the hydro unit. I could not see the printed Table 2.1 itself.
  - The KIOS "IEEE 9-bus" data ([PDF](https://www.kios.ucy.ac.cy/testsystems/wp-content/uploads/2020/03/IEEE-9.pdf): 512 / 270 / 125 MVA, H = 2.63 / 4.13 / 4.77 s) is a **different, modified** system. Do not mix it with Anderson & Fouad data.

---

## Gaps the literature leaves for a 9-bus capstone

1. **No head-to-head on the original Anderson & Fouad 9-bus.** No study compares GFL (PLL + df/dt + droop) with GFM (VSM) BESS on the unmodified Anderson & Fouad 9-bus, with an identical energy budget, identical current limits and the Sauer & Pai machine and exciter set.
   - Tayyebi uses one 100 MVA SM with H=3.7 s; Lu uses 30 MVA wind plants; Datta and Madiba change the generator fleet.
   - A study reproducing Table 8.1 as a baseline and then tracking how the 1.33 Hz and 2.03 Hz modes and the exciter modes move with each BESS control would be new.
2. **Sizing on this benchmark is missing.** No paper links Knap-type sizing (RoCoF limit to H_target, Δf_ss to λ, then MW/MWh) to the 9-bus with a VSM versus a PLL-based device. In particular, the extra MW a GFL device needs because of estimation delay (Poolla found about 1.6–3× in SE-Australia) has not been quantified there.
3. **Measurement effects are under-reported.** The 9-bus papers rarely state the RoCoF window or the PLL bandwidth. Rezkalla shows a 100 ms vs 500 ms window can halve the measured RoCoF. A sensitivity study of PLL bandwidth, filter and window against nadir and RoCoF, and against the risk of the GFL device destabilising, is open.
4. **Current-limited GFM on the 9-bus is studied only for frequency stability.** Its interaction with the SG governor/AVR (Tayyebi's windup instability) has not been combined with BESS SoC and energy limits, or with secondary-dip-like recovery behaviour.
5. **Analytical cross-checks are rare.** 9-bus papers seldom compare time-domain results with the SFR closed form (Anderson–Mirheydar or Egido) extended with virtual inertia and FFR terms. Doing so would make the capstone verifiable at PhD standard.

**Caveats.**
- For Lasseter 2020, Zhong & Weiss 2011, D'Arco VSM 2015, Qoria 2020, Teng 2016 and Pattabiraman 2018/2019 I checked only the Crossref DOI record; their summaries are from my background knowledge.
- Numbers I could not extract are omitted: Alonso Sørensen sizing (PDF blocked), Egido, Ullah, Badesa savings.
- The Hong 2018 DOI is not verified.
- I could not reach the project-doc tools in this session, so nothing was written to the "ILGIN MUHTAS" project.

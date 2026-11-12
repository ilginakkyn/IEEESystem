"""Bağımsız yazılımla çapraz doğrulama: ANDES (CURENT, Python) ile IEEE 9 bara.

Aynı Anderson & Fouad verisi ANDES'e programla girilir ve E1 olayı (Bara 6'ya +31,5 MW,
sabit akım yükü) koşulur. Karşılaştırılabilirlik için bu modelde de aynı varsayımlar
kullanılır: üç makine de TGOV1 (buhar), yük P ~ V, Q ~ V², frekans bağımlılığı yok (Kpf = 0).

Bilinen model farkları (sonuç farkının beklenen kaynakları):
  - ANDES'te iki eksenli makine yok; GENROU, alt geçici zaman sabitleri çok küçük
    (0,01 s) ve x'' ≈ x' seçilerek iki eksenli modele yaklaştırıldı (x''d = x''q zorunlu).
  - IEEEX1 doyması ikinci dereceden; bizim DC1A üstel doymamız iki noktadan eşlendi.
Kullanım:  python3 validation/andes_crosscheck.py   (önce: pip install andes)
Çıktı:     results/andes_crosscheck.csv  ve ekrana karşılaştırma tablosu
"""
import csv, os
import numpy as np
import andes

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
andes.config_logger(stream_level=40)

F0 = 50.0
lines = [(4, 5, 0.0100, 0.0850, 0.176), (4, 6, 0.0170, 0.0920, 0.158), (5, 7, 0.0320, 0.1610, 0.306),
         (6, 9, 0.0390, 0.1700, 0.358), (7, 8, 0.0085, 0.0720, 0.149), (8, 9, 0.0119, 0.1008, 0.209)]
trafos = [(1, 4, 0.0576), (2, 7, 0.0625), (3, 9, 0.0586)]
loads = [(5, 1.25, 0.50), (6, 0.90, 0.30), (8, 1.00, 0.35)]
# bus, S_rating, H(100 MVA), xd, x'd, xq, x'q, T'd0, T'q0, V, P
gens = [(1, 247.5, 23.64, 0.1460, 0.0608, 0.0969, 0.0969, 8.96, 0.310, 1.040, None),
        (2, 192.0, 6.40, 0.8958, 0.1198, 0.8645, 0.1969, 6.00, 0.535, 1.025, 1.63),
        (3, 128.0, 3.01, 1.3125, 0.1813, 1.2578, 0.2500, 5.89, 0.600, 1.025, 0.85)]


def build():
    ss = andes.System()
    ss.config.freq = F0
    for b in range(1, 10):
        ss.add('Bus', dict(idx=b, name=f'B{b}', Vn=230.0, v0=1.0))
    for i, (a, b, r, x, bb) in enumerate(lines):
        ss.add('Line', dict(idx=f'L{i}', bus1=a, bus2=b, r=r, x=x, b=bb, fn=F0, Vn1=230.0, Vn2=230.0))
    for i, (a, b, x) in enumerate(trafos):
        ss.add('Line', dict(idx=f'T{i}', bus1=a, bus2=b, r=0.0, x=x, b=0.0, trans=1, tap=1.0, fn=F0, Vn1=230.0, Vn2=230.0))
    for i, (b, p, q) in enumerate(loads):
        ss.add('PQ', dict(idx=f'PQ{b}', bus=b, p0=p, q0=q, vmax=1.5, vmin=0.5, Vn=230.0))
    for (b, S, H, xd, xd1, xq, xq1, Td10, Tq10, V, P) in gens:
        if P is None:
            ss.add('Slack', dict(idx=f'G{b}', bus=b, v0=V, Sn=100.0, p0=0.716, a0=0.0, Vn=230.0))
        else:
            ss.add('PV', dict(idx=f'G{b}', bus=b, v0=V, p0=P, Sn=100.0, Vn=230.0))
        x2 = 0.98 * min(xd1, xq1)
        ss.add('GENROU', dict(idx=f'GR{b}', bus=b, gen=f'G{b}', Sn=100.0, Vn=230.0, fn=F0, M=2 * H, D=0.0, ra=0.0,
                              xd=xd, xq=xq, xd1=xd1, xq1=xq1, xd2=x2, xq2=x2, xl=0.8 * x2,
                              Td10=Td10, Tq10=Tq10, Td20=0.01, Tq20=0.01, S10=0.0, S12=0.0))
        ss.add('IEEEX1', dict(idx=f'EX{b}', syn=f'GR{b}', TR=0.0, TA=0.2, TB=0.0, TC=0.0, KA=20.0, KE=1.0,
                              TE=0.314, KF1=0.063, TF1=0.35, VRMAX=8.0, VRMIN=-8.0,
                              E1=1.8, SE1=0.0039 * np.exp(1.555 * 1.8), E2=2.4, SE2=0.0039 * np.exp(1.555 * 2.4)))
        ss.add('TGOV1', dict(idx=f'TG{b}', syn=f'GR{b}', R=0.05 * 100.0 / S, T1=0.5, T2=3.0, T3=10.0,
                             VMAX=10.0, VMIN=0.0, Dt=0.0))
    ss.add('Alter', dict(t=1.0, model='PQ', dev='PQ6', src='Ipeq', attr='v', method='+', amount=0.315))
    ss.setup()
    ss.PQ.config.p2p, ss.PQ.config.p2i, ss.PQ.config.p2z = 0.0, 1.0, 0.0
    ss.PQ.config.q2q, ss.PQ.config.q2i, ss.PQ.config.q2z = 0.0, 0.0, 1.0
    return ss


def metrics(t, f, t0=1.0):
    i0 = np.searchsorted(t, t0)
    f0 = np.interp(t0, t, f)
    r100 = (np.interp(t0 + 0.1, t, f) - f0) / 0.1
    r500 = (np.interp(t0 + 0.5, t, f) - f0) / 0.5
    j = np.argmin(f[i0:]) + i0
    qss = np.mean(f[t >= t[-1] - 1.0])
    return dict(rocof100=r100, rocof500=r500, nadir=f[j], t_nadir=t[j] - t0, f_qss=qss)


ss = build()
ss.PFlow.run()
pf = dict(V=ss.Bus.v.v.copy(), a=np.degrees(ss.Bus.a.v.copy()))
Vpub = np.array([1.040, 1.025, 1.025, 1.026, 0.996, 1.013, 1.026, 1.016, 1.032])   # A&F Şekil 2.18
Apub = np.array([0, 9.3, 4.7, -2.2, -4.0, -3.7, 3.7, 0.7, 2.0])
pf_dV, pf_dA = np.max(np.abs(pf['V'] - Vpub)), np.max(np.abs(pf['a'] - Apub))
ss.TDS.config.tf = 30.0
ss.TDS.config.tstep = 0.005
ss.TDS.config.no_tqdm = 1
ss.TDS.run()
ts = ss.dae.ts
t = np.array(ts.t)
w = np.array(ts.x[:, ss.GENROU.omega.a])
M = ss.GENROU.M.v
f = F0 * (w @ M) / M.sum()
mA = metrics(t, f)

# Aynı varsayımlarla bu çalışmanın modeli: validation/ieee9v2_same_assumptions.m -> results/andes_ref_traj.csv
ref = os.path.join(root, 'results', 'andes_ref_traj.csv')
mB = None
if os.path.exists(ref):
    D = np.loadtxt(ref, delimiter=',', skiprows=1)
    mB = metrics(D[:, 0], D[:, 1])
    fB = np.interp(t, D[:, 0], D[:, 1])
    ok = t >= 1.0
    print(f'COI frekans eğrileri arasındaki en büyük fark (t > 1 s): {1000 * np.max(np.abs(f[ok] - fB[ok])):.1f} mHz')

print('ANDES güç akışı |V|:', np.round(pf['V'], 4))
print('ANDES güç akışı açı:', np.round(pf['a'], 2))
print(f"{'ölçüt':10s} {'ANDES':>10s} {'ieee9v2':>10s} {'fark %':>8s}")
rows = []
for k in ['rocof100', 'rocof500', 'nadir', 't_nadir', 'f_qss']:
    a = mA[k]
    if mB:
        b = mB[k]
        if k in ('nadir', 'f_qss'):
            d = 100 * ((F0 - a) - (F0 - b)) / (F0 - b)       # sapma üzerinden bağıl fark
        else:
            d = 100 * (a - b) / b
        print(f'{k:10s} {a:10.4f} {b:10.4f} {d:8.2f}')
        rows.append([k, a, b, d])
    else:
        print(f'{k:10s} {a:10.4f}')
        rows.append([k, a, '', ''])
with open(os.path.join(root, 'results', 'andes_crosscheck.csv'), 'w', newline='') as fh:
    wr = csv.writer(fh)
    wr.writerow(['metric', 'andes', 'ieee9v2', 'diff_pct_of_deviation'])
    wr.writerows(rows)
    wr.writerow(['pf_maxdV_vs_AF_pu', pf_dV, '', ''])
    wr.writerow(['pf_maxdA_vs_AF_deg', pf_dA, '', ''])
np.savetxt(os.path.join(root, 'results', 'andes_traj.csv'), np.c_[t, f], delimiter=',', header='t,f_coi', comments='')

# Küçük sinyal: elektromekanik modlar (0,5-3 Hz), ANDES EIG ile bu modelin linearize.m sonucu
se = build()
se.PFlow.run()
se.EIG.run()
osc = sorted([m for m in se.EIG.mu if 0.5 * 2 * np.pi < m.imag < 3 * 2 * np.pi], key=lambda z: -z.imag)
refm = os.path.join(root, 'results', 'andes_ref_modes.csv')
B = np.loadtxt(refm, delimiter=',', skiprows=1, ndmin=2) if os.path.exists(refm) else None
print('\nElektromekanik ve uyarma modları:  ANDES f (Hz), ζ  |  ieee9v2 f (Hz), ζ')
out = []
for k, m in enumerate(osc):
    fa, za = m.imag / 2 / np.pi, -m.real / abs(m)
    if B is not None:
        j = int(np.argmin(np.abs(B[:, 0] - fa)))
        print(f'  {fa:6.3f} {100 * za:6.2f} %  |  {B[j, 0]:6.3f} {100 * B[j, 1]:6.2f} %')
        out.append([fa, za, B[j, 0], B[j, 1]])
    else:
        print(f'  {fa:6.3f} {100 * za:6.2f} %')
        out.append([fa, za, np.nan, np.nan])
np.savetxt(os.path.join(root, 'results', 'andes_modes.csv'), np.array(out), delimiter=',',
           header='f_andes_Hz,zeta_andes,f_ieee9v2_Hz,zeta_ieee9v2', comments='')

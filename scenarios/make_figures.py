"""Rapordaki şekillerin PNG sürümleri (matplotlib). MATLAB'de collect_results(true) aynı
şekilleri MATLAB grafikleriyle üretir; bu betik, MATLAB'siz ortamda Türkçe karakterleri
doğru basmak için yazıldı.
Kullanım (ieee9v2 klasöründe):  python3 scenarios/make_figures.py
Gerekenler: numpy, scipy, matplotlib
"""
import csv, os
import numpy as np
import scipy.io as sio
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rd, fd = os.path.join(root, 'results'), os.path.join(root, 'figures')
os.makedirs(fd, exist_ok=True)
plt.rcParams.update({'font.size': 10, 'axes.grid': True, 'grid.alpha': 0.3,
                     'axes.spines.top': False, 'axes.spines.right': False})


def load(i):
    p = os.path.join(rd, i + '.mat')
    return sio.loadmat(p, squeeze_me=True, struct_as_record=False)['S'] if os.path.exists(p) else None


def ref(ax, x0, x1, y=49.2, txt='Nadir sınırı 49,2 Hz'):
    ax.axhline(y, color='0.35', ls='--', lw=1)
    ax.text(x1, y + 0.01, txt, ha='right', va='bottom', color='0.35', fontsize=9)


def traj(ids, labels, xl, fn, title, ylim=None):
    fig, ax = plt.subplots(figsize=(7.5, 4.2))
    for i, l in zip(ids, labels):
        S = load(i)
        if S is not None:
            ax.plot(S.t, S.f, lw=1.6, label=l)
    ref(ax, *xl)
    ax.set_xlim(xl)
    if ylim:
        ax.set_ylim(ylim)
    ax.set_xlabel('Zaman (s)'); ax.set_ylabel('f_COI (Hz)'); ax.set_title(title, loc='left')
    ax.legend(loc='lower right', fontsize=8.5, frameon=False)
    fig.tight_layout(); fig.savefig(os.path.join(fd, fn), dpi=140); plt.close(fig)


traj(['A_S0_E1', 'A_S2_E1', 'A_S3_E1', 'A_S4_E1', 'A_S5_E1', 'A_S6_E1'],
     ['S0 baz (3 senkron)', 'S2 G2 yerine PV, BESS yok', 'S3 GFL yalnız atalet', 'S4 GFL yalnız droop',
      'S5 GFL atalet + droop', 'S6 GFM (VSM)'],
     (0, 15), 'F1_ana_senaryolar.png', 'E1: Bara 6\'ya +31,5 MW (yükün %10\'u), 50 Hz', (49.1, 50.05))
traj(['A_S0_E2', 'A_S2_E2', 'A_S5_E2', 'A_S6_E2'],
     ['S0 baz', 'S2 BESS yok', 'S5 GFL-BESS 40 MVA', 'S6 GFM-BESS 40 MVA'],
     (0, 15), 'F2_E2_agir_olay.png', 'E2: +63 MW (yükün %20\'si)', (48.4, 50.05))
traj(['A_S2_E1', 'A_S9b_E1', 'A_S9c_E1'],
     ['S9a = S2: rüzgar, sentetik atalet yok', 'S9b rüzgar + sentetik atalet', 'S9c rüzgar + GFL-BESS'],
     (0, 30), 'F5_ruzgar.png', 'Tip-4 rüzgar: sentetik atalet ve ikincil düşüş', (49.2, 50.05))
traj(['A_S8a_E1', 'A_S8b_E1', 'A_S8c_E1', 'A_S2_E1'],
     ['S8a G1 ünitelerinin %50\'si, BESS yok', 'S8b + GFL-BESS', 'S8c + GFM-BESS', 'S2 (G1 tam)'],
     (0, 15), 'F6_dusuk_atama.png', 'Ünite ataması: G1\'in yarısı kapalı', (48.9, 50.05))

# F3: BESS gücü
fig, ax = plt.subplots(figsize=(7.5, 4.2))
for i, l in [('A_S5_E1', 'S5 GFL, E1'), ('A_S6_E1', 'S6 GFM, E1'), ('A_S5_E2', 'S5 GFL, E2'), ('A_S6_E2', 'S6 GFM, E2')]:
    S = load(i)
    if S is None:
        continue
    P = np.atleast_1d(S.Pf) if np.size(S.Pf) > 1 else np.asarray(S.Pg)[:, -1]
    P = P.reshape(len(S.t), -1)[:, -1]
    ax.plot(S.t, P - P[0], lw=1.6, label=l)
ax.set_xlim(0.8, 6); ax.set_xlabel('Zaman (s)'); ax.set_ylabel('BESS gücü, ΔP (MW)')
ax.set_title('BESS çıkış gücü (40 MVA, Bara 2)', loc='left'); ax.legend(frameon=False, fontsize=8.5)
fig.tight_layout(); fig.savefig(os.path.join(fd, 'F3_bess_guc.png'), dpi=140); plt.close(fig)

# F4: SNSP taraması
rows = {r['id']: r for r in csv.DictReader(open(os.path.join(rd, 'summary_all.csv')))}
fig, ax = plt.subplots(figsize=(7.5, 4.2))
for key, l in [('none_keep', 'BESS yok, üniteler açık'), ('none_prop', 'BESS yok, üniteler kapanır'),
               ('gfl_prop', 'GFL-BESS, üniteler kapanır'), ('gfm_prop', 'GFM-BESS, üniteler kapanır')]:
    xs, ys = [], []
    for s in range(0, 80, 10):
        r = rows.get(f'C_{s:02d}_{key}')
        if r:
            xs.append(s); ys.append(float(r['nadir']))
    ax.plot(xs, ys, marker='o', lw=1.6, label=l)
ref(ax, 0, 70)
ax.set_xlabel('Yenilenebilir payı, SNSP (%)'); ax.set_ylabel('Nadir (Hz)')
ax.set_title('SNSP taraması (E1): ataleti düşüren ünitelerin kapanması', loc='left')
ax.legend(frameon=False, fontsize=8.5, loc='lower left')
fig.tight_layout(); fig.savefig(os.path.join(fd, 'F4_snsp.png'), dpi=140); plt.close(fig)

# F7: yerleşim ve grup sayısı
P = list(csv.DictReader(open(os.path.join(rd, 'place_summary.csv'))))
Ns = sorted({int(r['N']) for r in P})
fig, axs = plt.subplots(1, 2, figsize=(9, 4.2))
for ax, col, lab, best in [(axs[0], 'rloc_w', 'En kötü yerel RoCoF |Hz/s| (aşağısı iyi)', max),
                           (axs[1], 'zeta', 'En kötü elektromekanik sönüm ζ (yukarısı iyi)', min)]:
    for j, n in enumerate(Ns):
        g = [r for r in P if int(r['N']) == n]
        v = np.array([float(r[col]) for r in g])
        x = j + (np.arange(len(v)) % 9 - 4) * 0.04
        y = np.abs(v) if col == 'rloc_w' else 100 * v
        ax.scatter(x, y, s=12, color='0.65')
        k = int(np.argmax(v) if best is max else np.argmin(v))
        ax.scatter(x[k], y[k], s=40, color='C0', zorder=3)
        ax.annotate(g[k]['buses'], (x[k], y[k]), xytext=(6, -3 if col == 'rloc_w' else 8),
                    textcoords='offset points', fontsize=8, color='C0')
    ax.set_xticks(range(len(Ns))); ax.set_xticklabels(Ns); ax.set_xlabel('BESS grup sayısı N (toplam 40 MVA)')
    ax.set_title(lab, loc='left', fontsize=9.5)
axs[1].axhline(5, color='0.35', ls='--', lw=1); axs[1].text(len(Ns) - 1, 5.5, 'ζ = %5', ha='right', color='0.35', fontsize=9)
axs[1].set_ylabel('ζ (%)')
fig.suptitle('114 yerleşim × 3 bozulma yeri: grup sayısı performansı değil dayanıklılığı artırıyor', x=0.01, ha='left', fontsize=10.5)
fig.tight_layout(); fig.savefig(os.path.join(fd, 'F7_yerlesim.png'), dpi=140); plt.close(fig)

# F8: N-1 boyutlandırma
p = os.path.join(rd, 'n1_sizing_w1.csv')
if os.path.exists(p):
    N1 = list(csv.DictReader(open(p)))
    fig, ax = plt.subplots(figsize=(7.5, 4.2))
    for t, l in [('gfl', 'GFL'), ('gfm', 'GFM')]:
        g = [r for r in N1 if r['type'] == t or (r['type'] == 'gfl' and r['S'] == '0')]
        g = sorted(g, key=lambda r: int(r['S']))
        ax.plot([int(r['S']) for r in g], [float(r['nadir']) for r in g], marker='o', lw=1.6, label=l)
    ref(ax, 0, 120)
    ax.set_xlabel('BESS gücü (MVA, Bara 2)'); ax.set_ylabel('Nadir (Hz)')
    ax.set_title('N-1 (G3 açması, 85 MW): kriter için ≈ 71–76 MVA gerekiyor', loc='left')
    ax.legend(frameon=False)
    fig.tight_layout(); fig.savefig(os.path.join(fd, 'F8_n1_boyut.png'), dpi=140); plt.close(fig)

print('şekiller:', sorted(os.listdir(fd)))

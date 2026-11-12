"""Yerleşim çalışması analizi: results/place_runs_w*.csv (+ place_ss.csv) -> özet tablolar.
Kullanım: python3 scenarios/place_analyze.py
"""
import csv, glob, os, statistics as st
from collections import defaultdict

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rows = []
for f in sorted(glob.glob(os.path.join(root, 'results', 'place_runs_w*.csv'))):
    with open(f) as fh:
        for r in csv.DictReader(fh):
            for k in ('rocof100', 'rocof500', 'nadir', 't_nadir', 'rocof_loc_max', 'dP_tot'):
                r[k] = float(r[k])
            r['N'] = int(r['N']); r['evbus'] = int(r['evbus']); r['bus_loc'] = int(r['bus_loc'])
            rows.append(r)

ss = {}
p = os.path.join(root, 'results', 'place_ss.csv')
if os.path.exists(p):
    with open(p) as fh:
        for r in csv.DictReader(fh):
            ss[r['buses']] = (float(r['zeta_min_em']), float(r['f_em']))

# yerleşim başına: 3 bozulma yerinin en kötüsü (worst-case) ve ortalaması
cfg = defaultdict(list)
for r in rows:
    cfg[(r['N'], r['buses'])].append(r)
agg = []
for (N, b), rs in cfg.items():
    if len(rs) < 3:
        continue
    agg.append(dict(N=N, buses=b,
                    nadir_w=min(x['nadir'] for x in rs), nadir_m=st.mean(x['nadir'] for x in rs),
                    r100_w=min(x['rocof100'] for x in rs), r500_w=min(x['rocof500'] for x in rs),
                    rloc_w=min(x['rocof_loc_max'] for x in rs), rloc_m=st.mean(x['rocof_loc_max'] for x in rs),
                    dP=max(x['dP_tot'] for x in rs),
                    zeta=ss.get(b, (float('nan'), float('nan')))[0]))

out = os.path.join(root, 'results', 'place_summary.csv')
keys = ['N', 'buses', 'nadir_w', 'nadir_m', 'r100_w', 'r500_w', 'rloc_w', 'rloc_m', 'dP', 'zeta']
with open(out, 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=keys); w.writeheader()
    for a in sorted(agg, key=lambda a: (a['N'], -a['rloc_w'])):
        w.writerow({k: (round(a[k], 5) if isinstance(a[k], float) else a[k]) for k in keys})

print(f'{len(rows)} koşu, {len(agg)} tam yerleşim')
for N in sorted({a['N'] for a in agg}):
    A = [a for a in agg if a['N'] == N]
    def rng(k):
        v = [a[k] for a in A]; return min(v), st.median(v), max(v)
    best_loc = max(A, key=lambda a: a['rloc_w']); worst_loc = min(A, key=lambda a: a['rloc_w'])
    best_nad = max(A, key=lambda a: a['nadir_w'])
    print(f'\nN={N} ({len(A)} yerleşim)')
    for k in ('nadir_w', 'r100_w', 'r500_w', 'rloc_w', 'zeta'):
        lo, me, hi = rng(k); print(f'  {k:8s} min {lo:.4f} med {me:.4f} max {hi:.4f}')
    print(f'  en iyi yerel RoCoF : {best_loc["buses"]} {best_loc["rloc_w"]:.4f} nadir {best_loc["nadir_w"]:.4f} r100 {best_loc["r100_w"]:.4f}')
    print(f'  en kötü yerel RoCoF: {worst_loc["buses"]} {worst_loc["rloc_w"]:.4f} nadir {worst_loc["nadir_w"]:.4f}')
    print(f'  en iyi nadir       : {best_nad["buses"]} {best_nad["nadir_w"]:.4f}')
    top = sorted(A, key=lambda a: -a['rloc_w'])[:5]
    print('  ilk 5 (yerel RoCoF):', ', '.join(f'{a["buses"]}:{a["rloc_w"]:.4f}' for a in top))

# tek grup: bara bazında
print('\nTek grup, bara bazında (bozulma yeri 5/6/8):')
for r in sorted([a for a in agg if a['N'] == 1], key=lambda a: int(a['buses'])):
    rs = sorted(cfg[(1, r['buses'])], key=lambda x: x['evbus'])
    print(f'  bara {r["buses"]}: ' + ' | '.join(f'e{x["evbus"]} nad {x["nadir"]:.4f} r100 {x["rocof100"]:.4f} loc {x["rocof_loc_max"]:.4f}@{x["bus_loc"]}' for x in rs) + f'  zeta {r["zeta"]:.4f}')

# bozulma yerine en yakın grup etkisi: bozulma barasında grup var mı?
print('\nBozulma barasında grup olması (N=2,3):')
for N in (2, 3):
    has, no = [], []
    for r in rows:
        if r['N'] != N: continue
        (has if str(r['evbus']) in r['buses'].split('-') else no).append(r)
    if has and no:
        print(f'  N={N}: grup var  loc {st.mean(x["rocof_loc_max"] for x in has):.4f} r100 {st.mean(x["rocof100"] for x in has):.4f} nadir {st.mean(x["nadir"] for x in has):.4f} (n={len(has)})')
        print(f'        grup yok  loc {st.mean(x["rocof_loc_max"] for x in no):.4f} r100 {st.mean(x["rocof100"] for x in no):.4f} nadir {st.mean(x["nadir"] for x in no):.4f} (n={len(no)})')

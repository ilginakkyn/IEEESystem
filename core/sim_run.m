function R = sim_run(sc, opt)
%SIM_RUN  Zaman bölgesi benzetimi (sabit adımlı RK4, her aşamada ağ çözümü).
%   R = sim_run(sc, opt)
%   opt.t_end [s] (20), opt.dt [s] (0.002), opt.rec [s] (0.01), opt.tol (1e-7)
%   R: zaman serileri (t, f COI, bara açıları/genlikleri, güçler, SOC) ve R.met ölçütleri
if nargin < 2, opt = struct(); end
if ~isfield(opt,'t_end'), opt.t_end = 20; end
if ~isfield(opt,'dt'), opt.dt = 0.002; end
if ~isfield(opt,'rec'), opt.rec = 0.01; end
if ~isfield(opt,'tol'), opt.tol = 1e-7; end
if ~isfield(opt,'verbose'), opt.verbose = false; end

[M, x, V] = build_model(sc);
sc = M.sc;
% denge kontrolü
dx0 = deriv(0, x, M, V, 1e-11, 60);
R.eq_res = max(abs(dx0));
if R.eq_res > 1e-5
    warning('sim_run:eq', '%s: başlangıç dengesi zayıf, max|dx| = %.2e', sc.name, R.eq_res);
end

dt = opt.dt; nst = round(opt.t_end/dt);
nrs = max(1, round(opt.rec/dt));
nr = floor(nst/nrs) + 1;
ev = sc.events; done = false(1, numel(ev));
T = zeros(nr,1); F = T; W = zeros(nr, M.nm); ANG = zeros(nr,9); VM = zeros(nr,9);
PM = zeros(nr, M.nm); PE = PM; PG = zeros(nr, M.ng); PF = zeros(nr, M.nf);
SOC = zeros(nr, M.ng + M.nf); WR = zeros(nr, M.ng); ILIM = zeros(nr, M.nf);
ir = 0; tol = opt.tol;
tev = Inf; if ~isempty(ev), tev = min([ev.t]); end

for k = 0:nst
    t = k*dt;
    for q = 1:numel(ev)
        if ~done(q) && t >= ev(q).t - 1e-9
            [M, x] = apply_event(ev(q), M, x, V); done(q) = true;
        end
    end
    if mod(k, nrs) == 0
        [k1, V, o] = deriv(t, x, M, V, tol);
        ir = ir + 1;
        T(ir) = t; F(ir) = o.wcoi*M.f0; W(ir,:) = o.w'; ANG(ir,:) = angle(V)';
        VM(ir,:) = abs(V)'; PM(ir,:) = o.Pm'*100; PE(ir,:) = o.Pe'*100;
        if M.ng > 0
            PG(ir,:) = o.Pg'*100; SOC(ir,1:M.ng) = x(M.ig(:,7))'; WR(ir,:) = x(M.ig(:,8))';
        end
        if M.nf > 0
            PF(ir,:) = o.Pf'*100; SOC(ir,M.ng+1:end) = x(M.ifm(:,4))'; ILIM(ir,:) = o.Ilim';
        end
    else
        [k1, V] = deriv(t, x, M, V, tol);
    end
    if k == nst, break; end
    [k2, V] = deriv(t+dt/2, x+dt/2*k1, M, V, tol);
    [k3, V] = deriv(t+dt/2, x+dt/2*k2, M, V, tol);
    [k4, V] = deriv(t+dt,   x+dt*k3,   M, V, tol);
    x = x + dt/6*(k1 + 2*k2 + 2*k3 + k4);
    if any(~isfinite(x)), warning('sim_run:nan','%s: sayısal ıraksama t=%.3f', sc.name, t); break; end
end
R.name = sc.name; R.sc = sc; R.M = M;
R.t = T(1:ir); R.f = F(1:ir); R.w = W(1:ir,:); R.ang = ANG(1:ir,:); R.Vm = VM(1:ir,:);
R.Pm = PM(1:ir,:); R.Pe = PE(1:ir,:); R.Pg = PG(1:ir,:); R.Pf = PF(1:ir,:);
R.soc = SOC(1:ir,:); R.wr = WR(1:ir,:); R.ilim = ILIM(1:ir,:);
R.xend = x; R.tev = tev;
R.met = metrics_calc(R, tev, M.f0);
end

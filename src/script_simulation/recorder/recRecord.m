x1_hist(:, t_idx) = x1;
x2_hist(:, t_idx) = x2;
xd1_hist(:, t_idx) = xd1;
xd2_hist(:, t_idx) = xd2;

u_hist(:, t_idx) = u;
uSat_hist(:, t_idx) = u_sat;
lbd_hist(:, t_idx) = opt.lbd;
th_hist(:, t_idx) = nnWeightNorm(nn.th, opt);

% aux_hist(:, t_idx) = zeta;
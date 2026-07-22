x_hist(:, t_idx) = x;
xd_hist(:, t_idx) = xd;

u_hist(:, t_idx) = u;
uSat_hist(:, t_idx) = u_sat;
th_hist(:, t_idx) = nnWeightNorm(nn.th, opt);

if CONTROL_NUM == 1
    % CoNAC
    lbd_hist(:, t_idx) = opt.lbd;
elseif CONTROL_NUM == 2
    % Aux.
    zeta_hist(:, t_idx) = z;
end

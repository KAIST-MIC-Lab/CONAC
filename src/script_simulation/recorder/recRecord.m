

x_hist(:, t_idx) = x;
r_hist(:, t_idx) = r1;
rd_hist(:, t_idx) = r2;
u_hist(:, t_idx) = u;
uSat_hist(:, t_idx) = u_sat;
if strcmp(nnOpt.alg,"Proposed")
    L_hist(:, t_idx) = nnOpt.Lambda;
end
V_hist(:, t_idx) = nn_V_norm_cal(nn.V, nnOpt);
dot_L_hist(:, t_idx) = dot_L;

aux_hist(:, t_idx) = zeta;
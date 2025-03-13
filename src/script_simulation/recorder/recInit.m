
fprintf("                                 \n");
fprintf(" Controller:\n");
fprintf("     "+string(c_idx)+"\n");
fprintf("\n");
fprintf(" FLAGs\n");
fprintf("     animation      : "+string(ANIMATION_FLAG)+"\n");
fprintf("     animation save : "+string(AINMATION_SAVE_FLAG)+"\n");
fprintf("     figure save    : "+string(FIGURE_SAVE_FLAG)+"\n");
fprintf("     result save    : "+string(RESULT_SAVE_FLAG)+"\n");
fprintf("\n");

%% RECORDER
num_x = length(x); num_u = length(u);
num_t = length(t);

x_hist = zeros(num_x, num_t); x_hist(:, 1) = x;
r_hist = zeros(num_x/2, num_t); r_hist(:, 1) = r1;
rd_hist = zeros(num_x/2, num_t); rd_hist(:, 1) = r2;
u_hist = zeros(num_u, num_t); u_hist(:, 1) = u;
uSat_hist = zeros(num_u, num_t); uSat_hist(:, 1) = u;
L_hist = zeros(length(nnOpt.beta), num_t); L_hist(:,1) = zeros(length(nnOpt.beta),1);
dot_L_hist = zeros(1, num_t); dot_L_hist(:,1) = 0;
V_hist = zeros(nnOpt.l_size-1, num_t); V_hist(:, 1) = nn_V_norm_cal(nn.V, nnOpt);
aux_hist = zeros(num_x/2, num_t);

comp_control_hist = zeros(1, num_t);
comp_train_hist = zeros(1, num_t);

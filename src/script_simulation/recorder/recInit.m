
fprintf("\n");
fprintf(" FLAGs\n");
fprintf("     animation      : "+string(ANIMATION_FLAG)+"\n");
fprintf("     animation save : "+string(AINMATION_SAVE_FLAG)+"\n");
fprintf("     figure save    : "+string(FIGURE_SAVE_FLAG)+"\n");
fprintf("     result save    : "+string(RESULT_SAVE_FLAG)+"\n");
fprintf("\n");

%% RECORDER
num_x = length(x1); 
num_u = length(u);
num_t = length(t);

x1_hist = zeros(num_x, num_t); x1_hist(:, 1) = x1;
x2_hist = zeros(num_x, num_t); x2_hist(:, 1) = x2;
xd1_hist = zeros(num_x, num_t); 
xd2_hist = zeros(num_x, num_t); 

[xd1,xd2] = r_func(0);
xd1_hist(:, 1) = xd1;
xd2_hist(:, 1) = xd2;

u_hist = zeros(num_u, num_t); u_hist(:, 1) = u;
uSat_hist = zeros(num_u, num_t); uSat_hist(:, 1) = u;

%% 
if CONTROL_NUM == 1
    % CoNAC
    lbd_hist = zeros(length(opt.beta), num_t); lbd_hist(:,1) = zeros(length(opt.beta),1);
    th_hist = zeros(opt.l_size-1, num_t); th_hist(:, 1) = nnWeightNorm(nn.th, opt);
elseif CONTROL_NUM == 2
    % Aux.
    th_hist = zeros(opt.l_size-1, num_t); th_hist(:, 1) = nnWeightNorm(nn.th, opt);
    zeta_hist = zeros(num_u, num_t); zeta_hist(:, 1) = z;
end

% aux_hist = zeros(num_x/2, num_t);


fprintf("\n");
fprintf(" Simulation Settings\n");
fprintf("     figure plot    : "+string(FIGURE_PLOT_FLAG)+"\n");
fprintf("     result save    : "+string(RESULT_SAVE_FLAG)+"\n");
switch CONTROL_NUM
    case 1
        fprintf("     control method  : CoNAC\n");
    case 2
        fprintf("     control method  : Auxiliary Control\n");
end
fprintf("\n");

%% RECORDER
num_x = length(x); 
num_u = length(u);
num_t = length(t);

x_hist = zeros(num_x, num_t); x_hist(:, 1) = x;
xd_hist = zeros(num_x, num_t); xd_hist(:, 1) = zeros(num_x,1);

u_hist = zeros(num_u, num_t); u_hist(:, 1) = u;
uSat_hist = zeros(num_u, num_t); uSat_hist(:, 1) = u;

%% ADDITIONAL RECORDER FOR CONTROL METHODS
if CONTROL_NUM == 1
    % CoNAC
    lbd_hist = zeros(length(opt.beta), num_t); lbd_hist(:,1) = zeros(length(opt.beta),1);
    th_hist = zeros(opt.l_size-1, num_t); th_hist(:, 1) = nnWeightNorm(nn.th, opt);
elseif CONTROL_NUM == 2
    % Aux.
    th_hist = zeros(opt.l_size-1, num_t); th_hist(:, 1) = nnWeightNorm(nn.th, opt);
    zeta_hist = zeros(num_u, num_t); zeta_hist(:, 1) = z;
end

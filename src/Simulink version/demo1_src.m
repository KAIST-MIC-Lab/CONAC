clear

%% SIMULATION SETTING
sim_name = "demo1.slx";
T = 5;

addpath("dynamics_model/");

%% SYSTEM DECLARE
[~, IC] = model1_load();
% [r_f, rd_f, rdd_f] = ref1_load(); % sin func

x0 = IC.x;

%% ALGORITHM SELECTION
% ctrl_name = "CTRL1"; % BSC
ctrl_name = "CTRL2"; % Dixon
% ctrl_name = "CTRL3"; % Dixon + Aux.
% ctrl_name = "CTRL4"; % Proposed

%% NN STRUCTURE
nnOpt.init_range = 1e-3; % weight init range
nnOpt.e_tol = 0; % error tolerance
nnOpt.W = diag([1 1 1 1]); % error weight matrix

%% CONTROLLER PARAMETERS
nnOpt.ctrl_param.k1 = 50;
nnOpt.ctrl_param.k2 = 50;

nnOpt.ctrl_param.mu = 1e-1;
zeta = rand(2,1) / norm(rand(2,1)) * sqrt(nnOpt.ctrl_param.mu) * 1.5;

nnOpt.ctrl_param.Kp    = eye(2) * 1e0 * 2;
nnOpt.ctrl_param.Azeta = eye(2) * 1e1 *0;
% nnOpt.ctrl_param.Kp    = diag([1 0.1]) * 1e1 * 1;
% nnOpt.ctrl_param.Azeta = diag([1 0.1]) * 1e0 * 5;
nnOpt.ctrl_param.Bzeta = diag([1 1]) * 1e0 * 1;

assert(nnOpt.ctrl_param.k2 > 1/2)
% assert( all( ...
%     eig(2*nnOpt.ctrl_param.Kzeta -nnOpt.ctrl_param.Kp'*nnOpt.ctrl_param.Kp-eye(size(nnOpt.ctrl_param.Kzeta))) > 0 ...
%     ))

nnOpt.ctrl_param.M = eye(2) * 1;
nnOpt.ctrl_param.C = eye(2) * 1;
nnOpt.ctrl_param.G = zeros(2,1);
nnOpt.ctrl_param.inv_M = inv(nnOpt.ctrl_param.M);

%% ALGORITHM PARAMETERS
if strcmp(ctrl_name, "CTRL1")


elseif strcmp(ctrl_name, "CTRL2")
    ctrl = 2;

    nnOpt.alpha = 5e2; % learning rate
    % nnOpt.rho = nnOpt.alpha * 1e-2; % e-modification
    nnOpt.rho = 0;

    nnOpt.Lambda = 0;
    nnOpt.Beta = 0;

elseif strcmp(ctrl_name, "CTRL3")
    ctrl = 3;

    nnOpt.alpha = 5e2; % learning rate
    % nnOpt.rho = nnOpt.alpha * 1e-2; % e-modification
    nnOpt.rho = 0;
    
elseif strcmp(ctrl_name, "CTRL4")
    ctrl = 4;

    nnOpt.alpha = 5e2; % learning rate
    nnOpt.rho = 0;

    c_num = 8;

    nnOpt.Lambda = zeros(c_num,1);
%         nnOpt.Beta = ones(c_num,1) * 1e+0;
    nnOpt.Beta = [ ...
        1 1 1 ...   % weight ball
        0 0 ...     % maximum input
        0 0 ...     % minimum input
        1 ...       % input ball
        ] * 1e-1;

elseif strcmp(ctrl_name, "ALM")
    error("not ready")
end

%% CONSTRAINTS
% nnOpt.cstr.V_max = [
%     % sqrt(1.5*2.7*24)%30
%     % sqrt(1.5*2.7*72)%30
%     200
%     300
%     1000
% ];
nnOpt.cstr.V_max = [
    % sqrt(1.5*2.7*24)%30
    % sqrt(1.5*2.7*72)%30
    20
    30
    100
];

nnOpt.cstr.U_max = [
    40
    2e2
%     ];
] * 1e0;

nnOpt.cstr.U_min = [
    1e2
    5e1
%     ];
] * -1e2;

nnOpt.cstr.u_ball = 50;

%% NN STRUCTURE
nnOpt.NN_size = [
    % layer info (node numbers)
    2 % input layer [r; rd]
    8
    8
%         8
    2 % output layer
]; 


%% NUMBERS
% layer number
nnOpt.l_size = length(nnOpt.NN_size);
% total tape number
nnOpt.t_size = sum(nnOpt.NN_size(1:end-1));
% total weight number (will be calc-ed)
nnOpt.v_size_list = zeros(nnOpt.l_size-1 ,1);    
for idx = 1:1:nnOpt.l_size-1
    nnOpt.v_size_list(idx) = (nnOpt.NN_size(idx)+1) * nnOpt.NN_size(idx+1);      
end

nnOpt.v_size = sum(nnOpt.v_size_list); 

%% INITIAL WEIGHTS
th = (rand(nnOpt.v_size,1)-1/2)*2*nnOpt.init_range;
eta = zeros(nnOpt.NN_size(end)*2, nnOpt.v_size); % dPhi/dth
L = zeros(8, 1);

%% SIM
fprintf("SIMULATION IS RUNNING\n")
sim_result = sim(sim_name);
fprintf("SIMULATION TERMINATED\n")

%% MAIN PLOTTER
% error("change the plotter to use generally")
demo1_plot(sim_result, nnOpt);

%% CONTROLLER PARAMETERS (OPTIONAL TO USE)
% alp = 5; % decay rate?
% alp = 1; % decay rate?
% 
% ctrl_param.M0 = eye(2);
% ctrl_param.C0 = eye(2) * 2*alp;
% ctrl_param.G0 = eye(2) * alp^2;

% nnOpt.ctrl_param = ctrl_param;
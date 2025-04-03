%% INITIALIZATION
clear  
clc

addpath("models");

fprintf("                                   \n");
fprintf("***********************************\n");
fprintf("*    Optimization based NN Ctrl   *\n");
fprintf("***********************************\n");

FIGURE_PLOT_FLAG    = 1;
ANIMATION_FLAG      = 0;
AINMATION_SAVE_FLAG = 0;
FIGURE_SAVE_FLAG    = 0;
RESULT_SAVE_FLAG    = 0;
CONTROL_NUM = 1;    % 1: CoNAC, 2: Aux.

seed = 18; rng(seed);

%% SIMULATION SETTING
ctrl_dt = 1/250;
dt = 1/1000;
% dt = ctrl_dt * 1/10;
T = 30;
t = 0:dt:T;
rpt_dt = 1;

%% SYSTEM DECLARE
grad_x = model1_load();
% [xd1_f, xd2_f] = ref1_load(); % sin func
r_func = ref4_load(); 

% x1 = [0;0];  
x1 = [deg2rad(-90);0];  
x2 = [0;0];
u = [0;0];

%% CONTROLLER LOAD
%  TODO: design more controllers
if CONTROL_NUM == 1    % CoNAC
    ctrl_path = "CoNAC";
elseif CONTROL_NUM == 2 % Aux.
    ctrl_path = "Aux";
end

addpath("controllers/"+ctrl_path);
addpath(genpath('controllers/'+ctrl_path));

% opt = loadOpts(ctrl_dt);
addpath("controllers");
opt = loadGlobalOpts(ctrl_dt, CONTROL_NUM);

initControl;

%% RECORDER INITIALIZATION
addpath("recorder");
recInit;

%% MAIN SIMULATION
% ********************************************************
fprintf("[INFO] Simulation Start\n");

for t_idx = 2:1:num_t
    [xd1,xd2] = r_func(t(t_idx));
    
    e1 = x1 - xd1;
    e2 = x2 - xd2;

    r = e2 + opt.Lambda * e1;

    if t_idx==2 || rem(t(t_idx)/dt, ctrl_dt/dt) == 0
        preControl
        postControl
    end

    % control input saturation
    u_sat = sat(u, opt, CONTROL_NUM);

    % error check
    assert(~isnan(norm(u)));
    
    % step forward
    grad = grad_x([x1;x2], u_sat, t(t_idx));
    x1 = x1 + grad(1:2) * dt;
    x2 = x2 + grad(3:4) * dt;

    recRecord;

    % simulation report
    if rem(t(t_idx)/dt, rpt_dt/dt) == 0
        fprintf("[INFO] Time Step %.2f/%.2fs (%.2f%%)\r",t(t_idx), T, t(t_idx)/T*100);
    end
    
end
fprintf("[INFO] Simulation End\n");
fprintf("\n");

if FIGURE_PLOT_FLAG
    addpath("utils");
    plot_wrapper;
end

if RESULT_SAVE_FLAG
    fprintf("[INFO] Result Saving...\n");
    whatTimeIsIt = string(datetime('now','Format','d-MMM-y_HH-mm-ss'));

    if CONTROL_NUM == 1
        % [~,~] = mkdir("sim_result/"+whatTimeIsIt);
        save("sim_result/"+whatTimeIsIt+".mat", ...
            "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
            "u_hist", "uSat_hist", "lbd_hist", "th_hist", ...
            "opt", "T" ...
            );
    elseif CONTROL_NUM == 2
        % [~,~] = mkdir("sim_result/"+whatTimeIsIt);
        save("sim_result/"+whatTimeIsIt+".mat", ...
            "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
            "u_hist", "uSat_hist", "lbd_hist", "zeta_hist", "th_hist", ...
            "opt", "T" ...
            );
    end

    fprintf("Saved: \n%s\n", whatTimeIsIt)

    
    % data_name = [
    %     "$t$";
    %     "$q_1$";
    %     "$q_2$";
    %     "$\dot{q}_1$";
    %     "$\dot{q}_2$";
    %     "$q_{1d}$";
    %     "$q_{2d}$";
    %     "$\dot{q}_{1d}$";
    %     "$\dot{q}_{2d}$";
    %     "$\tau_1$";
    %     "$\tau_2$";
    %     "$\text{sat}(\tau_1)$";
    %     "$\text{sat}(\tau_2)$";
    %     "\lambda_{\theta_0}";
    %     "\lambda_{\theta_1}";
    %     "\lambda_{\theta_2}";
    %     "\lambda_{u}";
    %     "\lVert \theta_0 \rVert";
    %     "\lVert \theta_1 \rVert";
    %     "\lVert \theta_2 \rVert";
    % ];
    % data = [
    %     t;
    %     x1_hist;
    %     x2_hist;
    %     xd1_hist;
    %     xd2_hist;
    %     u_hist;
    %     uSat_hist;
    %     lbd_hist;
    %     th_hist;
    % ];
    % output = [data_name, data];

    % writematrix(output, "result.csv");

    % writematrix([t' x1_hist(1,:)'], "result_q1.dat");
end
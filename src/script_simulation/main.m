%% INITIALIZATION
clear  
clc

addpath("models");

fprintf("                                   \n");
fprintf("***********************************\n");
fprintf("* Numerical Validation for CONAC   *\n");
fprintf("***********************************\n");

FIGURE_PLOT_FLAG    = 1;    
RESULT_SAVE_FLAG    = 1;
CONTROL_NUM         = 1;    % 1: CoNAC, 2: Aux, 3: Aux-Comp
OPT_NUM             = 2;    % parameter options

seed = 1000; rng(seed);

%% SIMULATION SETTING
ctrl_dt = 1/250;            % control sampling time
dt = 1/1000;                % simulation time step
rpt_dt = 4;                 % report time step (for printing simulation progress)

% T = 12 * 2;                 % total simulation time
%                             %   (ref. applied twice)
% T = 35+12;                       % with warmup time
T = 42;                       % with warmup time
% T = 20;                       

t = 0:dt:T;

%% SYSTEM DECLARE
grad_x = model1_load();     % system dynamics (grad_x = f(x,u,t))
r_func = ref4_load();       % ref. signal 

x1 = [deg2rad(-90);0];      % initial state (link angle)
x2 = [0;0];                 % initial state (link angular velocity)
u = [0;0];                  % initial control input (torque)   

%% CONTROLLER LOAD
if CONTROL_NUM == 1    % CoNAC
    ctrl_path = "CoNAC";
elseif CONTROL_NUM == 2 % Aux.
    ctrl_path = "CoNAC-AUX";
elseif CONTROL_NUM == 3 % Complex Aux.
    ctrl_path = "CoNAC-AUX-Comp";
end

addpath("controllers/"+ctrl_path);
addpath(genpath('controllers/'+ctrl_path));

% opt = loadOpts(ctrl_dt);
addpath("controllers");
opt = loadGlobalOpts(ctrl_dt, CONTROL_NUM, OPT_NUM);

initControl;

%% RECORDER INITIALIZATION
addpath("recorder");
recInit;

%% MAIN SIMULATION
% ********************************************************
fprintf("Simulation Start\n");

for t_idx = 2:1:num_t
    [xd1,xd2] = r_func(t(t_idx));
    
    e1 = x1 - xd1;
    e2 = x2 - xd2;

    r = e2 + opt.Lambda * e1;       % filtered error

    if t_idx==2 || rem(t(t_idx)/dt, ctrl_dt/dt) == 0
        preControl
        postControl
    end

    % control input saturation
    u_sat = sat(u, opt, CONTROL_NUM);

    % error check
    assert(~isnan(norm(u)));
    
    % step forward
    k1 = grad_x([x1;x2], u_sat, t(t_idx));
    k2 = grad_x([x1;x2] + k1*dt/2, u_sat, t(t_idx) + dt/2);
    k3 = grad_x([x1;x2] + k2*dt/2, u_sat, t(t_idx) + dt/2);
    k4 = grad_x([x1;x2] + k3*dt, u_sat, t(t_idx) + dt);
    grad = (k1 + 2*k2 + 2*k3 + k4)/6;
    x1 = x1 + grad(1:2) * dt;
    x2 = x2 + grad(3:4) * dt;
    % grad = grad_x([x1;x2], u_sat, t(t_idx));
    % x1 = x1 + grad(1:2) * dt;
    % x2 = x2 + grad(3:4) * dt;

    recRecord;

    % simulation report
    if rem(t(t_idx)/dt, rpt_dt/dt) == 0
        fprintf("Time Step %.2f/%.2fs (%.2f%%)\r",t(t_idx), T, t(t_idx)/T*100);
    end
    
end
fprintf("Simulation End\n");
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
        fprintf("Saved: \n%s\n", whatTimeIsIt)
    elseif CONTROL_NUM == 2
        % [~,~] = mkdir("sim_result/"+whatTimeIsIt);
        save("sim_result/"+whatTimeIsIt+".mat", ...
            "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
            "u_hist", "uSat_hist", "zeta_hist", "th_hist", ...
            "opt", "T" ...
            );
        fprintf("Saved: \n%s\n", whatTimeIsIt)
    end

    fprintf("Saved: \n%s\n", whatTimeIsIt)
end
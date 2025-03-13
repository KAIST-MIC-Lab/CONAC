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

%% SIMULATION SETTING
dt = 1e-4;
T = 15;
t = 0:dt:T;
rpt_dt = 1;

%% SYSTEM DECLARE
grad_x = model1_load();
[xd1_f, xd2_f] = ref1_load(); % sin func
% [r_f, rd_f, rdd_f] = ref2_load(); % step func

x1 = [2;-2];  
x2 = [0;0];
u = [0;0];

%% CONTROLLER LOAD
addpath("controllers/CoNAC");
addpath(genpath('controllers/CoNAC'))
opt = loadOpts(dt);
initControl;

%% RECORDER INITIALIZATION
addpath("recorder");
recInit;

%% MAIN SIMULATION
% ********************************************************
fprintf("[INFO] Simulation Start\n");

for t_idx = 2:1:num_t
    xd1 = xd1_f(x1, t(t_idx));
    xd2 = xd2_f(x2, t(t_idx));
    
    e1 = x1 - xd1;
    e2 = x2 - xd2;

    r = e2 + opt.Gamma * e1;

    x_in = [x1;x2;r];

    [nn, u_NN] = nnForward(nn, opt, x_in);
    [nn, opt] = nnBackward(nn, opt, r, u_NN);
    u = u_NN;

    % control input saturation
    if norm(u) > opt.cstr.u_ball
        u_bar = opt.cstr.u_ball;
        u_sat = u / norm(u) * u_bar;
    else
        u_sat = u;
    end 

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
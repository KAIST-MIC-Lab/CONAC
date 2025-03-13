%% INITIALIZATION
clear  
clc

addpath("models");
addpath("controllers");

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
[grad_x, IC] = model1_load();
[r_f, rd_f, rdd_f] = ref1_load(); % sin func
% [r_f, rd_f, rdd_f] = ref2_load(); % step func

%% CONTROLLER LOAD
opt = loadOpts(dt);

%% RECORDER INITIALIZATION
recInit;

%% MAIN SIMULATION
% ********************************************************
fprintf("[INFO] Simulation Start\n");

for t_idx = 2:1:num_t
    r1 = r_f(x, t(t_idx));
    r1d = rd_f(x, t(t_idx));
    r1dd = rdd_f(x, t(t_idx));
  
    % backstep check
    e1 = x(1:2) - r1;
    r2 = r1d - k1*e1;
    e2 = x(3:4) - r2;
    e = [e1;e2];
    r2d = r1dd - k1*(x(3:4) - r1d);
   
    x_in = r1;
    
    tic;
    [nn, u_NN, info] = nn_forward(nn, nnOpt, x_in);
    comp_control_hist(t_idx) = toc;

    tic;
    [nn, nnOpt, dot_L, info] = nn_backward(nn, nnOpt, ctrlOpt, e, u_NN);
    comp_train_hist(t_idx) = toc;
    
    u = -u_NN;

    % control input saturation
    u_bar = ctrlOpt.u_ball;
    u_sat = u / norm(u) * u_bar; 

    % gradient calculation
    grad = grad_x(x, u_sat, t(t_idx));

    % error check
    assert(~isnan(norm(u)));
    assert(~isnan(norm(grad)));

    % step forward
    x = x + grad * dt;

    recRecord;


    % simulation report
    if rem(t(t_idx)/dt, rpt_dt/dt) == 0
        fprintf("[INFO] Time Step %.2f/%.2fs (%.2f%%)\r",t(t_idx), T, t(t_idx)/T*100);
    end
    
end
fprintf("[INFO] Simulation End\n");
fprintf("\n");

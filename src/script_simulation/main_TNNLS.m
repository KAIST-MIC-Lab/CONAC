
%% INITIALIZATION
clear  
clc

addpath("dynamics_model/");
addpath("utils/");
addpath("utils_NN/");

%% SIMULATION SETTING
dt = 1e-4;
% T = 5;
T = 10;
% T = 15;
% T = 200;
t = 0:dt:T;
rpt_dt = 1;

FIGURE_PLOT_FLAG    = 1;
ANIMATION_FLAG      = 0;
AINMATION_SAVE_FLAG = 0;
FIGURE_SAVE_FLAG    = 0;
RESULT_SAVE_FLAG    = 0;

%% CONTROLLER SETTING
for c_idx = [1 2 3 4]


    seed = 1; rng(seed);
    % ctrl_name = opts.Properties.VariableNames{c_idx};
    ctrl_name = "CTRL"+string(c_idx);
    [ctrlOpt, nnOpt] = opt_load(c_idx, opts, dt);
       
    simulate
end

%% TERMINATION
fprintf("\n");
fprintf("[INFO] Program Terminated\n");
beep()

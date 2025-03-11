
% ********************************************************
%    * Optimization based Neuro Adaptive Controller *
%
%   Crafted By - Ryu Myeongseok
%   Version 0.1
%   Date : 2024.08.-  
%
% ********************************************************

%% INITIALIZATION
clear  
clc

addpath("dynamics_model/");
addpath("utils/");
addpath("utils_NN/");
addpath("InpSatFunc/");

%% SIMULATION SETTING
dt = 1e-4;
% T = 5;
T = 10;
% T = 15;
% T = 200;
t = 0:dt:T;
rpt_dt = 1;


FIGURE_PLOT_FLAG    = 0;
ANIMATION_FLAG      = 0;
AINMATION_SAVE_FLAG = 0;
FIGURE_SAVE_FLAG    = 0;
RESULT_SAVE_FLAG    = 1;

%% CONTROLLER SETTING
opts = readtable("ctrlOpts.csv",'delimiter', ',', 'TextType', 'string','ReadVariableNames',1, 'ReadRowNames', 1);

num_ctrl = size(opts, 2);

% CoNAC
c_idx = 5;
% p_list = linspace(1e-3, 1, 10);
p_list = [0.001 0.445 1];

% L2
% c_idx = 6;
% p_list = linspace(1e-3, 1, 10);
% p_list = [0.001 0.445 1];

% e_mod
% c_idx = 7;
% p_list = linspace(1e-3, 1, 10);
% p_list = [0.001 0.445 1];

Pi_list = zeros(3, length(p_list));
Pi_list(1, :) = p_list;  

for p_idx = 1:1:length(p_list)
    seed = 10; rng(seed);
    % ctrl_name = opts.Properties.VariableNames{c_idx};
    ctrl_name = "CTRL"+string(c_idx)+"_"+string(p_idx);
    [ctrlOpt, nnOpt] = opt_load(c_idx, opts, dt);

    if c_idx == 5
        nnOpt.beta = p_list(p_idx) * [1;1;0;0;0;0;0];
    elseif c_idx == 6
        nnOpt.L2 = p_list(p_idx);  
    elseif c_idx == 7
        nnOpt.rho = p_list(p_idx);
    end

    simulate
    e = x_hist(1:2, :) - r_hist;
    e = e.^2;
    e = sqrt(sum(e, 2));

    Pi_list(2:3, p_idx) = e * dt;
    clear("nnOpt", "ctrlOpt");
end

if c_idx == 5 & RESULT_SAVE_FLAG
    save("sim_result/CoNAC_var","Pi_list")
elseif c_idx == 6 & RESULT_SAVE_FLAG
    save("sim_result/CM1_var","Pi_list")
elseif c_idx == 7 & RESULT_SAVE_FLAG
    save("sim_result/CM2_var","Pi_list")
end
%% TERMINATION
fprintf("\n");
fprintf("[INFO] Program Terminated\n");
beep()

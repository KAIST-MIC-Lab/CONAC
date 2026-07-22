%% INITIALIZATION
clear  
clc

addpath("models");
sim_start_time = string(datetime('now','Format','d-MMM-y_HH-mm-ss'));

fprintf("                                   \n");
fprintf("***********************************\n");
fprintf("* Numerical Validation for CONAC   *\n");
fprintf("***********************************\n");

FIGURE_PLOT_FLAG    = 1;    
RESULT_SAVE_FLAG    = 1;

seed = 18; rng(seed);

%% SIMULATION SETTING
ctrl_dt = 1/250;            % control sampling time
dt = 1/1000;                % simulation time step
rpt_dt = 4;                 % report time step (for printing simulation progress)
T = 42;                       % with warmup time
t = 0:dt:T;

%%
% CONAC VARIATION SETTINGS (individual variable settings for ablation study)
%   - alp \in \{ 0.1, 0.5, 1.0 \}
%   - beta_4 \in \{ 1e0, 1e1, 1e2 \}

VAR_OPTS = {
    struct("CTRL_NUM", 1, "alpha", 0.1, ...
            "SAVE_NAME", "CoNAC_alpha_1e-1"), ...
    struct("CTRL_NUM", 1, "alpha", 0.5, ...
            "SAVE_NAME", "CoNAC_alpha_5e-1"), ...
    struct("CTRL_NUM", 1, "alpha", 1.0, ...
            "SAVE_NAME", "CoNAC_alpha_1e0"), ...
    struct("CTRL_NUM", 1, "beta_4", 1e0, ...
            "SAVE_NAME", "CoNAC_beta4_1e0"), ...
    struct("CTRL_NUM", 1, "beta_4", 1e1, ...
            "SAVE_NAME", "CoNAC_beta4_1e1"), ...
    struct("CTRL_NUM", 1, "beta_4", 1e2, ...
            "SAVE_NAME", "CoNAC_beta4_1e2") ...
};


%%
for var_idx = 1:1:length(VAR_OPTS)
    CTRL_VAR = VAR_OPTS{var_idx};
    CONTROL_NUM = CTRL_VAR.CTRL_NUM;

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
    else
        error("Invalid CONTROL_NUM. Must be 1, 2, or 3.");
    end

    addpath("controllers/"+ctrl_path);
    addpath(genpath('controllers/'+ctrl_path));

    % opt = loadOpts(ctrl_dt);
    addpath("controllers");
    opt = loadGlobalOpts(ctrl_dt, CONTROL_NUM, -999);

    %% OVERWRITE OPT WITH VAR_OPTS
    for field_idx = 1:length(fieldnames(CTRL_VAR))
        field_names = fieldnames(CTRL_VAR);
        if field_names{field_idx} == "CTRL_NUM" || field_names{field_idx} == "SAVE_NAME"
            continue
        elseif field_names{field_idx} == "alpha"
            opt.alpha = CTRL_VAR.(field_names{field_idx});
        elseif startsWith(field_names{field_idx}, "beta_")
            beta_idx = str2double(extractAfter(field_names{field_idx}, "beta_"));    
            opt.beta(beta_idx) = CTRL_VAR.(field_names{field_idx});
        end
    end

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
        if isnan(norm(u))
            warning("NaN detected in control input at time %.2f. Simulation stopped.", t(t_idx));
            break;
        end
        
        % step forward
        grad = grad_x([x1;x2], u_sat, t(t_idx));
        x1 = x1 + grad(1:2) * dt;
        x2 = x2 + grad(3:4) * dt;

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

        % save_name = whatTimeIsIt;
        save_name = CTRL_VAR.SAVE_NAME;

        [~,~] = mkdir("sim_result/"+sim_start_time);

        if CONTROL_NUM == 1
            save("sim_result/"+sim_start_time+"/"+save_name+".mat", ...
                "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
                "u_hist", "uSat_hist", "lbd_hist", "th_hist", ...
                "opt", "T" ...
                );
        elseif CONTROL_NUM == 2
            % [~,~] = mkdir("sim_result/"+whatTimeIsIt);
            save("sim_result/"+sim_start_time+"/"+save_name+".mat", ...
                "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
                "u_hist", "uSat_hist", "zeta_hist", "th_hist", ...
                "opt", "T" ...
                );
        end

        fprintf("Saved: \n%s\n", "sim_result/"+sim_start_time+"/"+save_name+".mat")
    end

end
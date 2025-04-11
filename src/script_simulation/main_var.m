%% INITIALIZATION
clear  
clc
whatTimeIsIt = string(datetime('now','Format','d-MMM-y_HH-mm-ss'));

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
ctrl_dt = 1/250;
dt = 1/1000;
% dt = ctrl_dt * 1/10;
T = 12 *2;
t = 0:dt:T;
rpt_dt = 4;
ISE = @(e) sqrt(sum(e.^2)*dt);

%% 
PI1 = [];
PI2 = [];

vars = linspace(0.1,200,5);

for CONTROL_NUM = 1:1:2
    for var_idx = 1:1:length(vars)
        seed = 18; rng(seed);

        ctrl_name = sprintf("%2d_%02d", CONTROL_NUM, var_idx);

        %% SYSTEM DECLARE
        grad_x = model1_load();
        % [xd1_f, xd2_f] = ref1_load(); % sin func
        r_func = ref4_load(); 

        % x1 = [0;0];  
        x1 = [deg2rad(-90);0];  
        x2 = [0;0];
        u = [0;0];

        %% CONTROLLER LOAD
        if CONTROL_NUM == 1    % CoNAC
            ctrl_path = "CoNAC";
        elseif CONTROL_NUM == 2 % Aux.
            ctrl_path = "CoNAC-Aux";
        end

        addpath("controllers/"+ctrl_path);
        addpath(genpath('controllers/'+ctrl_path));

        % opt = loadOpts(ctrl_dt);
        addpath("controllers");
        opt = loadGlobalOpts(ctrl_dt, CONTROL_NUM);
    
        if CONTROL_NUM == 1
            opt.beta(4) = vars(var_idx); % control input ball
            % opt.beta(5) = vars(var_idx); % control input 1 Max
            opt.beta(6) = vars(var_idx)*10; % control input 1 Max
            % opt.beta(7) = vars(var_idx); % control input 1 Max
            opt.beta(8) = vars(var_idx)*10; % control input 1 Min

            % opt.beta(4) = opt.beta(4) + vars(var_idx); % control input ball
            % % opt.beta(5) = opt.beta(5) + vars(var_idx); % control input 1 Max
            % opt.beta(6) = opt.beta(6) + vars(var_idx); % control input 1 Max
            % % opt.beta(7) = opt.beta(7) + vars(var_idx); % control input 1 Max
            % opt.beta(8) = opt.beta(8) + vars(var_idx); % control input 1 Min
        elseif CONTROL_NUM == 2
            opt.A_zeta = - vars(var_idx) * eye(2);
        end

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

        %% L2 NORM 
        e = x1_hist-xd1_hist;
        e_dot = x2_hist-xd2_hist;
        r = e - opt.Lambda*e_dot;

        cu = sqrt(max(0, sum(u_hist.^2) - opt.cstr.u_ball^2));
        cu1 = sqrt(max(0, sign(u_hist(1,:)).*u_hist(1,:) - opt.cstr.uMax1));
        cu2 = sqrt(max(0, sign(u_hist(2,:)).*u_hist(2,:) - opt.cstr.uMax2));

        if CONTROL_NUM == 1
            PI1(var_idx,1) = ISE(r(1,:));
            PI1(var_idx,2) = ISE(r(2,:));
            PI1(var_idx,3) = ISE(cu);
            PI1(var_idx,4) = ISE(cu1);
            PI1(var_idx,5) = ISE(cu2);
        else
            PI2(var_idx,1) = ISE(r(1,:));
            PI2(var_idx,2) = ISE(r(2,:));
            PI2(var_idx,3) = ISE(cu);
            PI2(var_idx,4) = ISE(cu1);
            PI2(var_idx,5) = ISE(cu2);
        end

        %% PLOT AND SAVE
        if FIGURE_PLOT_FLAG
            addpath("utils");
            plot_wrapper;
        end

        if FIGURE_SAVE_FLAG
            [~,~] = mkdir("figures/"+whatTimeIsIt);
            
            fprintf("[INFO] Figure Saving...\n");

            for fig_idx = 1:1:10
                [~,~] = mkdir("figures/"+whatTimeIsIt+"/fig"+fig_idx);
                saveas(figure(fig_idx), "figures/"+whatTimeIsIt+"/fig"+fig_idx+"/"+ctrl_name+"_"+fig_idx+".png")
            end

            % figure(idx);
            % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
            % exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
            % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
            
            fprintf("Saved: \n%s\n", whatTimeIsIt)
        end

        if RESULT_SAVE_FLAG
            [~,~] = mkdir("sim_result/"+whatTimeIsIt);

            fprintf("[INFO] Result Saving...\n");

            if CONTROL_NUM == 1
                save("sim_result/"+whatTimeIsIt+"/"+ctrl_name+".mat", ...
                    "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
                    "u_hist", "uSat_hist", "lbd_hist", "th_hist", ...
                    "opt", "T" ...
                    );
            elseif CONTROL_NUM == 2
                save("sim_result/"+whatTimeIsIt+"/"+ctrl_name+".mat", ...
                    "t", "x1_hist", "x2_hist", "xd1_hist", "xd2_hist", ...
                    "u_hist", "uSat_hist", "lbd_hist", "zeta_hist", "th_hist", ...
                    "opt", "T" ...
                    );
            end

            fprintf("Saved: \n%s\n", whatTimeIsIt)
        end
    end
end

%% BOX-PLOT
figure(11); clf;
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

Pi_list = transpose([PI1(:,1), PI2(:,1), PI1(:,2), PI2(:,2),PI1(:,3), PI2(:,3), PI1(:,4), PI2(:,4), PI1(:,5), PI2(:,5)]);
lgds = {'C1 $q_1$', 'C2 $q_1$', 'C1 $q_2$', 'C2 $q_2$', 'C1 $c_u$', 'C2 $c_u$', 'C1 $c_1$', 'C2 $c_1$', 'C1 $c_2$', 'C2 $c_2$'};
boxplot(Pi_list', 'Labels', lgds, 'Whisker', 1.5); hold on
ylabel("Square Root of ISE", "Interpreter", "latex")
% xlabel("$q_{2}\ (\rm rad)$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
% ylim([-10e-4, 20e-4])
a = gca;
% a.YTick = linspace(-10e-4, 20e-4, 6);
% a.YRuler.Exponent = -4;
set(gca,'TickLabelInterpreter','latex');

figure(12);clf;
tiledlayout(5,1);

nexttile
plot(vars, PI1(:,1), 'o-', 'color', 'blue', 'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,1), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,2), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,2), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,3), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,3), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,4), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,4), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,5), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,5), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on
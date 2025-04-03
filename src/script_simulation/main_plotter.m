clear

%%
SAVE_FLAG = 0;
POSITION_FLAG = 1; % it will plot fiugures in the same position
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

%% 
ctrl1_name = "3-Apr-2025_17-38-31"; % CoNAC
ctrl2_name = "3-Apr-2025_17-38-57"; % Aux.

%%
ctrl1_log = load("sim_result/"+ctrl1_name+".mat");
ctrl2_log = load("sim_result/"+ctrl2_name+".mat");

%% RESULT PLOTTER
T = ctrl1_log.T;
t = ctrl1_log.t;
obs_t = 1:length(t);
opt1 = ctrl1_log.opt;
opt2 = ctrl2_log.opt;

c1_x1 = ctrl1_log.x1_hist;
c1_x2 = ctrl1_log.x2_hist;
c1_xd1 = ctrl1_log.xd1_hist;
c1_xd2 = ctrl1_log.xd2_hist;
c1_u = ctrl1_log.u_hist;
c1_uSat = ctrl1_log.uSat_hist;
c1_lbd = ctrl1_log.lbd_hist;
c1_th = ctrl1_log.th_hist;

c2_x1 = ctrl2_log.x1_hist;
c2_x2 = ctrl2_log.x2_hist;
c2_xd1 = ctrl2_log.xd1_hist;
c2_xd2 = ctrl2_log.xd2_hist;
c2_u = ctrl2_log.u_hist;
c2_uSat = ctrl2_log.uSat_hist;
c2_lbd = ctrl2_log.lbd_hist;
c2_zeta = ctrl2_log.zeta_hist;
c2_th = ctrl2_log.th_hist;

u_max1 = opt1.cstr.uMax1;
u_max2 = opt1.cstr.uMax2;
u_ball = opt1.cstr.u_ball;
th_max = opt1.cstr.th_max;

%%
font_size = 16;
line_width = 2;
lgd_size = 12;
    
fig_height = 210 * 1; 
fig_width = 450 * 1;

% font_size = 20;
% line_width = 2;
% lgd_size = 16;
    
% fig_height = 230 * 1; 
% fig_width = 800 * 1;

% ctrl_start = .75;
% ctrl_start_idx = ctrl_start/ctrl1.id.Time(2);
% plot_range = [ctrl_start_idx:length(ctrl1.id.Time)];

% zoom_x_start = .895+ctrl_start;
% zoom_x_range = 0.05;

% ============================================
%     Fig. 1: Current d-axis (Ref vs Obs)
% ============================================
figure(1); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

% plot(ctrl_start+[0.5 0.5], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
% text(ctrl_start+.02, -4.7, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
% text(ctrl_start+.52, -4.7, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

plot(t(obs_t), c1_xd1(1,obs_t), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(t(obs_t), c2_x1(1,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_x1(1,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% % maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%     Fig. 2: Current q-axis (Ref vs Obs)
% ============================================
figure(2); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), c1_xd1(2,obs_t), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(t(obs_t), c2_x1(2,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_x1(2,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_2$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(iq_ref.Data); minVal = min(iq_ref.Data); 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 3: Voltage Norm
% ============================================
figure(3);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), c2_u(1,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_u(1,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "blact(k)")
plot(t(obs_t), ones(size(obs_t))*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*-1*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_1$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = 420; minVal = 100; 
% maxVal = max(norm_v2); minVal = min(norm_v2); 
% len = maxVal-minVal; ratio = .1;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 4: Voltage Norm
% ============================================
figure(4);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), c2_u(2,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_u(2,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*-1*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_2$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = 420; minVal = 100; 
% maxVal = max(norm_v2); minVal = min(norm_v2); 
% len = maxVal-minVal; ratio = .1;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 5: Weight
% ============================================
figure(6);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), ones(size(obs_t))*th_max(1), "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on
plot(t(obs_t), ones(size(obs_t))*th_max(2), "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on  
plot(t(obs_t), ones(size(obs_t))*th_max(3), "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on

plot(t(obs_t), c1_th(1,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_th(2,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t(obs_t), c1_th(3,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "--"); hold on

plot(t(obs_t), c2_th(1,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c2_th(2,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t(obs_t), c2_th(3,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "--"); hold on

xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\Vert \hat\theta_i\Vert$', 'FontSize', font_size, 'Interpreter', 'latex');

    lgd = legend;
    % lgd.Orientation = 'Vertical';
    % lgd.Orientation = 'Horizontal';
    lgd.NumColumns = 3;
    lgd.Location = 'southwest';
    lgd.Interpreter = 'latex';
    lgd.FontSize = lgd_size; 

grid on; grid minor;
% maxVal = V_max(2); minVal = 0; 
% maxVal = 58; minVal = 0; 
% len = maxVal-minVal; ratio = .1;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 5: Multipliers
% ============================================
figure(5);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

semilogy(t(obs_t), exp(c1_lbd(1,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_1)$: $\lambda_{\theta_0}$"); hold on
semilogy(t(obs_t), exp(c1_lbd(2,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\theta_1}$"); hold on
semilogy(t(obs_t), exp(c1_lbd(3,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_1)$: $\lambda_{\theta_2}$"); hold on
semilogy(t(obs_t), exp(c1_lbd(4,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{u}$"); hold on
semilogy(t(obs_t), exp(c1_lbd(4,:)), "Color", "red", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{u}$"); hold on
semilogy(t(obs_t), exp(c1_lbd(5,:)), "Color", "green", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{u_1}}$"); hold on
% semilogt(y)(obs_t, exp(c1_lbd(6,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{u_2}}$"); hold on
semilogy(t(obs_t), exp(c1_lbd(7,:)), "Color", "green", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{min u_1}}$"); hold on
% semilogy(obs_t, exp(c1_lbd(8,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{min u_2}}$"); hold on

semilogy(t(obs_t), exp(c2_lbd(1,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_2)$: $\lambda_{\theta_0}$"); hold on
semilogy(t(obs_t), exp(c2_lbd(2,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_2)$: $\lambda_{\theta_1}$"); hold on
semilogy(t(obs_t), exp(c2_lbd(3,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_2)$: $\lambda_{\theta_2}$"); hold on

xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\lambda_j$ (Log scale)', 'FontSize', font_size, 'Interpreter', 'latex');
    lgd = legend;
    % lgd.Orientation = 'Vertical';
    lgd.NumColumns = 2;
    lgd.Location = 'southwest';
    lgd.Interpreter = 'latex';
    lgd.FontSize = lgd_size; 
grid on; grid minor;
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

nexttile
    ax = gca;
    ax.XColor = 'none';
    ax.YColor = 'none';
    ax.Color = 'none';


% ============================================
%     Fig. 6: Aux. State
% ============================================
figure(6); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

% plot(ctrl_start+[0.5 0.5], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
% text(ctrl_start+.02, -4.7, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
% text(ctrl_start+.52, -4.7, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

plot(t(obs_t), c2_zeta(1,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c2_zeta(2,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-."); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\zeta$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% % maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';
% %% SAVE FIGURES
% if SAVE_FLAG
%     [~,~] = mkdir("figures/compare");

%     for idx = 1:1:6

%         f_name = "figures/compare/Fig" + string(idx);

%         saveas(figure(idx), f_name + ".png")

%         figure(idx);
%         % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
%         exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
%         % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")

%     end
% end

% %% NUMERICAL ANALYSIS
% ctrl_dt = 1/8e3;
% sim_dt = ctrl_dt / 100;

% ed1 = id1.Data-id_ref.Data;
% ed2 = id2.Data-id_ref.Data;
% eq1 = iq1.Data-iq_ref.Data;
% eq2 = iq2.Data-iq_ref.Data;

% ed1 = ed1(ctrl_start_idx:end);
% ed2 = ed2(ctrl_start_idx:end);
% eq1 = eq1(ctrl_start_idx:end);
% eq2 = eq2(ctrl_start_idx:end);

% ep_idx = floor(length(ed1)/2);

% ed1_ep1 = ed1(1:ep_idx);
% ed1_ep2 = ed1(ep_idx+1:end); 
% ed2_ep1 = ed2(1:ep_idx);
% ed2_ep2 = ed2(ep_idx+1:end);
% eq1_ep1 = eq1(1:ep_idx);
% eq1_ep2 = eq1(ep_idx+1:end);
% eq2_ep1 = eq2(1:ep_idx);
% eq2_ep2 = eq2(ep_idx+1:end);

% ISE = @(e) sqrt(sum(e.^2)*sim_dt);

% fprintf("Norm of error in Episode 1: \n")
% fprintf("Controller 1 ed: %.3f\n", ISE(ed1_ep1))
% fprintf("Controller 1 eq: %.3f\n", ISE(eq1_ep1))
% fprintf("Controller 2 ed: %.3f\n", ISE(ed2_ep1))
% fprintf("Controller 2 eq: %.3f\n", ISE(eq2_ep1))

% fprintf("Norm of error in Episode 2: \n")
% fprintf("Controller 1 ed: %.3f\n", ISE(ed1_ep2))
% fprintf("Controller 1 eq: %.3f\n", ISE(eq1_ep2))
% fprintf("Controller 2 ed: %.3f\n", ISE(ed2_ep2))
% fprintf("Controller 2 eq: %.3f\n", ISE(eq2_ep2))

% fprintf("id: C1/C2\n")
% fprintf("Episode 1: %.3f\n", ISE(ed1_ep1)/ISE(ed2_ep1))
% fprintf("Episode 2: %.3f\n", ISE(ed1_ep2)/ISE(ed2_ep2))
% fprintf("iq: C1/C2\n")
% fprintf("Episode 1: %.3f\n", ISE(eq1_ep1)/ISE(eq2_ep1))
% fprintf("Episode 2: %.3f\n", ISE(eq1_ep2)/ISE(eq2_ep2))

% fprintf("C1: E1/E2\n")
% fprintf("id: %.3f\n", ISE(ed1_ep2)/ISE(ed1_ep1))
% fprintf("iq: %.3f\n", ISE(eq1_ep2)/ISE(eq1_ep1))
% fprintf("C2: E1/E2\n")
% fprintf("id: %.3f\n", ISE(ed2_ep2)/ISE(ed2_ep1))
% fprintf("iq: %.3f\n", ISE(eq2_ep2)/ISE(eq2_ep1))

beep()
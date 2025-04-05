clear

ANITMATE = 0;
AINMATION_SAVE_FLAG = 0;
SAVE_FLAG = 1;
POSITION_FLAG = 1; % it will plot fiugures in the same position

%%
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

% font_size = 16;
% line_width = 2;
% lgd_size = 12;
    
% fig_height = 210 * 1; 
% fig_width = 450 * 1;

font_size = 20;
line_width = 2;
lgd_size = 16;
    
fig_height = 230 * 1; 
fig_width = 800 * 2;
%% 
ctrl1_name = "c1"; % CoNAC
ctrl2_name = "c2"; % Aux.

%%
% ctrl1_log = readmatrix("sim_result/"+ctrl1_name+".csv");
% ctrl2_log = readmatrix("sim_result/"+ctrl2_name+".csv");

ctrl1_log = post_procc("sim_result/"+ctrl1_name+".csv");
ctrl2_log = post_procc("sim_result/"+ctrl2_name+".csv");

%% RESULT PLOTTER
% T = ctrl1_log.T;
t1 = ctrl1_log(:,1);
t1 = t1-t1(1);
t2 = ctrl2_log(:,1);
t2 = t2-t2(1);
T = t1(end);
obs_t1 = 1:length(t1);
obs_t2 = 1:length(t2);
% opt1 = ctrl1_log.opt;
% opt2 = ctrl2_log.opt;

c1_x1 =     transpose(ctrl1_log(:,[3,4]));
c1_x2 =     transpose(ctrl1_log(:,[5,6]));
c1_xd1 =    transpose(ctrl1_log(:,[7,8]));
c1_xd2 =    transpose(ctrl1_log(:,[9,10]));
c1_u =      transpose(ctrl1_log(:,[11,12]));
c1_uSat =   transpose(ctrl1_log(:,[13,14]));
c1_lbd =    transpose(ctrl1_log(:,15:22));
c1_th =     transpose(ctrl1_log(:,23:25));
c1_zeta =   transpose(ctrl1_log(:,26:27));
c1_cmp =   transpose(ctrl1_log(:,28));

c2_x1 =     transpose(ctrl2_log(:,[3,4]));
c2_x2 =     transpose(ctrl2_log(:,[5,6]));
c2_xd1 =    transpose(ctrl2_log(:,[7,8]));
c2_xd2 =    transpose(ctrl2_log(:,[9,10]));
c2_u =      transpose(ctrl2_log(:,[11,12]));
c2_uSat =   transpose(ctrl2_log(:,[13,14]));
c2_lbd =    transpose(ctrl2_log(:,15:22));
c2_th =     transpose(ctrl2_log(:,23:25));
c2_zeta =   transpose(ctrl2_log(:,26:27));
c2_cmp =   transpose(ctrl2_log(:,28));

u_max1 = 10;
u_max2 = 2;
u_ball = 10;
th_max = [11,12,13];

%%

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


plot(t2(obs_t2), c2_x1(1,obs_t2), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t1(obs_t1), c1_x1(1,obs_t1), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t1(obs_t1), c1_xd1(1,obs_t1), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
maxVal = 2; minVal = -2; 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%     Fig. 2: Current q-axis (Ref vs Obs)
% ============================================
figure(2); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];


plot(t2(obs_t2), c2_x1(2,obs_t2), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t1(obs_t1), c1_x1(2,obs_t1), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t1(obs_t1), c1_xd1(2,obs_t1), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_2$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(iq_ref.Data); minVal = min(iq_ref.Data); 
maxVal = 2; minVal = -2; 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 3: Voltage Norm
% ============================================
figure(3);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t2(obs_t2), c2_u(1,obs_t2), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t1(obs_t1), c1_u(1,obs_t1), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "blact(k)")
plot(t1(obs_t1), ones(size(obs_t1))*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t1(obs_t1), ones(size(obs_t1))*-1*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_1$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = u_max1; minVal = -u_max1; 
% maxVal = max(norm_v2); minVal = min(norm_v2); 
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 4: Voltage Norm
% ============================================
figure(4);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t2(obs_t2), c2_u(2,obs_t2), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t1(obs_t1), c1_u(2,obs_t1), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t1(obs_t1), ones(size(obs_t1))*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t1(obs_t1), ones(size(obs_t1))*-1*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_2$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = u_max2; minVal = -u_max2; 
% maxVal = max(norm_v2); minVal = min(norm_v2); 
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 5: Weight
% ============================================
figure(5);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t1(obs_t1), ones(size(obs_t1))*th_max(1), "Color", "black", "LineWidth", line_width, "LineStyle", "-", 'HandleVisibility','off'); hold on
plot(t1(obs_t1), ones(size(obs_t1))*th_max(2), "Color", "black", "LineWidth", line_width, "LineStyle", "-.", 'HandleVisibility','off'); hold on  
plot(t1(obs_t1), ones(size(obs_t1))*th_max(3), "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on

plot(t2(obs_t2), c2_th(1,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat{\theta}_0$"); hold on
plot(t2(obs_t2), c2_th(2,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat{\theta}_1$"); hold on
plot(t2(obs_t2), c2_th(3,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat{\theta}_2$"); hold on

plot(t1(obs_t1), c1_th(1,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat{\theta}_0$"); hold on
plot(t1(obs_t1), c1_th(2,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat{\theta}_1$"); hold on
plot(t1(obs_t1), c1_th(3,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat{\theta}_2$"); hold on


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
maxVal = th_max(2); minVal = 0; 
% maxVal = 58; minVal = 0; 
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 6: Multipliers
% ============================================
figure(6);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

semilogy(t1(obs_t1), (c1_lbd(1,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_1)$: $\lambda_{\theta_0}$"); hold on
semilogy(t1(obs_t1), (c1_lbd(2,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\theta_1}$"); hold on
semilogy(t1(obs_t1), (c1_lbd(3,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_1)$: $\lambda_{\theta_2}$"); hold on
semilogy(t1(obs_t1), (c1_lbd(4,:)), "Color", "red", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_1)$: $\lambda_{u}$"); hold on
semilogy(t1(obs_t1), (c1_lbd(5,:)), "Color", "green", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_1)$: $\lambda_{\bar{u_1}}$"); hold on
% semilogy(obs_t1, (c1_lbd(6,:)), "Color", "green", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{u_2}}$"); hold on
semilogy(t1(obs_t1), (c1_lbd(7,:)), "Color", "green", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{min u_1}}$"); hold on
% % semilogy(obs_t, (c1_lbd(8,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\bar{min u_2}}$"); hold on

semilogy(t2(obs_t2), (c2_lbd(1,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_2)$: $\lambda_{\theta_0}$"); hold on
semilogy(t2(obs_t2), (c2_lbd(2,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_2)$: $\lambda_{\theta_1}$"); hold on
semilogy(t2(obs_t2), (c2_lbd(3,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_2)$: $\lambda_{\theta_2}$"); hold on

xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\lambda_j$ (Log scale)', 'FontSize', font_size, 'Interpreter', 'latex');
    lgd = legend;
    % lgd.Orientation = 'Vertical';
    lgd.NumColumns = 2;
    lgd.Location = 'southwest';
    lgd.Interpreter = 'latex';
    lgd.FontSize = lgd_size; 
grid on; grid minor;
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%        Fig. 7: Animate
% ============================================
if ANITMATE
    animate
end

% ============================================
%     Fig. 8: Aux. State
% ============================================
figure(8); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

% plot(ctrl_start+[0.5 0.5], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
% text(ctrl_start+.02, -4.7, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
% text(ctrl_start+.52, -4.7, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

plot(t2(obs_t2), c2_zeta(1,obs_t2), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t2(obs_t2), c2_zeta(2,obs_t2), "Color", "red", "LineWidth", line_width, "LineStyle", "-."); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\zeta$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';


% ============================================
%     Fig. 9: Control Bird-eye View
% ============================================
figure(9); clf;
% hF = gcf; 
% hF.Position(3:4) = [fig_width, fig_height];

ang = 0:0.01:2*pi;

plot(u_ball*cos(ang), u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([-100, 100], [1, 1] * u_max2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([-100, 100], [-1, -1] * u_max2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([1, 1] * u_max1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([-1, -1] * u_max1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% p1 = plot(c2_u(1,:), c2_u(2,:), "color", 'red', "LineWidth", 2, "LineStyle", "-"); hold on
plot(c2_uSat(1,:), c2_uSat(2,:), "color", 'cyan', "LineWidth", 2, "LineStyle", "-"); hold on
% p1 = plot(c1_u(1,:), c1_u(2,:), "color", 'red', "LineWidth", 2, "LineStyle", "-"); hold on
plot(c1_uSat(1,:), c1_uSat(2,:), "color", 'blue', "LineWidth", 2, "LineStyle", "-"); hold on
xlabel("$\tau_1\ [\rm Nm]$", "Interpreter", "latex")
ylabel("$\tau_2\ [\rm Nm]$", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
xlim([-u_ball*1.25, u_ball*1.25])
ylim([-u_ball*1.25, u_ball*1.25])
pbaspect([1 1 1])
% legend([p1, p2], ["$\tau$", "Saturated $\tau$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northwest")


%% ============================================
%% SAVE FIGURES
if SAVE_FLAG
    [~,~] = mkdir("figures/");

    for idx = 1:1:9

        f_name = "figures//Fig" + string(idx);

        saveas(figure(idx), f_name + ".png")

        figure(idx);
        % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
        exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
        % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")

    end
end

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

%% RESULT PLOTTER
t1 = data.t;
T = data.T;
obs_t1 = 1:length(t1);

obs_t1_1 = find(t1 >= start_time & t1 <= end_time);

c1_x1 =     data.x1_hist;
c1_x2 =     data.x2_hist;
c1_xd1 =    data.xd1_hist;
c1_xd2 =    data.xd2_hist;
c1_u =      data.u_hist;
c1_uSat =   data.uSat_hist;
c1_th =     data.th_hist;
if CONTROL_NUM == 1
    c1_lbd =    data.lbd_hist;
elseif CONTROL_NUM == 2
    c1_zeta =   data.zeta_hist;
end

%%
% ============================================
%     Fig. 1: Current d-axis (Ref vs Obs)
% ============================================
figure(1);
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

plot(t1(obs_t1), c1_x1(1,obs_t1), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name); hold on
plot(t1(obs_t1), c1_xd1(1,obs_t1), "Color", "red", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on

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
figure(2)
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

plot(t1(obs_t1), c1_x1(2,obs_t1), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name); hold on
plot(t1(obs_t1), c1_xd1(2,obs_t1), "Color", "red", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on

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
figure(3)
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t1(obs_t1), c1_u(1,obs_t1), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "blact(k)")
plot(t1(obs_t1), ones(size(obs_t1))*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t1(obs_t1), ones(size(obs_t1))*-1*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on

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
figure(4)
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t1(obs_t1), c1_u(2,obs_t1), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t1(obs_t1), ones(size(obs_t1))*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t1(obs_t1), ones(size(obs_t1))*-1*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_2$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = u_max2; minVal = -u_max2; 
maxVal = 5; minVal = -5; 
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
figure(5)
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t1(obs_t1), ones(size(obs_t1))*th_max(1), "Color", "black", "LineWidth", line_width, "LineStyle", "-", 'HandleVisibility','off'); hold on
plot(t1(obs_t1), ones(size(obs_t1))*th_max(2), "Color", "black", "LineWidth", line_width, "LineStyle", "-.", 'HandleVisibility','off'); hold on  
plot(t1(obs_t1), ones(size(obs_t1))*th_max(3), "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on

plot(t1(obs_t1), c1_th(1,:), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat{\theta}_0$"); hold on
plot(t1(obs_t1), c1_th(2,:), "Color", data_color, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat{\theta}_1$"); hold on
plot(t1(obs_t1), c1_th(3,:), "Color", data_color, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat{\theta}_2$"); hold on


xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\Vert \hat\theta_i\Vert$', 'FontSize', font_size, 'Interpreter', 'latex');

    % lgd = legend;
    % % lgd.Orientation = 'Vertical';
    % % lgd.Orientation = 'Horizontal';
    % lgd.NumColumns = 3;
    % lgd.Location = 'southeast';
    % lgd.Interpreter = 'latex';
    % lgd.FontSize = lgd_size; 

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
figure(6)
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

% semilogy(t1(obs_t1), (c1_lbd(1,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_1)$: $\lambda_{\theta_0}$"); hold on
% semilogy(t1(obs_t1), (c1_lbd(2,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\theta_1}$"); hold on
% semilogy(t1(obs_t1), (c1_lbd(3,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_1)$: $\lambda_{\theta_2}$"); hold on
if CONTROL_NUM == 1
    semilogy(t1(obs_t1), (c1_lbd(4,:)), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name+"$(C_1)$: $\lambda_{u}$"); hold on
    semilogy(t1(obs_t1), (c1_lbd(5,:)), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name+"$(C_1)$: $\lambda_{\bar{u_1}}$"); hold on
    semilogy(t1(obs_t1), (c1_lbd(7,:)), "Color", data_color, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", data_name+"$(C_1)$: $\lambda_{\bar{min u_1}}$"); hold on
end

xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\lambda_j$ (Log scale)', 'FontSize', font_size, 'Interpreter', 'latex');
    % lgd = legend;
    % % lgd.Orientation = 'Vertical';
    % lgd.NumColumns = 3;
    % lgd.Location = 'southeast';
    % lgd.Interpreter = 'latex';
    % lgd.FontSize = lgd_size; 
grid on; grid minor;
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% ============================================
%     Fig. 7: Aux. State
% ============================================
figure(7); 
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

if ctrl_idx > VAR_NUM
% plot(ctrl_start+[0.5 0.5], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
% text(ctrl_start+.02, -4.7, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
% text(ctrl_start+.52, -4.7, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

plot(t1(obs_t1), c1_zeta(1,obs_t1), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name); hold on
% plot(t1(obs_t1), c1_zeta(2,obs_t1), "Color", "red", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\zeta_2$"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\zeta$', 'FontSize', font_size, 'Interpreter', 'latex');
    lgd = legend;
    % lgd.Orientation = 'Vertical';
    lgd.NumColumns = 3;
    lgd.Location = 'southeast';
    lgd.Interpreter = 'latex';
    lgd.FontSize = lgd_size; 
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';
end

% % ============================================
% %     Fig. 8: Control Bird-eye View
% % ============================================
% figure(8); clf;
% hF = gcf; 
% hF.Position(3:4) = [fig_width, fig_height];

% ang = 0:0.01:2*pi;

% plot(u_ball*cos(ang), u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([-100, 100], [1, 1] * u_max2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([-100, 100], [-1, -1] * u_max2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([1, 1] * u_max1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([-1, -1] * u_max1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot(c1_u(1,:), c1_u(2,:), "color", 'blue', "LineWidth", 2, "LineStyle", "-"); hold on
% plot(c1_uSat(1,obs_t1_1), c1_uSat(2,obs_t1_1), "color", 'red', "LineWidth", 2, "LineStyle", "-"); hold on
% xlabel("$\tau_1 / \rm Nm$", "Interpreter", "latex")
% ylabel("$\tau_2 / \rm Nm$", "Interpreter", "latex")
% set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
% grid on 
% xlim([-u_ball*1.25, u_ball*1.25])
% % ylim([-u_ball*1.25, u_ball*1.25])
% ylim([-u_ball*1.25, u_ball*1.25])
% pbaspect([1 1 1])
% % legend([p1, p2], ["$\tau$", "Saturated $\tau$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northwest")

%%
figure(8);
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

norm_u = sqrt(c1_u(1,:).^2 + c1_u(2,:).^2);
plot(t1(obs_t1), norm_u(obs_t1), "Color", data_color, "LineWidth", line_width, "LineStyle", "-", "DisplayName", data_name); hold on
plot(t1(obs_t1), ones(size(obs_t1))*u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\zeta$', 'FontSize', font_size, 'Interpreter', 'latex');
    % lgd = legend;
    % % lgd.Orientation = 'Vertical';
    % lgd.NumColumns = 3;
    % lgd.Location = 'southeast';
    % lgd.Interpreter = 'latex';
    % lgd.FontSize = lgd_size; 
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

beep()
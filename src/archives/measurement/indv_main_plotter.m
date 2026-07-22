clear

%%
SAVE_FLAG = 0;
POSITION_FLAG = 1; % it will plot fiugures in the same position
TEX_CONVERT_FLAG = 0;
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

%%
font_size = 18;
line_width = 1.5;
lgd_size = 16;
    
fig_height = 200;
fig_width = 400;

fig_unit = 'pixels';

%% 
ctrl1_name = "c2.trc";
ctrl_num = 1;

%%
% data1 = post_procc(ctrl1_name, ctrl_num);
data1 = trc2data(ctrl1_name, ctrl_num);

c1 = "blue";
th_max = [8 7 6];
u_ball = 11;
u_max2 = 3.5;
u_max1 = sqrt(u_ball^2 - u_max2^2);

focus_c1 = find(data1.u1.Time >= 0 & data1.u1.Time <= 24);

%%
ep_time = 12+4; T = ep_time * 2;

start_t = 19;
end_t = 21;

%% FIG. 1; STATE 1
figure(1); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(data1.q1.Time, data1.q1.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot(data1.r1.Time, data1.r1.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max(data1.r1.Data); minVal = min(data1.r1.Data); 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% FIG. 2; STATE 2
figure(2); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(data1.q2.Time, data1.q2.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot(data1.r2.Time, data1.r2.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_2$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max(data1.r2.Data); minVal = min(data1.r2.Data); 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';


%% FIG. 3; CONTROL INPUT 1
figure(3);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(data1.u1.Time, data1.u1.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot([-10 T+10], +1*[u_max1 u_max1], "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
plot([-10 T+10], -1*[u_max1 u_max1], "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, -.2, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, -.2, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_1$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = 11; minVal = -1;
% maxVal = max(norm_v2); minVal = min(norm_v2); 
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% FIG. 4; CONTROL INPUT 2
figure(4);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(data1.u2.Time, data1.u2.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot([-10 T+10], +1*[u_max2 u_max2], "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
plot([-10 T+10], -1*[u_max2 u_max2], "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, -.2, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, -.2, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_2$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = 3; minVal = -3;
% maxVal = max(norm_v2); minVal = min(norm_v2); 
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% FIG. 5; CONTROL INPUT NORM
figure(5);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

norm_u1 = sqrt(data1.u1.Data.^2 + data1.u2.Data.^2);

plot(data1.u1.Time, norm_u1, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot([-10 T+10], [u_ball u_ball], "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, .2, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, .2, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\Vert {\tau} \Vert$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = u_ball; minVal = 0; 
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% FIG. 6; CONTROL NORM (BIRDEYE)
figure(6);clf
hf = gcf;
hF.Units = fig_unit;
hf.Position(3:4) = [fig_width, fig_height];

ang = 0:0.01:2*pi;

plot(u_ball*cos(ang), u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([-100, 100], [1, 1] * u_max2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([-100, 100], [-1, -1] * u_max2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([1, 1] * u_max1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot([-1, -1] * u_max1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on

plot(data1.u1.Data(focus_c1), data1.u2.Data(focus_c1), "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

xlabel("$\tau_1$ / Nm", "Interpreter", "latex")
ylabel("$\tau_2$ / Nm", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on; grid minor;

xlim([8 11.5])
ylim([0.1 4.5])

% pbaspect([1 1 1])

%% FIG. 7; WEIGHT NORM
figure(7);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot([-10 T+10], +1*[th_max(1) th_max(1)], "Color", "black", "LineWidth", line_width, "LineStyle", "-", 'HandleVisibility','off'); hold on
plot([-10 T+10], +1*[th_max(2) th_max(2)], "Color", "black", "LineWidth", line_width, "LineStyle", "-.", 'HandleVisibility','off'); hold on
plot([-10 T+10], +1*[th_max(3) th_max(3)], "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on

plot(data1.th0.Time, data1.th0.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(data1.th1.Time, data1.th1.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_0$"); hold on
plot(data1.th2.Time, data1.th2.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_1$"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-.", "HandleVisibility", "off"); hold on
text(.2, 1.5, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman', "HandleVisibility", "off") 
text(ep_time+.2, 1.5, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman', "HandleVisibility", "off")

xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\Vert \hat\theta_i\Vert$', 'FontSize', font_size, 'Interpreter', 'latex');
    lgd = legend;
    % lgd.Orientation = 'Vertical';
    % lgd.Orientation = 'Horizontal';
    lgd.NumColumns = 3;
    lgd.Location = 'northwest';
    lgd.Interpreter = 'latex';
    lgd.FontSize = lgd_size; 
    % lgd.IconColumnWidth = 5;
    % lgd.Position(3:4) = lgd.Position(3:4) * .01;
    % lgd.Position = lgd.Position * .01;
    
grid on; grid minor;
maxVal = max(th_max); minVal = 0; 
len = maxVal-minVal; ratio = .1;
ylim([minVal maxVal+len*ratio]);
xlim([0 T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% FIG. 8; LAGRANGE MULTIPLIERS
figure(8);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

if ctrl_num == 1 || ctrl_num == 2
    semilogy(data1.lbdu.Time, data1.lbdu.Data, "Color", 'r', "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\lambda_{u}$"); hold on
    semilogy(data1.lbdu2Max.Time, data1.lbdu2Max.Data, "Color", 'g', "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{u_2}$ Max"); hold on
    semilogy(data1.lbdu2Min.Time, data1.lbdu2Min.Data, "Color", 'b', "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\lambda_{u_2}$ Min"); hold on
elseif ctrl_num == 3 || ctrl_num == 4
    semilogy(data1.lbdth2.Time, data1.lbdth2.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\lambda_{\theta_2}$"); hold on
end

xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\lambda_j$ (Log scale)', 'FontSize', font_size, 'Interpreter', 'latex');
    lgd = legend;
    % lgd.Orientation = 'Vertical';
    lgd.NumColumns = 2;
    lgd.Location = 'southwest';
    lgd.Interpreter = 'latex';
    lgd.FontSize = lgd_size; 
grid on; grid minor;
% xlim([start_t end_t])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% FIG. 9; AUXILIARY STATE
figure(9); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

if ctrl_num == 4
    plot(data1.z1.Time(focus_c1), data1.z1.Data(focus_c1), "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.z2.Time(focus_c1), data1.z2.Data(focus_c1), "Color", c1, "LineWidth", line_width, "LineStyle", "-."); hold on
end

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\zeta_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(data2.zeta(1,data2.obs)); minVal = 0; 
maxVal = 3.5; minVal = 0; 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';


% =============================================
%    Fig. 10: Computational Time
% =============================================
figure(10); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

plot(data1.cmp.Time, data1.cmp.Data, "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

xlabel("Time / s", "Interpreter", "latex")
ylabel("Cmp. Time / ms", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
xlim([0 T])
% ylim([-u_max2*1.25, u_max2*1.25])
% legend([p1, p2], ["$\tau$", "Saturated $\tau$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northwest")

% =============================================
%    Fig. 11: Test
% =============================================
figure(11); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

plot(data1.ctrlFlag.Time, data1.ctrlFlag.Data, "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

xlabel("Time / s", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
xlim([0 T])


%% SAVE FIGURES
if SAVE_FLAG
    [~,~] = mkdir("figures/compare");

    for idx = 1:1:10

        f_name = "figures/compare/Fig" + string(idx);

        saveas(figure(idx), f_name + ".png")

        figure(idx);
        % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
        exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
        % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
    
        matlab2tikz(char(f_name+".tex"))
    end
end

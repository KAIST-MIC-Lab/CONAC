clear
addpath('~/Desktop/matlab2tikz/src')
%%
SAVE_FLAG = 1;
POSITION_FLAG = 1; % it will plot fiugures in the same position
TEX_CONVERT_FLAG = 0;
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

font_size = 18;
line_width = 1.5;
lgd_size = 16;
    
fig_height = 200;
fig_width = 800;

fig_unit = 'pixels';

%% 
ctrl_info = {
    struct("path", "4-Apr-2026_19-53-47", "color", "blue", "C_num", 1), ... % CoNAC
    struct("path", "4-Apr-2026_19-53-56", "color", "magenta", "C_num", 1), ... % CoNAC (large alpha)
    struct("path", "4-Apr-2026_19-54-04", "color", "green", "C_num", 1) ... % CoNAC (large beta)
    struct("path", "4-Apr-2026_19-54-22", "color", "cyan", "C_num", 2), ... % Aux.
    struct("path", "4-Apr-2026_19-54-12", "color", gray, "C_num", 1), ... % CoNAC (0 beta)
};

ctrl1_name = ctrl_info{1}.path; color1 = ctrl_info{1}.color; ctrl1_type = ctrl_info{1}.C_num;
ctrl2_name = ctrl_info{2}.path; color2 = ctrl_info{2}.color; ctrl2_type = ctrl_info{2}.C_num;
ctrl3_name = ctrl_info{3}.path; color3 = ctrl_info{3}.color; ctrl3_type = ctrl_info{3}.C_num;
ctrl4_name = ctrl_info{4}.path; color4 = ctrl_info{4}.color; ctrl4_type = ctrl_info{4}.C_num;
ctrl5_name = ctrl_info{5}.path; color5 = ctrl_info{5}.color; ctrl5_type = ctrl_info{5}.C_num;

%%
ctrl1_log = load("sim_result/"+ctrl1_name+".mat");
ctrl2_log = load("sim_result/"+ctrl2_name+".mat");
ctrl3_log = load("sim_result/"+ctrl3_name+".mat");
ctrl4_log = load("sim_result/"+ctrl4_name+".mat");
ctrl5_log = load("sim_result/"+ctrl5_name+".mat");

%% RESULT PLOTTER
T = ctrl1_log.T;
t = ctrl1_log.t;
obs_t = 1:length(t);
opt1 = ctrl1_log.opt;
opt2 = ctrl2_log.opt;
opt3 = ctrl3_log.opt;
opt4 = ctrl4_log.opt;
opt5 = ctrl5_log.opt;

c1_x1 = ctrl1_log.x1_hist;
c1_x2 = ctrl1_log.x2_hist;
c1_xd1 = ctrl1_log.xd1_hist;
c1_xd2 = ctrl1_log.xd2_hist;
c1_u = ctrl1_log.u_hist;
c1_uSat = ctrl1_log.uSat_hist;
if ctrl1_type == 1
    c1_lbd = ctrl1_log.lbd_hist;
else
    c1_zeta = ctrl1_log.zeta_hist;
end
c1_th = ctrl1_log.th_hist;

c2_x1 = ctrl2_log.x1_hist;
c2_x2 = ctrl2_log.x2_hist;
c2_xd1 = ctrl2_log.xd1_hist;
c2_xd2 = ctrl2_log.xd2_hist;
c2_u = ctrl2_log.u_hist;
c2_uSat = ctrl2_log.uSat_hist;
if ctrl2_type == 1
    c2_lbd = ctrl2_log.lbd_hist;
else
    c2_zeta = ctrl2_log.zeta_hist;
end
c2_th = ctrl2_log.th_hist;

c3_x1 = ctrl3_log.x1_hist;
c3_x2 = ctrl3_log.x2_hist;
c3_xd1 = ctrl3_log.xd1_hist;
c3_xd2 = ctrl3_log.xd2_hist;
c3_u = ctrl3_log.u_hist;
c3_uSat = ctrl3_log.uSat_hist;
if ctrl3_type == 1
    c3_lbd = ctrl3_log.lbd_hist;
else
    c3_zeta = ctrl3_log.zeta_hist;
end
c3_th = ctrl3_log.th_hist;

c4_x1 = ctrl4_log.x1_hist;
c4_x2 = ctrl4_log.x2_hist;
c4_xd1 = ctrl4_log.xd1_hist;
c4_xd2 = ctrl4_log.xd2_hist;
c4_u = ctrl4_log.u_hist;
c4_uSat = ctrl4_log.uSat_hist;
if ctrl4_type == 1
    c4_lbd = ctrl4_log.lbd_hist;
else
    c4_zeta = ctrl4_log.zeta_hist;
end
c4_th = ctrl4_log.th_hist;

c5_x1 = ctrl5_log.x1_hist;
c5_x2 = ctrl5_log.x2_hist;
c5_xd1 = ctrl5_log.xd1_hist;
c5_xd2 = ctrl5_log.xd2_hist;
c5_u = ctrl5_log.u_hist;
c5_uSat = ctrl5_log.uSat_hist;
if ctrl5_type == 1
    c5_lbd = ctrl5_log.lbd_hist;
else
    c5_zeta = ctrl5_log.zeta_hist;
end
c5_th = ctrl5_log.th_hist;

u_max2 = opt1.cstr.uMax2;
u_ball = opt1.cstr.u_ball;
u_max1 = sqrt(u_ball^2 - u_max2^2);
th_max = opt1.cstr.th_max;

%%
warmup_time = 11;
ep_time = 12;

warmup_start_t = find(t >= warmup_time, 1);
epi_end_t = find(t >= warmup_time + 2*ep_time, 1);

epi_idx = find(t >= warmup_time & t <= warmup_time + 2*ep_time);

start_t = 19 + warmup_time;
end_t = 21 + warmup_time;
ctrl_obs_idx = find(t >= start_t & t <= end_t);

%% FIG. 1
figure(1); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height*5];
tl = tiledlayout(5,1);

nexttile(1) % State vs Reference (Joint 1)
plot(t, c1_xd1(1,:), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(t, c5_x1(1,:), "Color", color5, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c4_x1(1,:), "Color", color4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c3_x1(1,:), "Color", color3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c2_x1(1,:), "Color", color2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c1_x1(1,:), "Color", color1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot([warmup_time+warmup_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([warmup_time+2*warmup_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
text(2*warmup_time + ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max(c1_xd1(1,:)); minVal = min(c1_xd1(1,:)); 
% maxVal = 0; minVal = -1; 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([warmup_time T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

nexttile(2) % State vs Reference (Joint 2)
plot(t, c1_xd1(2,:), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(t, c5_x1(2,:), "Color", color5, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c4_x1(2,:), "Color", color4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c3_x1(2,:), "Color", color3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c2_x1(2,:), "Color", color2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c1_x1(2,:), "Color", color1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot([warmup_time+warmup_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([warmup_time+2*warmup_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(2*warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
text(3*warmup_time + ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$q_2$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max(c1_xd1(2,:)); minVal = min(c1_xd1(2,:));
% maxVal = 0; minVal = -1;
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([warmup_time T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

nexttile(3) % Control Input (Joint 1)
plot(t, c5_u(1,:), "Color", color5, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c5_uSat(1,:), "Color", color5, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c4_u(1,:), "Color", color4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c4_uSat(1,:), "Color", color4, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c3_u(1,:), "Color", color3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c3_uSat(1,:), "Color", color3, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c2_u(1,:), "Color", color2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c2_uSat(1,:), "Color", color2, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c1_u(1,:), "Color", color1, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c1_uSat(1,:), "Color", color1, "LineWidth", line_width, "LineStyle", "-."); hold on

plot([warmup_time+warmup_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([warmup_time+2*warmup_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(2*warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
text(3*warmup_time + ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

plot([0 T], [u_max1 u_max1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([0 T], [-u_max1 -u_max1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_1$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max(c1_u(1,:)); minVal = min(c1_u(1,:));
% maxVal = 0; minVal = -1;
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([warmup_time T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

nexttile(4) % Control Input (Joint 2)
plot(t, c5_u(2,:), "Color", color5, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c5_uSat(2,:), "Color", color5, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c4_u(2,:), "Color", color4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c4_uSat(2,:), "Color", color4, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c3_u(2,:), "Color", color3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c3_uSat(2,:), "Color", color3, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c2_u(2,:), "Color", color2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c2_uSat(2,:), "Color", color2, "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, c1_u(2,:), "Color", color1, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, c1_uSat(2,:), "Color", color1, "LineWidth", line_width, "LineStyle", "-."); hold on

plot([warmup_time+warmup_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([warmup_time+2*warmup_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(2*warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
text(3*warmup_time + ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

plot([0 T], [u_max2 u_max2], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([0 T], [-u_max2 -u_max2], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_2$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max(c1_u(2,:)); minVal = min(c1_u(2,:));
% maxVal = 0; minVal = -1;
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([warmup_time T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

nexttile(5) % Control Input Norm
norm_func = @(x) sqrt(x(1,:).^2 + x(2,:).^2);

plot(t, norm_func(c5_u), "Color", color5, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, norm_func(c4_u), "Color", color4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, norm_func(c3_u), "Color", color3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, norm_func(c2_u), "Color", color2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, norm_func(c1_u), "Color", color1, "LineWidth", line_width, "LineStyle", "-"); hold on

plot([warmup_time+warmup_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot([warmup_time+2*warmup_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(2*warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
text(3*warmup_time + ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

plot([0 T], [u_ball u_ball], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\Vert\tau\Vert$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = max([norm_func(c1_u), norm_func(c2_u), norm_func(c3_u), norm_func(c4_u), norm_func(c5_u)]); minVal = min([norm_func(c1_u), norm_func(c2_u), norm_func(c3_u), norm_func(c4_u), norm_func(c5_u)]);
% maxVal = 0; minVal = -1;
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
xlim([warmup_time T])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

return

%% FIG. 3; CONTROL INPUT 1
figure(3);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), c3_u(1,obs_t), "Color", gray, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c2_u(1,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_u(1,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "blact(k)")
plot(t(obs_t), ones(size(obs_t))*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*-1*u_max1, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

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

plot(t(obs_t), c3_u(2,obs_t), "Color", gray, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c2_u(2,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), c1_u(2,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*-1*u_max2, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\tau_2$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = 3; minVal = -2; 
% maxVal = max(norm_v2); minVal = min(norm_v2); 
len = maxVal-minVal; ratio = .1;
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

norm_u1 = sqrt(c1_u(1,:).^2 + c1_u(2,:).^2);
norm_u2 = sqrt(c2_u(1,:).^2 + c2_u(2,:).^2);
norm_u3 = sqrt(c3_u(1,:).^2 + c3_u(2,:).^2);

plot(t(obs_t), norm_u3(obs_t), "Color", gray, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), norm_u2(obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), norm_u1(obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
% text(0, 415, {"C$_1$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")
plot(t(obs_t), ones(size(obs_t))*u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "--"); hold on
% text(ctrl_start+.02, 320, {"C$_2$'s $\bar u$"}, "FontSize", font_size, "FontName", 'Times New Roman', "Interpreter", "Latex", "Color", "black")

plot([ep_time ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
text(.2, .2, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
text(ep_time+.2, .2, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\Vert {\tau} \Vert$ / Nm', 'FontSize', font_size, 'Interpreter', 'latex');
maxVal = 10; minVal = 0; 
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

plot(c3_u(1,ctrl_obs_idx), c3_u(2,ctrl_obs_idx), "Color", gray, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(c2_u(1,ctrl_obs_idx), c2_u(2,ctrl_obs_idx), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(c1_u(1,ctrl_obs_idx), c1_u(2,ctrl_obs_idx), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

xlabel("$\tau_1$ / Nm", "Interpreter", "latex")
ylabel("$\tau_2$ / Nm", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on; grid minor;

% xlim([-u_ball*1.25, u_ball*1.25])
% ylim([-u_max2*1.25, u_max2*1.25])

xlim([8 11.5])
ylim([0.1 1.5])

% del_x = 800; del_y = 230;
% sqz_ratio = 1e-2;

% xlim(9*[1 1] + [-1 1] * del_x/2 * sqz_ratio)
% ylim(1*[1 1] + [-1 1] * del_y/2 * sqz_ratio)

% pbaspect([1 1 1])
% legend([p1, p2], ["$\tau$", "Saturated $\tau$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northwest")
%% FIG. 7; WEIGHT NORM
figure(7);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), ones(size(obs_t))*th_max(1), "Color", "black", "LineWidth", line_width, "LineStyle", "-", 'HandleVisibility','off'); hold on
plot(t(obs_t), ones(size(obs_t))*th_max(2), "Color", "black", "LineWidth", line_width, "LineStyle", "-.", 'HandleVisibility','off'); hold on  
plot(t(obs_t), ones(size(obs_t))*th_max(3), "Color", "black", "LineWidth", line_width, "LineStyle", "--", 'HandleVisibility','off'); hold on

plot(t(obs_t), c3_th(1,:), "Color", gray, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(t(obs_t), c3_th(2,:), "Color", gray, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_1$"); hold on
plot(t(obs_t), c3_th(3,:), "Color", gray, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_2$"); hold on

plot(t(obs_t), c2_th(1,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(t(obs_t), c2_th(2,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_1$"); hold on
plot(t(obs_t), c2_th(3,:), "Color", "cyan", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_2$"); hold on

plot(t(obs_t), c1_th(1,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(t(obs_t), c1_th(2,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_1$"); hold on
plot(t(obs_t), c1_th(3,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_2$"); hold on

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
% maxVal = V_max(2); minVal = 0; 
maxVal = 13; minVal = 0; 
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

% semilogy(t(obs_t), exp(c1_lbd(1,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_1)$: $\lambda_{\theta_0}$"); hold on
% semilogy(t(obs_t), exp(c1_lbd(2,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\theta_1}$"); hold on
% semilogy(t(obs_t), exp(c1_lbd(3,:)), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_1)$: $\lambda_{\theta_2}$"); hold on

semilogy(t(ctrl_obs_idx), (c1_lbd(4,ctrl_obs_idx)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\lambda_{u}$"); hold on
semilogy(t(ctrl_obs_idx), (c1_lbd(5,ctrl_obs_idx)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{\bar{u}_1}$"); hold on
semilogy(t(ctrl_obs_idx), (c1_lbd(6,ctrl_obs_idx)), "Color", "blue", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\lambda_{\bar{u}_1}$"); hold on
% semilogy(t(ctrl_obs_idx), (c1_lbd(7,ctrl_obs_idx)), "Color", "green", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\underline{u}_1}$"); hold on
% semilogy(t(ctrl_obs_idx), (c1_lbd(8,ctrl_obs_idx)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_1)$: $\lambda_{\underline{u}_2}$"); hold on

% semilogy(t(obs_t), exp(c2_lbd(1,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_2)$: $\lambda_{\theta_0}$"); hold on
% semilogy(t(obs_t), exp(c2_lbd(2,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_2)$: $\lambda_{\theta_1}$"); hold on
% semilogy(t(obs_t), exp(c2_lbd(3,:)), "Color", "cyan", "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_2)$: $\lambda_{\theta_2}$"); hold on

semilogy(t(ctrl_obs_idx), (c3_lbd(4,ctrl_obs_idx)), "Color", gray, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\lambda_{u}$"); hold on
semilogy(t(ctrl_obs_idx), (c3_lbd(5,ctrl_obs_idx)), "Color", gray, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{\bar{u}_1}$"); hold on
semilogy(t(ctrl_obs_idx), (c3_lbd(6,ctrl_obs_idx)), "Color", gray, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\lambda_{\bar{u}_1}$"); hold on
% semilogy(t(ctrl_obs_idx), (c3_lbd(7,ctrl_obs_idx)), "Color", "green", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_2)$: $\lambda_{\underline{u}_1}$"); hold on
% semilogy(t(ctrl_obs_idx), (c3_lbd(8,ctrl_obs_idx)), "Color", "blue", "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_2)$: $\lambda_{\underline{u}_2}$"); hold on

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

%% FIG. 9; AUXILIARY STATE
figure(9); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];
% tl = tiledlayout(2,1);

% plot(ctrl_start+[0.5 0.5], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
% text(ctrl_start+.02, -4.7, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
% text(ctrl_start+.52, -4.7, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')

% nexttile
plot(t(ctrl_obs_idx), c2_zeta(1,ctrl_obs_idx), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$\zeta_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
maxVal = 3.5; minVal = 0; 
len = maxVal-minVal; ratio = .3;
ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

% nexttile
% plot(t(ctrl_obs_idx), c2_zeta(2,ctrl_obs_idx), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on

% grid on; grid minor;
% xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
% ylabel('$\zeta_2$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = 0; minVal = 2; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% % xlim([ctrl_start T+ctrl_start])
%     ax = gca;
%     ax.FontSize = font_size; 
%     ax.FontName = 'Times New Roman';

%% FIG. 10, 11; FILTERED ERROR
figure(10); clf;
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

e1 = c1_x1-c1_xd1; ed1 = c1_x2-c1_xd2;
e2 = c2_x1-c2_xd1; ed2 = c2_x2-c2_xd2;
e3 = c3_x1-c3_xd1; ed3 = c3_x2-c3_xd2;

r1 = ed1+[5 0; 0 15]*e1;
r2 = ed2+[5 0; 0 15]*e2;
r3 = ed3+[5 0; 0 15]*e3;

plot(t(obs_t), r3(1,obs_t), "Color", gray, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), r2(1,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), r1(1,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$r_1$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% % maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

figure(11); clf;
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(t(obs_t), r3(2,obs_t), "Color", gray, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), r2(2,obs_t), "Color", "cyan", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t(obs_t), r1(2,obs_t), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on

grid on; grid minor;
xlabel('Time / s', 'FontSize', font_size, 'Interpreter', 'latex');
ylabel('$r_2$ / rad', 'FontSize', font_size, 'Interpreter', 'latex');
% maxVal = max(id_ref.Data); minVal = min(id_ref.Data); 
% % maxVal = 0; minVal = -1; 
% len = maxVal-minVal; ratio = .3;
% ylim([minVal-len*ratio maxVal+len*ratio]);
% xlim([ctrl_start T+ctrl_start])
    ax = gca;
    ax.FontSize = font_size; 
    ax.FontName = 'Times New Roman';

%% SAVE FIGURES
if SAVE_FLAG
    [~,~] = mkdir("figures/compare");

    for idx = 1:1:11

        f_name = "figures/compare/Fig" + string(idx);

        saveas(figure(idx), f_name + ".png")

        figure(idx);
        % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
        exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
        % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
    
        % matlab2tikz(char(f_name+".tex"))
    end
end


%% NUMERICAL ANALYSIS
ctrl_dt = 1/250;
sim_dt = ctrl_dt / 1000;

ep_idx = floor(length(r1)/2);

r11_ep1 = r1(1,1:ep_idx);
r12_ep1 = r1(2,1:ep_idx);
r11_ep2 = r1(1,ep_idx+1:end);
r12_ep2 = r1(2,ep_idx+1:end);
r21_ep1 = r2(1,1:ep_idx);
r22_ep1 = r2(2,1:ep_idx);
r21_ep2 = r2(1,ep_idx+1:end);
r22_ep2 = r2(2,ep_idx+1:end);
r31_ep1 = r3(1,1:ep_idx);
r32_ep1 = r3(2,1:ep_idx);
r31_ep2 = r3(1,ep_idx+1:end);
r32_ep2 = r3(2,ep_idx+1:end);

ISE = @(e) sqrt(sum(e.^2)*sim_dt);

fprintf("Norm of error in Episode 1: \n")
fprintf("C1 r1 ep1: %.3f\n", ISE(r11_ep1))
fprintf("C1 r2 ep1: %.3f\n", ISE(r12_ep1))
fprintf("C2 r1 ep1: %.3f\n", ISE(r21_ep1))
fprintf("C2 r2 ep1: %.3f\n", ISE(r22_ep1))
fprintf("C3 r1 ep1: %.3f\n", ISE(r31_ep1))
fprintf("C3 r2 ep1: %.3f\n", ISE(r32_ep1))

fprintf("Norm of error in Episode 2: \n")
fprintf("C1 r1 ep2: %.3f\n", ISE(r11_ep2))
fprintf("C1 r2 ep2: %.3f\n", ISE(r12_ep2))
fprintf("C2 r1 ep2: %.3f\n", ISE(r21_ep2))
fprintf("C2 r2 ep2: %.3f\n", ISE(r22_ep2))
fprintf("C3 r1 ep2: %.3f\n", ISE(r31_ep2))
fprintf("C3 r2 ep2: %.3f\n", ISE(r32_ep2))

fprintf("Improvement in Episode 2: \n")
fprintf("C1 r1: %.3f\n", 1-ISE(r11_ep2)/ISE(r11_ep1))
fprintf("C1 r2: %.3f\n", 1-ISE(r12_ep2)/ISE(r12_ep1))
fprintf("C2 r1: %.3f\n", 1-ISE(r21_ep2)/ISE(r21_ep1))
fprintf("C2 r2: %.3f\n", 1-ISE(r22_ep2)/ISE(r22_ep1))
fprintf("C3 r1: %.3f\n", 1-ISE(r31_ep2)/ISE(r31_ep1))
fprintf("C3 r2: %.3f\n", 1-ISE(r32_ep2)/ISE(r32_ep1))

beep()
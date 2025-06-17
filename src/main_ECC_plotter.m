clear
clc

%%
FIGURE_PLOT = 1;
% SAVE_FLAG = 1;
SAVE_FLAG = 1;
POSITION_FLAG = 1; % it will plot fiugures in the same position

font_size = 18;
line_width = 2;
lgd_size = 18;
default_size = [100, 100, 560, 200];

% ERROR DATA LOAD
CoNAC_Pi = load("sim_result/CoNAC_var.mat");
CoNAC_Pi = CoNAC_Pi.Pi_list;    

CM2_Pi = load("sim_result/CM2_var.mat");
CM2_Pi = CM2_Pi.Pi_list;    

CM1_Pi = load("sim_result/CM1_var.mat");
CM1_Pi = CM1_Pi.Pi_list;    

% figure(1);clf %check CoNAC
% tl = tiledlayout(2,1);

% nexttile
% plot(CoNAC_Pi(1,:), CoNAC_Pi(2,:), 'r', 'LineWidth', 2); hold on
% nexttile
% plot(CoNAC_Pi(1,:), CoNAC_Pi(3,:), 'r', 'LineWidth', 2); hold on

% figure(2);clf % check CM1
% tl = tiledlayout(2,1);

% nexttile
% plot(CM1_Pi(1,:), CM1_Pi(2,:), 'r', 'LineWidth', 2); hold on
% nexttile
% plot(CM1_Pi(1,:), CM1_Pi(3,:), 'r', 'LineWidth', 2); hold on

% figure(3);clf % check CM2
% tl = tiledlayout(2,1);

% nexttile
% plot(CM2_Pi(1,:), CM2_Pi(2,:), 'r', 'LineWidth', 2); hold on
% nexttile
% plot(CM2_Pi(1,:), CM2_Pi(3,:), 'r', 'LineWidth', 2); hold on

figure(3); clf % box-whisker plot

CoNAC_Pi = sqrt(sum(CoNAC_Pi(2:3,:).^2, 1));
CM1_Pi = sqrt(sum(CM1_Pi(2:3,:).^2, 1));
CM2_Pi = sqrt(sum(CM2_Pi(2:3,:).^2, 1));

Pi_list = [CM1_Pi; CM2_Pi; CoNAC_Pi];
boxplot(Pi_list', 'Labels', {'NAC-L2', 'NAC-eMod', 'NAC-CO'}, 'Whisker', 1.5); hold on
ylabel("Square Root of ISE", "Interpreter", "latex")
% xlabel("$q_{2}\ (\rm rad)$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-10e-4, 20e-4])
a = gca;
% a.YTick = linspace(-10e-4, 20e-4, 6);
a.YRuler.Exponent = -4;
% a.YScale = 'log';
% xlim([0.5, 3.5])

if POSITION_FLAG
    set(gcf, 'Position',  [100, 100, 560, 250])
end

figure(4); clf % box-whisker plot

boxplot(Pi_list', 'Labels', {'NAC-L2', 'NAC-eMod', 'NAC-CO'}, 'Whisker', 1.5); hold on
ylabel("Square Root of ISE", "Interpreter", "latex")
% xlabel("$q_{2}\ (\rm rad)$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([2e-4, 7e-4])
a = gca;
% yticklabels({'2','3','4','5','6','20'});
a.YRuler.Exponent = -4;

% a.YScale = 'log';
% xlim([0.5, 3.5])

if POSITION_FLAG
    set(gcf, 'Position',  [100, 100, 560, 250])
end

max(Pi_list') * 1e3
min(Pi_list') * 1e3
median(Pi_list') * 1e3
quantile(Pi_list', [0.25 0.75]) * 1e3


% REPRESENTIVE CONTROLLER LOAD
c_list = get(gca,'colororder');

group = [5 6 7];
for c_idx = group
    for p_idx = [1 2 3]
        fprintf("[INFO] Loading CTRL%d\n", c_idx);
        ctrl_results.("ctrl"+string(c_idx)+"_"+string(p_idx)) = load( ...
            "sim_result/CTRL"+string(c_idx)+"_"+string(p_idx)+"/CTRL"+string(c_idx)+"_"+string(p_idx)+"_result.mat" ...
        );
    end
end

figure(5);clf % error plot CoNAC

t = ctrl_results.ctrl5_1.t;
e1 = ctrl_results.ctrl5_1.x_hist(1:2, :) ...
        - ctrl_results.ctrl5_1.r_hist;
e2 = ctrl_results.ctrl5_2.x_hist(1:2, :) ...
        - ctrl_results.ctrl5_2.r_hist;
e3 = ctrl_results.ctrl5_3.x_hist(1:2, :) ...
        - ctrl_results.ctrl5_3.r_hist;

e1 = sqrt(sum(e1.^2, 1));
e2 = sqrt(sum(e2.^2, 1));
e3 = sqrt(sum(e3.^2, 1));

plot(t, zeros(size(t)), "color",  'black', "LineWidth", line_width, "LineStyle", "-", ...
    'HandleVisibility','off'); hold on
plot(t, e1, "color",  c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\beta_j=0.001$"); hold on
plot(t, e2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\beta_j=0.45$"); hold on
plot(t, e3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\beta_j=1$"); hold on
xlabel("Time / s", "Interpreter", "latex")
ylabel("$\Vert {\xi}\Vert$ / rad", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-.005, .03])
% xlim([0.5, 3.5])
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size; 

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(6); clf % error plot CM1

t = ctrl_results.ctrl6_1.t;
e1 = ctrl_results.ctrl6_1.x_hist(1:2, :) ...
    - ctrl_results.ctrl6_1.r_hist;
e2 = ctrl_results.ctrl6_2.x_hist(1:2, :) ...
    - ctrl_results.ctrl6_2.r_hist;
e3 = ctrl_results.ctrl6_3.x_hist(1:2, :) ...
    - ctrl_results.ctrl6_3.r_hist;

e1 = sqrt(sum(e1.^2, 1));
e2 = sqrt(sum(e2.^2, 1));
e3 = sqrt(sum(e3.^2, 1));

plot(t, zeros(size(t)), "color",  'black', "LineWidth", line_width, "LineStyle", "-", ...
    'HandleVisibility','off'); hold on
plot(t, e1, "color",  c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\lambda=0.001$"); hold on
plot(t, e2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\lambda=0.45$"); hold on
plot(t, e3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\lambda=1$"); hold on
xlabel("Time / s", "Interpreter", "latex")
ylabel("$\Vert {\xi}\Vert$ / rad", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-.005, .03])
% xlim([0.5, 3.5])
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size; 

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end


figure(7); clf % error plot CM2

t = ctrl_results.ctrl7_1.t;
e1 = ctrl_results.ctrl7_1.x_hist(1:2, :) ...
    - ctrl_results.ctrl7_1.r_hist;
e2 = ctrl_results.ctrl7_2.x_hist(1:2, :) ...
    - ctrl_results.ctrl7_2.r_hist;
e3 = ctrl_results.ctrl7_3.x_hist(1:2, :) ...
    - ctrl_results.ctrl7_3.r_hist;

e1 = sqrt(sum(e1.^2, 1));
e2 = sqrt(sum(e2.^2, 1));
e3 = sqrt(sum(e3.^2, 1));

plot(t, zeros(size(t)), "color",  'black', "LineWidth", line_width, "LineStyle", "-", ...
    'HandleVisibility','off'); hold on
plot(t, e1, "color",  c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\rho=0.001$"); hold on
plot(t, e2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\rho=0.45$"); hold on
plot(t, e3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\rho=1$"); hold on
xlabel("Time / s", "Interpreter", "latex")
ylabel("$\Vert {\xi}\Vert$ / rad", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-.005, .03])
% xlim([0.5, 3.5])
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size; 

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end


figure(8); clf % weight norm CoNAC

t = ctrl_results.ctrl5_1.t;
th1 = ctrl_results.ctrl5_1.V_hist;
th2 = ctrl_results.ctrl5_2.V_hist;
th3 = ctrl_results.ctrl5_3.V_hist;

% total norm
% th1 = sqrt(sum(th1.^2,1));
% th2 = sqrt(sum(th2.^2,1));
% th3 = sqrt(sum(th3.^2,1));
% last layer's norm
th1 = th1(end,:);
th2 = th2(end,:);
th3 = th3(end,:);

plot(t, th1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\beta_j=0.001$"); hold on
plot(t, th2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\beta_j=0.45$"); hold on
plot(t, th3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\beta_j=1$"); hold on
xlabel("Time / s", "Interpreter", "latex")
ylabel("$\Vert \hat{\theta}\Vert$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([0, 60])
% xlim([0, 10])    
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size; 

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end


figure(9); clf % weight norm CM1

t = ctrl_results.ctrl6_1.t;
th1 = ctrl_results.ctrl6_1.V_hist;
th2 = ctrl_results.ctrl6_2.V_hist;
th3 = ctrl_results.ctrl6_3.V_hist;

% total norm
% th1 = sqrt(sum(th1.^2,1));
% th2 = sqrt(sum(th2.^2,1));
% th3 = sqrt(sum(th3.^2,1));
% last layer's norm
th1 = th1(end,:);
th2 = th2(end,:);
th3 = th3(end,:);

plot(t, th1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\lambda=0.001$"); hold on
plot(t, th2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\lambda=0.45$"); hold on
plot(t, th3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\lambda=1$"); hold on
xlabel("Time / s", "Interpreter", "latex")
ylabel("$\Vert { \hat{\theta}}\Vert$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([0, 60])
% xlim([0.5, 3.5])    
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size; 

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end


figure(10); clf % weight norm CM2

t = ctrl_results.ctrl7_1.t;
th1 = ctrl_results.ctrl7_1.V_hist;
th2 = ctrl_results.ctrl7_2.V_hist;
th3 = ctrl_results.ctrl7_3.V_hist;

% total norm
% th1 = sqrt(sum(th1.^2,1));
% th2 = sqrt(sum(th2.^2,1));
% th3 = sqrt(sum(th3.^2,1));
% last layer's norm
th1 = th1(end,:);
th2 = th2(end,:);
th3 = th3(end,:);


plot(t, th1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\rho=0.001$"); hold on
plot(t, th2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\rho=0.45$"); hold on
plot(t, th3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\rho=1$"); hold on
xlabel("Time / s", "Interpreter", "latex")
ylabel("$\Vert { \hat{\theta}}\Vert$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([0, 60])
% xlim([0.5, 3.5])    
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size; 
    
if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(11); clf % multipliers CoNAC

t = ctrl_results.ctrl5_1.t;
L = ctrl_results.ctrl5_1.L_hist;

semilogy(t, L(1,:), "color", "red", "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\lambda_{ {\theta}_0}$"); hold on
semilogy(t, L(2,:), "color", "blue", "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\lambda_{ {\theta}_1}$"); hold on
grid on
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$\lambda_j\ (\rm Log scale)$", "Interpreter","latex")
% ylim([0, 35])
xlim([0, 10])    
lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(12); clf % weight per layer CoNAC

t = ctrl_results.ctrl5_1.t;
th = ctrl_results.ctrl5_1.V_hist;
cstr = ctrl_results.ctrl5_1.nnOpt.cstr;

l_len = size(th, 1);
% c_list = rand(l_len, 3);

plot(t, th(1, :), 'color', 'red', 'DisplayName',"$\Vert \hat{\theta}_0\Vert$" ...
        , "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, ones(size(t)) * cstr.V_max(1), "color", 'red', 'DisplayName',"$\bar{\theta}_0$", ...
        "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, th(2, :), 'color', 'blue', 'DisplayName',"$\Vert \hat{\theta}_1\Vert$" ...
    , "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, ones(size(t)) * cstr.V_max(2), "color", 'blue', 'DisplayName',"$\bar{\theta}_1$", ...
        "LineWidth", line_width, "LineStyle", "-."); hold on

lgd = legend;
lgd.Orientation = 'Horizontal';
lgd.Location = 'southeast';
lgd.Interpreter = 'latex';
% lgd.NumColumns = 2;
lgd.FontSize = lgd_size;

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("Weights Norm$ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 

ylim([0, max(cstr.V_max) * 1.25])

% ylim([0, max(th, [], 'all') * 1.25])
% ylim([0, max(th, [], 'all')+20])

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(13); clf % control input norm CoNAC

t = ctrl_results.ctrl5_1.t;
u_norm_1 = sqrt(ctrl_results.ctrl5_1.u_hist(1, :).^2 + ctrl_results.ctrl5_1.u_hist(2, :).^2);
u_norm_2 = sqrt(ctrl_results.ctrl5_2.u_hist(1, :).^2 + ctrl_results.ctrl5_2.u_hist(2, :).^2);
u_norm_3 = sqrt(ctrl_results.ctrl5_3.u_hist(1, :).^2 + ctrl_results.ctrl5_3.u_hist(2, :).^2);

plot(t, u_norm_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\beta_j=0.001$"); hold on
plot(t, u_norm_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\beta_j=0.45$"); hold on
plot(t, u_norm_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\beta_j=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$\Vert u \Vert$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([0, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(14); clf % control input norm CM1
t = ctrl_results.ctrl6_1.t;
u_norm_1 = sqrt(ctrl_results.ctrl6_1.u_hist(1, :).^2 + ctrl_results.ctrl6_1.u_hist(2, :).^2);
u_norm_2 = sqrt(ctrl_results.ctrl6_2.u_hist(1, :).^2 + ctrl_results.ctrl6_2.u_hist(2, :).^2);
u_norm_3 = sqrt(ctrl_results.ctrl6_3.u_hist(1, :).^2 + ctrl_results.ctrl6_3.u_hist(2, :).^2);

plot(t, u_norm_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\lambda=0.001$"); hold on
plot(t, u_norm_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\lambda=0.45$"); hold on
plot(t, u_norm_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\lambda=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$\Vert u \Vert$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([0, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(15); clf % control input norm CM2
t = ctrl_results.ctrl7_1.t;
u_norm_1 = sqrt(ctrl_results.ctrl7_1.u_hist(1, :).^2 + ctrl_results.ctrl7_1.u_hist(2, :).^2);
u_norm_2 = sqrt(ctrl_results.ctrl7_2.u_hist(1, :).^2 + ctrl_results.ctrl7_2.u_hist(2, :).^2);
u_norm_3 = sqrt(ctrl_results.ctrl7_3.u_hist(1, :).^2 + ctrl_results.ctrl7_3.u_hist(2, :).^2);

plot(t, u_norm_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\rho=0.001$"); hold on
plot(t, u_norm_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\rho=0.45$"); hold on
plot(t, u_norm_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\rho=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$\Vert u \Vert$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([0, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end    

figure(16); clf % control input 1 CoNAC
t = ctrl_results.ctrl5_1.t;
u1_1 = ctrl_results.ctrl5_1.u_hist(1, :);
u1_2 = ctrl_results.ctrl5_2.u_hist(1, :);
u1_3 = ctrl_results.ctrl5_3.u_hist(1, :);

plot(t, u1_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\beta_j=0.001$"); hold on
plot(t, u1_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\beta_j=0.45$"); hold on
plot(t, u1_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
        "DisplayName", "$\beta_j=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$u_1$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-60, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(17); clf % control input 1 CM1
t = ctrl_results.ctrl6_1.t;
u1_1 = ctrl_results.ctrl6_1.u_hist(1, :);
u1_2 = ctrl_results.ctrl6_2.u_hist(1, :);
u1_3 = ctrl_results.ctrl6_3.u_hist(1, :);

plot(t, u1_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\lambda=0.001$"); hold on
plot(t, u1_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\lambda=0.45$"); hold on
plot(t, u1_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\lambda=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$u_1$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-60, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(18); clf % control input 1 CM2
t = ctrl_results.ctrl7_1.t;
u1_1 = ctrl_results.ctrl7_1.u_hist(1, :);
u1_2 = ctrl_results.ctrl7_2.u_hist(1, :);
u1_3 = ctrl_results.ctrl7_3.u_hist(1, :);

plot(t, u1_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\rho=0.001$"); hold on
plot(t, u1_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\rho=0.45$"); hold on
plot(t, u1_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\rho=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$u_1$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-60, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(19); clf % control input 2 CoNAC
t = ctrl_results.ctrl5_1.t;
u2_1 = ctrl_results.ctrl5_1.u_hist(2, :);
u2_2 = ctrl_results.ctrl5_2.u_hist(2, :);
u2_3 = ctrl_results.ctrl5_3.u_hist(2, :);

plot(t, u2_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\beta_j=0.001$"); hold on
plot(t, u2_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\beta_j=0.45$"); hold on
plot(t, u2_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\beta_j=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$u_2$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-60, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(20); clf % control input 2 CM1
t = ctrl_results.ctrl6_1.t;
u2_1 = ctrl_results.ctrl6_1.u_hist(2, :);
u2_2 = ctrl_results.ctrl6_2.u_hist(2, :);
u2_3 = ctrl_results.ctrl6_3.u_hist(2, :);

plot(t, u2_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\lambda=0.001$"); hold on
plot(t, u2_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\lambda=0.45$"); hold on
plot(t, u2_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\lambda=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$u_2$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-60, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

figure(21); clf % control input 2 CM2
t = ctrl_results.ctrl7_1.t;
u2_1 = ctrl_results.ctrl7_1.u_hist(2, :);
u2_2 = ctrl_results.ctrl7_2.u_hist(2, :);
u2_3 = ctrl_results.ctrl7_3.u_hist(2, :);

plot(t, u2_1, "color", c_list(1,:), "LineWidth", line_width, "LineStyle", "-", ...
    "DisplayName", "$\rho=0.001$"); hold on
plot(t, u2_2, "color", c_list(2,:), "LineWidth", line_width, "LineStyle", "-.", ...
    "DisplayName", "$\rho=0.45$"); hold on
plot(t, u2_3, "color", c_list(3,:), "LineWidth", line_width, "LineStyle", "--", ...
    "DisplayName", "$\rho=1$"); hold on

xlabel("$t\ (\rm s)$", "Interpreter", "latex")
ylabel("$u_2$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([-60, 60])
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'southwest';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;

if POSITION_FLAG
    set(gcf, 'Position',  default_size)
end

%% SAVE FIGURES
if SAVE_FLAG
    for idx = 3:21
        % fig_name = fig_names(idx);
        fig_name = "fig"+string(idx);
        f_name = "figures/main_plot/ECC/" + fig_name;

        saveas(figure(idx), f_name + ".png")
        % exportgraphics(figure(idx), f_name+'.eps')
        exportgraphics(figure(idx), f_name+'.eps', 'ContentType', 'vector')
    end
end

beep()
return


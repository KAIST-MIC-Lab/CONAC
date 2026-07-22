clear

%%
SAVE_FLAG = 0;
POSITION_FLAG = 1; % it will plot fiugures in the same position
TEX_CONVERT_FLAG = 0;
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

%%
if TEX_CONVERT_FLAG
    font_size = 4;
    line_width = .5;
    lgd_size = 2;

    fig_height = 8.89/4;
    fig_width = 8.89;

    fig_unit = 'centimeters';
else
    font_size = 18;
    line_width = 1.5;
    lgd_size = 16;
        
    fig_height = 200;
    fig_width = 800;

    fig_unit = 'pixels';
end

%% 
ctrl1_name = "c1.trc"; % CoNAC
ctrl2_name = "c1_pd.trc"; % Aux.
% ctrl3_name = "2025_04_09_13_30"; % CoNAC 2.
% ctrl4_name = "2025_04_09_13_30"; % CoNAC 2.

%%
% data1 = post_procc(ctrl1_name, 4);
% data2 = post_procc(ctrl2_name, 4);
% data3 = post_procc(ctrl3_name, 4);
% data4 = post_procc(ctrl4_name, 4);

data1 = trc2data(ctrl1_name, 1);
data2 = trc2data(ctrl2_name, 2);
% data3 = trc2data(ctrl3_name, 3);
% data4 = trc2data(ctrl4_name, 4);


c1 = "blue"; c2="cyan"; c3=gray; c4="yellow";
th_max = [11 12 13];
u_ball = 120;
u_max1 = 100;
u_max2 = 300;

%%
ep_time = 12; T = ep_time * 2;

start_t = 19;
end_t = 21;

%% FIG. 1; STATE 1
figure(1); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

% plot(data4.q1.Time, data4.q1.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
% plot(data3.q1.Time, data3.q1.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.q1.Time, data2.q1.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data1.q1.Time, data1.q1.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

% plot(data4.r1.Time, data4.r1.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
% plot(data3.r1.Time, data3.r1.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(data2.r1.Time, data2.r1.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
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

% plot(data4.q2.Time, data4.q2.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
% plot(data3.q2.Time, data3.q2.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.q2.Time, data2.q2.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data1.q2.Time, data1.q2.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

% plot(data4.r2.Time, data4.r2.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
% plot(data3.r2.Time, data3.r2.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(data2.r2.Time, data2.r2.Data, "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
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

% plot(data4.u1.Time, data4.u1.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
% plot(data3.u1.Time, data3.u1.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.u1.Time, data2.u1.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
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

% plot(data4.u2.Time, data4.u2.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
% plot(data3.u2.Time, data3.u2.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.u2.Time, data2.u2.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
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

%% SAVE
if SAVE_FLAG
    [~,~] = mkdir("figures");

    for idx = 1:1:4

        f_name = "figures/Fig" + string(idx);

        saveas(figure(idx), f_name + ".png")

        figure(idx);
        % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
        exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
        % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
    
        % matlab2tikz(char(f_name+".tex"))
    end
end



return

%% FIG. 5; CONTROL INPUT NORM
figure(5);clf
hF = gcf;
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

norm_u1 = sqrt(data1.u1.Data.^2 + data1.u2.Data.^2);
norm_u2 = sqrt(data2.u1.Data.^2 + data2.u2.Data.^2);
norm_u3 = sqrt(data3.u1.Data.^2 + data3.u2.Data.^2);
norm_u4 = sqrt(data4.u1.Data.^2 + data4.u2.Data.^2);

plot(data4.u1.Time, norm_u4, "Color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data3.u1.Time, norm_u3, "Color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.u1.Time, norm_u2, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
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

plot(data4.u1.Data, data4.u2.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data3.u1.Data, data3.u2.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.u1.Data, data2.u2.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data1.u1.Data, data1.u2.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

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

plot(data2.th0.Time, data2.th0.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(data2.th1.Time, data2.th1.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_0$"); hold on
plot(data2.th2.Time, data2.th2.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_1$"); hold on

plot(data3.th0.Time, data3.th0.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(data3.th1.Time, data3.th1.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_0$"); hold on
plot(data3.th2.Time, data3.th2.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_1$"); hold on

plot(data4.th0.Time, data4.th0.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\hat\theta_0$"); hold on
plot(data4.th1.Time, data4.th1.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\hat\theta_0$"); hold on
plot(data4.th2.Time, data4.th2.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\hat\theta_1$"); hold on

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

semilogy(data1.lbdu.Time,     data1.lbdu.Data,     "Color", c1, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\lambda_{u}$"); hold on
semilogy(data1.lbdu2Max.Time, data1.lbdu2Max.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{\bar{u}_2}$"); hold on
semilogy(data1.lbdu2Min.Time, data1.lbdu2Min.Data, "Color", c1, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\lambda_{\bar{u}_2}$"); hold on

semilogy(data3.lbdu.Time,     data3.lbdu.Data,     "Color", c3, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\lambda_{u}$"); hold on
semilogy(data3.lbdu2Max.Time, data3.lbdu2Max.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{\bar{u}_2}$"); hold on
semilogy(data3.lbdu2Min.Time, data3.lbdu2Min.Data, "Color", c3, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\lambda_{\bar{u}_2}$"); hold on

semilogy(data4.lbdu.Time,     data4.lbdu.Data,     "Color", c4, "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$(C_4)$: $\lambda_{\theta_0}$"); hold on
semilogy(data4.lbdu2Max.Time, data4.lbdu2Max.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$(C_4)$: $\lambda_{\theta_1}$"); hold on
semilogy(data4.lbdu2Min.Time, data4.lbdu2Min.Data, "Color", c4, "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$(C_4)$: $\lambda_{\theta_2}$"); hold on

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

%% FIG. 9; AUXILIARY STATE
figure(9); clf;
hF = gcf; 
hF.Units = fig_unit;
hF.Position(3:4) = [fig_width, fig_height];

plot(data2.zeta1.Time, data2.zeta1.Data, "Color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on

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

plot(data4.cmp.Time, data4.cmp.Data, "color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data3.cmp.Time, data3.cmp.Data, "color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data2.cmp.Time, data2.cmp.Data, "color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
plot(data1.cmp.Time, data1.cmp.Data, "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

xlabel("Time / s", "Interpreter", "latex")
ylabel("Cmp. Time / ms", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
xlim([0 T])
% ylim([-u_max2*1.25, u_max2*1.25])
% legend([p1, p2], ["$\tau$", "Saturated $\tau$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northwest")


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
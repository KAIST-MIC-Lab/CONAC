function [] = demo1_plot(sim_result, nnOpt)

%% FIGURE SETTING
fig_names = [
    "fig1 state vs ref"
    "fig2 dot state vs ref"
    "fig3 control input"
    "fig4 weight ball"
    "fig5 input ball"
    "fig6 multipliers"        
    "fig7 zeta"        
    "fig8 zeta ball"        
];

fig_len = length(fig_names);

%% PREPARE
font_size = 12;
line_width = 2;
lgd_size = 8;

%% DATA EXTRACTION
t = sim_result.tout;

x1 = signal2data(sim_result.logsout, "x1"); x1 = x1.Data;
x2 = signal2data(sim_result.logsout, "x2"); x2 = x2.Data;
xd1 = signal2data(sim_result.logsout, "xd1"); xd1 = xd1.Data;
xd2 = signal2data(sim_result.logsout, "xd2"); xd2 = xd2.Data;

r1 = signal2data(sim_result.logsout, "r1"); r1 = r1.Data;
r2 = signal2data(sim_result.logsout, "r2"); r2 = r2.Data;
rd1 = signal2data(sim_result.logsout, "rd1"); rd1 = rd1.Data;
rd2 = signal2data(sim_result.logsout, "rd2"); rd2 = rd2.Data;

u1 = signal2data(sim_result.logsout, "u1"); u1 = u1.Data;     
u2 = signal2data(sim_result.logsout, "u2"); u2 = u2.Data;

th = signal2data(sim_result.weights, "Weights"); th = th.Data;
L = signal2data(sim_result.multipliers, "Multipliers"); L = L.Data;

dot_L = signal2data(sim_result.dot_L, "dot_L"); dot_L = dot_L.Data;

z1 = signal2data(sim_result.logsout, "zeta1"); z1 = z1.Data;
z2 = signal2data(sim_result.logsout, "zeta2"); z2 = z2.Data;

cstr = nnOpt.cstr;

%% FIG.1: STATE vs REFERENCE
figure(1); clf
tl = tiledlayout(2, 1);

nexttile
p1 = plot(t, r1, "Color", "green", "LineWidth", line_width, "LineStyle", "-"); hold on
p2 = plot(t, x1, "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("State 1 $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(r1) * 0.75, max(r1) * 1.25])
% ylim([-0.25, 1.75])
legend([p1, p2], ["$r_1$","$x_1$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")

nexttile
p1 = plot(t, r2, "Color", "green", "LineWidth", line_width, "LineStyle", "-"); hold on
p2 = plot(t, x2, "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("State 2 $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(r2) * 1.25, max(r2) * 0.75])
% ylim([-0.25, 1.75])
legend([p1, p2], ["$r_2$","$x_2$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")

%% FIG.2: DOT STATE vs REFERENCE
figure(2); clf
tl = tiledlayout(2, 1);

nexttile
p1 = plot(t, rd1, "Color", "green", "LineWidth", line_width, "LineStyle", "-"); hold on
p2 = plot(t, xd1, "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("State Dot 1 $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(rd1) * 1.25, max(rd1) * 1.25])
legend([p1, p2], ["$\dot r_1$","$\dot x_1$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")

nexttile
p1 = plot(t, rd2, "Color", "green", "LineWidth", line_width, "LineStyle", "-"); hold on
p2 = plot(t, xd2, "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("State Dot 2 $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(rd2) * 1.25, max(rd2) * 1.25])
legend([p1, p2], ["$\dot r_2$","$\dot x_2$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")

%% FIG.3: CONTROL INPUT 
figure(3); clf
tl = tiledlayout(2, 1);

actset1 = find(u1 > cstr.U_max(1) | u1 < cstr.U_min(1));
actset2 = find(u2 > cstr.U_max(2) | u2 < cstr.U_min(2));

nexttile
p1 = plot(t, u1, "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
% plot(t(actset1), u1(actset1), "Color", "red", "LineWidth", line_width, "LineStyle", "."); hold on
scatter(t(actset1), u1(actset1), "Color", "red", "Marker","."); hold on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("Control 1 $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(u1) * 1.25, max(u1) * 1.25])

nexttile
p1 = plot(t, u2, "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
scatter(t(actset2), u2(actset2), "Color", "red", "Marker","."); hold on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("Control 2 $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(u2) * 1.25, max(u2) * 1.25])

%% FIG.4: WEIGHTS BALL CONTSRAINT
figure(4); clf

l_len = size(th, 1);

for l_idx = 1:1:l_len
    c = rand(1,3);

    plot(t, th(l_idx, :), 'color', c, 'DisplayName',"V"+string(l_idx-1) ...
        , "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(t, ones(size(t)) * cstr.V_max(l_idx), "color", c, "LineWidth", line_width, "LineStyle", "-."); hold on
end

xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("Weights Norm $ $", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
ylim([0, max(cstr.V_max) * 1.25])

%% FIG.5: CONTROL BALL CONSTRAINT
figure(5); clf

ang = 0:0.01:2*pi;

plot(cstr.u_ball*cos(ang), cstr.u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot(u1, u2, "color", 'blue', "LineWidth", 1, "LineStyle", "-"); hold on
xlabel("Control 1 $ $", "Interpreter", "latex")
ylabel("Control 2 $ $", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
xlim([-cstr.u_ball*1.25, cstr.u_ball*1.25])
ylim([-cstr.u_ball*1.25, cstr.u_ball*1.25])

%% FIG.6: MULTIPLIERS & DOT LAGRANGIAN
figure(6); clf
tl = tiledlayout(2, 1);

nexttile
for l_idx = 1:1:size(L, 1)
    c = rand(1,3);

    semilogy(t, L(l_idx, :), 'color', c, 'DisplayName',"\lambda_"+string(l_idx) ...
    , "LineWidth", line_width, "LineStyle", "-"); hold on
end
grid on
legend

nexttile
semilogy(t, dot_L, 'color', 'blue', 'DisplayName', "\dot L" ...
        , "LineWidth", line_width, "LineStyle", "-"); hold on
grid on
legend

%% FIG.7: ZETA
figure(7); clf
tl = tiledlayout(2, 1);

nexttile
plot(t, z1, "color", 'black', "LineWidth", line_width, "LineStyle", "-"); hold on
xlabel("Zeta 1 $ $", "Interpreter", "latex")
ylabel("t $ $", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
% xlim([-cstr.u_ball*1.25, cstr.u_ball*1.25])
% ylim([-cstr.u_ball*1.25, cstr.u_ball*1.25])

nexttile
plot(t, z2, "color", 'black', "LineWidth", line_width, "LineStyle", "-"); hold on
xlabel("Zeta 2 $ $", "Interpreter", "latex")
ylabel("t $ $", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
% xlim([-cstr.u_ball*1.25, cstr.u_ball*1.25])
% ylim([-cstr.u_ball*1.25, cstr.u_ball*1.25])

%% FIG 8: ZETA BALL 
figure(8); clf

mu = nnOpt.ctrl_param.mu;
ang = 0:0.01:2*pi;

plot(mu*cos(ang), mu*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
plot(z1, z2, "color", 'blue', "LineWidth", 1, "LineStyle", "-"); hold on
xlabel("Zeta 1 $ $", "Interpreter", "latex")
ylabel("Zeta 2 $ $", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on 
% xlim([-cstr.u_ball*1.25, cstr.u_ball*1.25])
% ylim([-cstr.u_ball*1.25, cstr.u_ball*1.25])

%% QUANTATIVE COMPARISOM


end

%% BACK UP
% tl = tiledlayout(2, 1);
% 
% nexttile
% p1 = plot(t, r1.Data, "Color", "green", "LineWidth", line_width, "LineStyle", "-"); hold on
% p2 = plot(t, x1.Data, "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
% xlabel("Time $[\rm s]$", "Interpreter", "latex")
% ylabel("State 1 $ $", "Interpreter","latex")
% set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
% grid on
% % ylim([min(th_1) * 1.25, max(th_1) * 1.25])
% % legend([p1, p2], {case_name(2),case_name(4)}, "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")
% legend([p1, p2], ["$r_1$","$x_1$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")
% % lg1  = legend([p1, p2],["$r_1$","$x_1$"] ,'Orientation','Horizontal', 'FontSize', font_size); 
% % lg1.Layout.Tile = 'North';
% 
% nexttile
% p1 = plot(t, r2.Data, "Color", "green", "LineWidth", line_width, "LineStyle", "-"); hold on
% p2 = plot(t, x2.Data, "Color", "blue", "LineWidth", line_width, "LineStyle", "-."); hold on
% xlabel("Time $[\rm s]$", "Interpreter", "latex")
% ylabel("State 2 $ $", "Interpreter","latex")
% set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
% grid on
% % ylim([min(th_1) * 1.25, max(th_1) * 1.25])
% % legend([p1, p2], {case_name(2),case_name(4)}, "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")
% legend([p1, p2], ["$r_2$","$x_2$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northeast")
% % lg1  = legend([p1, p2],["$r_1$","$x_1$"] ,'Orientation','Horizontal', 'FontSize', font_size); 
% % lg1.Layout.Tile = 'North';
% 
% % set(gcf,"position", [0,1080*1.5,560*3,420])

% plot(t_1, ones(size(t_1)) * th_cstr, "Color", "black", "LineWidth", 3, "LineStyle", "-"); hold on
% plot(t_1, ones(size(t_1)) * -th_cstr, "Color", "black", "LineWidth", 3, "LineStyle", "-"); hold on
% p1 = plot(t_1, th_1, "Color", "blue", "LineWidth", 3, "LineStyle", "-"); hold on
% p2 = plot(t_2, th_2, "Color", "green", "LineWidth", 3, "LineStyle", "-."); hold on
% xlabel("Time $[\rm s]$", "Interpreter", "latex")
% ylabel("Pitch Angle $[\rm{rad}]$", "Interpreter","latex")
% set(gca, 'FontSize', 26, 'FontName', 'Times New Roman')
% grid on
% text(0.1, -1.8e-3,"Pitch Constraint","Interpreter","latex", "FontSize", 26, "FontWeight", "bold")

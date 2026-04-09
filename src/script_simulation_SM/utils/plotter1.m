figure(1); clf
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(5, 1);

start_t = .75;

%% FIG.1.1: STATE vs REFERENCE
% ********************************************************
nexttile(1)

plot(t, xd(1,:), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(t, x(1,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
xlabel("$t$ / s", "Interpreter", "latex")
ylabel("$i_{\rm s}^d$ / A", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
% ylim([min(r1) * 0.75, max(r1) * 1.25])
% ylim([-0.5, 2.5])

xlim([start_t, T])

nexttile(2)

plot(t, xd(2,:), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); hold on
plot(t, x(2,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
xlabel("$t$ / s", "Interpreter", "latex")
ylabel("$i_{\rm s}^q$ / A", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
% ylim([min(r2) * 1.25, max(r2) * 0.75])
% ylim([-2.5, .5])

xlim([start_t, T])


%% FIG.1.2: CONTROL INPUT 
% ********************************************************
nexttile(3)

plot(t, ones(size(t)) * cstr.uMax1, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, u(1,:), "Color", "red", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\tau$"); hold on
plot(t, u_sat(1,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-", "DisplayName", "Saturated $\tau$"); hold on
xlabel("$t$ / s", "Interpreter", "latex")
ylabel("$v_{\rm s}^d$ / V", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(u_sat(1,:)) * 1.25, max(u_sat(1,:)) * 1.25])

xlim([start_t, T])

nexttile(4)

plot(t, ones(size(t)) * cstr.uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, u(2,:), "Color", "red", "LineWidth", line_width, "LineStyle", "-"); hold on
plot(t, u_sat(2,:), "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
xlabel("$t$ / s", "Interpreter", "latex")
ylabel("$v_{\rm s}^q$ / V", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
ylim([min(u_sat(2,:)) * 1.25, max(u_sat(2,:)) * 1.25])

xlim([start_t, T])

%% FIG.1.3: CONTROL INPUT NORM
% ********************************************************
nexttile(5)
u_norm = sqrt(u(1,:).^2 + u(2,:).^2);

plot(t, ones(size(t)) * cstr.u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(t, u_norm, "Color", "blue", "LineWidth", line_width, "LineStyle", "-"); hold on
xlabel("$t$ / s", "Interpreter", "latex")
ylabel("$\Vert v_{\rm s} \Vert$ / V", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on

xlim([start_t, T])

% %% FIG.5: CONTROL TOP VIEW
% % ********************************************************
% figure(8); clf
% hF = gcf; 
% % hF.Position(3:4) = [fig_width, fig_height];

% ang = 0:0.01:2*pi;

% plot(cstr.u_ball*cos(ang), cstr.u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([-100, 100], [1, 1] * cstr.uMax2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([-100, 100], [-1, -1] * cstr.uMax2, "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([1, 1] * cstr.uMax1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% plot([-1, -1] * cstr.uMax1, [-100, 100], "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
% p1 = plot(u1, u2, "color", 'red', "LineWidth", 2, "LineStyle", "-"); hold on
% p2 = plot(u1_sat, u2_sat, "color", 'blue', "LineWidth", 2, "LineStyle", "-"); hold on
% xlabel("$\tau_1\ [\rm Nm]$", "Interpreter", "latex")
% ylabel("$\tau_2\ [\rm Nm]$", "Interpreter", "latex")
% set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
% grid on 
% xlim([-cstr.u_ball*1.25, cstr.u_ball*1.25])
% ylim([-cstr.u_ball*1.25, cstr.u_ball*1.25])
% pbaspect([1 1 1])
% legend([p1, p2], ["$\tau$", "Saturated $\tau$"], "Interpreter","latex", "FontSize", lgd_size, "FontWeight", "bold", "Location", "northwest")

%% FIG.6: MULTIPLIERS & DOT LAGRANGIAN
% ********************************************************
figure(2); clf
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(2, 1);


for l_idx = 1:1:size(L, 1)
    c = rand(1,3);

    % plot(t, L(l_idx, :), 'color', c, 'DisplayName',"$\lambda_"+string(l_idx)+"$" ...
    % , "LineWidth", line_width, "LineStyle", "-"); hold on
    semilogy(t, L(l_idx, :), 'color', c, 'DisplayName',"$\lambda_"+string(l_idx)+"$" ...
    , "LineWidth", line_width, "LineStyle", "-"); hold on
end
grid on
xlabel("Time $[\rm s]$", "Interpreter", "latex")
ylabel("$\lambda_i$ (log scale)", "Interpreter", "latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
lgd = legend;
lgd.Orientation = 'horizontal';
lgd.Location = 'northoutside';
lgd.Interpreter = 'latex';
lgd.FontSize = lgd_size;


%% FIG.4: WEIGHTS BALL CONTSRAINT
% ********************************************************
figure(3); clf
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];

l_len = size(th, 1);
% c_list = rand(l_len, 3);
c_list = eye(3);

for l_idx = flip(1:1:l_len)
    c = c_list(l_idx, :);

    plot(t, th(l_idx, :), 'color', c, 'DisplayName',"$\Vert\hat\theta_"+string(l_idx-1)+"\Vert$" ...
        , "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(t, ones(size(t)) * cstr.th_max(l_idx), "color", c, 'DisplayName',"$\bar \theta_"+string(l_idx-1)+"$", ...
         "LineWidth", line_width, "LineStyle", "-."); hold on
end
lgd = legend;
lgd.Orientation = 'Vertical';
lgd.Location = 'northwest';
lgd.Interpreter = 'latex';
lgd.NumColumns = opt.l_size-1;
lgd.FontSize = lgd_size;
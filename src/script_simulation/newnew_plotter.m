% clear

%%
SAVE_FLAG = 0;
POSITION_FLAG = 1; % it will plot fiugures in the same position
gray = "#808080";
more_blue = "#0072BD";
more_red = "#A2142F";

font_size = 18;
line_width = 1.5;
lgd_size = 16;

fig_height = 200;
fig_width = 800;
ax_height = 180;
ax_width = 720;

fig_unit = 'pixels';

norm_func = @(x) sqrt(x(1,:).^2 + x(2,:).^2);

%% 
% dataSet = 

%% RESULT PLOTTER
T = dataSet{1}.T;
t = dataSet{1}.t;
obs_t = 1:length(t);

%%
warmup_time = 11;
ep_time = 12;

warmup_start_t = find(t >= warmup_time, 1);
epi_end_t = find(t >= warmup_time + 2*ep_time, 1);

epi_idx = find(t >= warmup_time & t <= warmup_time + 2*ep_time);

% start_t = 19 + warmup_time;
% end_t = 21 + warmup_time;
start_t = 31; end_t = 41;
ctrl_obs_idx = find(t >= start_t & t <= end_t);

%% FIG. 1-4
figW = 17;   % cm, one-column width 정도
figH = 8;
axSize = [2.0 2 14.3 5.1];

ax_list = {};
maxVals = ones(5,1)*-inf; minVals = ones(5,1)*inf;
for f_idx = 1:1:5
    fig = figure(f_idx); clf;
    ax = axes(fig);
    hold(ax, 'on');
    grid(ax, 'on');
    box(ax, 'on');

    set(fig, 'Units', 'centimeters');
    fig.Position(3:4) = [figW figH];
    % set(ax, 'Units', 'centimeters');
    % set(ax, 'Position', axSize);

    set(ax, 'FontName', 'Times New Roman');
    set(ax, 'FontSize', 14);
    set(ax, 'LineWidth', 1.1);
    set(ax, 'TickLabelInterpreter', 'latex');

    % set(fig, 'PaperUnits', 'centimeters');
    % set(fig, 'PaperSize', [figW figH]);
    % set(fig, 'PaperPosition', [0 0 figW figH]);
    % print(fig, 'fig_error.pdf', '-dpdf', '-painters');

    ax_list{f_idx} = ax;
end

% ============================
% before all data


% ============================
% all data
for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    CTRL_INFO = data.CTRL_INFO;
    opt = data.opt;

    x1_hist = data.x1_hist;
    x2_hist = data.x2_hist;
    r_hist = data.r_hist;
    r_norm_hist = norm_func(r_hist);        
    xd1_hist = data.xd1_hist;
    xd2_hist = data.xd2_hist;
    u_hist = data.u_hist;
    uSat_hist = data.uSat_hist;
    
    plot(ax_list{1}, t, x1_hist(1,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{2}, t, x1_hist(2,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{3}, t, u_hist(1,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{3}, t, uSat_hist(1,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-."); 
    plot(ax_list{4}, t, u_hist(2,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{4}, t, uSat_hist(2,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-.");
    plot(ax_list{5}, t, norm_func(u_hist), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); 
    
    maxVal = [max(x1_hist(1,:)) max(x1_hist(2,:)) max(uSat_hist(1,:)) max(uSat_hist(2,:)), max(norm_func(u_hist))]';
    minVal = [min(x1_hist(1,:)) min(x1_hist(2,:)) min(uSat_hist(1,:)) min(uSat_hist(2,:)), min(norm_func(u_hist))]';
    maxVals = max(maxVals, maxVal);
    minVals = min(minVals, minVal);    
end

% ============================
% after all data
plot(ax_list{1}, t, dataSet{1}.xd1_hist(1,:), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); 
plot(ax_list{2}, t, dataSet{1}.xd1_hist(2,:), "Color", "red", "LineWidth", line_width, "LineStyle", "--");

plot(ax_list{3}, [t(1) t(end)], [1 1]*opt.cstr.uMax1, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{3}, [t(1) t(end)], [-1 -1]*opt.cstr.uMax1, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{4}, [t(1) t(end)], [1 1]*opt.cstr.uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{4}, [t(1) t(end)], [-1 -1]*opt.cstr.uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{5}, [t(1) t(end)], [1 1]*opt.cstr.u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{5}, [t(1) t(end)], [-1 -1]*opt.cstr.u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on

for f_idx = 1:1:5
    plot(ax_list{f_idx}, [warmup_time, warmup_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
    plot(ax_list{f_idx}, [warmup_time+ep_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
    plot(ax_list{f_idx}, [warmup_time+2*ep_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
    text(ax_list{f_idx}, warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
    text(ax_list{f_idx}, warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
    text(ax_list{f_idx}, warmup_time + 2*ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

    len = maxVals(f_idx)-minVals(f_idx); ratio = .3;
    if len~=0
        ax_list{f_idx}.YLim = [minVals(f_idx)-len*ratio maxVals(f_idx)+len*ratio];
    end
end

% label
ax_list{1}.XLabel.String = 'Time / s';
ax_list{1}.YLabel.String = '$q_1$ / rad';
ax_list{2}.XLabel.String = 'Time / s';
ax_list{2}.YLabel.String = '$q_2$ / rad';
ax_list{3}.XLabel.String = 'Time / s';
ax_list{3}.YLabel.String = '$\tau_1$ / Nm';
ax_list{4}.XLabel.String = 'Time / s';
ax_list{4}.YLabel.String = '$\tau_2$ / Nm';
ax_list{5}.XLabel.String = 'Time / s';
ax_list{5}.YLabel.String = '$||\tau||$ / Nm';

%% ============================
% Top view of the control input
% ============================
fig = figure(6); clf;
ax = axes(fig);
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');

set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [8 8];
set(ax, 'FontName', 'Times New Roman');
set(ax, 'FontSize', 14);
set(ax, 'LineWidth', 1.1);
set(ax, 'TickLabelInterpreter', 'latex');

maxminX = [-inf inf]; maxminY = [-inf inf];
for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    CTRL_INFO = data.CTRL_INFO;

    u_hist = data.u_hist(:, ctrl_obs_idx);

    plot(ax, u_hist(1,:), u_hist(2,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-");

    maxminX = [min(u_hist(1,:)) max(u_hist(1,:))];
    maxminY = [min(u_hist(2,:)) max(u_hist(2,:))];
end
plot(ax, data.opt.cstr.u_ball*cos(0:0.01:2*pi), data.opt.cstr.u_ball*sin(0:0.01:2*pi), "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax, [-1000 1000], [1 1]*data.opt.cstr.uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax, [-1000 1000], [-1 -1]*data.opt.cstr.uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
ax.XLabel.String = '$\tau_1$ / Nm';
ax.YLabel.String = '$\tau_2$ / Nm';
maxminX = [-data.opt.cstr.u_ball, data.opt.cstr.u_ball];
maxminY = [-data.opt.cstr.u_ball, data.opt.cstr.u_ball];
ax.XLim = [maxminX(1)-1 maxminX(2)+1];
ax.YLim = [maxminY(1)-1 maxminY(2)+1];

%% ============================
% [CONAC] Multipliers
% ============================
FIG_NUM_START = 11;

for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};

    if data.CTRL_INFO.CTRL_NUM ~= 1
        continue
    end

    FIG_NUM_START = FIG_NUM_START + 1;
    fig = figure(FIG_NUM_START); clf;
    ax = axes(fig);

    set(fig, 'Units', 'centimeters');
    fig.Position(3:4) = [figW figH];

    lbd_num = length(data.opt.lbd);
    th_lbd_num = data.opt.l_size-1;
    
    % log plot
    for lbd_idx = th_lbd_num+1:1:lbd_num
        semilogy(ax, t, data.lbd_hist(lbd_idx,:), "LineWidth", line_width, "LineStyle", "-", "DisplayName", sprintf("Lambda %d", lbd_idx)); hold on
    end

    lgd = legend(ax);

    hold(ax, 'on');
    grid(ax, 'on');
    box(ax, 'on');

    plot(ax, [warmup_time, warmup_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-.", "HandleVisibility", "off"); hold on
    plot(ax, [warmup_time+ep_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-.", "HandleVisibility", "off"); hold on
    plot(ax, [warmup_time+2*ep_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-.", "HandleVisibility", "off"); hold on
    text(ax, warmup_time + .2, -1.8, "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
    text(ax, warmup_time + ep_time + .2, -1.8, "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
    text(ax, warmup_time + 2*ep_time + .2, -1.8, "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

end

%% ============================
%   Weight Norms
% ============================
fig = figure(FIG_NUM_START+1); clf; FIG_NUM_START = FIG_NUM_START + 1;
ax = axes(fig);
set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [figW figH];
hold(ax, 'on');

for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    CTRL_INFO = data.CTRL_INFO;

    th_hist = data.th_hist;
    for th_idx = 1:1:size(th_hist,1)
        plot(ax, t, th_hist(th_idx,:), "Color", CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); hold on
    end
end

%% ============================
% [AUX] Zeta
% ============================
% zeta 1
fig1 = figure(FIG_NUM_START+1); clf; FIG_NUM_START = FIG_NUM_START + 1;
ax1 = axes(fig1);
set(fig1, 'Units', 'centimeters');
fig1.Position(3:4) = [figW figH];
fig2 = figure(FIG_NUM_START+2); clf; FIG_NUM_START = FIG_NUM_START + 1;
ax2 = axes(fig2);
set(fig2, 'Units', 'centimeters');
fig2.Position(3:4) = [figW figH];

for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};

    if data.CTRL_INFO.CTRL_NUM ~= 2 && data.CTRL_INFO.CTRL_NUM ~= 3
        continue
    end

    zeta_hist = data.zeta_hist;

    plot(ax1, t, zeta_hist(1,:), "Color", data.CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(ax2, t, zeta_hist(2,:), "Color", data.CTRL_INFO.Color, "LineWidth", line_width, "LineStyle", "-"); hold on
end

return



%% SAVE FIGURES
if SAVE_FLAG
    [~,~] = mkdir("figures/compare");

    for idx = 1:1:2

        f_name = "figures/compare/Fig" + string(idx);

        saveas(figure(idx), f_name + ".png")

        figure(idx);
        % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
        exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
        % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
    
        % matlab2tikz(char(f_name+".tex"))

        fprintf("Saved Figure %d\n", idx)
    end
end

return

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
% 
% epi_idx = find(t >= 11 & t <= 11 + 2*12);
% 
% xd1 = dataSet{1}.xd1_hist(:, epi_idx);
% xd2 = dataSet{1}.xd2_hist(:, epi_idx);
% xd3 = dataSet{1}.xd3_hist(:, epi_idx);
% 
% max_xd1 = max(xd1, [] ,2);
% min_xd1 = min(xd1, [] ,2);
% max_xd2 = max(xd2, [] ,2);
% min_xd2 = min(xd2, [] ,2);
% fprintf("xd1_1: %.3f ~ %.3f, xd1_2: %.3f ~ %.3f\n", min_xd1(1), max_xd1(1), min_xd1(2), max_xd1(2))
% fprintf("xd2_1: %.3f ~ %.3f, xd2_2: %.3f ~ %.3f\n", min_xd2(1), max_xd2(1), min_xd2(2), max_xd2(2))
% 
% fil_xd = xd2 + diag([5 15])*xd1;
% min_fil_xd = min(fil_xd, [] ,2);
% max_fil_xd = max(fil_xd, [] ,2);
% 
% min_xd3 = min(xd3, [] ,2);
% max_xd3 = max(xd3, [] ,2);
% 
% fprintf("fil_xd1: %.3f ~ %.3f, fil_xd2: %.3f ~ %.3f\n", min_fil_xd(1), max_fil_xd(1), min_fil_xd(2), max_fil_xd(2))
% fprintf("xd3_1: %.3f ~ %.3f, xd3_2: %.3f ~ %.3f\n", min_xd3(1), max_xd3(1), min_xd3(2), max_xd3(2))
% 
% return
clear

%%
% SIM = true;
SIM = false;
SAVE_FLAG = 1;
POSITION_FLAG = 1; % it will plot fiugures in the same position

uMax1 = sqrt(100 - 9);
uMax2 = 3;
u_ball = 10;
th_max = [6,6,6]*10;

warmup_time = 11+3;
ep_time = 12;

global_start_t = warmup_time;
% global_end_t = T;
global_end_t = warmup_time + 2*ep_time;
start_t = 26.2; 
end_t   = 27.5;
% start_t = 32.4; 
% end_t   = 34.9;


%% VARIABLE MAPPING
if SIM
    load("RESULT.mat")
    T = dataSet{1}.T;
    t = dataSet{1}.t;
    obs_t = 1:length(t);

    warmup_start_t = find(t >= warmup_time, 1);
    epi_end_t = find(t >= warmup_time + 2*ep_time, 1);
    epi_idx = find(t >= warmup_time & t <= warmup_time + 2*ep_time);
    ctrl_obs_idx = find(t >= start_t & t <= end_t);
    ctrl_obs_idx2 = find(t >= start_t-0.5 & t <= end_t+0.5); %little longer
else
    dataSet = cell(4,1);

    data_path_1 = "20260723_233623";
    data_path_2 = "20260723_230649";
    data_path_3 = "20260723_212336";
    data_path_4 = "20260723_221156";

    dataSet{1} = loadFromMeas("meas_result/"+data_path_1+"/"+data_path_1+".mat", 4);
    dataSet{2} = loadFromMeas("meas_result/"+data_path_2+"/"+data_path_2+".mat", 3);
    dataSet{3} = loadFromMeas("meas_result/"+data_path_3+"/"+data_path_3+".mat", 2);
    dataSet{4} = loadFromMeas("meas_result/"+data_path_4+"/"+data_path_4+".mat", 1);

    [t_end_max, t_max_idx] = max([length(dataSet{1}.t), length(dataSet{2}.t), length(dataSet{3}.t), length(dataSet{4}.t)]);
    % fill nan values


    t = dataSet{t_max_idx}.t;
    T = dataSet{t_max_idx}.T;
    obs_t = 1:length(t);
    warmup_start_t = find(t >= warmup_time, 1);
    epi_end_t = find(t >= warmup_time + 2*ep_time, 1);
    epi_idx = find(t >= warmup_time & t <= warmup_time + 2*ep_time);
    ctrl_obs_idx = find(t >= start_t & t <= end_t);
    ctrl_obs_idx2 = find(t >= start_t-1.5 & t <= end_t+1.5); %little longer
end


CTRL_NUM = 4;
color_list = [ ...
    "#808080";
    "magenta";
    "cyan";
    "blue";
];
name_list = {
    "NAC";
    "AUX";
    "CONAClow";
    "CONAChigh";
};

%%
font_size = 12;
ax_font_size = 12;
line_width = 1.5;
lgd_size = 16;

fig_height = 200;
fig_width = 1000;
ax_height = fig_height * .9;
ax_width = fig_width * .9;

fig_unit = 'pixels';

norm_func = @(x) sqrt(sum(x.^2, 1));

%% FIG. 1-4
figW = 17;   % cm, one-column width 정도
figH = 5;
axSize = [2.0 2 14.3 5.1];

ax_list = {};
% maxVals = ones(5,1)*-inf; minVals = ones(5,1)*inf;
maxVals = [
    50
    60
    rad2deg(3)
    rad2deg(3)
    10
    3
    11
];
minVals = [
    -60
    -90
    rad2deg(-3)
    rad2deg(-3)
    6
    0.1
    % -10.4
    % -3.5
    0
];
for f_idx = 1:1:7
    fig = figure(f_idx); clf;
    ax = axes(fig);
    hold(ax, 'on');
    grid(ax, 'on');
    grid(ax, 'minor');
    box(ax, 'on');

    set(fig, 'Units', 'centimeters');
    fig.Position(3:4) = [figW figH];
    % set(ax, 'Units', 'centimeters');
    % set(ax, 'Position', axSize);

    set(ax, 'FontName', 'Times New Roman');
    set(ax, 'FontSize', ax_font_size);
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

    x1_hist = rad2deg(data.x1_hist);
    x2_hist = rad2deg(data.x2_hist);
    xd1_hist = rad2deg(data.xd1_hist);
    xd2_hist = rad2deg(data.xd2_hist);
    u_hist = data.u_hist;
    uSat_hist = data.uSat_hist;
    color = color_list(ctrl_idx);

    % fill nan values for same length
    if length(t) > length(x1_hist)
        x1_hist = [x1_hist, nan(2, length(t)-length(x1_hist))];
        x2_hist = [x2_hist, nan(2, length(t)-length(x2_hist))];
        u_hist = [u_hist, nan(2, length(t)-length(u_hist))];
        uSat_hist = [uSat_hist, nan(2, length(t)-length(uSat_hist))];
    end
    
    plot(ax_list{1}, t, x1_hist(1,:),       "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{2}, t, x1_hist(2,:),       "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{3}, t, x2_hist(1,:),       "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{4}, t, x2_hist(2,:),       "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{5}, t, u_hist(1,:),        "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{5}, t, uSat_hist(1,:),     "Color", color, "LineWidth", line_width, "LineStyle", "-."); 
    plot(ax_list{6}, t, u_hist(2,:),        "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    plot(ax_list{6}, t, uSat_hist(2,:),     "Color", color, "LineWidth", line_width, "LineStyle", "-.");
    plot(ax_list{7}, t, norm_func(u_hist),  "Color", color, "LineWidth", line_width, "LineStyle", "-"); 
    
    % maxVal = [max(x1_hist(1,:)) max(x1_hist(2,:)) max(uSat_hist(1,:)) max(uSat_hist(2,:)), max(norm_func(u_hist))]';
    % minVal = [min(x1_hist(1,:)) min(x1_hist(2,:)) min(uSat_hist(1,:)) min(uSat_hist(2,:)), min(norm_func(u_hist))]';
    % maxVals = max(maxVals, maxVal);
    % minVals = min(minVals, minVal);    
end

% ============================
% after all data
plot(ax_list{1}, t, rad2deg(dataSet{t_max_idx}.xd1_hist(1,:)), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); 
plot(ax_list{2}, t, rad2deg(dataSet{t_max_idx}.xd1_hist(2,:)), "Color", "red", "LineWidth", line_width, "LineStyle", "--");
plot(ax_list{3}, t, rad2deg(dataSet{t_max_idx}.xd2_hist(1,:)), "Color", "red", "LineWidth", line_width, "LineStyle", "--"); 
plot(ax_list{4}, t, rad2deg(dataSet{t_max_idx}.xd2_hist(2,:)), "Color", "red", "LineWidth", line_width, "LineStyle", "--");

plot(ax_list{5}, [t(1) t(end)], [+1 +1]*uMax1, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{5}, [t(1) t(end)], [-1 -1]*uMax1, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{6}, [t(1) t(end)], [+1 +1]*uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{6}, [t(1) t(end)], [-1 -1]*uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{7}, [t(1) t(end)], [+1 +1]*u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax_list{7}, [t(1) t(end)], [-1 -1]*u_ball, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on

% 
for f_idx = 1:1:7
    plot(ax_list{f_idx}, [warmup_time, warmup_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
    plot(ax_list{f_idx}, [warmup_time+ep_time, warmup_time+ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
    plot(ax_list{f_idx}, [warmup_time+2*ep_time, warmup_time+2*ep_time], [-5e1 5e1], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
    % text(ax_list{f_idx}, warmup_time + .2, minVals(f_idx), "Episode 1", "FontSize", font_size, "FontName", 'Times New Roman')
    % text(ax_list{f_idx}, warmup_time + ep_time + .2, minVals(f_idx), "Episode 2", "FontSize", font_size, "FontName", 'Times New Roman')
    % text(ax_list{f_idx}, warmup_time + 2*ep_time + .2, minVals(f_idx), "Episode 3", "FontSize", font_size, "FontName", 'Times New Roman')

    len = maxVals(f_idx)-minVals(f_idx); ratio = .3;
    if len~=0
        ax_list{f_idx}.YLim = [minVals(f_idx)-len*ratio maxVals(f_idx)+len*ratio];
    end
    ax_list{f_idx}.XLim = [global_start_t global_end_t];
end

% label
ax_list{1}.XLabel.String = 'Time / s';
ax_list{1}.YLabel.String = '$q_1$ / deg';
ax_list{2}.XLabel.String = 'Time / s';
ax_list{2}.YLabel.String = '$q_2$ / deg';
ax_list{3}.XLabel.String = 'Time / s';
ax_list{3}.YLabel.String = '$\dot{q}_1$ / deg/s';
ax_list{4}.XLabel.String = 'Time / s';
ax_list{4}.YLabel.String = '$\dot{q}_2$ / deg/s';
ax_list{5}.XLabel.String = 'Time / s';
ax_list{5}.YLabel.String = '$\tau_1$ / Nm';
ax_list{6}.XLabel.String = 'Time / s';
ax_list{6}.YLabel.String = '$\tau_2$ / Nm';
ax_list{7}.XLabel.String = 'Time / s';
ax_list{7}.YLabel.String = '$\Vert\tau\Vert$ / Nm';

for ax_idx = 1:1:7
    ax_list{ax_idx}.XLabel.Interpreter = 'latex';
    ax_list{ax_idx}.YLabel.Interpreter = 'latex';
end

%% ============================
% Top view of the control input
% ============================
fig = figure(8); clf;
ax = axes(fig);
hold(ax, 'on');
grid(ax, 'on');
grid(ax, 'minor');
box(ax, 'on');

set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [figW figH*1.5];
set(ax, 'FontName', 'Times New Roman');
set(ax, 'FontSize', ax_font_size);
set(ax, 'LineWidth', 1.1);
set(ax, 'TickLabelInterpreter', 'latex');

maxminX = [-inf inf]; maxminY = [-inf inf];
for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    CTRL_INFO = data.CTRL_INFO;

    u_hist = data.u_hist;
    u_hist = [u_hist, nan(2, length(t)-length(u_hist))];
    u_hist = u_hist(:, ctrl_obs_idx2);
    color = color_list(ctrl_idx);

    plot(ax, u_hist(1,:), u_hist(2,:), "Color", color, "LineWidth", line_width, "LineStyle", "-");

    maxminX = [min(u_hist(1,:)) max(u_hist(1,:))];
    maxminY = [min(u_hist(2,:)) max(u_hist(2,:))];
end
plot(ax, u_ball*cos(0:0.01:2*pi), u_ball*sin(0:0.01:2*pi), "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax, [-1000 1000], [+1 +1]*uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax, [-1000 1000], [-1 -1]*uMax2, "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
plot(ax, [1 1]*uMax1, [-10000, 10000], "Color", "black", "LineWidth", line_width, "LineStyle", "-."); hold on
ax.XLabel.String = '$\tau_1$ / Nm'; ax.XLabel.Interpreter = 'latex';
ax.YLabel.String = '$\tau_2$ / Nm'; ax.YLabel.Interpreter = 'latex';
maxminX = [-u_ball, u_ball];
maxminY = [-u_ball, u_ball];
ax.XLim = [8.8 10.8];
ax.YLim = [0 3.2];

%% ============================
% [CONAC] Multipliers
% ============================

fig = figure(9); clf;
ax = axes(fig);

set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [figW figH];

C1_u_ball_lbd = dataSet{4}.lbd_hist(4,:);
C2_u_ball_lbd = dataSet{3}.lbd_hist(4,:);
C1_u2_max_lbd = dataSet{4}.lbd_hist(7,:);
C2_u2_max_lbd = dataSet{3}.lbd_hist(7,:);

semilogy(ax, dataSet{4}.t, C1_u_ball_lbd, "Color", color_list(4), "LineWidth", line_width, "LineStyle", "-", "DisplayName", '$\lambda_{\mbox{\boldmath $\tau$}}$'); hold on
semilogy(ax, dataSet{3}.t, C2_u_ball_lbd, "Color", color_list(3), "LineWidth", line_width, "LineStyle", "-", "DisplayName", '$\lambda_{\mbox{\boldmath $\tau$}}$'); hold on
% semilogy(ax, dataSet{4}.t, C1_u2_max_lbd, "Color", color_list(4), "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{\overline{\tau}_2}$"); hold on
% semilogy(ax, dataSet{3}.t, C2_u2_max_lbd, "Color", color_list(3), "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\lambda_{\overline{\tau}_2}$"); hold on

hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');
grid(ax, 'minor');

lgd = legend(ax);
lgd.Location = 'southeast';
lgd.Interpreter = 'latex';
lgd.FontSize = 10;
lgd.NumColumns = 2;
set(ax, 'FontName', 'Times New Roman');
set(ax, 'FontSize', ax_font_size);
set(ax, 'LineWidth', 1.1);
set(ax, 'TickLabelInterpreter', 'latex');
ax.XLabel.String = 'Time / s';
ax.YLabel.String = '$\lambda_{\mbox{\boldmath $\tau$}}$';
ax.XLabel.Interpreter = 'latex';
ax.YLabel.Interpreter = 'latex';

ax.XLim = [start_t end_t];
ax.YLim = [0.000078389151053,7.12744126403738];

%% ============================
%   Weight Norms
% ============================
fig = figure(10); clf;
ax = axes(fig);
set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [figW figH];
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');
grid(ax, 'minor');
set(ax, 'FontName', 'Times New Roman');
set(ax, 'FontSize', ax_font_size);
set(ax, 'LineWidth', 1.1);
set(ax, 'TickLabelInterpreter', 'latex');

for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    CTRL_INFO = data.CTRL_INFO;
    color = color_list(ctrl_idx);
    
    t = data.t;

    th_hist = data.th_hist;
    th0 = th_hist(1,:);
    th1 = th_hist(2,:);
    th2 = th_hist(3,:);

    plot(ax, t, th0, "Color", color, "LineWidth", line_width, "LineStyle", "-", "HandleVisibility", "off"); hold on
    plot(ax, t, th1, "Color", color, "LineWidth", line_width, "LineStyle", "-.", "HandleVisibility", "off"); hold on
    plot(ax, t, th2, "Color", color, "LineWidth", line_width, "LineStyle", "--", "HandleVisibility", "off"); hold on
    
end
% dummy for legend (not plotted)
plot(ax, NaN, NaN, "Color", 'k', "LineWidth", line_width, "LineStyle", "-", "DisplayName", "$\Vert\widehat{\mbox{\boldmath $\theta$}}_0\Vert$"); hold on
plot(ax, NaN, NaN, "Color", 'k', "LineWidth", line_width, "LineStyle", "-.", "DisplayName", "$\Vert\widehat{\mbox{\boldmath $\theta$}}_1\Vert$"); hold on
plot(ax, NaN, NaN, "Color", 'k', "LineWidth", line_width, "LineStyle", "--", "DisplayName", "$\Vert\widehat{\mbox{\boldmath $\theta$}}_2\Vert$"); hold on
plot(ax, [0 T], [+1 +1]*th_max(1), "Color", "black", "LineWidth", line_width, "LineStyle", "-.", "HandleVisibility", "off"); hold on

lgd = legend(ax);
lgd.Location = 'northeast';
lgd.Interpreter = 'latex';
lgd.FontSize = 10;
lgd.NumColumns = 3;

ax.XLim = [global_start_t global_end_t];
ax.YLim = [0 15];
ax.XLabel.String = 'Time / s';
ax.YLabel.String = '$\Vert\widehat{\mbox{\boldmath $\theta$}}_i\Vert$';
ax.XLabel.Interpreter = 'latex';
ax.YLabel.Interpreter = 'latex';

%% ============================
% [AUX] Zeta
% ============================
% zeta 1
fig = figure(11); clf;
ax = axes(fig);
set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [figW figH];
hold(ax, 'on');
grid(ax, 'on');
box(ax, 'on');
grid(ax, 'minor');
set(ax, 'FontName', 'Times New Roman');
set(ax, 'FontSize', ax_font_size);
set(ax, 'LineWidth', 1.1);
set(ax, 'TickLabelInterpreter', 'latex');

for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    color = color_list(ctrl_idx);

    if data.CTRL_INFO.CTRL_NUM ~= 3
        continue
    end
    
    t = data.t;
    zeta_hist = data.zeta_hist;

    plot(ax, t, zeta_hist(1,:), "Color", color, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(ax, t, zeta_hist(2,:), "Color", color, "LineWidth", line_width, "LineStyle", "-."); hold on
end

%% ============================
% Computation Time
% ============================
fig = figure(12); clf;
ax = axes(fig);
set(fig, 'Units', 'centimeters');
fig.Position(3:4) = [figW figH];
hold(ax, 'on');
box(ax, 'on');
grid(ax, 'on');
grid(ax, 'minor');
set(ax, 'FontName', 'Times New Roman');
set(ax, 'FontSize', ax_font_size);
set(ax, 'LineWidth', 1.1);
set(ax, 'TickLabelInterpreter', 'latex');

for ctrl_idx = 1:1:length(dataSet)
    data = dataSet{ctrl_idx};
    color = color_list(ctrl_idx)
    
    t = data.t;
    comp_time_hist = data.comp_time_hist;
    % comp_time_hist = zeros(size(t));

    plot(ax, t, comp_time_hist, "Color", color, "LineWidth", line_width, "LineStyle", "-"); hold on
end

ax.XLim = [global_start_t global_end_t];
ax.XLabel.String = 'Time / s';
ax.YLabel.String = 'Comp. Time / s';
ax.XLabel.Interpreter = 'latex';
ax.YLabel.Interpreter = 'latex';


%% SAVE FIGURES
if SAVE_FLAG
    FIG_SAVE_PATH = "figures";
    [~,~] = mkdir(FIG_SAVE_PATH);

    for idx = 1:1:12

        f_name = FIG_SAVE_PATH + "/Fig" + string(idx);

        saveas(figure(idx), f_name + ".png")

        figure(idx);
        % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
        exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
        % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
    
        % matlab2tikz(char(f_name+".tex"))

        fprintf("Saved Figure %d\n", idx)
    end
end


%% NUMERICAL ANALYSIS
ctrl_dt = 1/250;
sim_dt = ctrl_dt / 1000;

ep1_idx = find(t >= warmup_time & t <= warmup_time + ep_time);
ep2_idx = find(t >= warmup_time + ep_time & t <= warmup_time + 2*ep_time);

for c_idx = 1:1:length(dataSet)
    data = dataSet{c_idx};

    x1_hist = data.x1_hist;
    x2_hist = data.x2_hist;
    xd1_hist = data.xd1_hist;
    xd2_hist = data.xd2_hist;
    e1_hist = x1_hist - xd1_hist;
    e2_hist = x2_hist - xd2_hist;

    Lambda = diag([5 15]);
    r = e2_hist + Lambda*e1_hist;

    dataSet{c_idx}.r_hist = r(1,:);
end

RMSE = @(e) sqrt(mean(e.^2, 2));

fprintf("%% RMSE: \n")
for c_idx = 1:1:length(dataSet)
    data = dataSet{c_idx};

    if data.t(end) < warmup_time + 2*ep_time
        fprintf("%% C %s : failed to control\n", name_list{c_idx})
        continue
    end

    e_hist = rad2deg(data.x1_hist - data.xd1_hist);
    r_hist = rad2deg(data.r_hist);

    e1_ep1 = e_hist(1, ep1_idx);
    e2_ep1 = e_hist(2, ep1_idx);
    e1_ep2 = e_hist(1, ep2_idx);
    e2_ep2 = e_hist(2, ep2_idx);
    r_ep1  = r_hist(ep1_idx);
    r_ep2  = r_hist(ep2_idx);

    ctrl_name = name_list{c_idx};

    fprintf("%% -------------------------------\n")
    fprintf("%% C %s :\n", ctrl_name)
    fprintf("%% error position (1) %.3f, (2) %.3f [imp: %.3f]\n", RMSE(e1_ep1), RMSE(e2_ep1), 1-RMSE(e2_ep1)/RMSE(e1_ep1))
    fprintf("%% error velocity (1) %.3f, (2) %.3f [imp: %.3f]\n", RMSE(e1_ep2), RMSE(e2_ep2), 1-RMSE(e2_ep2)/RMSE(e1_ep2))
    fprintf("%% filter error   (1) %.3f, (2) %.3f [imp: %.3f]\n", RMSE(r_ep1), RMSE(r_ep2), 1-RMSE(r_ep2)/RMSE(r_ep1))
    fprintf("\n")

    fprintf("\\newcommand{\\%sEpiOneAngOne}{%.3f}\n", ctrl_name, RMSE(e1_ep1))
    fprintf("\\newcommand{\\%sEpiOneAngTwo}{%.3f}\n", ctrl_name, RMSE(e2_ep1))
    fprintf("\\newcommand{\\%sEpiTwoAngOne}{%.3f}\n", ctrl_name, RMSE(e1_ep2))
    fprintf("\\newcommand{\\%sEpiTwoAngTwo}{%.3f}\n", ctrl_name, RMSE(e2_ep2))
    fprintf("\\newcommand{\\%sImpAngOne}{%.3f}\n", ctrl_name, (RMSE(e1_ep2)/RMSE(e1_ep1)-1)*100)
    fprintf("\\newcommand{\\%sImpAngTwo}{%.3f}\n", ctrl_name, (RMSE(e2_ep2)/RMSE(e2_ep1)-1)*100)
end
beep()

function data = loadFromMeas(data_path, CTRL_INFO)
    data_orig = load(data_path);

    data = struct();
    data.CTRL_INFO.CTRL_NUM = CTRL_INFO;
    
    % ref start to end idx
    xd1_hist = data_orig.r(1:2, :);
    ref_start_idx = find(isnan(xd1_hist(1,:))==0, 1);
    ref_end_idx = find(isnan(xd1_hist(1,:))==0, 1, 'last');
        
    % data mapping
    data.x1_hist = data_orig.q(1:2, ref_start_idx:ref_end_idx);
    data.x2_hist = data_orig.qdot(1:2, ref_start_idx:ref_end_idx);
    data.xd1_hist = data_orig.r(1:2, ref_start_idx:ref_end_idx);
    data.xd2_hist = data_orig.rdot(1:2, ref_start_idx:ref_end_idx);
    data.u_hist = data_orig.u_command(1:2, ref_start_idx:ref_end_idx);
    data.uSat_hist = data_orig.u_saturated(1:2, ref_start_idx:ref_end_idx);
    % data.xd3_hist = data_orig.rddot(1:2, :);

    data.lbd_hist = data_orig.lbd(:, ref_start_idx:ref_end_idx);
    data.th_hist = data_orig.Vn(:, ref_start_idx:ref_end_idx);
    data.zeta_hist = data_orig.zeta(:, ref_start_idx:ref_end_idx);
    
    data.comp_time_hist = data_orig.comp_time(ref_start_idx:ref_end_idx);

    t = data_orig.t(ref_start_idx:ref_end_idx);
    data.t = t - t(1);
    data.T = data.t(end);
end
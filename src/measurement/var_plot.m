SAVE_FLAG = 1;

save_idx = [];

%%
font_size = 20;
line_width = 2;
lgd_size = 16;
    
fig_height = 230 * 1.5; 
fig_width = 800 * 1;

% 
data_num = "10-Apr-2025_11-56-08";

sim_dt = 1/250;
ISE = @(e) sqrt(sum(e.^2)*sim_dt);

u_max1 = 11.5;
u_max2 = 16;
u_ball = 12;
th_max = [11,12,13];

[~,~] = mkdir("figures/"+ctrl_name);
[~,~] = mkdir("figures/"+ctrl_name+"/c1");
[~,~] = mkdir("figures/"+ctrl_name+"/c2");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig1");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig2");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig3");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig4");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig5"); 
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig6");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig7");
[~,~] = mkdir("figures/"+ctrl_name+"/c1/fig8");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig1");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig2");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig3");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig4");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig5");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig6");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig7");
[~,~] = mkdir("figures/"+ctrl_name+"/c2/fig8");


VAR_NUM = 9;

%% DATA PRE-PROCESSING
PI1 = []; PI2 = [];

% remove the data with large change
data = readtable("sim_result/"+ctrl_name);
data = data{1:end-1, 1:28};
ori_num = length(data);


figure(12); clf;
plot(data(:,2)); hold on
% % plot(data(:,1), data(:,9)); hold on


del_ts = [0.001, 0.004];
pt = [];
% sampling time check
for idx = 1:length(del_ts)
    del_t = del_ts(idx);
    tmp_pt = find((data(2:end,1) - data(1:end-1,1) - del_t).^2 < 1e-3);
    
    pt = union(pt, tmp_pt);
end
data = data(pt, :);

pt = 1:size(data,1);
thr = 1e-1;
for idx = 3:28
    tmp_pt = find((data(2:end,idx) - data(1:end-1,idx)).^2 > thr);
    pt = setdiff(pt, tmp_pt);
end

data = data(pt, :);
mod_num = length(data);
loss_ratio = (ori_num - mod_num) / ori_num;
fprintf('loss ratio: %.3f%%\n', loss_ratio*1e2);

% seperate
pt1 = find(data(:,2) == 4);
pt2 = find(data(:,2) == 5);
pt = setdiff(1:size(data,1), pt1);
pt = setdiff(pt, pt2);
data(pt, 2) = zeros(length(pt), 1);

figure(12); clf;
plot(data(:,1), data(:,2)); hold on
% plot(data(:,2)); hold on
plot(data(:,1), data(:,9)); hold on

% data(96514,:) = [];

rise_flag = find(data(2:end,2) - data(1:end-1,2) > 0);
rise_t = data(rise_flag, 1);
fall_flag = find(data(2:end,2) - data(1:end-1,2) < 0);
fall_t = data(fall_flag, 1);

assert(length(rise_flag)/2 == VAR_NUM, "VAR. NUM mismatch");
assert(length(rise_flag) == length(fall_flag), "rise and fall flag length mismatch");

for ctrl_idx = 1:VAR_NUM*2
    start_idx = rise_flag(ctrl_idx);
    end_idx = fall_flag(ctrl_idx);

    ep_idx = start_idx:end_idx;

    plot_idv

    e = c1_x1-c1_xd1;
    e_dot = c1_x2-c1_xd2;

    r = e - [2,0;0,2]*e_dot;

    cu = sqrt(max(0, norm(c1_u).^2 - u_ball^2));
    cu1 = max(0, c1_u(1,:) - u_max1);

    if ctrl_idx <= VAR_NUM
        C_name = "c1";
        PI1(ctrl_idx,1) = ISE(r(1,:));
        PI1(ctrl_idx,2) = ISE(r(2,:));
        PI1(ctrl_idx,3) = ISE(cu);
        PI1(ctrl_idx,4) = ISE(cu1);
    else
        C_name = "c2";
        PI2(ctrl_idx-VAR_NUM,1) = ISE(r(1,:));
        PI2(ctrl_idx-VAR_NUM,2) = ISE(r(2,:));
        PI2(ctrl_idx-VAR_NUM,3) = ISE(cu);
        PI2(ctrl_idx-VAR_NUM,4) = ISE(cu1);
    end

    % if SAVE_FLAG && sum(save_idx == ctrl_idx) > 0


    % end

    if SAVE_FLAG
        for idx = 1:1:8
            f_name = "figures/"+ctrl_name+"/"+C_name+"/fig" + string(idx)+"/" +string(ctrl_idx);
    
            saveas(figure(idx), f_name + ".png")
            
            figure(idx);
            % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
            % exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
            % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
        end
    end
end


%% Bosx-plot
figure(11); clf;
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

Pi_list = transpose([PI1(:,1), PI2(:,1), PI1(:,2), PI2(:,2),PI1(:,3), PI2(:,3), PI1(:,4), PI2(:,4)]);
lgds = {'C1 $q_1$', 'C2 $q_1$', 'C1 $q_2$', 'C2 $q_2$', 'C1 $c_u$', 'C2 $c_u$', 'C1 $c_1$', 'C2 $c_1$'};
boxplot(Pi_list', 'Labels', lgds, 'Whisker', 1.5); hold on
ylabel("Square Root of ISE", "Interpreter", "latex")
% xlabel("$q_{2}\ (\rm rad)$", "Interpreter","latex")
set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')
grid on
% ylim([-10e-4, 20e-4])
a = gca;
% a.YTick = linspace(-10e-4, 20e-4, 6);
% a.YRuler.Exponent = -4;
set(gca,'TickLabelInterpreter','latex');

figure(13);clf;
tiledlayout(4,1);

var_range = 10:10:90;

nexttile
plot(var_range, PI1(:,1), 'o-', 'color', 'blue', 'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(var_range, PI2(:,1), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(var_range, PI1(:,2), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(var_range, PI2(:,2), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(var_range, PI1(:,3), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(var_range, PI2(:,3), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(var_range, PI1(:,4), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(var_range, PI2(:,4), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on


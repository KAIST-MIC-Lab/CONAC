clear
clc

FIGURE_PLOT_FLAG = 1;
FIGURE_SAVE_FLAG = 1;

save_idx = [];

%%
font_size = 20;
line_width = 2;
lgd_size = 16;
    
fig_height = 230 * 1.5; 
fig_width = 800 * 1;

% 
data_name = "10-Apr-2025_17-40-19";

dt = 1/1000;
ISE = @(e) sqrt(sum(e.^2)*dt);

u_ball = 6;
u_max1 = 5.8;
u_max2 = 15;
th_max = [11,12,13];

D = 'sim_result/'+data_name;
S = dir(fullfile(D,'*.mat'));

VAR_NUM = length(S)/2;

start_time = 31.4;
end_time = 32.4;

%% DATA PRE-PROCESSING
PI1 = []; PI2 = [];

for CONTROL_NUM = 1:2
    for ctrl_idx = 1:VAR_NUM
        if CONTROL_NUM == 2
            ctrl_idx = ctrl_idx + VAR_NUM;
        end

        data = load(D+"/"+S(ctrl_idx).name);
        fprintf("Loading %s\n", S(ctrl_idx).name);

        plot_idv

        e = c1_x1-c1_xd1;
        e_dot = c1_x2-c1_xd2;

        r = e - [5,0;0,5]*e_dot;

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

        if FIGURE_SAVE_FLAG
            for idx = 1:1:8
                [~,~] = mkdir("figures/"+data_name+"/"+C_name+"/fig" + string(idx));

                f_name = "figures/"+data_name+"/"+C_name+"/fig" + string(idx)+"/" +string(ctrl_idx);
        
                saveas(figure(idx), f_name + ".png")
                
                figure(idx);
                % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
                % exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
                % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
            end
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

vars = linspace(0.1,10,100);


nexttile
plot(vars, PI1(:,1), 'o-', 'color', 'blue', 'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,1), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,2), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,2), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,3), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,3), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on

nexttile
plot(vars, PI1(:,4), 'o-', 'color', 'blue',  'LineWidth', line_width, 'MarkerSize', 10); hold on
plot(vars, PI2(:,4), 'o-', 'color', 'cyan',  'LineWidth', line_width, 'MarkerSize', 10); hold on


figure(14);clf; 
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

x_list = 1:8;
x_tiks = {
    '$C_1: e_1$',
    '$C_2: e_1$',
    '$C_1: e_2$',
    '$C_2: e_2$',
    '$C_1: c_u$',
    '$C_2: c_u$',
    '$C_1: c_1$',
    '$C_2: c_1$'
};
for idx = 1:1:VAR_NUM*2
    c = rand(1,3);
    if idx <= VAR_NUM
        marker = 'o';
        PI = PI1;
        xx = 1:2:7;
    else
        marker = '+';
        PI = PI2;
        idx = idx - VAR_NUM;
        xx = 2:2:8;
    end

    scatter(xx, PI(idx,:), marker, 'MarkerFaceColor', c, 'MarkerEdgeColor', c, 'LineWidth', 0.5); hold on

    xticks(1:8);
    xticklabels(x_tiks);
    set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', font_size, 'FontName', 'Times New Roman');

end

xlim([0 9])
ymin = min(min(min(PI1(:,1:4)), min(PI2(:,1:4))));
ymax = max(max(max(PI1(:,1:4)), max(PI2(:,1:4))));
ylim([ymin, ymax] + [-1, 1] * (ymax-ymin) * .1)
grid on
%% LET's BEGIN
clear
AINMATION_SAVE_FLAG = 1;



%% FIGURE SETTING
figure(7); clf

L1 = .45;            
L2 = .45;

accel = 1000;

line_width = 1.5;
font_size = 12;

%% DATA LOAD
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

%%
selected.ctrl5 = ["ctrl5_1", "ctrl5_2", "ctrl5_3"];
selected.ctrl6 = ["ctrl6_1", "ctrl6_2", "ctrl6_3"];
selected.ctrl7 = ["ctrl7_1", "ctrl7_2", "ctrl7_3"];
selected.overall = ["ctrl5_1", "ctrl6_1", "ctrl7_1"];

% representative result
r_hist = ctrl_results.ctrl5_1.r_hist;
t = ctrl_results.ctrl5_1.t;
u_ball = 30;

num_t = length(t);
dt = t(2)-t(1);
T = t(end);

%% ANIMATE!
sel_names = fieldnames(selected);
sel_num = size(sel_names, 1);

for sel_idx = 1:sel_num 
    fprintf("sel_idx: %d", sel_idx)
    selected_name = selected.(sel_names{sel_idx});

    if AINMATION_SAVE_FLAG
        v = VideoWriter("sim_result/"+sel_names{sel_idx}, 'MPEG-4');
        % v.Quality = 100;
        v.FrameRate = 1/dt/accel; 
        open(v);
    end

    for t_idx = 1:accel:num_t
        clf

        for c_idx = 1:size(selected_name, 2)
            ctrl_name = selected_name(c_idx);
            x_hist = ctrl_results.(ctrl_name).x_hist;
            q1 = x_hist(1, t_idx); q2 = x_hist(2, t_idx);

            plot( ...
                L1* [0 cos(q1), cos(q1)+cos(q1+q2)], ...
                L1* [0 sin(q1), sin(q1)+sin(q1+q2)], ...
                "Color", c_list(c_idx,:), ...
                "LineStyle","-", ...
                "Marker","o", ...
                "LineWidth", line_width ...
                ); hold on
        end
        
        r1 = r_hist(1, t_idx); r2 = r_hist(2, t_idx);

        plot( ...
            L1* [0 cos(r1), cos(r1)+cos(r1+r2)], ...
            L1* [0 sin(r1), sin(r1)+sin(r1+r2)], ...
            "Color", "red", ...
            "LineStyle","--", ...
            "Marker","o", ...
            "LineWidth", line_width ...
            ); hold on

        % time 
        text(-.95,+.8,0, ...
            sprintf( ...
                'Time: %.2f\t/%.2f s (%.1f%%) ', t(t_idx), T, round(t(t_idx)/T*100, 3) ...
            ), ...
            "FontSize", font_size, ...
            "FontName", "Times New Roman" ...
            );
            
        set(gca, 'XTickLabel', [])
        set(gca, 'YTickLabel', [])
        set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')

        grid on
        xlim([-1.2 1.2]);
        ylim([-1.2 1.2]);
        pbaspect([1 1 1])

        % input ball =============================
        axes('Position',[.6 .22 .2 .2])
        box on
        shadow = max(1, t_idx-1e3:1:t_idx);
        
        for c_idx = 1:size(selected_name, 2)
            ctrl_name = selected_name(c_idx);
            u_hist = ctrl_results.(ctrl_name).u_hist;

            plot(u_hist(1,shadow ), u_hist(2,shadow ), "color", c_list(c_idx,:), "LineWidth", line_width, "LineStyle", "-"); hold on
            plot(u_hist(1,t_idx), u_hist(2,t_idx), "color", c_list(c_idx,:),"Marker","o"); hold on
        end

        xlabel("$\tau_1$", "Interpreter", "latex")
        ylabel("$\tau_2$", "Interpreter", "latex")
        set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

        grid on
        mul_range = 2;
        xlim(mul_range* [-u_ball, u_ball])
        ylim(mul_range* [-u_ball, u_ball])
        pbaspect([1 1 1])


        % weight ball =============================
        axes('Position',[.3 .22 .2 .2])
        box on
        ang = 0:0.01:2*pi;
        shadow = max(1, t_idx-1e3:1:t_idx);
        
        for c_idx = 1:size(selected_name, 2)
            ctrl_name = selected_name(c_idx);
            V_hist = ctrl_results.(ctrl_name).V_hist;

            plot(V_hist(1,shadow ), V_hist(2,shadow ), "color", c_list(c_idx,:), "LineWidth", line_width, "LineStyle", "-"); hold on
            plot(V_hist(1,t_idx), V_hist(2,t_idx), "color", c_list(c_idx,:),"Marker","o"); hold on
        end
    
        xlabel("${\hat{\theta}}_0$", "Interpreter", "latex")
        ylabel("${\hat{\theta}}_1$", "Interpreter", "latex")
        set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

        grid on
        mul_range = 1;
        xlim(mul_range* [-1, 15])
        ylim(mul_range* [-1, 25])
        pbaspect([1 1 1])

        % get frame
        drawnow

        if AINMATION_SAVE_FLAG
            f = getframe(gcf);
            writeVideo(v, f);
        end
        
        pause(0.001)
        clf
    end

    if AINMATION_SAVE_FLAG
        close(v);
    end
end
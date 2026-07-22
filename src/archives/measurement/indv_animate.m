clear
figure(1); close
figure(1);

AINMATION_SAVE_FLAG = 0;
video_name = "sample";
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

line_width = 1.5;
font_size = 12;
T = 24;

%% 
ctrl1_name = "2025_04_09_13_30"; % CoNAC

%%
data1 = post_procc(ctrl1_name, 4);

c1 = "blue"; 
th_max = [11 12 13];
u_ball = 12;
u_max1 = 10;
u_max2 = 3;

%%
dt = data1.t(2) - data1.t(1);

%%
L1 = .45;            
L2 = .45;

%% SAVE VIDEO
if AINMATION_SAVE_FLAG
    v = VideoWriter("sim_result/"+video_name, 'MPEG-4');
    % v.Quality = 100;
    v.FrameRate = 1/dt; 
    open(v);
end

%% ANIMATE
for t = 0:dt:T
    pause(0.001)
    clf

    t_idx1 = find(data1.t >= t, 1);

    q1_c1 = data1.x1(1, t_idx1); q2_c1 = data1.x1(2, t_idx1);

    r1 = data1.xd1(1, t_idx1); r2 = data1.xd1(2, t_idx1);

    plot( ...
        L1* [0 cos(r1), cos(r1)+cos(r1+r2)], ...
        L1* [0 sin(r1), sin(r1)+sin(r1+r2)], ...
        "Color", "red", ...c
        "LineStyle","--", ...
        "Marker","o", ...
        "LineWidth", line_width ...
        ); hold on

    plot( ...
        L1* [0 cos(q1_c1), cos(q1_c1)+cos(q1_c1+q2_c1)], ...
        L1* [0 sin(q1_c1), sin(q1_c1)+sin(q1_c1+q2_c1)], ...
        "Color", c1, ...
        "LineStyle","-", ...
        "Marker","o", ...
        "LineWidth", line_width ...
        ); hold on

    % time 
    text(.25,.85,0, ...
        sprintf( ...
            'Time: %.2f/%.0f s (%.1f%%) ', t, T, round(t/T*100, 3) ...
        ), ...
        "FontSize", font_size, ...
        "FontName", "Times New Roman" ...
        );
    grid on
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])

    set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')

    xlim([-1.2 1.2]);
    ylim([-1.2 1.2]);
    pbaspect([1 1 1])

    % input ball
    axes('Position',[.2 .2 .25 .2])
    box on
    ang = 0:0.01:2*pi;
    shadow = max(1, t_idx1-1e2:1:t_idx1);
    
    plot(data1.u(1,shadow ), data1.u(2,shadow ), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.u(1,t_idx1),   data1.u(2,t_idx1), "color", c1,"Marker","o"); hold on

    plot([-100 100], [1 1]*u_max2, "Color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
    plot([-100 100], [-1 -1]*u_max2, "Color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
    plot(u_ball*cos(ang), u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
    
    xlabel("$\tau_1$ / Nm", "Interpreter", "latex")
    ylabel("$\tau_2$ / Nm", "Interpreter", "latex")
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

    grid on

    xlim(1.2* [-u_ball, u_ball])
    ylim(1.4* [-u_max2, u_max2])
    % pbaspect([1 1])

    % tracking 1
    axes('Position',[.2 .7 .25 .2])
    box on
    shadow = max(1, t_idx1-1e2:1:t_idx1);

    plot(data1.t(1,shadow), data1.x1(1,shadow), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.t(1,shadow), data1.xd1(1,shadow), "color", 'red', "LineWidth", line_width, "LineStyle", "--"); hold on

    % xlabel("Time / s", "Interpreter", "latex")
    ylabel("$q_1$", "Interpreter", "latex")
    grid on
    set(gca, 'XTickLabel', [])
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

    maxVal = max(data1.xd1(1,:)); minVal = min(data1.xd1(1,:)); 
    len = maxVal-minVal; ratio = .3;
    ylim([minVal-len*ratio maxVal+len*ratio]);
    tmp_t = data1.t(1,shadow);
    if tmp_t(end) ~= 0
        xlim([tmp_t(1) tmp_t(end)])
    end

    % tracking 2
    axes('Position',[.2 .5 .25 .2])
    box on
    shadow = max(1, t_idx1-1e2:1:t_idx1);

    plot(data1.t(1,shadow), data1.x1(2,shadow), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.t(1,shadow), data1.xd1(2,shadow), "color", 'red', "LineWidth", line_width, "LineStyle", "--"); hold on

    xlabel("Time / s", "Interpreter", "latex")
    ylabel("$q_2$", "Interpreter", "latex")
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

    grid on
    maxVal = max(data1.xd1(2,:)); minVal = min(data1.xd1(2,:)); 
    len = maxVal-minVal; ratio = .3;
    ylim([minVal-len*ratio maxVal+len*ratio]);
    tmp_t = data1.t(1,shadow);
    if tmp_t(end) ~= 0
        xlim([tmp_t(1) tmp_t(end)])
    end
    % pbaspect([1 1])

    % get frame
    drawnow

    if AINMATION_SAVE_FLAG
        f = getframe(gcf);
        writeVideo(v, f);
    end
end

if AINMATION_SAVE_FLAG
    close(v);
end

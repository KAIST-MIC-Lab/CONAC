clear
figure(1); close
figure(1);

AINMATION_SAVE_FLAG = 1;
video_name = "sample";
gray = "#808080";

more_blue = "#0072BD";
more_red = "#A2142F";

line_width = 1.5;
font_size = 12;
ep_time = 12;
T = 2*ep_time;
accel = 10;
idleTime1 = 3+8;
idleTime2 = 4;

animation_end_t = T + idleTime1;

PhaseList = {
    "Idle 1",
    "Episode 1",
    "Episode 2",
    "Idle 2"
};

%% 
ctrl1_name = "c1.trc"; 
ctrl2_name = "c2.trc";
ctrl3_name = "c3.trc"; 
ctrl4_name = "c4.trc"; 

%%
data1 = trc2data(ctrl1_name, 1);
data2 = trc2data(ctrl2_name, 1);
data3 = trc2data(ctrl3_name, 1);
data4 = trc2data(ctrl4_name, 1);

c1 = "blue"; c2="cyan"; c3=gray; c4="magenta";
th_max = [6 6 6];
u_ball = 11;
u_max2 = 3.5;
u_max1 = sqrt(u_ball^2 - u_max2^2);

%%
dt = data1.q1.Time(2) - data1.q1.Time(1);

%%
L1 = .45;            
L2 = .45;

%% SAVE VIDEO
if AINMATION_SAVE_FLAG
    v = VideoWriter("figures/"+video_name, 'MPEG-4');
    % v.Quality = 100;
    v.FrameRate = 1/dt/accel; 
    open(v);
end

%% ANIMATE
for t = 0:dt*accel:animation_end_t
    t_idx1 = find(data1.q1.Time >= t, 1);
    t_idx2 = find(data2.q1.Time >= t, 1);
    t_idx3 = find(data3.q1.Time >= t, 1);
    t_idx4 = find(data4.q1.Time >= t, 1);

    if isempty(t_idx1) || isempty(t_idx2) || isempty(t_idx3) || isempty(t_idx4)
        break
    end

    q1_c1 = data1.q1.Data(t_idx1); q2_c1 = data1.q2.Data(t_idx1);
    q1_c2 = data2.q1.Data(t_idx2); q2_c2 = data2.q2.Data(t_idx2);
    q1_c3 = data3.q1.Data(t_idx3); q2_c3 = data3.q2.Data(t_idx3);
    q1_c4 = data4.q1.Data(t_idx4); q2_c4 = data4.q2.Data(t_idx4);

    r1 = data1.r1.Data(t_idx1); r2 = data1.r2.Data(t_idx1);

    plot( ...
        L2* [0 cos(q1_c4), cos(q1_c4)+cos(q1_c4+q2_c4)], ...
        L2* [0 sin(q1_c4), sin(q1_c4)+sin(q1_c4+q2_c4)], ...
        "Color", c4, ...
        "LineStyle","-", ...
        "Marker","o", ...
        "LineWidth", line_width ...
        ); hold on

    plot( ...
        L2* [0 cos(q1_c3), cos(q1_c3)+cos(q1_c3+q2_c3)], ...
        L2* [0 sin(q1_c3), sin(q1_c3)+sin(q1_c3+q2_c3)], ...
        "Color", c3, ...
        "LineStyle","-", ...
        "Marker","o", ...
        "LineWidth", line_width ...
        ); hold on

    plot( ...
        L2* [0 cos(q1_c2), cos(q1_c2)+cos(q1_c2+q2_c2)], ...
        L2* [0 sin(q1_c2), sin(q1_c2)+sin(q1_c2+q2_c2)], ...
        "Color", c2, ...
        "LineStyle","-", ...
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

    plot( ...
        L1* [0 cos(r1), cos(r1)+cos(r1+r2)], ...
        L1* [0 sin(r1), sin(r1)+sin(r1+r2)], ...
        "Color", "red", ...c
        "LineStyle","--", ...
        "Marker","o", ...
        "LineWidth", line_width ...
        ); hold on

    %  phase
    if t < idleTime1
        p_idx = 1;
    elseif t < idleTime1 + ep_time
        p_idx = 2;
    elseif t < idleTime1 + 2*ep_time
        p_idx = 3;
    else
        p_idx = 4;
    end
    text(.25,-.85,0, ...
        "Phase: "+PhaseList(p_idx), ...
        "FontSize", font_size+5, ...
        "FontName", "Times New Roman" ...
        );

    %  time
    text(.25,-.95,0, ...
        sprintf( ...
            'Time: %.2f/%.0f s (%.1f%%) ', t, animation_end_t, round(t/animation_end_t*100, 3) ...
        ), ...
        "FontSize", font_size, ...
        "FontName", "Times New Roman" ...
        );


    grid on
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')

    grid on
    xlim([-1.2 1.2]);
    ylim([-1.2 1.2]);
    pbaspect([1 1 1])

    % tracking 1
    axes('Position',[.2 .7 .25 .2])
    box on
    shadow = max(1, t_idx1-1e2:1:t_idx1);
    shadow = shadow';

    plot(data4.q1.Time(shadow), data4.q1.Data(shadow), "color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data3.q1.Time(shadow), data3.q1.Data(shadow), "color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data2.q1.Time(shadow), data2.q1.Data(shadow), "color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.q1.Time(shadow), data1.q1.Data(shadow), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

    plot(data1.r1.Time(shadow), data1.r1.Data(shadow), "color", 'red', "LineWidth", line_width, "LineStyle", "--"); hold on

    % xlabel("Time / s", "Interpreter", "latex")
    ylabel("$q_1$ / rad", "Interpreter", "latex")
    grid on
    set(gca, 'XTickLabel', [])
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

    maxVal = max(data1.r1.Data); minVal = min(data1.r1.Data); 
    len = maxVal-minVal; ratio = .3;
    ylim([minVal-len*ratio maxVal+len*ratio]);
    tmp_t = data1.r1.Time(shadow);
    if tmp_t(end) ~= 0
        xlim([tmp_t(1) tmp_t(end)])
    end

    % tracking 2
    axes('Position',[.2 .5 .25 .2])
    box on
    shadow = max(1, t_idx1-1e2:1:t_idx1);
    shadow = shadow';
    
    plot(data4.q2.Time(shadow), data4.q2.Data(shadow), "color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data3.q2.Time(shadow), data3.q2.Data(shadow), "color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data2.q2.Time(shadow), data2.q2.Data(shadow), "color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.q2.Time(shadow), data1.q2.Data(shadow), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on

    plot(data1.r2.Time(shadow), data1.r2.Data(shadow), "color", 'red', "LineWidth", line_width, "LineStyle", "--"); hold on

    xlabel("Time / s", "Interpreter", "latex")
    ylabel("$q_2$ / rad", "Interpreter", "latex")
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

    grid on
    maxVal = max(data1.r2.Data); minVal = min(data1.r2.Data); 
    len = maxVal-minVal; ratio = .3;
    ylim([minVal-len*ratio maxVal+len*ratio]);
    tmp_t = data1.r1.Time(shadow);
    if tmp_t(end) ~= 0
        xlim([tmp_t(1) tmp_t(end)])
    end
    % pbaspect([1 1])

    % input ball
    t_idx1 = find(data1.u1.Time >= t, 1);
    t_idx2 = find(data2.u1.Time >= t, 1);
    t_idx3 = find(data3.u1.Time >= t, 1);
    t_idx4 = find(data4.u1.Time >= t, 1);

    axes('Position',[.2 .2 .25 .2])
    box on
    ang = 0:0.01:2*pi;
    shadow = max(1, t_idx1-1e2:1:t_idx1);
    shadow = shadow';

    plot(data4.u1.Data(shadow), data4.u2.Data(shadow), "color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data3.u1.Data(shadow), data3.u2.Data(shadow), "color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data2.u1.Data(shadow), data2.u2.Data(shadow), "color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.u1.Data(shadow), data1.u2.Data(shadow), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data4.u1.Data(t_idx4), data4.u2.Data(t_idx4), "color", c4,"Marker","o"); hold on
    plot(data3.u1.Data(t_idx3), data3.u2.Data(t_idx3), "color", c3,"Marker","o"); hold on
    plot(data2.u1.Data(t_idx2), data2.u2.Data(t_idx2), "color", c2,"Marker","o"); hold on
    plot(data1.u1.Data(t_idx1), data1.u2.Data(t_idx1), "color", c1,"Marker","o"); hold on

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

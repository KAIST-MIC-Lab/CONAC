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
T = 24;

%% 
ctrl1_name = "2025_04_09_13_30"; % CoNAC
ctrl2_name = "2025_04_09_13_30"; % Aux.
ctrl3_name = "2025_04_09_13_30"; % CoNAC 2.
ctrl4_name = "2025_04_09_13_30"; % CoNAC 2.

%%
data1 = post_procc(ctrl1_name, 4);
data2 = post_procc(ctrl2_name, 4);
data3 = post_procc(ctrl3_name, 4);
data4 = post_procc(ctrl4_name, 4);

c1 = "blue"; c2="cyan"; c3=gray; c4="yellow";
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
    t_idx2 = find(data2.t >= t+1, 1);
    t_idx3 = find(data3.t >= t+2, 1);
    t_idx4 = find(data4.t >= t+3, 1);

    q1_c1 = data1.x1(1, t_idx1); q2_c1 = data1.x1(2, t_idx1);
    q1_c2 = data2.x1(1, t_idx2); q2_c2 = data2.x1(2, t_idx2);
    q1_c3 = data3.x1(1, t_idx3); q2_c3 = data3.x1(2, t_idx3);
    q1_c4 = data4.x1(1, t_idx4); q2_c4 = data4.x1(2, t_idx4);

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

    % time 
    text(-.95,+.8,0, ...
        sprintf( ...
            't [s]: %.2f\t/%.2f (%.1f%%) ', t, T, round(t/T*100, 3) ...
        ), ...
        "FontSize", font_size, ...
        "FontName", "Times New Roman" ...
        );

    xlabel("$x$", "Interpreter", "latex")
    ylabel("$y$", "Interpreter","latex")
    set(gca, 'FontSize', font_size, 'FontName', 'Times New Roman')

    grid on
    xlim([-1.2 1.2]);
    ylim([-1.2 1.2]);
    pbaspect([1 1 1])

    % input ball
    axes('Position',[.6 .22 .2 .2])
    box on
    ang = 0:0.01:2*pi;
    shadow = max(1, t_idx1-1e1:1:t_idx1);
    
    plot(data4.u(1,shadow ), data4.u(2,shadow ), "color", c4, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data4.u(1,t_idx4),   data4.u(2,t_idx4), "color", c4,"Marker","o"); hold on

    plot(data3.u(1,shadow ), data3.u(2,shadow ), "color", c3, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data3.u(1,t_idx3),   data3.u(2,t_idx3), "color", c3,"Marker","o"); hold on

    plot(data2.u(1,shadow ), data2.u(2,shadow ), "color", c2, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data2.u(1,t_idx2),   data2.u(2,t_idx2), "color", c2,"Marker","o"); hold on

    plot(data1.u(1,shadow ), data1.u(2,shadow ), "color", c1, "LineWidth", line_width, "LineStyle", "-"); hold on
    plot(data1.u(1,t_idx1),   data1.u(2,t_idx1), "color", c1,"Marker","o"); hold on

    
    plot(u_ball*cos(ang), u_ball*sin(ang), "color", 'black', "LineWidth", line_width, "LineStyle", "-."); hold on
    
    xlabel("$\tau_1$", "Interpreter", "latex")
    ylabel("$\tau_2$", "Interpreter", "latex")
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman')

    grid on
    mul_range = 2;
    xlim(mul_range* [-u_ball, u_ball])
    ylim(mul_range* [-u_ball, u_ball])
    pbaspect([1 1 1])

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

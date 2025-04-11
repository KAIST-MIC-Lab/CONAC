function r_func = ref4_load()

r_func = @(t) epi_gen(t);

end

function [r1, r2] = epi_gen(t)
    T = 3; % traj. duration
    POINT_NUM = 4; % number of points in one cycle
    CYCLE_TIME = T*POINT_NUM;
    CYCLE_NUM = 3;
    EPI_T = CYCLE_TIME*CYCLE_NUM;


    cycle = floor(t/CYCLE_TIME)+1;

    t = mod(t, CYCLE_TIME);
2.1
    x0 = deg2rad([-90;0]);  
    xd1 = deg2rad([45;-90]);
    xd2 = deg2rad([-45;45]);
    % xd3 = deg2rad([-50;-145]);
    xd3 = xd1;

    [r1,r2] = ref_gen(t, T, x0, xd1, xd2, xd3);
end

function [r1,r2] = ref_gen(t, T, x0, xd1, xd2, xd3)

    t = mod(t, 4*T);

    if t < T
        [r1,r2] = poly_filter(x0, xd1, T, t);
    elseif t < 2*T
        [r1,r2] = poly_filter(xd1, xd2, T, (t-T));
    elseif t < 3*T
        [r1,r2] = poly_filter(xd2, xd3, T, (t-2*T));
    else
        [r1,r2] = poly_filter(xd3, x0, T, (t-3*T));
    end
end


function [r1, r2] = poly_filter(x0, xd, T, t)

a0 = x0;
a1 = zeros(2,1);
a2 = zeros(2,1);
a3 = 10*(xd-a0)/T^3;
a4 = -15*(xd-x0)/T^4;
a5 = 6*(xd-a0)/T^5;

r1 = [a0 a1 a2 a3 a4 a5] * [1 t t^2 t^3 t^4 t^5]';
r2 = [a1 a2 a3 a4 a5] * [1 2*t 3*t^2 4*t^3 5*t^4]';

end
function r_func = ref4_load()

r_func = @(t) ref_gen(t);

end

function [r1,r2] = ref_gen(t)
    x0 = deg2rad([-90;0]);  
    xd1 = deg2rad([0;90]);
    xd2 = deg2rad([135;-135]);
    T = 2;    

    t = mod(t, 3*T);

    if t < T
        [r1,r2] = poly_filter(x0, xd1, T, t);
    elseif t < 2*T
        [r1,r2] = poly_filter(xd1, xd2, T, (t-T));
    else
        [r1,r2] = poly_filter(xd2, x0, T, (t-2*T));
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
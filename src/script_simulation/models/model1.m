function [M, C, G, F, J] = model1(q, u, t)
% 2 link manipulator dynamics

%% Parameters
% ********************************************************

m1 = 2.465;             % [kg]
m2 = 2.465;             % [kg]
% m2 = 1.093;
L1 = .2;             % [m]
L2 = .2;             % [m]
% L2 = .15+.01+.02;
Lc1 = .13888;             % [m]
Lc2 = .13888;             % [m]
% Lc2 = .08691;
g = 9.81;             % [m/s^2]

% b1 = 0;             % [Nms]
% b2 = 0;
% fc1 = 0;             % [Nm]
% fc2 = 0;

% b1 = 2.288;             % [Nms]
% b2 = .175;
% fc1 = 7.17;             % [Nm]
% fc2 = 1.734;

b1 = .1;
b2 = .1;
fc1 = .24;
fc2 = .24;
fs1 = .3;
fs2 = .3;

I1 = .06911;
I2 = .06911;
% I2 = .01532;

%% from 10.1109/AFRCON.2013.6757809

% m1 = 23.902;             % [kg]
% m2 = 3.88;
% L1 = .45;             % [m]
% L2 = .45;
% Lc1 = .091;             % [m]
% Lc2 = .048;
% g = 9.81;             % [m/s^2]
% 
% % b1 = 2.288;             % [Nms]
% % b2 = .175;
% % fc1 = 1e1;             % [Nm]
% % fc2 = 3;
% 
% b1 = 2.288;             % [Nms]
% b2 = .175;
% fc1 = 7.17;             % [Nm]
% fc2 = 1.734;
% 
% I1 = 1/12*m1*L1^2;             % [kgm^2]
% I2 = 1/12*m2*L2^2;

%%
q1 = q(1); q2 = q(2);

qd = q(3:4);
qd1 = qd(1); qd2 = qd(2); 

%%
Mmat11=I1+I2+Lc1^2*m1+L1^2*m2+Lc2^2*m2+2*L1*Lc2*m2*cos(q2);
Mmat12=I2+Lc2^2*m2+L1*Lc2*m2*cos(q2);
Mmat21=I2+Lc2^2*m2+L1*Lc2*m2*cos(q2);
Mmat22=I2+Lc2^2*m2;
Cmat11=(-1)*L1*Lc2*m2*sin(q2)*qd2;
Cmat12=(-1)*L1*Lc2*m2*sin(q2)*(qd1+qd2);
Cmat21=L1.*Lc2*m2*sin(q2)*qd1;
Cmat22=0;
Gmat1=g*((Lc1*m1+L1*m2)*cos(q1)+Lc2*m2*cos(q1+q2));
Gmat2=g*Lc2*m2*cos(q1+q2);

Jmat11 = (-1).*L1.*sin(q1)+(-1).*L2.*sin(q1+q2); 
Jmat12 = (-1).*L2.*sin(q1+q2);
Jmat21 = L1.*cos(q1)+L2.*cos(q1+q2); 
Jmat22 = L2.*cos(q1+q2);

f_thr = 1e-3;

Fc1 = fc1*qd1;
Fc2 = fc2*qd2;



if abs(qd1) < f_thr 
    if abs(u(1)) < fs1
        Fmat1 = u(1)-Gmat1;
    else
        if u(1)-Gmat1 >= 0
            Fmat1 = b1*qd1+fc1;
        else
            Fmat1 = b1*qd1-fc1;
        end
    end
else
    if qd1 >=0 
        Fmat1 = fc1 + b1*qd1;
    elseif q(3) < 0
        Fmat1 = -fc1 + b1*qd1;
    end
end

if abs(qd2) < f_thr 
    if abs(u(2)) < fs2
        Fmat2 = u(2)-Gmat2;
    else
        if u(2)-Gmat2 >= 0
            Fmat2 = b2*qd2+fc2;
        else
            Fmat2 = b2*qd2-fc2;
        end
    end
else
    if qd2 >=0 
        Fmat2 = fc2 + b2*qd2;
    elseif qd2 < 0
        Fmat2 = -fc2 + b2*qd2;
    end
end


%%
M = [
    Mmat11 Mmat12
    Mmat21 Mmat22  
    ];
C = [
    Cmat11 Cmat12
    Cmat21 Cmat22  
    ];
G = [
    Gmat1
    Gmat2
    ];
F = [
    Fmat1
    Fmat2
    ];
J = [
    Jmat11 Jmat12
    Jmat21 Jmat22
    ];

end
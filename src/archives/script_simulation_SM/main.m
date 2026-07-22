%% INITIALIZATION
clear  
clc

addpath("models");
addpath('machine_data/')

fprintf("                                   \n");
fprintf("***********************************\n");
fprintf("* Numerical Validation for CONAC   *\n");
fprintf("***********************************\n");

FIGURE_PLOT_FLAG    = 1;    
RESULT_SAVE_FLAG    = 0;
CONTROL_NUM         = 1;    % 1: CoNAC, 2: Aux.
OPT_NUM             = 0;    % parameter options

seed = 10; rng(seed);

Del_t = 0.1;
re_num = 3;
re_time = Del_t * re_num * 4;
start_t = .75;
T = re_time*2 + start_t;

%% SIMULATION SETTING
% T = 1;
% ctrl_dt = 1e-6;
% dt = ctrl_dt;
ctrl_dt = 1/8e3;
dt = ctrl_dt * 1/100;
% ctrl_dt = dt;
rpt_dt = 0.1;
t = 0:dt:T;
seed = 1; rng(seed);

%% SYSTEM DECLARE
grad = @sysGrad_lookup;
data_path = 'machine_data/machine_IPM01.mat';
param = load(data_path);

r_func = @(t, Del_t, re_num, start_t) current_ref(t, Del_t, re_num, start_t);

% r_func = @(t) 1e1*(heaviside(t-1)-heaviside(t-3));
% r_func = @(t) 8e2*(heaviside(t-1)-heaviside(t-3));
% r_func = @(t) 1e3*(heaviside(t-1)-heaviside(t-3));

% r_func = @(t) sin(10*t)*1e2;

% r_func = @(t) 1e3*(heaviside(t-1)-heaviside(t-3)) ...
%     + 5e2*(heaviside(t-5)-heaviside(t-7)) ...
%     + 7e2*(heaviside(t-9)-heaviside(t-11));

w = 66; 
w_rate = 240.855;

x = [0; 0];                     % state: [isd; isq]
u = [0; 0];                     % control input: [vsd; vsq]

%% CONTROLLER LOAD
if CONTROL_NUM == 1    % CoNAC
    ctrl_path = "CoNAC";
elseif CONTROL_NUM == 2 % Aux.
    ctrl_path = "CoNAC-AUX";
elseif CONTROL_NUM == 3 % Complex Aux.
    ctrl_path = "CoNAC-AUX-Comp";
end

addpath("controllers/"+ctrl_path);
addpath(genpath('controllers/'+ctrl_path));

% opt = loadOpts(ctrl_dt);
addpath("controllers");
opt = loadGlobalOpts(ctrl_dt, CONTROL_NUM, OPT_NUM);

initControl;

%% RECORDER INITIALIZATION
addpath("recorder");
recInit;

%% ADDITIONAL SETTINGS
LPF = 0.01; 
pre_xd = [0;0];

%% MAIN SIMULATION
% ********************************************************
fprintf("Simulation Start\n");

for t_idx = 2:1:num_t
    % w; 0 -> w_rate during 0.5s;
    w = min(w_rate, w + w_rate*dt/0.5);
    % w = w_rate;

    xd = r_func(t(t_idx), Del_t, re_num, start_t);  % reference current

    e = x - xd;                      % current error
    x_in = [x;xd];      

    if t_idx==2 || rem(t(t_idx)/dt, ctrl_dt/dt) == 0
        preControl
        postControl
    end

    % control input saturation
    if norm(u) > opt.cstr.u_ball
        u_sat = u/norm(u) * opt.cstr.u_ball;
    else 
        u_sat = u;
    end

    % u_sat = sat(u, opt, CONTROL_NUM);

    % error check
    assert(~isnan(norm(u)));
    
    % step forward
    % angular velocity update is not considered for simplicity
    grad_val = grad(w, x, u_sat, param);
    x = x + grad_val(2:3) * dt; % step forward with Euler method

    recRecord;

    % simulation report
    if rem(t(t_idx)/dt, rpt_dt/dt) == 0
        fprintf("Time Step %.2f/%.2fs (%.2f%%)\r",t(t_idx), T, t(t_idx)/T*100);
    end
    
end
fprintf("Simulation End\n");
fprintf("\n");

if FIGURE_PLOT_FLAG
    addpath("utils");
    plot_wrapper;
end

if RESULT_SAVE_FLAG
    fprintf("[INFO] Result Saving...\n");
    whatTimeIsIt = string(datetime('now','Format','d-MMM-y_HH-mm-ss'));

    if CONTROL_NUM == 1 
        % [~,~] = mkdir("sim_result/"+whatTimeIsIt);
        save("sim_result/"+whatTimeIsIt+".mat", ...
            "t", "x_hist", "xd_hist", ...
            "u_hist", "uSat_hist", "lbd_hist", "th_hist", ...
            "opt", "T" ...
            );
        fprintf("Saved: \n%s\n", whatTimeIsIt)
    elseif CONTROL_NUM == 2
        % [~,~] = mkdir("sim_result/"+whatTimeIsIt);
        save("sim_result/"+whatTimeIsIt+".mat", ...
            "t", "x_hist", "xd_hist", ...
            "u_hist", "uSat_hist", "zeta_hist", "th_hist", ...
            "opt", "T" ...
            );
        fprintf("Saved: \n%s\n", whatTimeIsIt)
    end

    fprintf("Saved: \n%s\n", whatTimeIsIt)
end

%% LOCAL FUNCTIONS
% function id = current_ref(cur_t)
%         Del_t = 0.1;
%         Del_xd = 2.5;
% 
%         k1 = fix( (cur_t+Del_t/2)/Del_t );
%         k2 = fix( cur_t/Del_t );
% 
%         id = [
%             (-1)^k1 * k1*Del_xd;
%             (-1)^k2 * k2*Del_xd;
%         ];
% end

function xd = current_ref(cur_t, Del_t, re_num, start_t)
t = cur_t-start_t;
t = max(t,0);

% Appetizer
% if t > 0.2
% xd = [1;1] * 5;
% else
% xd = [0;0];
% end


%%
% xd = [
%     sin(t);
%     -sin(t)
% ] * 5;

%% REF1: from Niklas's paper
k1 = fix( t/Del_t );
k2 = fix( (t+Del_t/2)/Del_t );

re_time = Del_t * re_num * 4;
resetIndex = fix(re_time/Del_t);

k1 = mod(k1, resetIndex);
k2 = mod(k2, resetIndex);


xd = ref_gen(k1, k2, re_num);

%% 
% Del_t = 0.1;
% Del_xd = 5;
% 
% k1 = fix( (t+Del_t/2)/Del_t );
% k2 = fix( t/Del_t );
% 
% xd = [
%     (-1)^k1 * k1*Del_xd;
%     (-1)^k2 * k2*Del_xd;
% ];


end

function xd = ref_gen(k1, k2, re_num)
    max_i = 4.19;

    Del_xd_d = max_i /re_num;
    Del_xd_q = max_i /re_num;

    xd = [ 
        (-1)^(fix((k1+1)/2+1));
        (-1)^(fix((k2+1)/2+1));
    ];
    xd = xd .* [
        fix((k1+3)/4)*Del_xd_d
        fix((k2+3)/4)*Del_xd_q
    ];
    xd = xd.* [ 
        mod(k1, 2)
        mod(k2, 2)
    ];
    xd = xd .* [-sign(xd(1)); -1];

end


function grad = sysGrad_lookup(w, i, u, param)
    J = [0 -1; 1 0];

    % current vectors / grids
    isd = param.machine.psi.s.arg.isd;
    isq = param.machine.psi.s.arg.isq;
    omegaP = param.machine.psi.s.arg.omegaP;

    % flux linkages
    PSISD = param.machine.psi.s.d;
    PSISQ = param.machine.psi.s.q;

    % differential inductances
    LSDD = param.machine.L.s.dd;
    LSDQ = param.machine.L.s.dq;
    LSQD = param.machine.L.s.qd;
    LSQQ = param.machine.L.s.qq;

    % dummy data
    R = eye(2) * param.machine.Rs;
    
    np = param.machine.nP;               
    kappa = param.machine.kappa;          
    Theta = param.machine.ThetaM;

    L_dd_grid = griddedInterpolant({isd, isq, omegaP}, LSDD, 'linear', 'linear');
    L_dq_grid = griddedInterpolant({isd, isq, omegaP}, LSDQ, 'linear', 'linear');
    L_qd_grid = griddedInterpolant({isd, isq, omegaP}, LSQD, 'linear', 'linear');
    L_qq_grid = griddedInterpolant({isd, isq, omegaP}, LSQQ, 'linear', 'linear');

    L_dd = L_dd_grid(i(1), i(2), w);
    L_dq = L_dq_grid(i(1), i(2), w);
    L_qd = L_qd_grid(i(1), i(2), w);
    L_qq = L_qq_grid(i(1), i(2), w);

    psi_q_grid = griddedInterpolant({isd, isq, omegaP}, PSISQ, 'linear', 'linear');
    psi_d_grid = griddedInterpolant({isd, isq, omegaP}, PSISD, 'linear', 'linear');

    psi_d = psi_d_grid(i(1), i(2), w);
    psi_q = psi_q_grid(i(1), i(2), w);

    % L_dd = interp3(isq, isd, omegaP, LSDD, i(2), i(1), w);
    % L_dq = interp3(isq, isd, omegaP, LSDQ, i(2), i(1), w);
    % L_qd = interp3(isq, isd, omegaP, LSQD, i(2), i(1), w);
    % L_qq = interp3(isq, isd, omegaP, LSQQ, i(2), i(1), w);
    L = [L_dd, L_dq; L_qd, L_qq];
    L = L*1;

    % psi_d = interp3(isq, isd, omegaP, PSISD, i(2), i(1), w);
    % psi_q = interp3(isq, isd, omegaP, PSISQ, i(2), i(1), w);
    psi = [psi_d; psi_q];
    psi = psi*1;


    trq = (2*np)/(3*kappa^2) * i'*J*psi;
    % trq = (k1+k2*i(1)) * i(2);
    % trq_l = 1*sign(w);
    trq_l = 0;
    grad1 = 1/Theta * (trq - trq_l);   

    inv_L = matInv22(L);
    grad2 = inv_L * (-R*i - w/np*J*psi + u);

    grad = [grad1; grad2];
end

function trq = trqCalc(i)

    L = [
        0.45     0;
        0     0.66
    ] * 1e-3;
    np = 8;               
    bias_psi = [0.0563; 0];

    k1 = 1.5*np*bias_psi(1);
    k2 = 1.5*np*(L(1,1) - L(2,2));
    k3 = k1/(2*k2);

    trq = (k1+k2*i(1)) * i(2);
end

function inv_M = matInv22(M)
    det = M(1,1)*M(2,2) - M(1,2)*M(2,1);
    assert(det ~= 0, 'Matrix is singular and cannot be inverted')

    inv_M = (1/det) * [
        +M(2,2), -M(1,2); 
        -M(2,1), +M(1,1)
    ];
end

function y = linear_interpolate(x, x1, x2, y1, y2)
    % y = (y2-y1)/(x2-x1) * (x - x1) + y1     
    y = (y2-y1)/(x2-x1) * (x-x1) + y1;
end

function z = bilinear_interpolate(x,y, x1,x2,y1,y2, z11,z12,z21,z22)
    z1 = linear_interpolate(x, x1, x2, z12, z22);
    z2 = linear_interpolate(x, x1, x2, z11, z21);
    z = linear_interpolate(y, y1, y2, z2, z1);
end

function y = interpolate_from_table(x,y, X,Y, Z)
    x_idx = find(X >= x); x_idx = x_idx(1);
    y_idx = find(Y >= y); y_idx = y_idx(1);

    x_upper = X(x_idx); x_lower = X(x_idx-1);
    y_upper = Y(y_idx); y_lower = Y(y_idx-1);

    z_ul = Z(x_idx-1, y_idx-1);
    z_uu = Z(x_idx, y_idx-1);
    z_ll = Z(x_idx-1, y_idx);
    z_lu = Z(x_idx, y_idx);

    y = bilinear_interpolate(x, y, x_lower, x_upper, y_lower, y_upper, z_ul, z_uu, z_ll, z_lu);
end
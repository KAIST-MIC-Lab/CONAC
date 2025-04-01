clear

%% SIMULATION SETTING
sim_name = "demo1.slx";
ctrl_dt = 1/250;
dt = 1/10000;
T = 50;

%% SYSTEM DECLARE
x1 = [deg2rad(-90);0];  
x2 = [0;0];
u = [0;0];

%% CONTROLLER LOAD
opt = loadOpts(ctrl_dt);

%%
alp = opt.alpha;
rho = opt.rho;
NN_size = opt.NN_size;
Lambda = opt.Lambda;
th_max = opt.cstr.th_max;
u_ball = opt.cstr.u_ball;
beta = opt.beta;

%% INITIAL WEIGHTS
th = (rand(opt.th_size,1)-1/2)*2*opt.init_range;
lbd = zeros(4, 1);

%% SIM
fprintf("SIMULATION IS RUNNING\n")
sim_result = sim(sim_name);
fprintf("SIMULATION TERMINATED\n")

%% MAIN PLOTTER
% error("change the plotter to use generally")
% demo1_plot(sim_result, opt);

%% LOCAL FUNCTIONS
function opt = loadOpts(dt)
    opt.dt = dt;

    opt.e_tol = 0e-3;
    opt.init_range = 1e-3;
    
    opt.Lambda = diag([1 1]) * 5e0;

    opt.alpha = 15e-1;
    opt.rho = opt.alpha*0e-2;
    opt.NN_size = [6,4,4,2];
    opt.W = 1;
    opt.e_size = 2;

    % opt.beta = [1 1 1] * 1e-1;
    opt.beta(1:3) = [1 1 1] * 1e-3;
    opt.beta(4) = 1e2; % control ipnut
    opt.cstr.th_max = [11;12;13] * 1e0;
    opt.cstr.u_ball = 6;

    c_num = length(opt.beta);
    opt.lbd = zeros(c_num,1);
    
%% PASSIVE NUMBER
    % layer number
    opt.l_size = length(opt.NN_size);
    % total tape number
    opt.tp_size = sum(opt.NN_size(1:end-1));
    % total weight number (will be calc-ed)
    opt.th_size_list = zeros(opt.l_size-1 ,1);    
    for idx = 1:1:opt.l_size-1
        opt.th_size_list(idx) = (opt.NN_size(idx)+1) * opt.NN_size(idx+1);
    end

    opt.th_size = sum(opt.th_size_list);    

end

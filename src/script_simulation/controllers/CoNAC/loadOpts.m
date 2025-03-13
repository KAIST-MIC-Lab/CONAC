function opt = loadOpts(dt)
    opt.dt = dt;

    opt.e_tol = 0e-3;
    opt.init_range = 1e-3;
    
    opt.Gamma = diag([1 1]);

    opt.alpha = 10e-0;
    opt.rho = opt.alpha*0e-0;
    opt.NN_size = [5,8,2];
    opt.W = 1;
    opt.e_size = 2;

    % opt.beta(1:2) = [1 1] * 0e0;
    % opt.beta(3) = 1e0;
    % opt.beta(4) = 10e-1;
    % opt.beta(5) = 50e-1;

    % opt.beta = [1 1 1] * 1e-1;
    opt.beta(1:2) = [1 1] * 0e0;
    opt.beta(3) = 5e1; % control ipnut
    opt.beta(4) = 0e-1; % state 
    opt.beta(5) = 0e1; % torque
    opt.cstr.V_max = [1; 1] * 15e0;
    % opt.cstr.u_ball = 159.0023;
    opt.cstr.x_ball = 25e0;
    opt.cstr.tau_ball = 5e0;
    opt.cstr.u_ball = 10;

    c_num = length(opt.beta);
    opt.Lambda = zeros(c_num,1);
    
%% PASSIVE NUMBER
    % layer number
    opt.l_size = length(opt.NN_size);
    % total tape number
    opt.t_size = sum(opt.NN_size(1:end-1));
    % total weight number (will be calc-ed)
    opt.v_size_list = zeros(opt.l_size-1 ,1);    
    for idx = 1:1:opt.l_size-1
        opt.v_size_list(idx) = (opt.NN_size(idx)+1) * opt.NN_size(idx+1);
    end

    opt.v_size = sum(opt.v_size_list);    

end

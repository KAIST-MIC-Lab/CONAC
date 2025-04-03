function opt = loadGlobalOpts(dt, CONTROL_NUM)
    opt.dt = dt;

    opt.e_tol = 0e-3;
    opt.init_range = 1e-3;
    
    opt.Lambda = diag([1 1]) * 5e0;

    opt.alpha = 7.5e-1;
    opt.rho = opt.alpha*0e-2;
    opt.NN_size = [6,4,4,2];
    opt.W = 1;
    opt.e_size = 2;

    opt.cstr.th_max = [11;12;13] * 1e0;
    opt.cstr.u_ball = 6.5;
    opt.cstr.uMax1 = 6;
    opt.cstr.uMax2 = 2.5;

    if CONTROL_NUM == 1
        % opt.beta = [1 1 1] * 1e-1;
        opt.beta(1:3) = [1 1 1] * 0e-3;
        opt.beta(4) = 1e3; % control ipnut ball
        opt.beta(5) = 1e3; % control ipnut 1 Max
        opt.beta(6) = 0e4; % control ipnut 2 Max
        opt.beta(7) = opt.beta(5); % control ipnut 1 Min
        opt.beta(8) = opt.beta(6); % control ipnut 2 Min
        opt.beta = opt.beta/opt.alpha;

        c_num = length(opt.beta);
        opt.lbd = zeros(c_num,1);

    elseif CONTROL_NUM == 2
        opt.A_zeta = -10 * eye(2);
        opt.B_zeta = 1000 * eye(2);
    end
    
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

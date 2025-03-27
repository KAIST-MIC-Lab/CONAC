function nnOpt = nn_opt_load(dt)
    nnOpt.dt = dt;

    nnOpt.e_tol = 0e-3;
    nnOpt.init_range = 1e-3;
    
    nnOpt.A = -1;
    nnOpt.B = -[1 0; 0 -1];

    nnOpt.alpha = .5e3;
    nnOpt.alp_norm = 1;
    nnOpt.rho = nnOpt.alpha*0e-1;
    nnOpt.NN_size = [4,16,2];
    nnOpt.W = 1;
    nnOpt.e_size = 1;

    % nnOpt.beta = [0 0 5] * 1e-1;
    % nnOpt.beta = [1 1 5] * 1e-1;
    nnOpt.beta = [1 1] * 1e-1;
    nnOpt.beta = [nnOpt.beta 0e-1]; % control input
    nnOpt.beta = [nnOpt.beta 10e-1]; % state
    % nnOpt.beta(5) = 0; % torque
    nnOpt.cstr.V_max = [1; 1] * 1e0 * 5e2;
    nnOpt.cstr.u_ball = 150;
    nnOpt.cstr.x_ball = 2;
    % nnOpt.cstr.tau_ball = 0;


    c_num = length(nnOpt.beta);
    nnOpt.Lambda = zeros(c_num,1);
    
    nnOpt = numbersCalc(nnOpt);
    
end

%% LOCAL FUNCTIONS
function nnOpt = numbersCalc(nnOpt)
    %% NUMBERS
    % layer number
    nnOpt.l_size = length(nnOpt.NN_size);
    % total tape number
    nnOpt.t_size = sum(nnOpt.NN_size(1:end-1));
    % total weight number (will be calc-ed)
    nnOpt.v_size_list = zeros(nnOpt.l_size-1 ,1);    
    for idx = 1:1:nnOpt.l_size-1
        nnOpt.v_size_list(idx) = (nnOpt.NN_size(idx)+1) * nnOpt.NN_size(idx+1);
                  
    end

    nnOpt.v_size = sum(nnOpt.v_size_list);    

end
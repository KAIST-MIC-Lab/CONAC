function nnOpt = optLoad(dt)
    nnOpt.dt = dt;

    nnOpt.e_tol = 0e-3;
    nnOpt.init_range = 1e-3;
    
    nnOpt.Gamma = diag([1 1]);

    nnOpt.alpha = 10e-0;
    nnOpt.rho = nnOpt.alpha*0e-0;
    nnOpt.NN_size = [5,8,2];
    nnOpt.W = 1;
    nnOpt.e_size = 2;

    % nnOpt.beta(1:2) = [1 1] * 0e0;
    % nnOpt.beta(3) = 1e0;
    % nnOpt.beta(4) = 10e-1;
    % nnOpt.beta(5) = 50e-1;

    % nnOpt.beta = [1 1 1] * 1e-1;
    nnOpt.beta(1:2) = [1 1] * 0e0;
    nnOpt.beta(3) = 5e1; % control ipnut
    nnOpt.beta(4) = 0e-1; % state 
    nnOpt.beta(5) = 0e1; % torque
    nnOpt.cstr.V_max = [1; 1] * 15e0;
    % nnOpt.cstr.u_ball = 159.0023;
    nnOpt.cstr.x_ball = 25e0;
    nnOpt.cstr.tau_ball = 5e0;
    nnOpt.cstr.u_ball = 10;

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
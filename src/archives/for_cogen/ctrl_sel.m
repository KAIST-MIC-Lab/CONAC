function CONAC( ...
    CONTROL_NUM, ...    % (1 x 1) controller index
    q_arr, ...          % (2 x 1) joint angle array
    r_arr, ...          % (2 x 1) reference state array  
    qdot_arr, ...       % (2 x 1) joint velocity array
    rdot_arr, ...       % (2 x 1) reference state derivative array
    rddot_arr, ...      % (2 x 1) reference state second derivative array
    th, ...             % (58 x 1) neural network weight array
    lbd, ...            % (8 x 1) neural network multiplier array
    zeta, ...           % (2 x 1) auxiliary state array
    out, ...            % (2 x 1) output array
    Vn ...              % (3 x 1) neural network weight norm array
    )
    
    % CONTROLLER INDEX
    % -----------------------------------------------
    % 1 - PROPOSED CONAC
    % 2 - PROPOSED CONAC (smaller beta)
    % 3 - NAC with Aux. Sys.
    % 4 - NAC without input constraints

    % -- hard coded parameters --
    % A_zeta, ...         % (2 x 2) auxiliary system matrix A
    % B_zeta, ...         % (2 x 2) auxiliary system matrix B
    % alp, ...            % (1 x 1) neural network learning rate
    % ctrl_dt, ...        % (1 x 1) control time step
    % th_max, ...         % (1 x 1) neural network weight limit
    % u_ball, ...         % (1 x 1) input limit
    % u1_max, ...         % (1 x 1) input limit for u1
    % u2_max, ...         % (1 x 1) input limit for u2
    % Lambda_arr, ...     % (2 x 2) error filter
    % beta, ...           % (8 x 1) multiplier update rate

    A_zeta = diag([1e1, 1e1]);
    B_zeta = diag([1e3, 1e3]);
    alp = 0.2;
    ctrl_dt = 1/250;
    th_max = [6;6;6];
    u_ball = 11;
    u1_max = 10.428;
    u2_max = 3.5;
    Lambda = diag([5,15]);
    beta = [1,1,1,10,0,0,100,100]';

    l_size = 4;
    tp_size = 14;
    th_size_list = [28, 20, 10];
    th_size = 58;

    % 
    fil_x = qdot_arr + Lambda*q_arr;
    fil_xd = rdot_arr + Lambda*r_arr;
    fil_xdd = rddot_arr + Lambda*rdot_arr;

    e = fil_x - fil_xd;

    %% FEEDFORWAD 
    % ================================================
    %     FEEDFORWARD (CONTROL INPUT CALCULATION)
    % ================================================
    pt_V = 1;
    Vn = zeros(l_size-1, 1);

    % neural network input
    in = [fil_xd;fil_xdd;fil_x]; 

    %% FORWARD (layer 1)
    n = NN_size(1)+1;
    m = NN_size(2);

    V0 = zeros(n,m);
    th_index = pt_V;
    for j = 1:m
        for i = 1:n
            V0(i,j) = th(th_index);
            th_index = th_index +1;
        end
    end
    in0 = [in; 1];

    out0 = V0'*in0;
    Vn(1) = norm(V0);

    % pointer to next
    pt_V = pt_V + (n*m);

    %% FORWARD (layer 2)
    n = NN_size(2)+1;
    m = NN_size(3);

    V1 = zeros(n,m);
    th_index = pt_V;
    for j = 1:m
        for i = 1:n
            V1(i,j) = th(th_index);
            th_index = th_index +1;
        end
    end
    in1 = [tanh(out0); 1];

    out1 = V1'*in1;
    Vn(2) = norm(V1);

    % pointer to next
    pt_V = pt_V + (n*m);

    %% FORWARD (layer 3)
    n = NN_size(3)+1;
    m = NN_size(4);

    V2 = zeros(n,m);
    th_index = pt_V;
    for j = 1:m
        for i = 1:n
            V2(i,j) = th(th_index);
            th_index = th_index +1;
        end
    end
    in2 = [tanh(out1); 1];

    out2 = V2'*in2;
    Vn(3) = norm(V2);

    % pointer to next
    pt_V = pt_V + (n*m);
    
    %% RESULT
    assert(pt_V-1 == th_size)
    
    out = out2;

    %% NN GRADIENT CALCULATION
    % ================================================
    %       NEURAL NETWORK JACOBIAN CALCULATION
    % ================================================
    %% BACKPROPAGATION (layer end-0)    
    l2 = NN_size(4);        
    grad2 = kron(eye(l2), in2');

    %% BACKPROPAGATION (layer end-1)
    l2 = NN_size(3);        
    phi_dot2 = tanh_dot(out1);
    grad1 = V2'*phi_dot2*kron(eye(l2), in1');
    
    %% BACKPROPAGATION (layer end-2)    
    l2 = NN_size(2);        
    phi_dot1 = tanh_dot(out0);
    grad0 = V2'*phi_dot2*V1'*phi_dot1*kron(eye(l2), in0');

    %% RESULT
    nnGrad = [grad0 grad1 grad2];

    % ===============================================
    % Input constraint handling
    % ===============================================
    if CONTROL_NUM == 1 || CONTROL_NUM == 2
        
        %% CONSTRAINT FUNCTION CALCULATION
        % ball condition 
        cumsum_V = [0;cumsum(th_size_list)];
        c_b = (Vn.^2 - th_max.^2) ./ 2;
        % input ball 
        c_ub = (norm(out)^2 - u_ball^2) ./ 2;
        % input saturation
        c_uM1 = out(1) - u1_max;
        c_uM2 = out(2) - u2_max;
        c_um1 = -u1_max - out(1);
        c_um2 = -u2_max - out(2);
        % summary
        c = [c_b; c_ub; c_uM1; c_uM2; c_um1; c_um2];

        %% CONSTRAINT GREADIENT (dC/dth)
        cd = zeros(lbd_size, th_size);

        for l_idx = 1:1:length(th_max)
            start_pt = cumsum_V(l_idx)+1;
            end_pt = cumsum_V(l_idx+1);
            cd(l_idx, start_pt:end_pt) = th(start_pt:end_pt,1);
        end
        
        cd(l_idx+1:end, :) = [
            out(1)*nnGrad(1,:) + out(2)*nnGrad(2,:);
            nnGrad(1,:);
            nnGrad(2,:);
            -nnGrad(1,:);
            -nnGrad(2,:);
        ];

    elseif CONTROL_NUM == 3
        del_u = zeros(2,1);
        if u(1) > u1_max
            del_u(1) = out(1) - u1_max;
        elseif u(1) < -u1_max
            del_u(1) = out(1) + u1_max;
        end
        if u(2) > u2_max
            del_u(2) = out(2) - u2_max;
        elseif u(2) < -u2_max
            del_u(2) = out(2) + u2_max;
        end

        zeta_grad = -A_zeta'*zeta + B_zeta'*del_u;
        zeta = zeta + zeta_grad * ctrl_dt;
    end


    %% BACKPROPAGATION 
    % ================================================
    %     BACKPROPAGATION (NEURAL NETWROK UPDATE)
    % ================================================
    if CONTROL_NUM == 1 || CONTROL_NUM == 2
        th_grad = -alp*nnGrad'*e; % dJ/dth
        th_grad = th_grad - alp* cd' * lbd; % dC/dth

        lbd_grad = diag(beta) * c;

        th = th + th_grad * ctrl_dt;
        lbd = lbd + lbd_grad * ctrl_dt;
        lbd = max(lbd, 0);

    elseif CONTROL_NUM == 3
        th_grad = -alp*nnGrad'*(e+zeta); % dJ/dth
        th = th + th_grad * ctrl_dt;

    elseif CONTROL_NUM == 4
        th_grad = -alp*nnGrad'*e; % dJ/dth
        th = th + th_grad * ctrl_dt;

    end

    return
end

%% LOCAL FUNCTIONS
function phi_dot = tanh_dot(Phi)
    phi_dot = zeros(length(Phi)+1, length(Phi));
    for idx = 1:1:length(Phi)
        phi_dot(idx,idx) = 1-tanh(Phi(idx))^2;
    end
end











function [c, cd] = nn_cstr(nn, nnOpt, x, u_NN, nnGrad)
    %% CONSTRAINTS PARAMETERS
    V_max = nnOpt.cstr.V_max;
    u_ball = nnOpt.cstr.u_ball;
    x_ball = nnOpt.cstr.x_ball;
    % tau_ball = nnOpt.cstr.tau_ball;

    %% ERROR CHECK
    assert(length(V_max) == nnOpt.l_size-1)
    
    %% ACTIVE SET CHECK
    % ball condition
    c_b = zeros(nnOpt.l_size-1, 1);
    
    cumsum_V = [0;cumsum(nnOpt.v_size_list)];
    for l_idx = 1:1:nnOpt.l_size-1
        start_pt = cumsum_V(l_idx)+1;
        end_pt = cumsum_V(l_idx+1);   

        c_b(l_idx) = norm(nn.V(start_pt: end_pt))^2 ...
            - V_max(l_idx)^2;
    end
    
    % input ball
    u = -u_NN;
    c_ub = norm(u)^2 - u_ball^2;

    % state ball
    c_xb = norm(x)^2 - x_ball^2;

    % torque ball
    % c_tau = trq^2 - tau_ball^2;

    % summary
    c = [c_b; c_ub; c_xb];
    
    %% ACTIVE SET CONSTRAINT GRADIENT CALC
    cd = zeros(length(c), nnOpt.v_size);
    for l_idx = 1:1:length(V_max)
        start_pt = cumsum_V(l_idx)+1;
        end_pt = cumsum_V(l_idx+1);
        cd(l_idx, start_pt:end_pt) = 2 * nn.V(start_pt:end_pt,1);
    end

    if length(x) == 1    
        cd(l_idx+1:end, :) = [
            2*u(1)*-nnGrad(1,:) + 2*u(2)*-nnGrad(2,:)
            zeros(1, nnOpt.v_size)
            zeros(1, nnOpt.v_size)
        ];
    else
        cd(l_idx+1:end, :) = [
            2*u(1)*-nnGrad(1,:) + 2*u(2)*-nnGrad(2,:)
            -(2*x(1)*-nnGrad(1,:) - 2*x(2)*-nnGrad(2,:))
            % trq*(-nnGrad(1,:)+nnGrad(2,:))
        ];
    end
end










function [c, cd] = nnCstr(nn, opt, u_NN, nnGrad)
    %% CONSTRAINTS PARAMETERS
    V_max = opt.cstr.V_max;
    u_ball = opt.cstr.u_ball;
    
    %% ERROR CHECK
    assert(length(V_max) == opt.l_size-1)
    
    %% ACTIVE SET CHECK
    % ball condition
    c_b = zeros(opt.l_size-1, 1);
    
    cumsum_V = [0;cumsum(opt.v_size_list)];
    for l_idx = 1:1:opt.l_size-1
        start_pt = cumsum_V(l_idx)+1;
        end_pt = cumsum_V(l_idx+1);   

        c_b(l_idx) = norm(nn.V(start_pt: end_pt))^2 ...
            - V_max(l_idx)^2;
    end
    
    % input saturation 
    u = -u_NN;
    
    % input ball
    c_ub = norm(u)^2 - u_ball^2;

    % summary
    c = [c_b; c_ub];
    
    %% ACTIVE SET CONSTRAINT GRADIENT CALC
    cd = zeros(length(c), opt.v_size);
    for l_idx = 1:1:length(V_max)
        start_pt = cumsum_V(l_idx)+1;
        end_pt = cumsum_V(l_idx+1);
        cd(l_idx, start_pt:end_pt) = 2 * nn.V(start_pt:end_pt,1);
    end
    
    cd(l_idx+1:end, :) = 2*u(1)*-nnGrad(1,:) + 2*u(2)*-nnGrad(2,:);
end










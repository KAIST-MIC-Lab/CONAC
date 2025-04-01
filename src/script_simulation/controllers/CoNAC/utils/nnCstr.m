function [c, cd] = nnCstr(nn, opt, u_NN, nnGrad)
    %% CONSTRAINTS PARAMETERS
    th_max = opt.cstr.th_max;
    u_ball = opt.cstr.u_ball;
    
    %% ERROR CHECK
    assert(length(th_max) == opt.l_size-1)
    
    %% ACTIVE SET CHECK
    % ball condition
    c_b = zeros(opt.l_size-1, 1);
    
    cumsum_th = [0;cumsum(opt.th_size_list)];
    for l_idx = 1:1:opt.l_size-1
        start_pt = cumsum_th(l_idx)+1;
        end_pt = cumsum_th(l_idx+1);   

        c_b(l_idx) = norm(nn.th(start_pt: end_pt))^2 ...
            - th_max(l_idx)^2;
    end
    
    % input saturation 
    u = u_NN;
    
    % input ball
    c_ub = norm(u)^2 - u_ball^2;

    % summary
    c = [c_b; c_ub];
    
    %% ACTIVE SET CONSTRAINT GRADIENT CALC
    cd = zeros(length(c), opt.th_size);
    for l_idx = 1:1:length(th_max)
        start_pt = cumsum_th(l_idx)+1;
        end_pt = cumsum_th(l_idx+1);
        cd(l_idx, start_pt:end_pt) = 2 * nn.th(start_pt:end_pt,1);
    end
    
    cd(l_idx+1:end, :) = 2*u(1)*nnGrad(1,:) + 2*u(2)*nnGrad(2,:);
end










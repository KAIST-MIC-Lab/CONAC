function [nn, nnOpt, dot_L, info] = nn_backward(nn, nnOpt, x, e, u_NN)

    %% NN GRADIENT CALCULATION
    nnGrad = nn_nnGradient(nn, nnOpt);

    % dead-zone
    if norm(e) < nnOpt.e_tol
        info = NaN;
        % dot_L = norm(V_grad);
        dot_L = norm(0);
        return;
    end

    %% UPDATE
    % dynamical gradient
    A = nnOpt.A;
    B = nnOpt.B;

    nn.eta = nn.eta + (A*nn.eta+B*-nnGrad) * nnOpt.dt;

    % active set check
    [c, cd] = nn_cstr(nn, nnOpt, x, u_NN, nnGrad);

    ActSet  = double(c>0);
    % Lambda  = nnOpt.Lambda .* ActSet;
    % c       = double(c .* ActSet);
    % cd      = double(cd .* ActSet);
    Lambda  = nnOpt.Lambda;

    % find gradient; theta, lambda
    % alp = nnOpt.alpha * norm(e) * 1e-1;
    % alp = nnOpt.alpha * (1 + min(norm(e), nnOpt.alp_norm)/nnOpt.alp_norm);
    % alp = nnOpt.alpha * (1+norm(e));
    alp = nnOpt.alpha;

    if norm(e) >15
        disp("")
    end

    % if length(x) == 1    
    %     V_grad = - alp * (-nnGrad'*B'*nnOpt.W*e + cd' * Lambda);
    % 
    % else
    %     Lambda(end) = 0;
    %     cx = x'*x - nnOpt.cstr.x_ball^2;
    %     cdx = -(2*x(1)*-nnGrad(1,:) + 2*x(2)*-nnGrad(2,:));
    %     V_grad = - alp * (-nnGrad'*B'*nnOpt.W*e + cd' * Lambda);
    %     V_grad = V_grad + alp * nnOpt.beta(end) * 1/cx * cdx;
    % end

    V_grad = - alp * (-nnGrad'*B'*nnOpt.W*e + (cd)' * Lambda);
    % V_grad = - alp * (nn.eta'*nnOpt.W*e + cd' * Lambda);
    V_grad = V_grad - nnOpt.rho * nn.V * norm(e);
    L_grad = diag(nnOpt.beta) * c;

    V_grad = V_grad * nnOpt.dt;
    L_grad = L_grad * nnOpt.dt;

    % update mupliers
    nnOpt.Lambda = Lambda + L_grad;
    nnOpt.Lambda = max(nnOpt.Lambda, 0);

    nn.V = nn.V + V_grad;

    %% TERMINATION
    dot_L = norm(V_grad);
    info.state = NaN;

    info.EIG = svd((B-alp*eye(2)) * nnGrad);
    
end
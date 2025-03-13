function [nn, opt] = nnBackward(nn, opt, e, u_NN)

    %% NN GRADIENT CALCULATION
    nnGrad = nnGradient(nn, opt);

    % dead-zone
    if norm(e) < opt.e_tol
        return;
    end

    %% UPDATE
    % active set check
    [c, cd] = nnCstr(nn, opt, u_NN, nnGrad);

    % ActSet  = double(c>0);
    Lambda  = opt.Lambda;

    % find gradient; theta, lambda
    V_grad = - opt.alpha * (nnGrad'*opt.W*e + cd'*Lambda);
    L_grad = diag(opt.beta) * c;

    V_grad = V_grad * opt.dt;
    L_grad = L_grad * opt.dt;

    % update
    nn.V = nn.V + V_grad;
    opt.Lambda = Lambda + L_grad;
    opt.Lambda = max(opt.Lambda, 0);

    %% TERMINATION
    
end
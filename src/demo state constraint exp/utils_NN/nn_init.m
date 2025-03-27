function nn = nn_init(nnOpt)
    %% MATRICES PRE-ALLOCATION
    nn.V = (rand(nnOpt.v_size,1)-1/2)*2*nnOpt.init_range;
    nn.tape = zeros(nnOpt.t_size, 1);

    nn.eta = zeros(nnOpt.e_size, nnOpt.v_size);

end
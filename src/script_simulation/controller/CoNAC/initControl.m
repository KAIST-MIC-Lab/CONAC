
%% NEURAL NETOWORK INITIAILIZATION
nn.V = (rand(opt.v_size,1)-1/2)*2*opt.init_range;
nn.tape = zeros(opt.t_size, 1);

nn.eta = zeros(opt.e_size, opt.v_size);
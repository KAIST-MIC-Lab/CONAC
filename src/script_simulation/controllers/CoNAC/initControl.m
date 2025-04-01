
%% NEURAL NETOWORK INITIAILIZATION
nn.th = (rand(opt.th_size,1)-1/2)*2*opt.init_range;
nn.tape = zeros(opt.tp_size, 1);

x_in = [x1;x2;r];                           % NN input vector 

fil_x = x2 + opt.Lambda*x1;
fil_xd = xd2 + opt.Lambda*xd1;
fil_xdd = xd3 + opt.Lambda*xd2;

x_in = [fil_xd; fil_xdd; fil_x];
[nn, u_NN] = nnForward(nn, opt, x_in);      % NN forward propagation
u = u_NN;                           % control input (before saturation)   




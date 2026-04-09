
x_in = [w;x;xd];                           % NN input vector 
[nn, u_NN] = nnForward(nn, opt, x_in);      % NN forward propagation
u = u_NN;                           % control input (before saturation)   




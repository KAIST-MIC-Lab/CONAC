
x_in = [x1;x2;r];                           % NN input vector 
[nn, u_NN] = nnForward(nn, opt, x_in);      % NN forward propagation
u = u_NN;                           % control input (before saturation)   




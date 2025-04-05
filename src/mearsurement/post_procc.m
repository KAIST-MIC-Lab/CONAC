function data = post_procc(path)

    data = readtable(path);
    data = data{1:end-1, 1:28};

    del_ts = [0.001, 0.004];
    pt = [];

    for idx = 1:length(del_ts)
        del_t = del_ts(idx);
        tmp_pt = find((data(2:end,1) - data(1:end-1,1) - del_t).^2 < 1e-6);
        
        pt = union(pt, tmp_pt);
    end

    tmp_pt = find((data(2:end,7) - data(1:end-1,7)).^2 > 1e-2);
    pt = setdiff(pt, tmp_pt);

    pt = setdiff(pt, find(data(:,2).^2 < 1e-6));

    data = data(pt, :);

end


% elapsedTime,
% CONTROL_FLAG,
% q(0),
% q(1),
% qdot(0),

% qdot(1),
% r(0),
% r(1),
% rdot(0),
% rdot(1),

% u(0),
% u(1),
% u_sat(0),
% u_sat(1),
% lbd(0), // th0 **** NUM LAMBDA: 8

% lbd(1), // th1
% lbd(2), // th2
% lbd(3), // u_ball
% lbd(4), // u_1 M
% lbd(5), // u_2 M

% lbd(6), // u_1 m
% lbd(7), // u_2 m
% Vn(0),
% Vn(1),
% Vn(2), // 잊지마잉

% zeta_arr[0],
% zeta_arr[1],
% avgCtrlTimeSec // Add average ctrl_wrapper execution time

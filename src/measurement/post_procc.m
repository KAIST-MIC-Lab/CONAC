function [data, loss_ratio] = post_procc(ctrl_name, ctrl_num)

    %% DATA LOAD
    log = readtable("sim_result/"+ctrl_name+".csv");
    
    log = log{1:end-1, 1:28};

    %% CONTROL NUMBER CHECK
    control_num = ctrl_num;
    % remove the log with large change
    tmp_pt = find((log(:,2) - control_num).^2 < 1e-6);
    
    log = log(tmp_pt, :);

    %% SAMPLING TIME CHECK0
    ori_num = length(log);

    pt = [];
    for del_t = [0.002, 0.004]
        tmp_pt = find((log(2:end,1) - log(1:end-1,1) - del_t).^2 < 1e-6);
        pt = union(pt, tmp_pt);
    end

    log = log(pt, :);

    %% LARGE CHANGE CHECK
    pt = 1:size(log,1);
    thr = 1e0;
    for idx = 3:28
        tmp_pt = find((log(2:end,idx) - log(1:end-1,idx)).^2 > thr);
        pt = setdiff(pt, tmp_pt);
    end
    
    log = log(pt, :);

    %% LOSS CHECK
    mod_num = length(log);
    loss_ratio = (ori_num - mod_num) / ori_num;
    fprintf('loss ratio: %.3f%%\n', loss_ratio*1e2);
    
    %% RUNNING TIME CHECK
    start_t = log(1,1);
    end_t = start_t+24;

    data.obs   = find(log(:,1) >= start_t & log(:,1) <= end_t);

    %% STORE IN STRUCTURE
    data.t      = transpose(log(:,1));  
    data.t = data.t - data.t(1);
    data.x1     = transpose(log(:,[3,4]));
    data.x2     = transpose(log(:,[5,6]));
    data.xd1    = transpose(log(:,[7,8]));
    data.xd2    = transpose(log(:,[9,10]));
    data.u      = transpose(log(:,[11,12]));
    data.uSat   = transpose(log(:,[13,14]));
    data.lbd    = transpose(log(:,15:22));
    data.th     = transpose(log(:,23:25));
    data.zeta   = transpose(log(:,26:27));
    data.cmp    = transpose(log(:,28));
    
end

%% DATA LABEL
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

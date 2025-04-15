function [data, loss_ratio] = post_procc_sep(ctrl_name)

    % remove the data with large change
    data = readtable("sim_result/"+ctrl_name);
    data{:,[1:28]} = data{:, [1,2,5:30]};
    data = data{1:end-1, 1:28};
    ori_num = length(data);

    pt = 1:size(data,1);
    thr = 2e0;
    for idx = 3:28
        tmp_pt = find((data(2:end,idx) - data(1:end-1,idx)).^2 > thr);
        pt = setdiff(pt, tmp_pt);
    end
    
    data = data(pt, :);
    mod_num = length(data);
    loss_ratio = (ori_num - mod_num) / ori_num;
    fprintf('loss ratio: %.3f%%\n', loss_ratio*1e2);

    % seperate
    pt1 = find(data(:,2) == 2);
    pt2 = find(data(:,2) == 3); 
    pt = setdiff(1:size(data,1), pt1);
    pt = setdiff(pt, pt2);
    data(pt, 2) = zeros(length(pt), 1);
    
    figure(1); clf;
    plot(data(:,1), data(:,2)); hold on
    plot(data(:,1), data(:,4)); hold on

    rise_flag = find(data(2:end,2) - data(1:end-1,2) > 0);
    rise_t = data(rise_flag, 1);
    fall_flag = find(data(2:end,2) - data(1:end-1,2) < 0);
    fall_t = data(fall_flag, 1);

    assert(length(rise_flag) == length(fall_flag), "rise and fall flag length mismatch");




    return

    del_ts = [0.002, 0.004];

    pt = find(data(:,2).^2 > 1e-6);
    data = data(pt, :);
    ori_num = length(data);

    pt = [];
    % sampling time check
    for idx = 1:length(del_ts)
        del_t = del_ts(idx);
        tmp_pt = find((data(2:end,1) - data(1:end-1,1) - del_t).^2 < 1e-6);
        
        pt = union(pt, tmp_pt);
    end

    % remove the data with large change
    thr = 1e0;
    for idx = 3:28
        tmp_pt = find((data(2:end,idx) - data(1:end-1,idx)).^2 > thr);
        pt = setdiff(pt, tmp_pt);
    end

    data = data(pt, :);
    mod_num = length(data);

    loss_ratio = (ori_num - mod_num) / ori_num;
    fprintf('loss ratio: %.3f%%\n', loss_ratio*1e2);
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

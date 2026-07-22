function [data] = post_procc(ctrl_name, ctrl_num)

    %% DATA LOAD
    log = load("sim_result/"+ctrl_name+".mat");
    log = log.out;

    %% ID EXTRACTION
    id3 = transpose(log.id3.Data);
    id4 = transpose(log.id4.Data);
    id5 = transpose(log.id5.Data);
    id6 = transpose(log.id6.Data);
    id7 = transpose(log.id7.Data);
    id8 = transpose(log.id8.Data);
    id9 = transpose(log.id9.Data);

    %% STORE IN STRUCTURE
    data.x1     = id3;
    data.xd1    = id4;
    data.u      = id5;
    data.th     = [id6;  id7(1,:)];
    
    if ctrl_num == 1 || ctrl_num == 3 || ctrl_num == 4
        data.lbd    = [id7(2,:); id8];
        data.t      = id9(1,:);
        data.cmp    = id9(2,:);
    elseif ctrl_num == 2
        data.zeta   = [id7(2,:); id8(1,:)];
        data.t      = id8(2,:);
        data.cmp    = id9(1,:);
    end
    
    % for time 
    data.t = log.id3.Time;

    %% RUNNING TIME CHECK

    


    % start_t = log(1,1);
    % end_t = start_t+24;
    start_t = 34;
    end_t = 50;

    data.obs   = find(data.t >= start_t & data.t <= end_t);
    %% 
    data.t = data.t - data.t(data.obs(1));
end

%% DATA LABEL
% C1: (13) proposed
% q (2) // 3
% r (2) // 4
% u  (2) // 5
% th (3) // 6 7|
% lbd (4,6,8) // |7 8
% t  (1) // |9
% cmp (1) // 9|
% C2: (12) aux
% q (2) // 3
% r (2) // 4
% u  (2) // 5
% th (3) // 6 7|
% zeta (2) // |7 8|
% t  (1) // |8
% cmp (1) // 9|
% C3: (14) with small beta
% q (2)
% r (2)
% u  (2)
% th (3)
% lbd (4,6,8)
% t  (1)
% cmp (1)
% C4: (14) no control input constraint
% q (2)
% r (2)
% u  (2)
% th (3)
% lbd (1,2,3)
% t  (1)
% cmp (1)

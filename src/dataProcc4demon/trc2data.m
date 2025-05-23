function data = trc2data(data_name, ctrl_num)

% clear
% data_name = "test0418"; 
% ctrl_num = 1;

log = fopen("sim_result/"+data_name+"", 'r');

%%
canData.id3.data = []; canData.id3.time = [];
canData.id4.data = []; canData.id4.time = [];
canData.id5.data = []; canData.id5.time = [];

%%
data_idx = 0;

while true
    data_idx = data_idx + 1;

    cur_line = fgetl(log);
    if cur_line == -1
        break
    end
    
    if cur_line(1) == ";" || cur_line(36) == "1" || cur_line(36) == "2"
        continue
    end

    cur_data = cur_line(42:64);
    cur_time = str2double(string(cur_line(11:19)))*1e-3;

    if cur_line(36) == "3"
        cur_data = unpack5(cur_data);
        canData.id3.data = [canData.id3.data; cur_data];
        canData.id3.time = [canData.id3.time; cur_time];
        
    elseif cur_line(36) == "4"
        cur_data = unpack4(cur_data);
        canData.id4.data = [canData.id4.data; cur_data];
        canData.id4.time = [canData.id4.time; cur_time];

    elseif cur_line(36) == "5"
        cur_data = unpack5(cur_data);
        canData.id5.data = [canData.id5.data; cur_data];
        canData.id5.time = [canData.id5.time; cur_time];

    else
        error("Unknown id")
    end
    
end

%% STORE IN STRUCTURE

data.q1.Data            = canData.id3.data(:,1);
data.q1.Time            = canData.id3.time;
data.q2.Data            = canData.id3.data(:,2);
data.q2.Time            = canData.id3.time;

data.r1.Data            = canData.id3.data(:,3);
data.r1.Time            = canData.id3.time;
data.r2.Data            = canData.id3.data(:,4);
data.r2.Time            = canData.id3.time;

data.u1.Data            = canData.id4.data(:,3);
data.u1.Time            = canData.id4.time;
data.u2.Data            = canData.id4.data(:,4);
data.u2.Time            = canData.id4.time;

data.lbdu.Data          = canData.id3.data(:,5);
data.lbdu.Time          = canData.id3.time;
data.lbdu2Max.Data      = canData.id4.data(:,1);
data.lbdu2Max.Time      = canData.id4.time;
data.lbdu2Min.Data      = canData.id4.data(:,2);
data.lbdu2Min.Time      = canData.id4.time;

data.th0.Data           = canData.id5.data(:,1);
data.th0.Time           = canData.id5.time;
data.th1.Data           = canData.id5.data(:,2);
data.th1.Time           = canData.id5.time;
data.th2.Data           = canData.id5.data(:,3);
data.th2.Time           = canData.id5.time;

data.t.Data             = canData.id5.data(:,4);
data.t.Time             = canData.id5.time;
data.cmp.Data           = canData.id5.data(:,5);
data.cmp.Time           = canData.id5.time;

%% OBSERVATION TIME
tmp = data.r1.Data;
tmp(tmp == 0) = -1.5700;
start_idx = find(tmp > -1.5700, 1);
if ctrl_num == 1
    start_time = data.r1.Time(start_idx)+.18;
elseif ctrl_num ==2
    start_time = data.r1.Time(start_idx);
else
    error
end

data_names = fieldnames(data);
for data_idx = 1:length(data_names)
    data_name = data_names{data_idx};

    start_idx = find(data.(data_name).Time >= start_time, 1);
    end_idx = find(data.(data_name).Time >= start_time+24, 1);
    
    if isempty(end_idx)
        end_idx = length(data.(data_name).Time);
    end

    data.(data_name).Data = data.(data_name).Data(start_idx:end_idx);
    data.(data_name).Time = data.(data_name).Time(start_idx:end_idx)-start_time;
end

end

%% LOCAL FUNCTIONS
function data = unpack5(cur_data)
    cur_data(cur_data == ' ') = [];

    data1 = hex2udec(cur_data([1,2,3])      , 12);
    data2 = hex2udec(cur_data([4,5,6])      , 12);
    data3 = hex2udec(cur_data([7,8,9])      , 12);
    data4 = hex2udec(cur_data([10,11,12])   , 12);
    data5 = hex2udec(cur_data([13,14,15,16]), 16);
    
    data = [...
        data1 data2 data3 data4 data5
    ] * 1e-2;
end

function data = unpack4(cur_data)
    cur_data(cur_data == ' ') = [];

    data1 = hex2udec(cur_data([1,2,3,4])    , 16);
    data2 = hex2udec(cur_data([5,6,7,8])    , 16);
    data3 = hex2udec(cur_data([9,10,11,12]) , 16);
    data4 = hex2udec(cur_data([13,14,15,16]), 16);
    
    data = [...
        data1 data2 data3 data4
    ] * 1e-3;
end

function data = hex2udec(data, bit)
    data = dec2bin(hex2dec(data), bit);
    if data(1) == '1'
        data = char(~(data - '0') + '0'); 
        data = bin2dec(data) * -1;
    else
        data = bin2dec(data);
    end
end



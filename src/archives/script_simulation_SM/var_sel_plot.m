clear
clc

FIGURE_PLOT_FLAG = 1;
FIGURE_SAVE_FLAG = 0;

save_idx = [];

for idx = 1:1:8
    figure(idx);clf;
end

%%
font_size = 20;
line_width = 2;
lgd_size = 16;
    
fig_height = 230 * 1.5; 
fig_width = 800 * 1;

% 
data_name = "10-Apr-2025_17-40-19";

dt = 1/1000;
ISE = @(e) sqrt(sum(e.^2)*dt);

u_ball = 6;
u_max1 = 5.8;
u_max2 = 15;
th_max = [11,12,13];

D = 'sim_result/'+data_name;
S = dir(fullfile(D,'*.mat'));

VAR_NUM = length(S)/2;

start_time = 31.4;
end_time = 32.4;

%% DATA PRE-PROCESSING
PI1 = []; PI2 = [];

sel_ctrl_num = flip([50,60,150,160]);

Colmat = hsv(); 

for ctrl_idx = sel_ctrl_num
    if ctrl_idx > VAR_NUM
        CONTROL_NUM = 2;
    else
        CONTROL_NUM = 1;
    end

    data_name = S(ctrl_idx).name;
    data_color = rand(1,3);
    % data_color = Colmat( mod(7*(ctrl_idx-1), 64)+1, :)...   
    % ---> Colour
        % *(0.9-0.3*(  mod(floor(7*(k-1)/64), 3)   ))

    data = load(D+"/"+S(ctrl_idx).name);
    fprintf("Loading %s\n", S(ctrl_idx).name);

    plot_sel_idv

    e = c1_x1-c1_xd1;
    e_dot = c1_x2-c1_xd2;

    r = e - [5,0;0,5]*e_dot;

    cu = sqrt(max(0, norm(c1_u).^2 - u_ball^2));
    cu1 = max(0, c1_u(1,:) - u_max1);

    if ctrl_idx <= VAR_NUM
        C_name = "c1";
        PI1(ctrl_idx,1) = ISE(r(1,:));
        PI1(ctrl_idx,2) = ISE(r(2,:));
        PI1(ctrl_idx,3) = ISE(cu);
        PI1(ctrl_idx,4) = ISE(cu1);
    else
        C_name = "c2";
        PI2(ctrl_idx-VAR_NUM,1) = ISE(r(1,:));
        PI2(ctrl_idx-VAR_NUM,2) = ISE(r(2,:));
        PI2(ctrl_idx-VAR_NUM,3) = ISE(cu);
        PI2(ctrl_idx-VAR_NUM,4) = ISE(cu1);
    end

    % if SAVE_FLAG && sum(save_idx == ctrl_idx) > 0


    % end

    if FIGURE_SAVE_FLAG
        for idx = 1:1:8
            [~,~] = mkdir("figures/"+data_name+"/"+C_name+"/fig" + string(idx));

            f_name = "figures/"+data_name+"/"+C_name+"/fig" + string(idx)+"/" +string(ctrl_idx);
    
            saveas(figure(idx), f_name + ".png")
            
            figure(idx);
            % set(gcf, 'Position', [0, 0, fig_width, fig_height]); % [left, bottom, width, height] 
            % exportgraphics(gcf, f_name+'.eps', 'ContentType', 'vector')
            % exportgraphics(figure(idx), f_name+'.eps',"Padding","figure")
        end
    end
end

%%
for idx = 1:1:8
    figure(idx)
    lgd = legend;
    lgd.Location = "SouthWest";
    lgd.Orientation = "Horizontal";
end

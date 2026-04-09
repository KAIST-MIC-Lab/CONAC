
%% PREPARE
font_size = 16;
line_width = 2;
lgd_size = 12;
fig_height = 210*5; fig_width = 450;
% fig_height = 210*4; fig_width = 450*2;

%% DATA EXTRACTION
cstr = opt.cstr;

x = x_hist;
xd = xd_hist;

u = u_hist;
u_sat = uSat_hist;

th = th_hist;

if CONTROL_NUM == 1
    % CoNAC
    L = lbd_hist;
elseif CONTROL_NUM == 2
    % Aux.
    z1 = zeta_hist(1,:);
    z2 = zeta_hist(2,:);
end

%% 
plotter1
% if CONTROL_NUM == 1
%     plotter_long_1
% elseif CONTROL_NUM == 2
%     plotter2
% end
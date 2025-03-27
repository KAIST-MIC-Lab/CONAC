clear
addpath('utils_NN')
addpath('machine_data/')

%% SIMULATION SETTING
T = 7;
ctrl_dt = 1e-5;
dt = ctrl_dt * 1e-0;
% ctrl_dt = dt;
rpt_dt = 1;
t = 0:dt:T;
seed = 1; rng(seed);

%% SYSTEM DYNAMICS
x = [0;0]; u = 0;
grad = @sysGrad;

% ref = @(t) 2e2*min(1, (max(0, (t-0.1)*5))) * [1;1];
ref = @(t) [sin(t); cos(t)] * t * 1e1;

%%
nnOpt = nn_opt_load(ctrl_dt);
nn = nn_init(nnOpt);

%%
x_hist = zeros(2, length(t));
u_hist = zeros(2, length(t));
r_hist = zeros(2, length(t));

th_hist = zeros(nnOpt.l_size-1, length(t));
lbd_hist = zeros(length(nnOpt.Lambda), length(t));

eig_hist = zeros(2, length(t));

%%
LPF = 0.9; pre_wr = ref(0);

for t_idx = 2:1:length(t)
    r = LPF*pre_wr + (1 - LPF)*ref(t(t_idx));   

    if t_idx==2 || rem(t(t_idx)/dt, ctrl_dt/dt) == 0
        e = x - r;
        
        x_in = [x;r];
        [nn, u_NN, ~] = nn_forward(nn, nnOpt, x_in);
        [nn, nnOpt, dot_L, info] = nn_backward(nn, nnOpt, x, e, u_NN);

        u = u_NN;
    end

    x = x + grad(x, u) * dt;

    if mod(t_idx, rpt_dt/dt) == 0
        fprintf('Time: %.2f\n', t(t_idx));
    end


    x_hist(:,t_idx) = x;
    u_hist(:,t_idx) = u;
    r_hist(:,t_idx) = r;

    th_hist(:,t_idx) = nn_V_norm_cal(nn.V, nnOpt);
    lbd_hist(:,t_idx) = nnOpt.Lambda;
    
    eig_hist(:,t_idx) = info.EIG;
end

%%
fig_height = 210; fig_width = 450;

figure(1); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
data = [r_hist(1,:); x_hist(1,:)];
colors = [0 0 1; 1 0 0];
line_styles = {'-', '-.'};
for d_idx = 1:1:size(data,1)
    plot(t, data(d_idx,:), 'Color', colors(d_idx,:), 'LineWidth', 2, 'LineStyle', line_styles(d_idx)); hold on;
end
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$x_1$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

maxVal = max(r_hist(1,:)); minVal = min(r_hist(1,:)); 
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);

figure(2); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
data = [r_hist(2,:); x_hist(2,:)];
colors = [0 0 1; 1 0 0];
line_styles = {'-', '-.'};
for d_idx = 1:1:size(data,1)
    plot(t, data(d_idx,:), 'Color', colors(d_idx,:), 'LineWidth', 2, 'LineStyle', line_styles(d_idx)); hold on;
end
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$x_2$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

maxVal = max(r_hist(2,:)); minVal = min(r_hist(2,:)); 
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);

figure(3); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tiledlayout(1,2);

nexttile
norm_x = sqrt(sum(x_hist.^2)); norm_r = sqrt(sum(r_hist.^2));
plot(t, norm_r, 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on
plot(t, norm_x, 'r', 'LineWidth', 2, 'LineStyle', '-.'); hold on
plot(t, ones(size(t))*nnOpt.cstr.x_ball, 'k', 'LineWidth',2); hold on
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$\Vert x\Vert$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

nexttile
ang = 0:0.01:2*pi;
plot(r_hist(1,:), r_hist(2,:), 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on;
plot(x_hist(1,:), x_hist(2,:), 'r', 'LineWidth', 2, 'LineStyle', '-.'); hold on;
plot(nnOpt.cstr.x_ball*cos(ang), nnOpt.cstr.x_ball*sin(ang), 'k', 'LineWidth', 2); hold on;
grid on;
xlabel('$x_1$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$x_2$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

% =========================================================================

figure(4); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
data = [u_hist(1,:)];
colors = [1 0 0];
for d_idx = 1:1:size(data,1)
    plot(t, data(d_idx,:), 'Color', colors(d_idx,:), 'LineWidth', 2); hold on;
end
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$u_1$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

len = 2*nnOpt.cstr.u_ball; ratio = .1;
ylim([-nnOpt.cstr.u_ball-len*ratio nnOpt.cstr.u_ball+len*ratio]);

figure(5); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
data = [u_hist(2,:)];
colors = [1 0 0];
for d_idx = 1:1:size(data,1)
    plot(t, data(d_idx,:), 'Color', colors(d_idx,:), 'LineWidth', 2); hold on;
end
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$u_2$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

len = 2*nnOpt.cstr.u_ball; ratio = .1;
ylim([-nnOpt.cstr.u_ball-len*ratio nnOpt.cstr.u_ball+len*ratio]);

figure(6); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tiledlayout(1,2);

nexttile
norm_u = sqrt(sum(u_hist.^2));
plot(t, ones(size(t))*nnOpt.cstr.u_ball, 'k', 'LineWidth',2); hold on
plot(t, norm_u, 'r', 'LineWidth', 2, 'LineStyle', '-.'); hold on
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$\Vert u\Vert$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

nexttile
ang = 0:0.01:2*pi;
plot(u_hist(1,:), u_hist(2,:), 'r', 'LineWidth', 2); hold on;
plot(nnOpt.cstr.u_ball*cos(ang), nnOpt.cstr.u_ball*sin(ang), 'k', 'LineWidth', 2); hold on;
grid on;
xlabel('$u_1$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$u_2$ [ ]', 'FontSize', 12, 'Interpreter', 'latex');

figure(8); clf;
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];

plot(t, eig_hist(1,:), 'LineWidth', 2); hold on;
plot(t, eig_hist(2,:), 'LineWidth', 2); hold on;

% =========================================================================

figure(7);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(1,2);

nexttile
for th_idx = 1:1:nnOpt.l_size-1
    plot(t, th_hist(th_idx, :), 'LineWidth', 2); hold on;
end
grid on

nexttile
for c_idx = 1:1:length(nnOpt.Lambda)
    semilogy(t, lbd_hist(c_idx,:), 'LineWidth', 2); hold on;
end
grid on;


% for f_idx = 1:1:7
%     saveas(f_idx, sprintf('fig_same_eig/fig%d.png', f_idx));
% end

%% LOCAL FUNCTION
function grad = sysGrad(x, u)

    A = [-10 4; 2 -10];
    % B = [
    %      tanh(x(1))*sin(x(2))+5 0
    %     1 (tanh(x(2))*cos(x(1))+5)*40
    % ] * 1;
    B = [9 -10; -3 -10];

    grad = A*x + B * u;

end

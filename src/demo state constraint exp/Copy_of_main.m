clear
addpath('utils_NN')
addpath('machine_data/')

%% SIMULATION SETTING
T = 5;
ctrl_dt = 1e-4;
% dt = ctrl_dt;
% ctrl_dt = 1/5e3;
dt = ctrl_dt * 1/1;
% ctrl_dt = dt;
rpt_dt = 1;
t = 0:dt:T;
% seed = 1; rng(seed);

%% SYSTEM DYNAMICS
x = [0;0];

grad = @gradSys;

ref = @(t) 1e2*min(1, (max(0, (t-.1)*5)));

% ref = @(t) 1e1*(heaviside(t-1)-heaviside(t-3));
% ref = @(t) 8e2*(heaviside(t-1)-heaviside(t-3));
% ref = @(t) 1e3*(heaviside(t-1)-heaviside(t-3));

% ref = @(t) sin(10*t)*1e2;

% ref = @(t) 1e3*(heaviside(t-1)-heaviside(t-3)) ...
%     + 5e2*(heaviside(t-5)-heaviside(t-7)) ...
%     + 7e2*(heaviside(t-9)-heaviside(t-11));

%%
nnOpt3 = nn_opt_load2(ctrl_dt);
nn3 = nn_init(nnOpt3);

%%
x_hist = zeros(2, length(t));
r_hist = zeros(2, length(t));
u_hist = zeros(2, length(t));

L3_hist = zeros(length(nnOpt1.beta), length(t));
th3_hist = zeros(nnOpt1.l_size-1, length(t));

%%
LPF = 0.99; pre_wr = ref(0);

for t_idx = 2:1:length(t)
    r = LPF*pre_wr + (1 - LPF)*ref(t(t_idx));   

    if t_idx==2 || rem(t(t_idx)/dt, ctrl_dt/dt) == 0
        e = x - r;
        % fprintf("C on t: %.5f\n", t(t_idx));
        x_in1 = [x; r];
        [nn3, u_NN3, ~] = nn_forward(nn3, nnOpt3, x_in3);
        [nn3, nnOpt3, dot_L1, ~] = nn_backward(nn3, nnOpt3, x, e, u_NN3);

        u = n_NN3;

        pre_wr = r;
    end


    % grad_val = grad(w, i);
    x = x + grad_val * dt;
    
    x_hist(t_idx) = x;
    r_hist(t_idx) = r;
    u_hist(:, t_idx) = u;

    L3_hist(:, t_idx) = nnOpt3.Lambda;
    th3_hist(:, t_idx) = nn_V_norm_cal(nn3.V, nnOpt3);

    if mod(t_idx, rpt_dt/dt) == 0
        fprintf('t_idx: %d\n', t_idx)
    end
       
    
end

%%
fig_height = 210; fig_width = 450;

figure(1); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(2,1);

nexttile;
plot(t, r_hist(1,:), 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on;
plot(t, x_hist(1,:), 'r', 'LineWidth', 2, 'LineStyle', '-.'); hold on;
grid on;
% % maxVal = max(ir_hist(1,:)); minVal = min(ir_hist(1,:)); 
% maxVal = nnOpt1.cstr.u_ball; minVal = -nnOpt1.cstr.u_ball;
% len = maxVal-minVal; ratio = .1;
% ylim([minVal-len*ratio maxVal+len*ratio]);

nexttile
plot(t, r_hist(2,:), 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on;
plot(t, x_hist(2,:), 'r', 'LineWidth', 2, 'LineStyle', '-.'); hold on;
grid on;
% maxVal = max(ir_hist(2,:)); minVal = min(ir_hist(2,:)); 
% maxVal = nnOpt1.cstr.u_ball; minVal = -nnOpt1.cstr.u_ball;
% len = maxVal-minVal; ratio = .1;
% ylim([minVal-len*ratio maxVal+len*ratio]);

figure(2); clf;
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tiledlayout(1,2);

nexttile
norm_i = sqrt(sum(x_hist.^2)); norm_id = sqrt(sum(ir_hist.^2));
plot(t, ones(size(t))*nnOpt1.cstr.u_ball, 'k', 'LineWidth',2); hold on
plot(t, norm_id, 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on
plot(t, norm_i, 'r', 'LineWidth', 2, 'LineStyle', '-.'); hold on
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$\Vert i\Vert$ [A]', 'FontSize', 12, 'Interpreter', 'latex');

nexttile
ang = 0:0.01:2*pi;
plot(nnOpt1.cstr.u_ball*cos(ang), nnOpt1.cstr.u_ball*sin(ang), 'k', 'LineWidth', 2); hold on;
plot(i_hist(1,:), i_hist(2,:), 'r', 'LineWidth', 2); hold on;
plot(ir_hist(1,:), ir_hist(2,:), 'b', 'LineWidth', 2); hold on;
grid on;
xlabel('id [A]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('iq [A]', 'FontSize', 12, 'Interpreter', 'latex');

figure(4); clf;
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(2,1);

nexttile;
plot(t, v_hist(1,:), 'r', 'LineWidth', 2); hold on;
plot(t, vSat_hist(1,:), 'b', 'LineWidth', 2); hold on;
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('vd [V]', 'FontSize', 12, 'Interpreter', 'latex');
maxVal = nnOpt2.cstr.u_ball; minVal = -nnOpt2.cstr.u_ball;
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);

nexttile
plot(t, v_hist(2,:), 'r', 'LineWidth', 2); hold on;
plot(t, vSat_hist(2,:), 'b', 'LineWidth', 2); hold on;
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('vq [V]', 'FontSize', 12, 'Interpreter', 'latex');
maxVal = nnOpt2.cstr.u_ball; minVal = -nnOpt2.cstr.u_ball;
len = maxVal-minVal; ratio = .1;
ylim([minVal-len*ratio maxVal+len*ratio]);

figure(5);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(1,2);

nexttile
norm_v = sqrt(sum(v_hist.^2));
plot(t, ones(size(t))*nnOpt2.cstr.u_ball, 'k', 'LineWidth',2); hold on
plot(t, norm_v, 'r', 'LineWidth', 2, 'LineStyle', '-'); hold on
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$\Vert v\Vert$ [V]', 'FontSize', 12, 'Interpreter', 'latex');

nexttile
ang = 0:0.01:2*pi;
plot(nnOpt2.cstr.u_ball*cos(ang), nnOpt2.cstr.u_ball*sin(ang), 'k', 'LineWidth', 2); hold on;
plot(v_hist(1,:), v_hist(2,:), 'r', 'LineWidth', 2); hold on;
grid on
xlabel('vd [V]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('vq [V]', 'FontSize', 12, 'Interpreter', 'latex');

figure(6);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(1,2);

nexttile
plot(t, th1_hist(1,:), 'r', 'LineWidth', 2); hold on;
plot(t, th1_hist(2,:), 'b', 'LineWidth', 2); hold on;
grid on;

nexttile
semilogy(t, L1_hist(1,:), 'r', 'LineWidth', 2); hold on;
semilogy(t, L1_hist(2,:), 'g', 'LineWidth', 2); hold on;
semilogy(t, L1_hist(3,:), 'b', 'LineWidth', 2); hold on;
semilogy(t, L1_hist(3,:), 'LineWidth', 2); hold on;
grid on;

figure(7);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];
tl = tiledlayout(1,2);

nexttile
plot(t, th2_hist(1,:), 'r', 'LineWidth', 2); hold on;
plot(t, th2_hist(2,:), 'b', 'LineWidth', 2); hold on;
grid on;

nexttile
semilogy(t, L2_hist(1,:), 'r', 'LineWidth', 2); hold on;
semilogy(t, L2_hist(2,:), 'g', 'LineWidth', 2); hold on;
semilogy(t, L2_hist(3,:), 'b', 'LineWidth', 2); hold on;
semilogy(t, L2_hist(4,:), 'LineWidth', 2); hold on;
grid on;

figure(8);clf
hF = gcf;
hF.Position(3:4) = [fig_width, fig_height];
plot(t, trq_hist, 'r', 'LineWidth', 2);
grid on;
xlabel('Time [s]', 'FontSize', 12, 'Interpreter', 'latex');
ylabel('$\tau$ [Nm]', 'FontSize', 12, 'Interpreter', 'latex');

%% LOCAL FUNCTION
function grad = gradSys(x,u)
    A = diag([-10, -10]);
    B = diag([2; 3]);


    grad = A*x+B*u;
end
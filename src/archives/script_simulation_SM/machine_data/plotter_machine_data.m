
% ============================================
%           DO NOT RUN THIS SCRIPT
%      this will be called by `plotter.m`
% ============================================

%% extract data from machine struct
% data_path = 'machine_pmsm_mtpx.mat';
data_path = 'machine_IPM01.mat';
param = load(data_path);

% current vectors / grids
ISD = param.machine.psi.s.arg.isd;
ISQ = param.machine.psi.s.arg.isq;

% flux linkages
PSISD = param.machine.psi.s.d(:,:,4);
PSISQ = param.machine.psi.s.q(:,:,4);
% PSISD = param.machine.psi.s.d;
% PSISQ = param.machine.psi.s.q;

% differential inductances
LSDD = param.machine.L.s.dd(:,:,4);
LSDQ = param.machine.L.s.dq(:,:,4);
LSQD = param.machine.L.s.qd(:,:,4);
LSQQ = param.machine.L.s.qq(:,:,4);
% LSDD = param.machine.L.s.dd;
% LSDQ = param.machine.L.s.dq;
% LSQD = param.machine.L.s.qd;
% LSQQ = param.machine.L.s.qq;

Rs = param.machine.Rs;
np = param.machine.nP;
kappa = param.machine.kappa;
    
%% MAIN PLOTTER
font_size = 24;
line_width = 2;
lgd_size = font_size;

% fig_height = 250; fig_width = 800;


% ============================================
%        Fig. 6: Model Parameters
% ============================================
figure(6); clf
hF = gcf; 
hF.Position(3:4) = [fig_width, fig_height];
tiledlayout(1,2);

% psisd
nexttile(1)
surf(ISD',ISQ',PSISD') %explain transpose!!!
xlabel('$i_{\rm s}^d$ / A','interpreter','latex', 'FontSize', font_size)
ylabel('$i_{\rm s}^q$ / A','interpreter','latex' , 'FontSize', font_size)
zlabel('$\psi_{\rm s}^d$ / Vs','interpreter','latex', 'FontSize', font_size)
ax = gca;
ax.FontSize = font_size; 
ax.FontName = 'Times New Roman';

% psisq
nexttile(2)
surf(ISD',ISQ',PSISQ')
xlabel('$i_{\rm s}^d$ / A','interpreter','latex', 'FontSize', font_size)
ylabel('$i_{\rm s}^q$ / A','interpreter','latex', 'FontSize', font_size)
zlabel('$\psi_{\rm s}^q$ / Vs','interpreter','latex', 'FontSize', font_size)
ax = gca;
ax.FontSize = font_size; 
ax.FontName = 'Times New Roman';

% % Lsdd
% nexttile(3)
% surf(ISD',ISQ',LSDD')
% xlabel('$i_{\rm s}^d$ / A','interpreter','latex', 'FontSize', font_size)
% ylabel('$i_{\rm s}^q$ / A','interpreter','latex', 'FontSize', font_size)
% zlabel('$L_{\rm s}^{dd}$ / Vs','interpreter','latex', 'FontSize', font_size)
% ax = gca;
% ax.FontSize = font_size; 
% ax.FontName = 'Times New Roman';

% % Lsdq
% nexttile(4)
% surf(ISD',ISQ',LSDQ')
% xlabel('$i_{\rm s}^d$ / A','interpreter','latex', 'FontSize', font_size)
% ylabel('$i_{\rm s}^q$ / A','interpreter','latex', 'FontSize', font_size)
% zlabel('$L_{\rm s}^{dq}$ / Vs','interpreter','latex', 'FontSize', font_size)
% ax = gca;
% ax.FontSize = font_size; 
% ax.FontName = 'Times New Roman';

% % Lsqd
% nexttile(5)
% surf(ISD',ISQ',LSDQ')
% xlabel('$i_{\rm s}^d$ / A','interpreter','latex', 'FontSize', font_size)
% ylabel('$i_{\rm s}^q$ / A','interpreter','latex', 'FontSize', font_size)
% zlabel('$L_{\rm s}^{qd}$ / Vs','interpreter','latex', 'FontSize', font_size)
% ax = gca;
% ax.FontSize = font_size; 
% ax.FontName = 'Times New Roman';

% % Lsqq
% nexttile(6)
% surf(ISD',ISQ',LSQQ')
% xlabel('$i_{\rm s}^d$ / A','interpreter','latex', 'FontSize', font_size)
% ylabel('$i_{\rm s}^q$ / A','interpreter','latex', 'FontSize', font_size)
% zlabel('$L_{\rm s}^{qq}$ / Vs','interpreter','latex', 'FontSize', font_size)
% ax = gca;
% ax.FontSize = font_size; 
% ax.FontName = 'Times New Roman';
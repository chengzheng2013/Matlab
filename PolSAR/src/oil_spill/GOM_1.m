% This file implements the detection method of oil-spill by using PolSAR.
% Target area is in the Gulf of Mexico, mission 8
clear 
clc
%% read data
disp('loading data...')
[hh_hh, hv_hv, vv_vv, hh_hv, hh_vv, hv_vv] = Data_IO('MissionNum',8);
[N_az, N_ra] = size(hh_hh);
size_N = numel(hh_hh);
span = hh_hh+vv_vv+2*hv_hv;
% 4-component decomposition
FourComp_decomp(hh_hh, hv_hv, vv_vv, hh_hv, hh_vv, hv_vv, '4decomp')
%% Span
figure
    imagesc(10*log10(span))
    Plotsetting_GOM1([-40 0],'Colorbar_unit',[40 -70])
    annotation('rectangle',[0.125 0.4 0.04 0.525],'Color','k','Linewidth',2)
        annotation('textbox',[0.17 0.71 0.1 0.1],'String','$A_1$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.7 0.525 0.06 0.4],'Color','k','Linewidth',2)
        annotation('textbox',[0.66 0.71 0.1 0.1],'String','$A_2$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.78 0.2 0.06 0.725],'Color','k','Linewidth',2)
        annotation('textbox',[0.835 0.71 0.1 0.1],'String','$A_3$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.68 0.2 0.1 0.325],'Color','k','Linewidth',2)
        annotation('textbox',[0.64 0.4 0.1 0.1],'String','$A_4$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    plot_para('Filename','output/span', 'Maximize',true)
%% Pauli decomposition
figure
    %Pauli_decomp(2*T_22, T_33, 2*T_11, 'Filename','Pauli_decomp','saibu',false)
    Pauli_decomp((hh_hh+vv_vv-hh_vv-conj(hh_vv)), 2*hv_hv,(hh_hh+vv_vv+hh_vv+conj(hh_vv)),'Filename','Pauli_decomp')
close all
%% Eigen-decomposition
[H, alpha_bar] = Eigen_decomp('FileName', 'eigen');
close all
%% Obtain terrain slope in azimuth and induced angle by terrain slope. 
T_11 = (hh_hh+vv_vv+hh_vv+conj(hh_vv))/2;
T_22 = (hh_hh+vv_vv-hh_vv-conj(hh_vv))/2;
T_33 = 2*hv_hv;
T_12 = (hh_hh-vv_vv-hh_vv+conj(hh_vv))/2;
T_13 = hh_hv + conj(hv_vv);
T_23 = hh_hv - conj(hv_vv);
%clear  hh_hh hv_hv vv_vv hh_hv hh_vv hv_vv
close all
temp_T = cat(1,cat(2, reshape(T_11,[1,1,size_N]), reshape(T_12,[1,1,size_N]), reshape(T_13,[1,1,size_N])), ......
             cat(2,reshape(conj(T_12),[1,1,size_N]), reshape(T_22,[1,1,size_N]), reshape(T_23,[1,1,size_N])),.......
             cat(2,reshape(conj(T_13),[1,1,size_N]), reshape(conj(T_23),[1,1,size_N]), reshape(T_33,[1,1,size_N])));
clear T_11 T_22 T_33 T_12 T_13 T_23 
get_polangle(temp_T);
clear temp_T
T_11 = (hh_hh+vv_vv+hh_vv+conj(hh_vv))/2;
T_22 = (hh_hh+vv_vv-hh_vv-conj(hh_vv))/2;
T_33 = 2*hv_hv;
T_12 = (hh_hh-vv_vv-hh_vv+conj(hh_vv))/2;
T_13 = hh_hv + conj(hv_vv);
T_23 = hh_hv - conj(hv_vv);
close all
%% Indicator
%{
figure
    imagesc(H+alpha_bar/180*pi+A_1+abs(hh_vv)./sqrt(hh_hh.*vv_vv))
    Plotsetting_GOM1([0 3])
    xlabel('Azimuth (km)')
    ylabel('Range (km)') 
    plot_para('Filename','output/para_F', 'Maximize',true)
%}
%%
figure
    imagesc(2*(hv_hv-real(hh_vv))./(hh_hh + 2*hv_hv + vv_vv))
    Plotsetting_GOM1([-1 1])
    annotation('rectangle',[0.125 0.4 0.04 0.525],'Color','k','Linewidth',2)
        annotation('textbox',[0.17 0.71 0.1 0.1],'String','$A_{\mu 1}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.7 0.525 0.06 0.4],'Color','k','Linewidth',2)
        annotation('textbox',[0.65 0.71 0.1 0.1],'String','$A_{\mu 2}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.78 0.2 0.06 0.725],'Color','k','Linewidth',2)
        annotation('textbox',[0.8 0.9 0.1 0.1],'String','$A_{\mu 3}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.68 0.2 0.1 0.325],'Color','k','Linewidth',2)
        annotation('textbox',[0.63 0.4 0.1 0.1],'String','$A_{\mu 4}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    plot_para('Filename','output/para_confomty', 'Maximize',true)
%%
figure
    imagesc(-(hv_hv>abs(real(hh_vv))))
    Plotsetting_GOM1([-1 0])
    annotation('rectangle',[0.125 0.4 0.04 0.525],'Color','k','Linewidth',2)
        annotation('textbox',[0.17 0.71 0.1 0.1],'String','$A_{\mu 1}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.7 0.525 0.06 0.4],'Color','k','Linewidth',2)
        annotation('textbox',[0.65 0.71 0.1 0.1],'String','$A_{\mu 2}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.78 0.2 0.06 0.725],'Color','k','Linewidth',2)
        annotation('textbox',[0.8 0.9 0.1 0.1],'String','$A_{\mu 3}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.68 0.2 0.1 0.325],'Color','k','Linewidth',2)
        annotation('textbox',[0.63 0.4 0.1 0.1],'String','$A_{\mu 4}$','Linestyle','none','Fontsize',40,'Interpreter', 'latex')
    colormap gray; colorbar off
    plot_para('Filename','output/para_muller', 'Maximize',true)
%%
figure
    imagesc(abs(T_12)./sqrt(T_11.*T_22))
    Plotsetting_GOM1([0 1])
    annotation('rectangle',[0.125 0.7 0.04 0.225],'Color','k','Linewidth',2)
        annotation('textbox',[0.17 0.71 0.1 0.1],'String','$A_{\gamma 1}$','Linestyle','none','Color','w','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.7 0.525 0.06 0.4],'Color','k','Linewidth',2)
        annotation('textbox',[0.65 0.71 0.1 0.1],'String','$A_{\gamma 2}$','Linestyle','none','Color','w','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.77 0.525 0.07 0.4],'Color','k','Linewidth',2)
        annotation('textbox',[0.82 0.42 0.1 0.1],'String','$A_{\gamma 3}$','Linestyle','none','Color','w','Fontsize',40,'Interpreter', 'latex')
    plot_para('Filename','output/para_corelation12', 'Maximize',true)
%%
figure
    imagesc((T_11-T_22)./(T_11+T_22))
    Plotsetting_GOM1([0 1])
    annotation('rectangle',[0.125 0.7 0.04 0.225],'Color','k','Linewidth',2)
        annotation('textbox',[0.17 0.71 0.1 0.1],'String','$A_{k 1}$','Linestyle','none','Color','w','Fontsize',40,'Interpreter', 'latex')
    annotation('rectangle',[0.7 0.525 0.06 0.4],'Color','k','Linewidth',2)
        annotation('textbox',[0.65 0.71 0.1 0.1],'String','$A_{k 2}$','Linestyle','none','Color','w','Fontsize',40,'Interpreter', 'latex')
    plot_para('Filename','output/para_moisture', 'Maximize',true)
%%
figure
    imagesc((T_22-T_33)./(T_22+T_33))
    Plotsetting_GOM1([0 1])
    xlabel('Azimuth (km)')
    ylabel('Range (km)') 
    plot_para('Filename','output/para_roughness', 'Maximize',true)
%%
figure
    %imagesc(atand((T_22+T_33)./T_11))
    imagesc((T_22+T_33)./T_11)
    Plotsetting_GOM1([0 1])
    plot_para('Filename','output/para_dielectric', 'Maximize',true)
%%
figure
    imagesc(sqrt(atand((T_22+T_33)./T_11)))
    Plotsetting_GOM1([0 10])
    plot_para('Filename','output/para_braggalpha', 'Maximize',true)
 
%% Incident angle and Bragg wavenumber
global im_size
figure
    plot(atand(linspace(4602.29004, 4602.29004+22490.8262, im_size(1))/12497),'k', 'Linewidth',3)
    xlim([1 3300])
    ylim([20 65])
    xlabel('range bin')
    ylabel('$\phi$ (deg)','Interpreter', 'latex')
    grid on
    pos = get(gca, 'Position');
    yoffset = +0.05;
    pos(2) = pos(2) + yoffset;
    set(gca, 'Position', pos)
    plot_para('Filename','incidence_angle', 'Maximize',true, 'Ratio',[4 3 1])
%% Bragg scattering coefficient 
epsilon_oil = 2;
epsilon_sea = 40;
theta = 0:1:90;
beta = 2*pi/(physconst('LightSpeed')/1.2575e9);
B_hh_oil = (cosd(theta)-sqrt(epsilon_oil-sind(theta).^2))./(cosd(theta)+sqrt(epsilon_oil-sind(theta).^2));
B_vv_oil = ((epsilon_oil-1)*(sind(theta).^2 - epsilon_oil*(1 + sind(theta).^2)))./(epsilon_oil*cosd(theta)+sqrt(epsilon_oil-sind(theta).^2)).^2;
B_hh_sea = (cosd(theta)-sqrt(epsilon_sea-sind(theta).^2))./(cosd(theta)+sqrt(epsilon_sea-sind(theta).^2));
B_vv_sea = ((epsilon_sea-1)*(sind(theta).^2 - epsilon_sea*(1 + sind(theta).^2)))./(epsilon_sea*cosd(theta)+sqrt(epsilon_sea-sind(theta).^2)).^2;
figure
    a = plot(theta, abs(B_hh_sea),'b--', theta, abs(B_vv_sea),'b','Linewidth',3);
    hold on 
    b = plot(theta, abs(B_hh_oil),'k--', theta, abs(B_vv_oil),'k','Linewidth',3);
    c = plot([65, 65], [0,10],'r', 'Linewidth',3);
    d = plot([20, 20], [0,10],'r', 'Linewidth',3);
    legend({'sea: $B_{hh}$', 'sea: $B_{vv}$','oil: $B_{hh}$','oil: $B_{vv}$'},'Interpreter','latex','Location','bestoutside')
    legend('boxoff')
    grid on
    hold off
    set(gca,'Xlim',[0 90],'Ylim',[0,10])
    xlabel('$\phi$ (deg)','Interpreter', 'latex')
    ylabel('Bragg coefficient')
    plot_para('Filename','die_angle', 'Maximize',true, 'Ratio',[4 3 1])
%%
figure
    plot(theta,atand(abs((B_hh-B_vv)./(B_hh+B_vv))),'k')
    grid on
    xlabel('angle (deg)')
%%  
figure
    plot(theta,2*pi./((physconst('LightSpeed')/1.2575e9)/2./sind(theta)), 'k', 'Linewidth',3)
    grid on
    xlabel('incident angle (deg)')
    ylabel('Bragg wavenumber (rad/m)','Interpreter', 'latex')
    xlim([20, 65])
    plot_para('Filename','braggwavenum', 'Maximize',true)
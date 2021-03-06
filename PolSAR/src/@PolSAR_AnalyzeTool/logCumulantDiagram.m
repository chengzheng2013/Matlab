function logCumulantDiagram(obj, kai_2, kai_3)
    figure
    histogram2(kai_3(:), kai_2(:), 750,...
            'DisplayStyle','tile','YBinLimits',[0 5],'XBinLimits',[-3 3])
    colormap jet
    set(gca,'Color',[0 0 0]+0.7,'XGrid','off','YGrid','off')
    hold on 
    var = [linspace(0,10,100), linspace(10,2000,4000)];
    plot(psi(2,var), psi(1,var), 'w--', 'Linewidth',2.5) % inverse gamma distribution 
    plot(-psi(2,var), psi(1,var), 'w', 'Linewidth',2.5) % gamma distribution
    %plot(-psi(2,var), psi(1,var) + psi(1,var), 'w-.', 'Linewidth',2.5) % K distribution
    set(gca, 'Xtick', -5:5,'xlim',[-3 3], 'ylim', [0 2])
    xlabel('$\kappa_3$','interpreter','latex')
    ylabel('$\kappa_2$','interpreter','latex')
    plot_para('Maximize',true,'Filename',[obj.OUTPUT_PATH '/log_cumulant_diagram'],'Ratio',[4 3 1])
    hold off
end
clear all
close all
figure(1)
load results_banditron_clean
semilogx(noise(2:end-1), mean(err(2:end-1,:),2),'LineWidth',2)
grid on
hold on
load results_all_clean
semilogx(noise, mean(err_newtron,2),'g','LineWidth',2)
semilogx(noise, mean(err_soba_diag,2),'r','LineWidth',2)
semilogx(noise, model_perc.aer(end)+zeros(1,numel(noise)), '-.k','LineWidth',2);
axis([noise(2) noise(end-1) 0 0.5])
title('SynSep')
xlabel('\gamma')
ylabel('error rate')
legend('Banditron', 'PNewtron', 'SOBAdiag', 'Perceptron','Location', 'best')
print -depsc2 ../../ICML17/figs/synsep_gamma.eps


figure(2)
load results_baselines_noise
semilogx(noise, mean(err,2),'LineWidth',2)
grid on
hold on
semilogx(noise, mean(err_newtron,2),'g','LineWidth',2)
load results_soba_diag_noise
semilogx(noise, mean(err_soba_diag,2),'r','LineWidth',2)
semilogx(noise, model_perc.aer(end)+zeros(1,numel(noise)), '-.k','LineWidth',2);
axis([10^-4/2 0.5 0.05 0.5])
title('SynNonSep')
xlabel('\gamma')
ylabel('error rate')
legend('Banditron', 'PNewtron', 'SOBAdiag', 'Perceptron','Location', 'best')
print -depsc2 ../../ICML17/figs/synnonsep_gamma.eps
clear all; 
close all;
rng(99990);
N = 50000; 
K = 3;    % now only support K=3 
gamma = 0.05;
W = [1,0; cos(pi*30/180), sin(pi*30/180); cos(-pi*30/180), sin(-pi*30/180)];

%%%%%%%%%%% generate samples %%%%%%%%%%%
X = ones(N,2);
X_ext = zeros(N,3);
Y = zeros(N,1); 
for i=1:N
    % pick angle 
    if rand() > 0.2
       clas = 1; 
    else
       clas = 2;
    end
    % pick length
    values = zeros(2,1);
    while (values(1)-values(2) < gamma || norm(X(i,:)) > 1)
       if clas==1
           angle = (30*rand()-15)*pi/180;
       else
           angle = (330*rand()+15)*pi/180;
       end
       len = 1;  % this is for strongly separable
                 % change to random functions when 
                 % generating weakly separable 
       X(i,:) = [len*cos(angle), len*sin(angle)];
       [values, idxs] = sort(W*X(i,:)', 'descend');
    end
    Y(i) = idxs(1);
    resid_norm = 1-norm(X(i,:));
    X_ext(i,1:2) = X(i,:);
    X_ext(i,3) = 1;
    if mod(i,10000)==0
        fprintf('generating %d-th sample\n', i);
    end
end

X_ext = X_ext/sqrt(2);

%%%%% scatter weak samples %%%%%
plot_idx = 1:100:N;
Nplot = length(plot_idx);
color_param = zeros(Nplot,3);
color_param(:,1) = (Y(plot_idx)==1); 
color_param(:,2) = (Y(plot_idx)==2); 
color_param(:,3) = (Y(plot_idx)==3); 
scatter(X(plot_idx,1), X(plot_idx,2), 30, color_param); 


%%%%%%%%% runs %%%%%%%%%
% (for code simplicity, we only show one run here)
see = randi(100000);
rng(see);
legend_list = {};

% 1. our algorithm with linear kernel
model_linova = model_init();
model_linova = ova_perceptron_train(X_ext', Y, model_linova);
errTot = model_linova.errTot;
figure(300); plot(plot_idx, errTot(plot_idx), '.-'); hold on;
legend_list = [legend_list, 'Our Algorithm (linear)'];

% 2. Banditron
for g = [0.1, 0.05, 0.005, 0.0005]
   model_ban = model_init();
   model_ban.gamma = g;
   model_ban.n_cla = K;
   model_ban = banditron_multi_train(X_ext', Y, model_ban);
   errTot = model_ban.errTot;  
   figure(300); plot(plot_idx, errTot(plot_idx));
   legend_list = [legend_list, sprintf('Banditron (%0.4f)', g)];
end
 
% 3. our algorithm with rational kernel
hp.nu = 0.5; 
hp.type = 'rational';
model_ova = model_init(@compute_kernel,hp);
model_ova.n_cla = K; 
model_ova.maxSV = Inf;
model_ova = ova_k_perceptron_train(X_ext',Y, model_ova);
errTot = model_ova.errTot;
figure(300); plot(plot_idx, errTot(plot_idx), '--');
legend_list = [legend_list, 'Our Algorithm (rational kernel)'];

legend(legend_list);
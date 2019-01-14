clc
clear
close all
rseed_list = [1686, 543264, 7454213, 4545, 9621]; % for synthesized data
% rseed_list = [1686]; % for real data

g_list = logspace(0, -4, 16);
nu_list = logspace(0, -4, 16);
maxSV = 1000;
margin_list = [0.1];
noise_list = [0]; 

for r = 1:length(rseed_list)
for m_idx = 1:length(margin_list)
for n_idx = 1:length(noise_list)

margin = margin_list(m_idx);
noise = noise_list(n_idx);
folder = sprintf('results_mg%0.4f_n%0.4f', margin, noise);
mkdir(folder);

rseed = rseed_list(r); 
rng(rseed);

%%%%%%%%%%%%%%%%%%%%%%%%%  generated data %%%%%%%%%%%%%%%%%%%%%%
dim = 400; 
n_cla = 9; 
n = 100000;
[W, x_tr, y_tr] = generate_strong_separable(n, dim, n_cla, margin);
dataset = 'strong';
%[W, x_tr, y_tr] = generate_weak_separable2(n, dim, n_cla, margin);
%dataset = 'weak';
%%%%%%%%%%%%%%%%%%%%%%%%%  generated data (end) %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% real data %%%%%%%%%%%%%%%%%%%%%%%%%%
%[y_tr, x_tr] = libsvmread('dataset/covtype.scale01/covtype.scale01');
%dataset = 'covtype'; 
%[y_tr, x_tr] = libsvmread('dataset/mnist.scale/mnist.scale');
%dataset = 'mnist';
% [y_tr, x_tr] = libsvmread('dataset/connect-4'); 
% dataset = 'connect-4';
% [y_tr, x_tr] = libsvmread('dataset/Sensorless.scale');
% dataset = 'Sensorless'; 
% [y_tr, x_tr] = libsvmread('dataset/shuttle.scale');
% dataset = 'shuttle';
%[y_tr, x_tr] = libsvmread('dataset/protein/protein');
%dataset = 'protein';
% [y_tr, x_tr] = libsvmread('dataset/combined/combined');
% dataset = 'SensIT_vehicle';
% [y_tr, x_tr] = libsvmread('dataset/letter.scale');
% dataset = 'letter';
% [y_tr, x_tr] = libsvmread('dataset/satimage.scale');
% dataset = 'satimage';
% x_tr = x_tr';
% y_tr = y_tr - min(y_tr)+1;
%%%%%%%%%%%%%%%%%%%%%%%%%% true data (end) %%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%% shuffle %%%%%%%%%%%%%%%%%%%%
fprintf('shuffling...\n')
randp = randperm(size(x_tr, 2));
x_tr = x_tr(:,randp); 
y_tr = y_tr(randp);

%%%%%%%%%%%%%%%%%%%%% size %%%%%%%%%%%%%%%%%%%
n_cla = max(y_tr); 
dim = size(x_tr, 1);
n = size(x_tr, 2);

%%%%%%%%%%%%%% add noise %%%%%%%%%%%%%%%%%
fprintf('add noise... \n');
[y_sample, flip_idx] = datasample(y_tr, floor(length(y_tr)*noise)); 
y_tr(flip_idx) = randi(n_cla, [length(flip_idx), 1]);

%%%%%%%%%%%%%% centralize %%%%%%%%%%%%%%%%%
fprintf('centralizing...\n');
for i=1:size(x_tr,1)       
    mean_i = mean(x_tr(i,:));
    x_tr(i,:) = x_tr(i,:)-mean_i;
    if mod(i,50)==0
       fprintf('centralizing i=%d\n', i);
    end
end

%%%%%%%%%%%%%%% normalize %%%%%%%%%%%%%%%%%
fprintf('normalizing...\n')
maxnorm = -1;
for i=1:size(x_tr, 2)
   if norm(x_tr(:,i)) > maxnorm
       maxnorm = norm(x_tr(:,i));
   end
end
x_tr = x_tr/maxnorm;

%%%%%%%%%%%%%%% ova_linear perceptron %%%%%%%%%%%%
rng(rseed);
model_linova = model_init();
model_linova = ova_perceptron_train(x_tr, y_tr, model_linova);
filename = sprintf('%s/linova_%s_sd%d.mat', folder, dataset, rseed); 
aer = model_linova.aer;
save(filename, 'aer');

%%%%%%%%%%%%%%% OvA k-perceptron original %%%%%%%%%%%%%%%
rng(rseed);
hp.type = 'rational_original';
for nu_idx = 1:length(nu_list)
   hp.nu = nu_list(nu_idx); 
   model_ovao = model_init(@compute_kernel,hp);
   model_ovao.n_cla = n_cla; 
   model_ovao.maxSV = maxSV;
   model_ovao = ova_k_perceptron_train(x_tr, y_tr, model_ovao);
   filename = sprintf('%s/ovao_%s_sd%d_nu%0.4f.mat', folder, dataset, rseed, hp.nu); 
   aer = model_ovao.aer;
   save(filename, 'aer');
end

%%%%%%%%%%%%%%% OvA k-perceptron %%%%%%%%%%%%%%%
rng(rseed);
hp.type = 'rational'; 
for nu_idx = 1:length(nu_list)
   hp.nu = nu_list(nu_idx); 
   model_ova = model_init(@compute_kernel,hp);
   model_ova.n_cla = n_cla; 
   model_ova.maxSV = maxSV;
   model_ova = ova_k_perceptron_train(x_tr, y_tr, model_ova);
   filename = sprintf('%s/ova_%s_sd%d_nu%0.4f.mat', folder, dataset, rseed, hp.nu); 
   aer = model_ova.aer;
   save(filename, 'aer');
end

%%%%%%%%%%%%%%% banditron %%%%%%%%%%%%%%
rng(rseed);
for g_idx = 1:length(g_list)
   rng(rseed);
   model_ban = model_init();
   model_ban.gamma = g_list(g_idx);
   model_ban.n_cla = n_cla;
   model_ban = banditron_multi_train(x_tr, y_tr, model_ban);
   filename = sprintf('%s/ban_%s_sd%d_ga%0.4f.mat', folder, dataset, rseed, g_list(g_idx)); 
   aer = model_ban.aer;
   save(filename, 'aer');
end

%%%%%%%%%%%%%%% kernel_banditron %%%%%%%%%%%%%%
% rng(rseed);
% for g_idx = 1:length(g_list)
%    rng(rseed);
%    hp.type = 'rational'; 
%    hp.nu = 0.5;
%    model_kban = model_init(@compute_kernel,hp);
%    model_kban.gamma = g_list(g_idx);
%    model_kban.maxSV = maxSV;
%    model_kban.n_cla = n_cla;
%    model_kban = k_banditron_multi_train(x_tr, y_tr, model_kban);
%    filename = sprintf('results/kban_%s_sd%d_ga%0.4f_nu%0.4f.mat', dataset, ...
%                                      rseed, g_list(g_idx), hp.nu); 
%    aer = model_kban.aer;
%    save(filename, 'aer');
% end

%%%%%%%%%%%%%%% multiclass perceptron %%%%%%%%%%%%
rng(rseed);
model_per = model_init();
model_per = perceptron_multi_train(x_tr, y_tr, model_per);
filename = sprintf('%s/per_%s_sd%d.mat', folder, dataset, rseed); 
aer = model_per.aer;
save(filename, 'aer');

%%%%%%%%%%%%%%%% soba %%%%%%%%%%%%%%
rng(rseed);
for g_idx = 1:length(g_list)
   rng(rseed);
   model_soba = model_init();
   model_soba.gamma = g_list(g_idx);
   model_soba.n_cla = n_cla;
   model_soba = soba_diag_multi_train(x_tr, y_tr, model_soba); 
   filename = sprintf('%s/soba_%s_sd%d_ga%0.4f.mat', folder, dataset, rseed, g_list(g_idx)); 
   aer = model_soba.aer;
   save(filename, 'aer');
end
%%%%%%%%%%%%%%%% newtron %%%%%%%%%%%%%%%%
%rng(rseed);
%model_newt = model_init();
%model_newt.gamma = 1/(length(y_tr))^(1/3);
%model_newt.n_cla = n_cla;
%newtron_diag_train(x_tr, y_tr, model_newt)

end
end
end
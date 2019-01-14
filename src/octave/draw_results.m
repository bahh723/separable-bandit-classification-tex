%close all;
%clear all;

% rseed_list = [1686, 543264, 7454213, 4545, 9621];
rseed_list = [1686];
folder = 'results_mg0.1000_n0.0000';

dataset = 'strong';  
ga_list = logspace(-0, -4, 16);
nu_list = logspace(0, -4, 16);
legend_list = {};

% linear ova
tmp = [];
for r=1:length(rseed_list)
   rseed = rseed_list(r);
   filename = sprintf('%s/linova_%s_sd%d.mat', folder, dataset, rseed);
   A = load(filename); 
   tmp = [tmp, A.aer(end)]; 
end
loglog(ga_list, ones(size(ga_list))*mean(tmp));   hold on;
legend_list = [legend_list, 'linear ova'];


% rational ova
err = [];
for nu_idx = 1:length(nu_list)
   tmp = []; 
   for r=1:length(rseed_list)
      rseed = rseed_list(r);
      filename = sprintf('%s/ova_%s_sd%d_nu%0.4f.mat', folder, dataset, rseed, nu_list(nu_idx));
      A = load(filename); 
      tmp = [tmp, A.aer(end)];
   end
   err = [err, mean(tmp)];
end
loglog(nu_list, err); 
legend_list = [legend_list, 'rational ova'];

% original rational ova
err = [];
for nu_idx = 1:length(nu_list)
   tmp = []; 
   for r=1:length(rseed_list)
   
      rseed = rseed_list(r);
      filename = sprintf('%s/ovao_%s_sd%d_nu%0.4f.mat', folder, dataset, rseed, nu_list(nu_idx));
      A = load(filename); 
      tmp = [tmp, A.aer(end)];
   end
   err = [err, mean(tmp)];
end
loglog(nu_list, err); 
legend_list = [legend_list, 'rational ova (original)'];

% banditron
err = [];
for ga_idx=1:length(ga_list)
   tmp = []; 
   for r=1:length(rseed_list)
      rseed = rseed_list(r);
      filename = sprintf('%s/ban_%s_sd%d_ga%0.4f.mat', folder, dataset, rseed, ga_list(ga_idx));
      A = load(filename); 
      tmp = [tmp, A.aer(end)];
   end
   err = [err, mean(tmp)];
end
loglog(ga_list, err); 
legend_list = [legend_list, 'banditron'];

% rational banditron
% err = [];
% for ga_idx=1:length(ga_list)
%    tmp = []; 
%    for r = 1:length(rseed_list)
%       rseed = rseed_list(r);
%       filename = sprintf('%s/kban_%s_sd%d_ga%0.4f_nu%0.4f.mat', folder, dataset, rseed, ga_list(ga_idx), 0.50);
%       A = load(filename);
%       tmp = [tmp, A.aer(end)];
%    end
%    err = [err, mean(tmp)];
% end
% loglog(ga_list, err); 
% legend_list = [legend_list, 'rational banditron'];

% soba
err = [];
for ga_idx=1:length(ga_list)
   tmp = []; 
   for r = 1:length(rseed_list)
      rseed = rseed_list(r);
      filename = sprintf('%s/soba_%s_sd%d_ga%0.4f.mat', folder, dataset, rseed, ga_list(ga_idx)); 
      A = load(filename);
      tmp = [tmp, A.aer(end)];
   end
   err = [err, mean(tmp)];
end
loglog(ga_list, err); 
legend_list = [legend_list, 'soba'];

% perceptron
tmp = [];
for r = 1:length(rseed_list)
   rseed = rseed_list(r);
   filename = sprintf('%s/per_%s_sd%d.mat', folder,dataset, rseed);
   A = load(filename); 
   tmp = [tmp, A.aer(end)];
end
loglog(ga_list, ones(size(ga_list))*mean(tmp)); 
legend_list = [legend_list, 'perceptron'];

legend(legend_list);
title(dataset); 
xlabel('parameter'); 
ylabel('error rate'); 
clear all;
close all;

%load syn_data_matlab
load results_banditron_clean

%[t, p] = libsvmread('/home/bremen/Projects/datasets/covtype.scale');
%t=t';
%p=p';

model_bak=model_init();
model_bak.n_cla=numel(unique(t));

%[p,t_noise]=shuffledata(p,t_noise);
%p(end+1,:)=1;

%model_perc=perceptron_multi_train(p,t,model_bak);

%noise=2.^(-16:-1);
err=zeros(numel(noise),10);
err_newtron=zeros(numel(noise),10);
for j=1:10
    for i=1:numel(noise)
      %model_bak.gamma=noise(i);
      %model_banditron=banditron_multi_train(p,t,model_bak);
      %err(i,j)=model_banditron.aer(end);
      
      model_bak.gamma=noise(i);
      model_newtron=newtron_diag_train(p,t,model_bak);
      err_newtron(i,j)=model_newtron.aer(end);      
    end
end

err_soba_diag=zeros(numel(noise),10);
for j=1:10
    for i=1:numel(noise)
      model_bak.gamma=noise(i);
      model_soba_diag=soba_diag_multi_train(p,t,model_bak);
      err_soba_diag(i,j)=model_soba_diag.aer(end);      
    end
end


%for i=1:numel(noise)
%  model_bak.gamma=noise(i);
%model_soba=soba_multi_train(p,t,model_bak);
%  err_soba(i)=model_soba.aer(end);
%end

%save results_baselines_noise

%plot(noise, err);
%hold on;
%plot(noise, model_perc.aer(end),'k');
%plot(noise, model_soba.aer(end),'r');

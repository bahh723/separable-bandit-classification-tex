% generate synthetic data

clear all
v=zeros(120,9);
for i=1:9
    v(:,i)=(rand(120,1)<1/4);
end


s=10^4;
p=zeros(400,s);
t=zeros(1,s);
for i=1:s
    idx=randperm(9);
    tmp=zeros(400,1);
    tmp(1:120,1)=v(:,idx(1));
    t(i)=idx(1);
    idx_on=find(tmp==1);
    shuffle_idx=randperm(numel(idx_on));
    tmp(idx_on(shuffle_idx(1:5)))=0;
    shuffle_idx=randperm(280);
    tmp(120+shuffle_idx(1:20))=1;
    p(:,i)=tmp;
end
p=sparse(p);

idx=randperm(numel(t));
n=s/100*5;
t_noise=t;

t_noise(idx(1:n))=randi(9,n,1);

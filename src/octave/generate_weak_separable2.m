function [W, X, Y] = generate_weak_separable2(n_sample, dim, n_cla, margin)
assert(dim >= n_cla); 
randdim = randsample(dim, n_cla); 
X = zeros(dim,n_sample);
Y = zeros(n_sample,1);
W = zeros(dim, n_cla); 
for i=1:n_cla
   W(randdim(i),i) = 1;
end
for i=1:n_sample
    x_i = 2*rand(dim,1)-1;
    x_i = x_i/norm(x_i);
    [score, clas] = sort(W'*x_i, 'descend');
    cla_i = clas(1); 
    if score(1)-score(2) < margin
       x_i(randdim(cla_i)) = x_i(randdim(cla_i)) + margin;
    end
    x_i = x_i/norm(x_i);
    
    [score, clas] = sort(W'*x_i, 'descend');
    cla_i = clas(1); 
    if score(1)-score(2) < margin
       x_i(randdim(cla_i)) = x_i(randdim(cla_i)) + margin;
    end
    x_i = x_i/norm(x_i);
    
    X(:,i) = x_i; 
    Y(i) = cla_i;
end
end
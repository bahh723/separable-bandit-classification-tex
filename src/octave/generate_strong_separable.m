function [W, X, Y] = generate_strong_separable(n_sample, dim, n_cla, margin)
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
    cla_i = randsample(n_cla, 1); 
    for j=1:n_cla
        if cla_i==j
            x_i(randdim(j)) = max(abs(x_i(randdim(j))), margin); 
        else
            x_i(randdim(j)) = -max(abs(x_i(randdim(j))), margin);
        end
    end    
    X(:,i) = x_i/norm(x_i);
    
    %%%%%%%%%%%%%%%% do two times %%%%%%%%%%%%%%%%
    for j=1:n_cla
        if cla_i==j
            x_i(randdim(j)) = max(abs(x_i(randdim(j))), margin); 
        else
            x_i(randdim(j)) = -max(abs(x_i(randdim(j))), margin);
        end
    end    
    X(:,i) = x_i/norm(x_i); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Y(i) = cla_i;
end
end
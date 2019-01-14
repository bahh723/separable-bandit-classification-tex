function [W, X, Y] = generate_weak_separable(n_sample, dim, n_cla, margin)
X = zeros(dim,n_sample);
Y = zeros(n_sample,1);
W = 2*rand(dim,n_cla)-1;   %dim=2, #class=5
for i=1:n_sample
    while(1)
       x_i = 2*rand(dim,1)-1; 
       x_i = x_i/sum(x_i.^2);
       [score, clas] = sort(W'*x_i, 'descend');
       cla_i = clas(1); 
       if score(1)-score(2)>margin
           break
       end
       % [tmp, cla_i] = max(W'*x_i);
    end
    X(:,i) = x_i/norm(x_i); 
    Y(i) = cla_i;
end


end
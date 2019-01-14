p=full(p);
for i=1:size(p,1)
  if rand<0.2
    p(i,:)=p(i,:)*10^(sign(randn));
  end
end
p=sparse(p);
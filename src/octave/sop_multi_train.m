function model = sop_multi_train(X,Y,model)
% SOP_MULTI_TRAIN Second Order Perceptron algorithm
%
%    MODEL = SOP_MULTI_TRAIN(X,Y,MODEL) trains a multiclass
%    classifier using the Second Order Perceptron.
%
%    Additional parameters:
%    - model.n_cla is the number of classes.
%
%   References:
%     - 
%
%    This file is part of the DOGMA library for MATLAB.
%    Copyright (C) 2009-2012, Francesco Orabona
%    If you use this software in a paper you have to cite
%     - Francesco Orabona. (2009)
%       DOGMA: a MATLAB toolbox for Online Learning
%       Software available at http://dogma.sourceforge.net
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%    Contact the author: francesco [at] orabona.com

n = length(Y);   % number of training samples
rand('state',0);

if isfield(model,'gamma')==0
    model.gamma = .01;
end

if isfield(model,'a')==0
    model.a = 1;
end

if isfield(model,'iter')==0
    model.iter = 0;
    model.w = zeros(model.n_cla,size(X,1));
    model.errTot = 0;
    model.numSV = zeros(numel(Y),1);
    model.aer = zeros(numel(Y),1);
    model.pred = zeros(model.n_cla,numel(Y));
    
    model.invA=eye(size(X,1)*model.n_cla)/model.a;
    %model.A=eye(size(X,1)*model.n_cla);
    model.theta = zeros(model.n_cla,size(X,1));
end

for i=1:n
    model.iter = model.iter+1;
    
    val_f = model.w*X(:,i);
    
    Yi = Y(i);
    
    [mx_f,y_hat] = max(val_f);
    
    model.errTot = model.errTot+(y_hat~=Yi);
    model.aer(model.iter) = model.errTot/model.iter;
    model.pred(:,model.iter) = val_f;

    if Yi~=y_hat
        tmp = zeros(model.n_cla,size(X,1));
        idx_wrong=find(val_f>val_f(Yi));
        for j=1:numel(idx_wrong)
          tmp(j,:) = -X(:,i)'/numel(idx_wrong);
        end
        %tmp(y_hat,:) = -X(:,i)';
        tmp(Yi,:) = X(:,i)';
        model.theta=model.theta+tmp;
        %model.A=model.A+tmp(:)*tmp(:)';
        q=model.invA*tmp(:);
        res=tmp(:)'*q;
        model.invA=model.invA-q*q'/(1+res);
        %model.w=reshape(model.invA*model.theta(:),model.n_cla,size(X,1));
        model.w=reshape(eye(size(X,1)*model.n_cla)*model.theta(:),model.n_cla,size(X,1));
    end
    
    if mod(i,model.step)==0
      fprintf('#%.0f AER:%5.2f\n', ...
            ceil(i/1000),model.aer(model.iter)*100);
            fflush(stdout);
    end
end

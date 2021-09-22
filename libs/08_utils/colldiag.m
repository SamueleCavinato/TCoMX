% COLLDIAG                   Belsley, Kuh, & Welsch collinearity diagnostics for design matrix
% 
%     info = colldiag(X,labels,fuzz,add_intercept,normalize);
%
%     Returns inflation factors, condition indices and variance decomposition 
%     factors that can be used to determine the degree of collinearity present 
%     in the design matrix of a multiple regression. 
%
%     Condition index           Degree of Collinearity
%     ------------------------------------------------
%     condind < 10              Weak
%     10 < condind < 30         Moderate to strong
%     condind > 100             Severe
%     ------------------------------------------------
%
%     The joint condition of a high condition index and at least 2 high variance
%     decomposition proportions (Belsley, Kuh & Welch suggest >0.5) indicate 
%     potential estimation problems.
%
%     Be aware that some references define ranges using the square root of the
%     condition index.
%
%     INPUTS
%     X             - design matrix [data points x variables]
%
%     OPTIONAL
%     labels        - cell array of variable names (strings) for labelling output
%     fuzz          - Threshold for printing vdps; defaults to 0.5. Vdps less
%                     than fuzz are not printed to info.str. Idea from Hendrickx's
%                     R package 'perturb'.
%     add_intercept - boolean (defaults false) to add a column of ones to X
%     normalize     - boolean (defaults true) for indicating whether to scale
%                     columns of X to have unit length.
%  
%     OUTPUTS
%     info    - structure with following fields
%               .n       - # of data points
%               .p       - # of variables
%               .add_intercept - boolean if intercept was added or present
%               .normalize - boolean if columns normed to unit length
%               .vif     - variance inflation factors
%               .condind - condition indices (sorted in ascending order)
%               .vdp     - variance decomposition proportions
%               .fuzz    - threshold value for vdps in .str
%               .str     - string table where the first column lists the 
%                          condition indices. The remainder of the table 
%                          lists the variance decomposition proportions.
%
%     REFERENCES
%     Belsley, Kuh, & Welsch (1980). 
%     Regression Diagnostics: Identifying Influential Data and Sources of 
%     Collinearity (Chapter 3)
%
%     SEE ALSO
%     colldiag_tableplot

%     $ Copyright (C) 2014 Brian Lau http://www.subcortex.net/ $
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     brian 10.01.06
%

function info = colldiag(X,labels,fuzz,add_intercept,normalize)

if nargin < 5
   normalize = true;
end

if nargin < 4
   add_intercept = false;
end

if nargin < 3
   fuzz = 0.5;
end

if nargin < 2
   for i = 1:size(X,2)
      labels{i} = ['X' num2str(i)];
   end
elseif exist('labels','var')
   if isempty(labels)
      for i = 1:size(X,2)
         labels{i} = ['X' num2str(i)];
      end
   end
end

if add_intercept
   if any(all(X==1))
      fprintf('Intercept already present in design matrix. ADD_INTERCEPT parameter ignored.\n');
   else
      X = [ones(size(X,1),1) , X];
      labels = {'int' labels{:}};
   end
end

[n,p] = size(X);

if p ~= length(labels)
   error('Labels don''t match design matrix.');
end

if normalize
   % Normalize each column to unit length (pg 183 in Belsley et al)
   len = sum(X.^2).^0.5;
   %X = X./repmat(len,n,1); % 
   X = bsxfun(@rdivide,X,len);
end

[~,S,V] = svd(X,0);
lambda = diag(S);
% Ratio of largest singular value to all singular values
%condind = repmat(S(1,1),p,1) ./ lambda;
condind = bsxfun(@rdivide,S(1,1),lambda);
% variance decomposition proportions
%phi_mat = (V'.*V') ./ repmat(lambda.^2,1,p); 
phi_mat = bsxfun(@rdivide,V'.*V',lambda.^2);
phi = sum(phi_mat);
%vdp = phi_mat ./ repmat(phi,p,1); 
vdp = bsxfun(@rdivide,phi_mat,phi);

% Variance inflation factors
vif = diag(inv(corr(X)));

s = sprintf('\n        Variance decomposition proportions\n\t');
for i = 1:p
   temp = sprintf('%s',[labels{i}(1:min(5,length(labels{i}))) repmat(' ',1,7-min(5,length(labels{i})))]);
   s = [s temp];
end
s = [s sprintf('\nCondInd\n')];
for i = 1:p
   s = [s sprintf('%g\t',round(condind(i)))];
   for j = 1:p
      if vdp(i,j) <= fuzz
         s = [s sprintf('-----  ')];
      else
         s = [s sprintf('%1.3f  ',vdp(i,j))];
      end
   end
   s = [s sprintf('\n')];
end
s = [s sprintf('\n   VIF: ')];
for i = 1:p
   s = [s sprintf('%5.1f  ',vif(i))];
end
s = [s sprintf('\n')];

if nargout == 0
   disp(s);
   return;
else
   info.n = n;
   info.p = p;
   info.add_intercept = add_intercept;
   info.normalize = normalize;
   info.labels = labels;
   info.vif = vif;
   info.condind = condind;
   info.vdp = vdp;
   info.fuzz = fuzz;
   info.str = s;
end

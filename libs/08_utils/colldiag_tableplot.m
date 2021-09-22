% COLLDIAG_TABLEPLOT         Tableplot for visualizing collinearity diagnostics
% 
%     colldiag_tableplot(info,sort_condind,keep_condind,sort_vdp,keep_vdp);
%
%     Plots condition indices and variance decomposition factors that can 
%     be used to determine the degree of collinearity present in the design 
%     matrix of a multiple regression. 
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
%     info - struct array (usually from COLLDIAG) with fields
%            .condind - condition indices
%            .vdp     - variance decomposition proportions
%
%     OPTIONAL
%     .labels  - field in info that is a cell array of variable names 
%                (strings) for labelling output
%     sort_condind - -1 sorts descending (default),0 no sorting, or +1 sorts ascending
%     keep_condind - # of vdps to plot
%     sort_vdp - boolean (defaults false) to sort each row by decreasing vdps
%     keep_vdp - # of vdps to plot
%
%     REFERENCES
%     Friendly, M. & Kwan, E. (2009). Where's Waldo: Visualizing Collinearity 
%     Diagnostics The American Statistician, 63(1), 56-65.
%     http://www.datavis.ca/papers/viscollin-web.pdf
%
%     SEE ALSO
%     colldiag

%     $ Copyright (C) 2011 Brian Lau http://www.subcortex.net/ $
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
%     brian 08.15.11
%

% define ranges
function colldiag_tableplot(info,sort_condind,keep_condind,sort_vdp,keep_vdp);

scale_subplots = true; % Set false if subplots are screwing up

condind = info.condind;
vdp = info.vdp;

n = length(condind);
m = size(vdp,2);

if nargin < 5
   keep_vdp = m;
elseif isempty(keep_vdp)
   keep_vdp = m;   
end
if nargin < 4
   sort_vdp = false;
end
if nargin < 3
   keep_condind = n;
elseif isempty(keep_condind)
   keep_condind = n;
end
if nargin < 2
   sort_condind = -1;
end

if sort_condind ~= 0
   [condind,I] = sort(condind);
   vdp = vdp(I,:);
end
if sort_condind == 1
   condind = flipud(condind);
   vdp = flipud(vdp);
end

if isfield(info,'labels')
   labels = info.labels;
else
   for i = 1:n
      labels{i} = ['X' num2str(i)];
   end
end

if sort_vdp
   labels = repmat(labels,n,1);
   for i = 1:n
      [vdp(i,:),I] = sort(vdp(i,:));
      labels(i,:) = labels(i,I);
   end
   labels = fliplr(labels);
   vdp = fliplr(vdp);
else
   labels = repmat(labels,n,1);
end

condind = condind(1:keep_condind);
vdp = vdp(1:keep_condind,1:keep_vdp);
labels = labels(1:keep_condind,1:keep_vdp);

n = length(condind);
m = size(vdp,2);

maxci = max(condind);

figure;
if scale_subplots
   ha = tight_subplot(n,m+1,[0.005 0],0,0);
end
for i = 1:n
   if scale_subplots
      axes(ha((i-1)*(m+1)+1));
   else
      ha = subplot(n,m+1,(i-1)*(m+1)+1);
   end
   hold on;
   
   % For condition index, first plot outer rectangle colored according to CI
   if condind(i) < 10
      rectangle('Position',[-.5 -.5 1 1],'Facecolor','g');
   elseif (condind(i) >= 10) & (condind(i) < 30)
      rectangle('Position',[-.5 -.5 1 1],'Facecolor','y');
   elseif (condind(i) >= 30) & (condind(i) < 100)
      rectangle('Position',[-.5 -.5 1 1],'Facecolor',[255 99 71]./255);
   else
      rectangle('Position',[-.5 -.5 1 1],'Facecolor','r');
   end

   % Then plot an inner rectangle, the area of which is scaled relative to
   % the largest CI (plus a factor so you can still see some color)
   rectangle('Position',[-.5 -.5 1 1]*(condind(i)/maxci)*.75,'Facecolor','w');
   text(.5,-.5,sprintf('CI=%g',round(condind(i))),'Horizontalalignment','right','Verticalalignment','bottom');
   axis square;
   axis off;

   for j = 1:m
      if scale_subplots
         axes(ha((i-1)*(m+1)+1+j));
      else
         h = subplot(n,m+1,(i-1)*(m+1)+1+j);
      end
      hold on
      
      rectangle('Position',[-.5 -.5 1 1],'Facecolor','w');
      plot([-.5 .5],[0 0],'k');
      plot([0 0],[-.5 .5],'k');
      if vdp(i,j) > 0.5
         rectangle('Position',[-.5 -.5 1 1]*vdp(i,j),'Curvature',[1,1],'Facecolor',[255 0 127]/255);
      elseif (vdp(i,j) > 0.25) & (vdp(i,j) <= 0.5)
         rectangle('Position',[-.5 -.5 1 1]*vdp(i,j),'Curvature',[1,1],'Facecolor',[253 215 228]/255);
      else
         rectangle('Position',[-.5 -.5 1 1]*vdp(i,j),'Curvature',[1,1],'Facecolor','w');
      end
      if vdp(i,j) > 0.5
         weight = 'bold';
         angle = 'italic';
      else
         weight = 'normal';
         angle = 'normal';
      end
      text(.45,-.5,sprintf('%1.2f',vdp(i,j)),'Horizontalalignment','right','Verticalalignment','bottom','FontWeight',weight,'FontAngle',angle);
      text(-.45,.5,labels{i,j},'Horizontalalignment','left','Verticalalignment','top','FontWeight',weight,'FontAngle',angle);
      axis square;
      axis off;
   end
end

function ha = tight_subplot(Nh, Nw, gap, marg_h, marg_w)

% tight_subplot creates "subplot" axes with adjustable gaps and margins
%
% ha = tight_subplot(Nh, Nw, gap, marg_h, marg_w)
%
%   in:  Nh      number of axes in hight (vertical direction)
%        Nw      number of axes in width (horizontaldirection)
%        gap     gaps between the axes in normalized units (0...1)
%                   or [gap_h gap_w] for different gaps in height and width 
%        marg_h  margins in height in normalized units (0...1)
%                   or [lower upper] for different lower and upper margins 
%        marg_w  margins in width in normalized units (0...1)
%                   or [left right] for different left and right margins 
%
%  out:  ha     array of handles of the axes objects
%                   starting from upper left corner, going row-wise as in
%                   going row-wise as in
%
%  Example: ha = tight_subplot(3,2,[.01 .03],[.1 .01],[.01 .01])
%           for ii = 1:6; axes(ha(ii)); plot(randn(10,ii)); end
%           set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','')

% Pekka Kumpulainen 20.6.2010   @tut.fi
% Tampere University of Technology / Automation Science and Engineering
% Copyright (c) 2010, Pekka Kumpulainen
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.


if nargin<3; gap = .02; end
if nargin<4 || isempty(marg_h); marg_h = .05; end
if nargin<5; marg_w = .05; end

if numel(gap)==1; 
    gap = [gap gap];
end
if numel(marg_w)==1; 
    marg_w = [marg_w marg_w];
end
if numel(marg_h)==1; 
    marg_h = [marg_h marg_h];
end

axh = (1-sum(marg_h)-(Nh-1)*gap(1))/Nh; 
axw = (1-sum(marg_w)-(Nw-1)*gap(2))/Nw;

py = 1-marg_h(2)-axh; 

ha = zeros(Nh*Nw,1);
ii = 0;
for ih = 1:Nh
    px = marg_w(1);
    
    for ix = 1:Nw
        ii = ii+1;
        ha(ii) = axes('Units','normalized', ...
            'Position',[px py axw axh], ...
            'XTickLabel','', ...
            'YTickLabel','');
        px = px+axw+gap(2);
    end
    py = py-axh-gap(1);
end


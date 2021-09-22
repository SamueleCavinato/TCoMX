function patient = TCoMX_LNS(tomoplan, METRICS_LIST, patient)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LNScalc Calculates the LNS metrics for a tomotherapy plan.
%   LNScalc(tomoplan) computes the Leaf Neighbor Score (LNS) metrics 
%   starting from the sinogram contained in tomoplan.sinogram. tomoplan is 
%   the structure returned by tomo_read_plan(filename) function of TCoMX.
%   The LNS metrics are computed at each projection by considering the
%   number of open leaves with 0 (1) open neighbors in case of L0NS (L1NS).
%   Then, plan LNS is computed as the arithmetic average over all
%   projections with at least one open leaf (LNS of projection with 0 open
%   leaves return NaN values, which are ignored in the computatino of the
%   arithmetic average using the 'omitnan' flag. 
%   The metric is computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans". 
%  
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%       LNS : struct containing the following field:
%        L0NScp  : Leaf Zero Neighbors Score computed at each projection
%        L0NSplan: Arithmetic average of L0NScp over all the projection 
%                  with at least one open leaf
%        L0NSstd : Standard deviation of L0NSplan compute over all the
%                  projection with at least one open leaf
%        L1NScp  : Leaf One Neighbor Score computed at each projection
%        L1NSplan: Arithmetic average of L1NScp over all the projection 
%                  with at least one open leaf
%        L1NSstd : Standard deviation of L1NScp compute over all the
%                  projection with at least one open leaf
%        L2NScp  : Leaf Two Neighbors Score computed at each projection
%        L2NSplan: Arithmetic average of L2NScp over all the projection 
%                  with at least one open leaf
%        L2NSstd : Standard deviation of L2NScp compute over all the
%                  projection with at least one open leaf
%                          
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%        Author: Samuele Cavinato, Research Fellow @IOV-IRCCS /
%                                  Ph.D. Student @unipd
%   Affiliation: Veneto Institute of Oncology, IOV-IRCCS /
%                University of Padova, Department of Physics and Astronomy
%        e-mail: samuele.cavinato@iov.veneto.it
%                samuele.cavinato@phd.unipd.it
%       Created: November, 2020
%       Updated: April, 2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% DO NOT HESITATE CONTACTING ME FOR ANY QUESTION/DOUBT/SUGGESTION. I'LL BE
% VERY GLAD TO DISCUSS WITH YOU. 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% Preliminary operations

% Export the sinogram from tomoplan
sinogram = tomoplan.sinogram;

% Select the leaves which are open at each projection
openleaves = sinogram(1:end-1,:) > 0;

% Allocate the matrix with the numbers of open neighbors of each leaf
% The entries are initialized to 9 (arbitrary number > 2, with 2 the 
% maximum number of neighbor a leaf can have) so that at
% the end the closed leaves will all have nb = -9. This is done in
% order not to have problem with 0 valued entries which can be either
% open or closed leaves and where only open are needed. 
nb = 9*ones(tomoplan.NCP-1, size(sinogram,2));

%% Count the number of neighbors of each leaf

% Left neighbors of leaves [2;end-1] 
nb(1:end,2:end-1) = nb(1:end,2:end-1) + (sinogram(1:end-1,1:end-2)>0);

% Right neighbors of leaves [2;end-1] 
nb(1:end,2:end-1) = nb(1:end,2:end-1) + (sinogram(1:end-1,3:end)>0);

% Right neighbors of leaf 1
nb(1:end,1) = nb(1:end,1) + (sinogram(1:end-1,2)>0);

% Left neighbor of the last leaf
nb(1:end,end) = nb(1:end,end) + (sinogram(1:end-1, end-1)>0);

% Use openleaves as a mask to select only open leaves
nb = nb .* openleaves;

% Shift all the values to -9,0,1,2 (closed, open 0 neigh, open 1 neigh,
% open 2 neigh)
nb = nb - 9;

%% Compute the L#NS metrics

% % 0 open neighbors
% LNS.L0NScp = nb==0;
% LNS.L0NScp = sum(LNS.L0NScp,2) ./ sum(openleaves,2) * 100;
% 
% % 1 open neighbor
% LNS.L1NScp = nb==1;
% LNS.L1NScp = sum(LNS.L1NScp,2) ./ sum(openleaves,2) * 100;
% 
% % 2 open neighbors (returned but not used)
% LNS.L2NScp = nb==2;
% LNS.L2NScp = sum(LNS.L2NScp,2) ./ sum(openleaves,2) * 100;
% 
% % Compute average and standard deviations over projections
% LNS.L0NSplan = mean(LNS.L0NScp, 'omitnan');
% % LNS.L0NSplan = LNS.L0NSplan * nnz(~isnan(LNS.L0NScp)) / (tomoplan.NCP - 1);
% 
% LNS.L0NSstd  = std(LNS.L0NScp, 'omitnan');
% 
% LNS.L1NSplan = mean(LNS.L1NScp, 'omitnan');
% % LNS.L0NSplan = LNS.L0NSplan * nnz(~isnan(LNS.L1NScp)) / (tomoplan.NCP - 1);
% 
% LNS.L1NSstd  = std(LNS.L1NScp, 'omitnan');
% 
% LNS.L2NSplan = mean(LNS.L2NScp, 'omitnan');
% % LNS.L0NSplan = LNS.L0NSplan * nnz(~isnan(LNS.L2NScp)) / (tomoplan.NCP - 1);
% 
% LNS.L2NSstd  = std(LNS.L2NScp, 'omitnan');
% 
% %   Check if L0NScp + L1NScp + L2NScp == 100 \%   
% %     if (nnz(L0NScp+L1NScp+L2NScp - 100) ~= 0)
% %         disp(['Error:' num2str(nnz(L0NScp+L1NScp+L2NScp - 100))]);
% %     end

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'LNS');

if ~isempty(output)

    if ~isempty(output.parameters)
        
        for pp = 1:numel(output.parameters)
            
            metricname = ['L' output.parameters{pp} 'NS'];

            LNS.([metricname 'cp']) = nb==str2num(output.parameters{pp});
            LNS.([metricname 'cp']) = sum(LNS.([metricname 'cp']),2) ./ sum(openleaves,2) * 100;
            
            % Compute average and standard deviations over projections
            patient.(output.category).(output.subcategory).(metricname) = mean(LNS.([metricname 'cp']), 'omitnan');
            patient.(output.category).(output.subcategory).(metricname) = patient.(output.category).(output.subcategory).(metricname); %* nnz(~isnan(LNS.([metricname 'cp']))) / (tomoplan.NCP - 1);
            
        end
        
    end
    
end

clear openleaves nb sinogram
        
end


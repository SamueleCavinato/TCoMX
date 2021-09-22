function patient = TCoMX_CLS(tomoplan, METRICS_LIST, patient)
% CLScalc Calculates the CLS metrics for a tomotherapy plan.
%   CLScalc(tomoplan) computes the Closed Leaf Score (CLS) metrics starting 
%   from the sinogram contained in tomoplan.sinogram. tomoplan is the 
%   structure retuned by tomo_read_plan(filename) function of TCoMX. 
%   The CLS metrics are computed at each projection. Then, plan CLS is
%   computed as the arithemetic average over all projections. 
%   The CLS metric is computed both considering the whole binary MLC 
%   area and the treatment area only. For the latter, the
%   treatment area is defined by the leaves within the right most and the
%   left most open leaves. 
%   The metric is computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans". 
%  
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%      CLS : struct with following field:
%
%       CLScp    : Closed Leaf Score computed at each projection considering 
%                  the whole binary MLC area
%       CLSplan  : arithmetic average of CLScp over all the projections 
%       CLSstd   : standard deviation of CLScp over all the projections 
%       CLSin    : Closed InterLeaf Score at each projections computed as 
%                  the ratio between the number of closed leaves within the
%                  treatment area and the total number of leaves.
%       CLSinplan: arithmetic average of CLSin over all the projections 
%       CLSinstd : standard deviation of CLSin over all the projections
%       
% 
%      area: struct with following field:
%
%       treatment_area   : treatment area for each projection. It
%                          corresponds to the number of leaves within the 
%                          first and last open
%       closed_leaves_in : number of closed leaves withing the treatment
%                          area at each projection
%       centroid         : average position of the open leaves at each
%                          projection
%       length_CC        : length of the connected components at each
%                          projection
%       nCC              : number of connected components at each
%                          projection
%       nCCplan          : averange number of connected components over all
%                          the projections
%       lengthCCplan     : average length of the connected components over
%                          all the projections
%       TAplan           : average treatment area over all the projections
%       TAstd            : standard deviation of the treatment area over
%                          all the projections
%       EMcp             : edge metrics at each projection computed as the
%                          ratio between the number of open leaves and the 
%                          number of connected componenents at the 
%                          corresponding projection.
%       EMplan           : average EM over all the projections ignoring NaN
%                          values
%       centroidplan     : average centroid over all the projections
%       centroidstd      : standard deviation of the centroid over all the
%                          projections
%       discproj         : percentage number of projections with 
%                          discontinuous field (nCC > 1) over the total
%                          number of projections                          
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

% Import the sinogram from tomoplan
sinogram = tomoplan.sinogram;

%% Compute the CLS metrics

% Select the leaves which are closed at each CP
closedleaves = sinogram(1:end-1,:) == 0;

% Compute the CLS at each CP
CLS.CLScp   = sum(closedleaves,2)/size(closedleaves,2)*100;


% Compute the average over all CPs
CLS.CLSplan = mean(CLS.CLScp, 'omitnan');

% Compute the std over all CPs
CLS.CLSstd  = std(CLS.CLScp, 'omitnan');

clear closedleaves

%% Percentage ratio of closed leaves within the treatment area.

area.treatment_area = zeros(tomoplan.NCP-1,1);
area.closed_leaves_in = zeros(tomoplan.NCP-1,1);

% Allocate the CLSin array
CLS.CLSin     = zeros(tomoplan.NCP - 1,1);
CLS.CLSinarea = zeros(tomoplan.NCP - 1,1);
area.centroid = zeros(tomoplan.NCP-1, 1);
area.lengthCC = [];
area.nCC = zeros(tomoplan.NCP -1, 1);

for ii=1:tomoplan.NCP - 1 % Number of projections = number of CPs - 1
        
    % Select the ii-th projection
    tmp = sinogram(ii,:);

    % Get the indices of non-zero elements (open leaves)
    idx = find(tmp>0);

    if ~isempty(idx)
        % Compute the centroid of the treatment area at this projection
        area.centroid(ii,1) = mean(abs(idx-(tomoplan.Nleaves/2+0.5)));
         
        % Store the dimension of the connected components
        [~,~, cc] = findCC(tmp);
    
        % Store the dimensions of the connected components
        area.lengthCC = [area.lengthCC cc];
    
        % Store number of connected componenents
        area.nCC(ii) = length(cc);

        % Count the closed leaves within the treatment area
        closedleaves = nnz(tmp(1,idx(1):idx(end))==0);
                
        % Store the dimension of the treatment area
        area.treatment_area(ii,1)   = idx(end)-idx(1)+1;
        area.closed_leaves_in(ii,1) = closedleaves;
    
        % Compute the percentage ratio of closed leaves between idx(min) 
        % and idx(max) with respect to the total number of leaves.
        CLS.CLSin(ii) = closedleaves / tomoplan.Nleaves * 100; 
        
    end
      
    % Compute the percentage ratio of closed leaves between idx(min)
    % and idx(max) with respect to the treatment area
    CLS.CLSinarea(ii,1) = area.closed_leaves_in(ii,1)/...
                                           area.treatment_area(ii,1) * 100;
end

% Compute the average number of connected componenents
area.nCCplan = mean(area.nCC);

% Compute the average length of the connected components
area.lengthCCplan = mean(area.lengthCC);

% Compute the treatment area plan
area.TAplan = mean(area.treatment_area);

% Compute the treatment area std
area.TAstd = std(area.treatment_area);

area.EMcp = (area.treatment_area-area.closed_leaves_in) ./ area.nCC;

        % Compute the Edge Metric
        area.EMplan = mean(area.EMcp, 'omitnan');
        % Renormalize the Edge Metric by the number of projections
        % area.EMplan = area.EMplan * nnz(~isnan(area.EMcp))/(tomoplan.NCP-1);

% area.EMstd = std(nonzeros(area.treatment_area-area.closed_leaves_in)./nonzeros(area.nCC));

if nnz(CLS.CLSinarea(~isnan(CLS.CLSinarea))) > 0
            % Compute the mean of CLSinarea over the non-continuous projections
            CLS.CLSinareaplandisc = mean(nonzeros(CLS.CLSinarea), 'omitnan');
            %CLS.CLSinareaplandisc = CLS.CLSinareaplandisc; %* nnz(~isnan(nonzeros(CLS.CLSinarea))) / (tomoplan.NCP-1);

            % Compute the mean of CLSinarea over all the projections
            CLS.CLSinareaplanall  = mean(CLS.CLSinarea, 'omitnan');
            % CLS.CLSinareaplanall  = CLS.CLSinareaplanall * nnz(~isnan(CLS.CLSinarea)) / (tomoplan.NCP-1);
    
    % Compute the std of the treatment area
    CLS.CLSinareadiscstd  = std(nonzeros(CLS.CLSinarea), 'omitnan');
    
    % Compute the std of the treatment area
    CLS.CLSinareaallstd   = std(CLS.CLSinarea, 'omitnan');
else
    CLS.CLSinareaplandisc = 0;
    CLS.CLSinareaplanall  = 0;
    CLS.CLSinareadiscstd  = 0;
    CLS.CLSinareaallstd   = 0;
end

% Compute the percentage of CPs with closed leaves within TA
area.discproj = nnz(area.closed_leaves_in)/(tomoplan.NCP-1)*100;

% Check if there are projections with close leaves. Otherwise, set mean and
% standard deviation of the CLSin (all of them) to 0.
if nnz(area.closed_leaves_in) > 0
    % Compute the arithmetic average over all projections
    CLS.CLSinplanall = mean(CLS.CLSin, 'omitnan');
    % Compute the arithmetic average over all projections
    CLS.CLSinplandisc = mean(nonzeros(CLS.CLSin), 'omitnan');
    % Compute the standard deviation over all projections
    CLS.CLSinallstd  = std(CLS.CLSin, 'omitnan');
    % Compute the standard deviation over all projections
    CLS.CLSindiscstd  = std(nonzeros(CLS.CLSin), 'omitnan');
else
    CLS.CLSinplanall  = 0;
    CLS.CLSinallstd   = 0;
    CLS.CLSinplandisc = 0;
    CLS.CLSindiscstd  = 0;
end

% Compute the centroid of the distribution for the plan
area.centroidplan = mean(area.centroid);
% Compute the standard deviation of the centroid of the plan
area.centroidstd  = std(area.centroid);

clear closedleaves idx tmp sinogram

end
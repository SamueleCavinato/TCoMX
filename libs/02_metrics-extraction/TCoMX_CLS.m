function patient = TCoMX_CLS(tomoplan, METRICS_LIST, patient)
% TCoMX_CLS Calculates CLS, CLSin, CLSinarea, CLSindisc, CLSinareadisc, TA, C, nCC, nLCC, lengthCC, fDISC
%
%   All the details concerning the definition and meaning of each metric 
%   can be found in the "TomoTherapy® Complexity Metrics Reference Guide". 
%   
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy® plan as returned by the function TCoMX_read_plan
%                of TCoMX.
%       METRICS_LIST: structure array containing all the metrics to be
%                     computed according to the METRICS.in file.
%       patient: structure containing the results of the computation
%
%   OUTPUT ARGUMENTS:
%       patient: structure array containing the metrics computed according
%                to the METRICS.in file. The fields are organized in
%                categories and sub-categories accordingly to the "TomoTherapy® 
%                Complexity Metrics Reference Guide"
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        Author: Samuele Cavinato, MSc, Ph.D. Student
%   Affiliation: Department of Medical Physics, Veneto Institute of 
%                Oncology IOV-IRCCS /
%                Department of Physics and Astronomy 'G.Galilei',
%                University of Padova
%        e-mail: samuele.cavinato@iov.veneto.it
%                samuele.cavinato@phd.unipd.it
%       Created: November, 2020
%       Updated: September, 2021
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

clear closedleaves

%% Percentage ratio of closed leaves within the treatment area.

area.treatment_area = zeros(tomoplan.NCP-1,1);
area.closed_leaves_in = zeros(tomoplan.NCP-1,1);

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
        [~,~, cc] = TCoMX_findCC(tmp);
        
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

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'nCC');

if ~isempty(output)
    
    if isempty(output.parameters)
        metricname = ['nCC'];
        
        % Compute the average number of connected componenents
        patient.(output.category).(output.subcategory).(metricname) = mean(area.nCC, 'omitnan');
        
    end
    
end


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'lengthCC');

if ~isempty(output)
    
    if isempty(output.parameters)
        metricname = ['lengthCC'];
        
        % Compute the average number of connected componenents
        patient.(output.category).(output.subcategory).(metricname) = mean(area.lengthCC, 'omitnan');
        
    end
    
end


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'TA');

if ~isempty(output)
    
    if isempty(output.parameters)
        metricname = ['TA'];
        
        % Compute the average number of connected componenents
        patient.(output.category).(output.subcategory).(metricname) = mean(area.treatment_area, 'omitnan');
        
    end
    
end


area.nLCCcp = (area.treatment_area-area.closed_leaves_in) ./ area.nCC;


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'nLCC');

if ~isempty(output)
    
    if isempty(output.parameters)
        metricname = ['nLCC'];
        
        % Compute the average number of connected componenents
        patient.(output.category).(output.subcategory).(metricname) = mean(area.nLCCcp, 'omitnan');
        
    end
    
end

% Compute the percentage of CPs with closed leaves within TA

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'fDISC');

if ~isempty(output)

    if isempty(output.parameters)

         metricname = ['fDISC'];
        
        % Compute the average number of connected componenents
        patient.(output.category).(output.subcategory).(metricname) = nnz(area.closed_leaves_in)/(tomoplan.NCP-1)*100;
        
    end
    
end


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'CLS');

if ~isempty(output)
    
    if ~isempty(output.parameters)
        
        for pp=1:numel(output.parameters)
            
            if strcmp(output.parameters{pp}, 'normal')
                metricname = ['CLS'];
                
                patient.(output.category).(output.subcategory).(metricname) =  mean(CLS.CLScp, 'omitnan');
 
                
            elseif strcmp(output.parameters{pp}, 'inareadisc')
                metricname = ['CLSinareadisc'];
                
                if nnz(CLS.CLSinarea(~isnan(CLS.CLSinarea))) > 0
                    
                    % Compute the average over all CPs
                    patient.(output.category).(output.subcategory).(metricname) = mean(nonzeros(CLS.CLSinarea), 'omitnan');
                    
                else
                    
                    patient.(output.category).(output.subcategory).(metricname) = 0.0;
                    
                end
                
            elseif strcmp(output.parameters{pp}, 'inarea')
                
                metricname = ['CLSinarea'];
                
                if nnz(CLS.CLSinarea(~isnan(CLS.CLSinarea))) > 0
                    
                    % Compute the average over all CPs
                    patient.(output.category).(output.subcategory).(metricname) = mean(CLS.CLSinarea, 'omitnan');
%                     patient.(output.category).(output.subcategory).(metricname) = mean(CLS.CLSinarea, 'omitnan')*nnz(~isnan(CLS.CLSinarea)) / (tomoplan.NCP-1);

                else
                    
                    patient.(output.category).(output.subcategory).(metricname) = 0.0;
                    
                end
                
                
            elseif  strcmp(output.parameters{pp}, 'indisc')
                
                metricname = ['CLSindisc'];
                
                % Check if there are projections with close leaves. Otherwise, set mean and
                % standard deviation of the CLSin (all of them) to 0.
                if nnz(area.closed_leaves_in) > 0
                    
                    patient.(output.category).(output.subcategory).(metricname) = mean(nonzeros(CLS.CLSin), 'omitnan');
                    
                else
                    
                    patient.(output.category).(output.subcategory).(metricname) = 0.0;
                    
                end
                
            elseif strcmp(output.parameters{pp}, 'in')
                
                metricname = ['CLSin'];
                
                if nnz(area.closed_leaves_in) > 0
                    
                    patient.(output.category).(output.subcategory).(metricname) = mean(CLS.CLSin, 'omitnan');
                    
                else
                    
                    patient.(output.category).(output.subcategory).(metricname) = 0.0;
                    
                end
                
            end
            
        end
        
        
    end
      
end


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'centroid');

if ~isempty(output)

    if isempty(output.parameters)

         metricname = ['centroid'];
        
        % Compute the average number of connected componenents
        patient.(output.category).(output.subcategory).(metricname) = mean(area.centroid, 'omitnan');
        
    end
    
end

% Compute the centroid of the distribution for the plan
area.centroidplan = mean(area.centroid);
% Compute the standard deviation of the centroid of the plan
area.centroidstd  = std(area.centroid);

clear closedleaves idx tmp sinogram

end
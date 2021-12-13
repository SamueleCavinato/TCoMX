function patient = TCoMX_ELOTV(tomoplan, METRICS_LIST, patient)
% TCoMX_ELOTV Calculates LOTV, ELOTV_Deltap
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
%                to the METRICS.in file. The sub-fields are organized in
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
%% Peliminary operations

% Read the sinogram from tomoplan
sinogram = tomoplan.sinogram;

% Maxium LOT for each leaf across all CPs
tmax = max(sinogram, [], 1);

% Find the open leaves
LOTV.activeleaves = find(tmax>0);

% Allocate memory for the LOTV of each leaf
LOTV.LOTVleaf = zeros(1,size(sinogram,2));

%% Computation of LOTV 

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'LOTV');

if ~isempty(output)

    % Iterate over the leaves
    for ll = 1:tomoplan.Nleaves
        % Iterate over the projections and compute the LOTV
        for k=1:tomoplan.NCP - 2 %Number of CPs - 2 as in the definition
            LOTV.LOTVleaf(1,ll) = LOTV.LOTVleaf(1,ll) + tmax(ll) ...
                - abs(sinogram(k,ll) - sinogram(k+1,ll));
        end
        LOTV.LOTVleaf(1,ll) = LOTV.LOTVleaf(1,ll)/(tomoplan.NCP - 2)/tmax(ll);
    end
    
    metricname = ['LOTV'];
    
    patient.(output.category).(output.subcategory).(metricname) =  mean(LOTV.LOTVleaf, 'omitnan');
  
    
    % Compute the average over all leaves
%     LOTV.LOTVplan = mean(LOTV.LOTVleaf, 'omitnan');
    % LOTV.LOTVplan = LOTV.LOTVplan * nnz(~isnan(LOTV.LOTVleaf)) / (tomoplan.Nleaves);

    % Compute the standard deviation over all leaves
    LOTV.LOTVstd  = std(LOTV.LOTVleaf, 'omitnan');

end

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'ELOTV');


if ~isempty(output)

    if ~isempty(output.parameters)
  
        for pp = 1:numel(output.parameters)
            
            LOTV.LOTVleaf(1,:) = 0;
            
            % Iterate over the leaves
            for ll = 1:tomoplan.Nleaves
                % Iterate over the projections and compute the LOTV
                for k=1:tomoplan.NCP - str2num(output.parameters{pp}) -1 %Number of CPs - 2 as in the definition
                    LOTV.LOTVleaf(1,ll) = LOTV.LOTVleaf(1,ll) + tmax(ll) ...
                        - abs(sinogram(k,ll) - sinogram(k + str2num(output.parameters{pp}),ll));
                end
                LOTV.LOTVleaf(1,ll) = 1 - LOTV.LOTVleaf(1,ll)/(tomoplan.NCP - str2num(output.parameters{pp}) -1)/tmax(ll);
            end

            metricname = ['ELOTV' num2str(output.parameters{pp})];

            patient.(output.category).(output.subcategory).(metricname) =  mean(LOTV.LOTVleaf, 'omitnan');

        end
        
    end

end

end

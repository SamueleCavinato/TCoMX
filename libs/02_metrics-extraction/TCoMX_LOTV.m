function patient = TCoMX_LOTV(tomoplan, METRICS_LIST, patient)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOTVcalc Calculates the LOTV metric for a Helical Tomotherapy plan.
%   LOTVcalc(tomoplan) computes thee Leaf Open Time Variability metric
%   starting from the sinogram contained in tomoplan.sinogram. tomoplan is
%   the structure returned by tomo_read_plan(filename) function of TCoMX.
%   The LOTV metric is computed for all leaves which open at least once
%   during the treatment. The plan LOTV is computed as the arithmetic
%   average of leaf LOTV over those leaves (LOTV for leaves which don't
%   open during the treatment result in NaN values which are ignore the
%   computation of the average using the 'omitnan' flag).  
%   The metric is computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans". 
%  
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%      LOTV : struct containing the following fields:
%       LOTVleaf: Leaf Open Time Variability metric for each leaf
%       LOTVplan: Arithmetic average of LOTVleaf over all the leaves which
%                 open at least once duting the treatment
%       LOTVstd : Standard deviation of LOTVleaf over all the leaves which
%                 open at least once during the treatment
%       activeleaves: leaves which open at least once during the treatment
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
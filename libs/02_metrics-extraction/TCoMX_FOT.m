function patient = TCoMX_FOT(tomoplan, METRICS_LIST, patient)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOTcalc Project the sinogram onto the leaf axis and compute statistics.
%   FOTcalc(tomoplan) projects the sinogram onto the horizontal axis in
%   order to compute the Fractional Open Time (FOT), i.e. the percentage
%   open time of each leaf over the whole treatment. Morover, some
%   statistics related to the FOT distribution is computed.
%   This is a new metric implemented at Veneto Insitute Of Oncology
%   (IOV-IRCCS), Padova, Veneto, Italy. 
%  
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%      FOT: structure array containing the following fields:
%             name: plan name
%       histogramX: projection of the sinogram onto the x-axis as 
%                   columnwise sum. It is multiplied by the ProjectionTime 
%                   and divided by the TreatmentTime. It is then multiplied
%                   by 100 to obtain a percentage.
%             mean: average FOT computed over all leaves with FOT>0.
%           median: median FOT computed over all leaves with FOT>0.
%              std: FOT standard dev. computed over all leaves with FOT>0.
%       
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%        Author: Samuele Cavinato, Research Fellow @IOV-IRCCS /
%                                  Ph.D. Student @unipd
%   Affiliation: Veneto Institute of Oncology, IOV-IRCCS /
%                University of Padua, Department of Physics and Astronomy
%        e-mail: samuele.cavinato@iov.veneto.it
%                samuele.cavinato@phd.unipd.it
%       Created: November, 2020
%       Updated: January, 2021
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% Peliminary operations

% Read the sinogram from tomoplan
sinogram = tomoplan.sinogram;

% Read the TreatmentTime from tomoplan
TreatmentTime = tomoplan.TreatmentTime;

% Read the ProjectionTime from tomoplan
ProjectionTime = tomoplan.ProjectionTime;


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'mFOT');

if ~isempty(output)
    
    if isempty(output.parameters)

	metricname = 'mFOT';
	% Project the sinogram onto the horizontal axis
        patient.(output.category).(output.subcategory).(metricname) = mean(nonzeros(sum(sinogram,1)*ProjectionTime/TreatmentTime*100));

	end
	
end


output  = TCoMX_FIND_METRIC(METRICS_LIST, 'mdFOT');

if ~isempty(output)
    
    if isempty(output.parameters)

	metricname = 'mdFOT';
	% Compute the FOT median
	patient.(output.category).(output.subcategory).(metricname) = median(nonzeros(sum(sinogram,1)*ProjectionTime/TreatmentTime*100));

    end
    
end

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'sdFOT');

if ~isempty(output)
    
    if isempty(output.parameters)

	metricname = 'sdFOT';
	% Compute the FOT std 
	patient.(output.category).(output.subcategory).(metricname) = std(nonzeros(sum(sinogram,1)*ProjectionTime/TreatmentTime*100));
   
    end
    
end

clear sinogram ProjectionTime TreatmentTime

end

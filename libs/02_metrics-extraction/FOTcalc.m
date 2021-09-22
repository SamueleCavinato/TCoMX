function FOT = FOTcalc(tomoplan)
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

% Assing the plan name
FOT.name = tomoplan.name;

% Project the sinogram onto the horizontal axis
FOT.histogramX = sum(sinogram,1)*ProjectionTime/TreatmentTime*100;

% Compute the FOT mean
FOT.mean = mean(nonzeros(FOT.histogramX));

% Compute the FOT median
FOT.median = median(nonzeros(FOT.histogramX));

% Compute the FOT std 
FOT.std = std(nonzeros(FOT.histogramX));

% Compute the dose-profile scaling for each leave
% depth      = 10 cm
% field size = 50 cm
FOT.Crossline_d10s50 = weightFOThistograms(10,50);

clear sinogram ProjectionTime TreatmentTime

end
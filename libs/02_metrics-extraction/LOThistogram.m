function [LOTh] = LOThistogram(tomoplan, varargin)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOThistogram Creates the LOT histogram from the sinogram.
%   LOThistogram(tomoplan) creates the LOT histogram of tomoplan.sinogram.
%   It exploits the MATLAB built-in function HISTOGRAM(X), which uses an
%   automatic binning algorithms to return bins width a uniform width. 
%   tomoplan is a MATLAB structure array returned by the function
%   tomo_read_plan(filename) of TCoMX. The tomoplan.sinogram entries are
%   onverted to millisecond using the projection time contained in 
%   tomoplan.ProjectionTime
%
%   INPUT ARGUMENTS:
%       tomoplan: structure array containing information about a
%       TomoTherapy plan as extrated by tomo_read_plan(filename) of TCoMX.
%
%   OUTPUT ARGUMENTS:
%       LOTh: structure array containing the following fields:
%         BinCounts: number of entries in each bin
%         BinEdges:  limits of each bin ( (NumBins + 1) dimensional)
%         BinWidth:  width of the bins
%         NumBins:   number of bins 
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
%% Preliminary operations

% for ip=1:nargin-1
%    if strcmpi('NUMBINS', varargin{ip})
%        NumBins = varargin{ip+1};
%    end
% end

% Import sinogram from tomoplan
sinogram = tomoplan.sinogram;

% Import ProjectionTime from tomoplan
ProjectionTime = tomoplan.ProjectionTime*1000; % ms

% Select the entries with LOT > ## ms (0: all open times)
mask = sinogram*ProjectionTime > 0;

NumBins = round(max(sinogram(:)*ProjectionTime));

%% Creation of LOT histogram
% Call MATLAB histogram function to create the histogram

h = histogram(sinogram(mask)*ProjectionTime, 'BinLimits',[min(sinogram(:)*ProjectionTime),...
    max(sinogram(:)*ProjectionTime)], 'normalization', 'Probability', 'NumBins', NumBins);

% Export usefull variables 
LOTh.name      = tomoplan.name;
LOTh.BinCounts = h.BinCounts;
LOTh.BinEdges  = h.BinEdges;
LOTh.BinWidth  = h.BinWidth;
LOTh.NumBins   = h.NumBins;
LOTh.MaxLOT    = max(sinogram(:)*ProjectionTime);
LOTh.MeanLOT   = mean(nonzeros(sinogram(:)*ProjectionTime));
LOTh.MedianLOT = median(nonzeros(sinogram(:)*ProjectionTime));
LOTh.ModeLOT   = mode(nonzeros(sinogram(:)*ProjectionTime));
LOTh.StdLOT    = std(nonzeros(sinogram(:)*ProjectionTime));

close all
clear h sinogram ProjectionTime mask

end


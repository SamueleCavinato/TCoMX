function patient = TCoMX_MI(tomoplan, METRICS_LIST, patient)
% TCoMX_MI Calculates MI
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
%% Preliminary operations
% Import the sinogram from tomoplan
sinogram = tomoplan.sinogram;

% Import the projection time from tomoplan
ProjectionTime = tomoplan.ProjectionTime;

%% Allocation and definition of useful variable

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'MI');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Define the frequencies for calculating MI
        ff = 0.01:0.01:2;

        % Allocate the memory to store the spectrum in each direction
        Zx  = zeros(length(ff),1);
        Zy  = zeros(length(ff),1);
        Zxy = zeros(length(ff),1);
        Zyx = zeros(length(ff),1);

        % Standard deviation of the whole sinogram
        sigma = std(sinogram(:)*ProjectionTime);

        % Define the deltat in four direction: x (horizontal), y (vertical) xy(
        % diagonal), yx (antidiagonal). 
        Deltatx = abs(sinogram(1:end-1,2:end) - sinogram(1:end-1,1:end-1))*ProjectionTime;
        Deltaty = abs(sinogram(2:end-1,:) - sinogram(1:end-2, :))*ProjectionTime;
        Deltatxy = abs(sinogram(2:end-1, 2:end) - sinogram(1:end-2,1:end-1))*ProjectionTime;
        Deltatyx  = abs(sinogram(1:end-2, 2:end) - sinogram(2:end-1, 1:end-1))*ProjectionTime;

        %% Computation of MI 

        % Calculate "cumulative" histogram (greater or equal) of the Deltat in each 
        % direction w.r. to the standard deviation and the frequencies ff
        for ii=1:length(ff)
            % Leaves direction
            Zx(ii,1)  = nnz(Deltatx  > ff(ii)*sigma) / (tomoplan.NCP - 1);

            % Projection direction
            Zy(ii,1)  = nnz(Deltaty  > ff(ii)*sigma) / (tomoplan.NCP - 1); 

            % Diagonal
            Zxy(ii,1) = nnz(Deltatxy > ff(ii)*sigma) / (tomoplan.NCP - 1);

            % Antidiagonal
            Zyx(ii,1) = nnz(Deltatyx > ff(ii)*sigma) / (tomoplan.NCP - 1);
        end

        % Compute the average cumulative histogram
        Zf = (Zx + Zy + Zxy + Zyx) / 4;

        metricname = ['MI'];
        % Compute the Modulation Index as descrete integral of Zf with spacing
        patient.(output.category).(output.subcategory).(metricname) = sum(Zf*ff(1));
            
%         % Compute the Modulation Index as descrete integral of Zf with spacing
%         % Deltaf = ff(1) 
%         MI.MIplan = sum(Zf*ff(1));

    end
end

clear ff sigma Deltatx Deltaty Deltatxy Deltatyx Zx Zy Zxy Zyx Zf sinogram ProjectionTime

end


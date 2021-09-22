function patient = TCoMX_MI(tomoplan, METRICS_LIST, patient)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MIcalc Computes the MI for a Helical Tomotherapy plan.
%   MIcalc(tomoplan) computes the Modulation Index (MI) starting from the
%   sinogram and the projection time contained in tomoplan.sinogram and
%   tomoplan.ProjectionTime. tomoplan is the structure returned by
%   tomo_read_plan(filename) funtion of TCoMX. The MI is computed
%   considering the time variability in 4 different directions: leaves
%   direction, projection direction, diagonal direction and anti-diagonal
%   direction. 
%   The metric is computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans". 
%
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename) 
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%      MI : struct containing the following fields:
%       MIplan: Modulation Index computed as the discrete integral of the
%               average cumulative distribution (greater or equal) of the 
%               average time variability in 4 directions.
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


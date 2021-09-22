function patient = TCoMX_LOTstats(tomoplan, METRICS_LIST, patient)
% LOTstats Computes statistics about the LOT of a Helical Tomotherapy plan.
%   LOTstats(tomoplan) computes statistics related to the Leaf Open Time of
%   starting from the sinogram and projection time contained in
%   tomplan.sinogram and tomoplan.ProjectionTime. tomoplan is the structure
%   returned by tomo_read_plan(filename) function of TCoMX. For detailed
%   information about the statistical metrics see the OUTPUT ARGUMENTS.
%   The metrics are computed in the version presented in Santos et al., JACMP
%   2020, "On the complexity of helical tomotherapy treatment plans".
%
%   INPUT ARGUMENTS:
%      tomoplan: structure array containing information about a
%                TomoTherapy plan as returned by tomo_read_plan(filename)
%                of TCoMX.
%
%   OUTPUT ARGUMENTS:
%      stats: structure array containing the following LOT statistics:
%        meanLOT: Arithmetic average of all non-zero LOT in the sinogram;
%        stdLOT : Standard deviation of all non-zero LOT in the sinohram;
%        medianLOT : median of the LOT distribution
%        modeLOT: mode of the LOT distribution
%        LOT100cp: Percentage fraction of LOT < 100 ms at each projection.
%                  Projections with 0 open leaves result in a LOT100cp=NaN.
%        LOT100plan: Arithmetic average of LOT100cp. NaN values are
%                    excluded from the computation using the 'omitnan'
%                    flag.
%        LOT100std : Arithmetic average of LOT100cp. NaN values are
%                    excluded from the computation using the 'omitnan'
%                    flag.
%        LOT50cp  : Percentage fraction of LOT < 50 ms at each projection.
%                   Projections with 0 open leaves result in a LOT100cp=NaN.
%        LOT50plan: Arithmetic average of LOT50cp. NaN values are
%                   excluded from the computation using the 'omitnan'
%                   flag.
%        LOT50std : Arithmetic average of LOT50cp. NaN values are
%                   excluded from the computation using the 'omitnan'
%                   flag.
%        LOT30cp  : Percentage fraction of LOT < 30 ms at each projection.
%                   Projections with 0 open leaves result in a LOT100cp=NaN.
%        LOT30plan: Arithmetic average of LOT30cp. NaN values are
%                   excluded from the computation using the 'omitnan'
%                   flag.
%        LOT30std : Arithmetic average of LOT30cp. NaN values are
%                   excluded from the computation using the 'omitnan'
%                   flag.
%        LOTpt20cp: Percentage fraction of LOT > (pt-20) ms at each projection.
%                   Projections with 0 open leaves result in a LOT100cp=NaN.
%        LOTpt20plan: Arithmetic average of LOT100cp. NaN values are
%                     excluded from the computation using the 'omitnan'
%                     flag.
%        LOTpt20std : Arithmetic average of LOTpt20cp. NaN values are
%                     excluded from the computation using the 'omitnan'
%                     flag.
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
ProjectionTime = tomoplan.ProjectionTime*1000; % ms

%% Compute statistical metrics

output = TCoMX_FIND_METRIC(METRICS_LIST, 'mLOT');

if ~isempty(output)

    if isempty(output.parameters)

        % Compute the mean LOT
        patient.(output.category).(output.subcategory).(output.metric)  = mean(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); % ms

    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'mFLOT');

if ~isempty(output)

    if isempty(output.parameters)

        % Compute the Normalized Fractional Leaf Open Time average
        patient.(output.category).(output.subcategory).(output.metric) = mean(nonzeros(sinogram(1:end-1,:)));

    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'sdLOT');

if ~isempty(output)

    if isempty(output.parameters)
        
        % Compute the std open time
        patient.(output.category).(output.subcategory).(output.metric) = std(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); % ms
        
    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'sdFLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Normalized Fractional Leaf Open Time standard deviation
        patient.(output.category).(output.subcategory).(output.metric) = std(nonzeros(sinogram(1:end-1,:)));
        
    end
end

output = TCoMX_FIND_METRIC(METRICS_LIST, 'mdLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the median LOT
        patient.(output.category).(output.subcategory).(output.metric) = median(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); %ms

    end
    
end

output = TCoMX_FIND_METRIC(METRICS_LIST, 'mdFLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        patient.(output.category).(output.subcategory).(output.metric) = median(nonzeros(sinogram(1:end-1,:)));
        
    end
    
end

output = TCoMX_FIND_METRIC(METRICS_LIST, 'moLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the mode LOT
        patient.(output.category).(output.subcategory).(output.metric) = mode(nonzeros(sinogram(1:end-1, :)*ProjectionTime)); %ms
        
    end
    
end

output = TCoMX_FIND_METRIC(METRICS_LIST, 'moFLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the FLOT mode
        patient.(output.category).(output.subcategory).(output.metric) = mode(nonzeros(sinogram(1:end-1, :)));
        
    end
    
end

output = TCoMX_FIND_METRIC(METRICS_LIST, 'kLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the kurtosis of the LOT distribution
         patient.(output.category).(output.subcategory).(output.metric) = kurtosis(nonzeros(sinogram(1:end-1,:)*ProjectionTime));
        
    end
    
end

output = TCoMX_FIND_METRIC(METRICS_LIST, 'sLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the skewness of the LOT distribution
        patient.(output.category).(output.subcategory).(output.metric) = skewness(nonzeros(sinogram(1:end-1,:)*ProjectionTime));

    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'minLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the skewness of the LOT distribution
        patient.(output.category).(output.subcategory).(output.metric) = min(nonzeros(sinogram(1:end-1,:)*ProjectionTime));

    end
    
end



output = TCoMX_FIND_METRIC(METRICS_LIST, 'minFLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the skewness of the LOT distribution
        patient.(output.category).(output.subcategory).(output.metric) = min(nonzeros(sinogram(1:end-1,:)));

    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'maxLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the skewness of the LOT distribution
        patient.(output.category).(output.subcategory).(output.metric) = max(nonzeros(sinogram(1:end-1,:)*ProjectionTime));

    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'maxFLOT');

if ~isempty(output)
    
    if isempty(output.parameters)
        
        % Compute the skewness of the LOT distribution
        patient.(output.category).(output.subcategory).(output.metric) = max(nonzeros(sinogram(1:end-1,:)));

    end
    
end


openleaves = find(sinogram(:,:)>0);


output = TCoMX_FIND_METRIC(METRICS_LIST, 'CLNS');

if ~isempty(output)
    
    if ~isempty(output.parameters)
        
        for pp = 1:length(output.parameters)
            
            if contains(output.parameters(pp), 'in')

                % TO BE IMPLEMENTED?
                
                
            elseif contains(output.parameters(pp), 'pt')
                                   
                metricname = ['CLNS' output.parameters{pp}];
                metricname = strrep(metricname, ' ', '');
                checkpoint = str2num(strrep(output.parameters{pp}, 'pt', ''));
                
                patient.(output.category).(output.subcategory).(metricname) = nnz(sinogram(openleaves)*ProjectionTime > (ProjectionTime - checkpoint))/length(openleaves)*100;  
                
            elseif contains(output.parameters(pp), 'all')
                
                
                % TO BE IMPLEMENTED?
                
            else 
               
                checkpoint = str2num(output.parameters{pp});    
                metricname = ['CLNS' output.parameters{pp}];
                metricname = strrep(metricname, ' ', '');

                if checkpoint >= 0      
                    patient.(output.category).(output.subcategory).(metricname) = nnz(sinogram(openleaves)*ProjectionTime < checkpoint)/length(openleaves)*100;
                else
                     patient.(output.category).(output.subcategory).(metricname) = nan;
                end
                    
            end
                
        end
    end
    
end


output = TCoMX_FIND_METRIC(METRICS_LIST, 'CFNS');

if ~isempty(output)
    
    if ~isempty(output.parameters)
        
        for pp = 1:length(output.parameters)

            checkpoint = str2num(output.parameters{pp});    
            metricname = ['CFNS' output.parameters{pp}];
           
            metricname = strtrim(metricname);
                        
            patient.(output.category).(output.subcategory).(metricname) = nnz(sinogram(openleaves) < checkpoint/100)/length(openleaves)*100;
            
        end
        
    end
    
end


% stats.LOT20plan   = nnz(sinogram(openleaves)*ProjectionTime < 20)/length(openleaves)*100;
% stats.LOT20planall    = stats.LOT20plan + stats.LOTpt20plan;
% 
% tmp  = nnz(sinogram(openleaves)*ProjectionTime < 18)/length(openleaves)*100;
% stats.LOTin20plan = nnz(sinogram(openleaves)*ProjectionTime < 25)/length(openleaves)*100 - tmp;
% 
% tmp  = nnz(sinogram(openleaves)*ProjectionTime > (ProjectionTime - 18))/length(openleaves)*100;
% stats.LOTinpt20plan = 100 - (tmp + nnz(sinogram(openleaves)*ProjectionTime < (ProjectionTime - 25))/length(openleaves)*100);
% 
% stats.LOTin20planall = stats.LOTin20plan + stats.LOTinpt20plan;
% 
% stats.LOTpt40plan = nnz(sinogram(openleaves)*ProjectionTime > (ProjectionTime - 40))/length(openleaves)*100;
% stats.LOT40plan   = nnz(sinogram(openleaves)*ProjectionTime < 40)/length(openleaves)*100;
% stats.LOT40planall    = stats.LOT40plan + stats.LOTpt40plan;


clear sinogram ProjectionTime

end
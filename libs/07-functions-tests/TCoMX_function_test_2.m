%% MFcalc

Nleaves = 12;

%sinogram = rand(10,Nleaves);

sinogram = [0   2 6  0 1  2  0 0  2 4  0  0 ;
            0   0 0  0 0  0  0 0  0 0  0  0 ;
            0   0 4  5 2  0  3 2  1 3  0  0 ;
            10 10 0 10 0 10 10 0 10 0 10 10 ;
            0   0 1  2 4  0  0 3  0 0  0  0; 
            0   0 0  1 0  0  0 0  4 0  0  0;
            0   0 0  0 0  0  0 0  0 0  0  0];

sinogram = sinogram/10;

ProjectionTime = 250; % ms

NCP = size(sinogram,1);

%% Computation of MF
MF = max(sinogram(:))/mean(nonzeros(sinogram(:)));

disp(['MF = ', num2str(MF)]);

% OK, verificato con calcolatrice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOTstats

% Compute the mean LOT
stats.meanLOT  = mean(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); % ms
disp(['meanLOT = ', num2str(stats.meanLOT)]); % OK

% Compute the Normalized Fractional Leaf Open Time average
stats.meanFLOT = stats.meanLOT/(ProjectionTime);
disp(['meanFLOT = ', num2str(stats.meanFLOT)]);

% Compute the std open time
stats.stdLOT =   std(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); % ms
disp(['stdLOT = ', num2str(stats.stdLOT)]);

% Compute the Normalized Fractional Leaf Open Time std
stats.stdFLOT = stats.stdLOT/(ProjectionTime);
disp(['stdFLOT = ', num2str(stats.stdFLOT)]);

% Compute the median LOT
stats.medianLOT = median(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); %ms
disp(['medianLOT = ', num2str(stats.medianLOT)]);

% Compute the FLOT median
stats.medianFLOT = stats.medianLOT/(ProjectionTime);
disp(['medianFLOT = ', num2str(stats.medianFLOT)]);

% Compute the mode LOT
stats.modeLOT = mode(nonzeros(sinogram(1:end-1, :)*ProjectionTime)); %ms
disp(['modeLOT = ', num2str(stats.modeLOT)]);

% Compute the FLOT mode
stats.modeFLOT = stats.modeLOT/(ProjectionTime);
disp(['modeFLOT = ', num2str(stats.modeFLOT)]);

% Compute the kurtosis of the LOT distribution
stats.kurtosis = kurtosis(nonzeros(sinogram(1:end-1,:)*ProjectionTime));
disp(['kurtosis = ', num2str(stats.kurtosis)]);

% Compute the skewness of the LOT distribution
stats.skewness = skewness(nonzeros(sinogram(1:end-1,:)*ProjectionTime));
disp(['skewness = ', num2str(stats.skewness)]);

openleaves = find(sinogram(:,:)>0);

stats.LOT100plan  = nnz(sinogram(openleaves)*ProjectionTime < 100)/length(openleaves)*100;
disp(['LOT100 = ', num2str(stats.LOT100plan)]);

stats.LOT50plan   = nnz(sinogram(openleaves)*ProjectionTime < 50)/length(openleaves)*100;
disp(['LOT50 = ', num2str(stats.LOT50plan)]);

stats.LOT30plan   = nnz(sinogram(openleaves)*ProjectionTime < 30)/length(openleaves)*100;
disp(['LOT30 = ', num2str(stats.LOT30plan)]);

stats.LOTpt20plan = nnz(sinogram(openleaves)*ProjectionTime > (ProjectionTime - 20))/length(openleaves)*100;
disp(['LOTpt20 = ', num2str(stats.LOTpt20plan)]);

stats.LOT20plan   = nnz(sinogram(openleaves)*ProjectionTime < 20)/length(openleaves)*100;
disp(['LOT20 = ', num2str(stats.LOT20plan)]);

stats.LOT20planall    = stats.LOT20plan + stats.LOTpt20plan;
disp(['LOT20planall = ', num2str(stats.LOT20planall)]);

tmp  = nnz(sinogram(openleaves)*ProjectionTime < 18)/length(openleaves)*100;
stats.LOTin20plan = nnz(sinogram(openleaves)*ProjectionTime < 25)/length(openleaves)*100 - tmp;
disp(['LOTin20 = ', num2str(stats.LOTin20plan)]);

tmp  = nnz(sinogram(openleaves)*ProjectionTime > (ProjectionTime - 18))/length(openleaves)*100;
stats.LOTinpt20plan = 100 - (tmp + nnz(sinogram(openleaves)*ProjectionTime < (ProjectionTime - 25))/length(openleaves)*100);
disp(['LOTinpt20 = ', num2str(stats.LOTinpt20plan)]);

stats.LOTin20planall = stats.LOTin20plan + stats.LOTinpt20plan;
disp(['LOTin20planall = ', num2str(stats.LOTin20planall)]);

stats.LOTpt40plan = nnz(sinogram(openleaves)*ProjectionTime > (ProjectionTime - 40))/length(openleaves)*100;
disp(['LOTpt40plan = ', num2str(stats.LOTpt40plan)]);

stats.LOT40plan   = nnz(sinogram(openleaves)*ProjectionTime < 40)/length(openleaves)*100;
disp(['LOT40plan= ', num2str(stats.LOT40plan)]);

stats.LOT40planall    = stats.LOT40plan + stats.LOTpt40plan;
disp(['LOT40planall = ', num2str(stats.LOT40planall)]);

stats.FLOT95plan = nnz(sinogram(openleaves) < 0.95)/length(openleaves)*100;
disp(['FLOT95plan = ', num2str(stats.FLOT95plan)]);

stats.FLOT75plan = nnz(sinogram(openleaves) < 0.75)/length(openleaves)*100;
disp(['FLOT75plan = ', num2str(stats.FLOT75plan)]);

stats.FLOT50plan = nnz(sinogram(openleaves) < 0.50)/length(openleaves)*100;
disp(['FLOT50plan = ', num2str(stats.FLOT50plan)]);

stats.FLOT25plan = nnz(sinogram(openleaves) < 0.25)/length(openleaves)*100;
disp(['FLOT25plan = ', num2str(stats.FLOT25plan)]);

stats.FLOT10plan = nnz(sinogram(openleaves) < 0.10)/length(openleaves)*100;
disp(['FLOT10plan = ', num2str(stats.FLOT10plan)]);

stats.FLOT5plan  = nnz(sinogram(openleaves) < 0.05)/length(openleaves)*100;
disp(['FLOT5plan = ', num2str(stats.FLOT5plan)]);

%% LOTVcalc
Nleaves = size(sinogram,2);

NCP = size(sinogram,1);
% Maxium LOT for each leaf across all CPs
tmax = max(sinogram, [], 1);

% Find the open leaves
activeleaves = find(tmax>0);

% Allocate memory for the LOTV of each leaf
LOTVleaf = zeros(1,size(sinogram,2));

% Iterate over the leaves
for ll = 1:Nleaves
    % Iterate over the projections and compute the LOTV
    for k=1:NCP - 2 %Number of CPs - 2 as in the definition
        LOTVleaf(1,ll) = LOTVleaf(1,ll) + tmax(ll) ...
            - abs(sinogram(k,ll) - sinogram(k+1,ll));
    end
    LOTVleaf(1,ll) = LOTVleaf(1,ll)/(NCP - 2)/tmax(ll);
end

% Compute the average over all leaves
LOTVplan = mean(LOTVleaf, 'omitnan');
disp(['LOTVplan = ', num2str(LOTVplan)]);

% Compute the standard deviation over all leaves
LOTVstd  = std(LOTVleaf, 'omitnan');
disp(['LOTVstd = ', num2str(LOTVstd)]);

%% PSTVcalc 

Nleaves = size(sinogram,2);

NCP = size(sinogram,1);

% Compute the PSTV metric at each projection (NProjections = NCP - 1)
PSTVcp = sum(abs(sinogram(1:end-2,1:end-1) - sinogram(1:end-2,2:end)),2) ...
         + sum(abs(sinogram(1:end-2, 1:end-1) - sinogram(2:end-1, 1:end-1)),2);

% Compute the average over all CPs
PSTVplan = mean(PSTVcp);
disp(['PSTVplan = ', num2str(PSTVplan)]);

% Compute the std over all CPs
PSTVstd  = std(PSTVcp);
disp(['PSTVstd = ', num2str(PSTVstd)]);


%% LNScalc

% Select the leaves which are open at each projection
openleaves = sinogram(1:end-1,:) > 0;

% Allocate the matrix with the numbers of open neighbors of each leaf
% The entries are initialized to 9 (arbitrary number > 2, with 2 the 
% maximum number of neighbor a leaf can have) so that at
% the end the closed leaves will all have nb = -9. This is done in
% order not to have problem with 0 valued entries which can be either
% open or closed leaves and where only open are needed. 
nb = 9*ones(NCP-1, size(sinogram,2));

% Left neighbors of leaves [2;end-1] 
nb(1:end,2:end-1) = nb(1:end,2:end-1) + (sinogram(1:end-1,1:end-2)>0);

% Right neighbors of leaves [2;end-1] 
nb(1:end,2:end-1) = nb(1:end,2:end-1) + (sinogram(1:end-1,3:end)>0);

% Right neighbors of leaf 1
nb(1:end,1) = nb(1:end,1) + (sinogram(1:end-1,2)>0);

% Left neighbor of the last leaf
nb(1:end,end) = nb(1:end,end) + (sinogram(1:end-1, end-1)>0);

% Use openleaves as a mask to select only open leaves
nb = nb .* openleaves;

% Shift all the values to -9,0,1,2 (closed, open 0 neigh, open 1 neigh,
% open 2 neigh)
nb = nb - 9;

% 0 open neighbors
L0NScp = nb==0;
L0NScp = sum(L0NScp,2) ./ sum(openleaves,2) * 100;

% 1 open neighbor
L1NScp = nb==1;
L1NScp = sum(L1NScp,2) ./ sum(openleaves,2) * 100;

% 2 open neighbors (returned but not used)
L2NScp = nb==2;
L2NScp = sum(L2NScp,2) ./ sum(openleaves,2) * 100;

% Compute average and standard deviations over projections
L0NSplan = mean(L0NScp, 'omitnan');
disp(['L0NSplan = ', num2str(L0NSplan)]);
L0NSstd  = std(L0NScp, 'omitnan');
disp(['L0NSstd = ', num2str(L0NSstd)]);

L1NSplan = mean(L1NScp, 'omitnan');
disp(['L1NSplan = ', num2str(L1NSplan)]);
L1NSstd  = std(L1NScp, 'omitnan');
disp(['L1NSstd = ', num2str(L1NSstd)]);

L2NSplan = mean(L2NScp, 'omitnan');
disp(['L2NSplan = ', num2str(L2NSplan)]);
L2NSstd  = std(L2NScp, 'omitnan');
disp(['L2NSstd = ', num2str(L2NSstd)]);

%% CLScalc

% Compute the CLS metrics: percentage ratio of closed leaves to all leaves

% Select the leaves which are closed at each CP
closedleaves = sinogram(1:end-1,:) == 0;

% Compute the CLS at each CP
CLS.CLScp   = sum(closedleaves,2)/size(closedleaves,2)*100;

% Compute the average over all CPs
CLS.CLSplan = mean(CLS.CLScp, 'omitnan');
disp(['CLSplan = ', num2str(CLS.CLSplan)]);

% Compute the std over all CPs
CLS.CLSstd  = std(CLS.CLScp, 'omitnan');
disp(['CLSstd = ', num2str(CLS.CLSstd)]);

clear closedleaves

area.treatment_area = zeros(NCP-1,1);
area.closed_leaves_in = zeros(NCP-1,1);

% Allocate the CLSin array
CLS.CLSin     = zeros(NCP - 1,1);
CLS.CLSinarea = zeros(NCP - 1,1);
area.centroid = zeros(NCP-1, 1);
area.lengthCC = [];
area.nCC = zeros(NCP -1, 1);

for ii=1:NCP - 1 % Number of projections = number of CPs - 1
        
    % Select the ii-th projection
    tmp = sinogram(ii,:);

    % Get the indices of non-zero elements (open leaves)
    idx = find(tmp>0);

    if ~isempty(idx)
        % Compute the centroid of the treatment area at this projection
        area.centroid(ii,1) = mean(abs(idx-(Nleaves/2+0.5)));
         
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
        % and idx(max) with respect to the treatment area
        CLS.CLSinarea(ii,1) = area.closed_leaves_in(ii,1)/...
                                          area.treatment_area(ii,1) * 100;
        
        % Compute the percentage ratio of closed leaves between idx(min) 
        % and idx(max) with respect to the total number of leaves.
        CLS.CLSin(ii) = closedleaves / Nleaves * 100; 
        
    end
       
end

% Compute the average number of connected componenents
area.nCCplan = mean(area.nCC);

% Compute the average length of the connected components
area.lengthCCplan = mean(area.lengthCC);

% Compute the treatment area plan
area.TAplan = mean(area.treatment_area);

% Compute the treatment area std
area.TAstd = std(area.treatment_area);

% Compute the Edge Metric
area.EMplan = mean(nonzeros(area.treatment_area-area.closed_leaves_in)./nonzeros(area.nCC));

area.EMstd = std(nonzeros(area.treatment_area-area.closed_leaves_in)./nonzeros(area.nCC));

if nnz(CLS.CLSinarea) > 0
    % Compute the mean of CLSinarea over the non-continuous projections
    CLS.CLSinareaplandisc = mean(nonzeros(CLS.CLSinarea), 'omitnan');
    % Compute the mean of CLSinarea over all the projections
    CLS.CLSinareaplanall  = mean(CLS.CLSinarea, 'omitnan');
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
area.discproj = nnz(area.closed_leaves_in)/(NCP-1)*100;

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

disp(['CLSinplanall = ', num2str(CLS.CLSinplanall)]);
disp(['CLSinallstd = ', num2str(CLS.CLSinallstd)]);

disp(['CLSinareaall = ', num2str(CLS.CLSinareaplanall)]);
disp(['CLSinareaallstd = ', num2str(CLS.CLSinareaallstd)]);

% Compute the centroid of the distribution for the plan
area.centroidplan = mean(area.centroid);
% Compute the standard deviation of the centroid of the plan
area.centroidstd  = std(area.centroid);


%% 

sinogram = [0   2 6  0 1  2  0 0  2 4  0  0 ;
            0   0 0  0 0  0  0 0  0 0  0  0 ;
            0   0 4  5 2  0  3 2  1 3  0  0 ;
            10 10 0 10 0 10 10 0 10 0 10 10 ;
            0   0 1  2 4  0  0 3  0 0  0  0; 
            0   0 0  1 0  0  0 0  4 0  0  0;
            0   0 0  0 0  0  0 0  0 0  0  0];

sinogram = sinogram/10;

sinogram(sinogram == 1)  = -1;
sinogram(sinogram > 0)   = 1;
sinogram(sinogram == -1) = 2;

leafmov = zeros(1, Nleaves);

for nl=1:Nleaves
    for cp = 1:NCP-1
        if sinogram(cp, nl) == 0
            if sinogram(cp+1, nl) == 2
                leafmov(nl) = leafmov(nl)+1;  
            end
        end
        
        if sinogram(cp,nl) == 1
            leafmov(nl) = leafmov(nl)+2;
            if sinogram(cp+1, nl) == 2
                leafmov(nl) = leafmov(nl)+1;
            end
        end
        
        if sinogram(cp, nl) == 2
            if sinogram(cp+1, nl) == 0
                leafmov(nl) = leafmov(nl)+1;
            elseif sinogram(cp+1, nl) == 1
                leafmov(nl) = leafmov(nl)+1;
            end
        end    
    end
end

nOC.nOCplan = mean(leafmov)/(NCP-1);

disp(['nOCplan = ', num2str(nOC.nOCplan)]);

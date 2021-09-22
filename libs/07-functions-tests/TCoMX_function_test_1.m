%% MFcalc

Nleaves = 12;

%sinogram = rand(10,Nleaves);

sinogram = [0 2 6 0 1 2 0 0 2 4 0 0 ;
            0 0 0 0 0 0 0 0 0 0 0 0 ;
            0 0 4 5 2 0 3 2 1 3 0 0 ;
            10 10 0 10 0 10 10 0 10 0 10 10 ;
            0 0 1 2 4 0 0 3 0 0 0 0; 
            0 0 0 1 0 0 0 0 4 0 0 0];

sinogram = sinogram/10;
        
% Allocate a matrix for the MF of each leaf
MFleaf = zeros(1, size(sinogram,2));

% Computation of MF

% Compute the MF for each leaf over all CPs
for ll=1:Nleaves
        MFleaf(1,ll) = max(sinogram(1:end-1,ll)) / mean(nonzeros(sinogram(1:end-1,ll)));
end

% Compute the average MF over all leaves with MF != NaN
MFplan = mean(MFleaf, 'omitnan');

% Compute the std of MF over all leaves with MF!= NaN
MFstd  = std(MFleaf, 'omitnan');


%% LOTstats

sinogram = [0 2 6 0 1 2 0 0 2 4 0 0 ;
            0 0 0 0 0 0 0 0 0 0 0 0 ;
            0 0 4 5 2 0 3 2 1 3 0 0 ;
            0 1 1 2 4 0 0 3 0 2 3 0; 
            0 0 0 0 0 0 0 0 0 0 0 0];

sinogram = sinogram/10;

Nleaves = size(sinogram,2);

NCP = size(sinogram,1);

ProjectionTime = 1000; % ms --> 1 s
% Compute statistical metrics

% Compute the mean LOT
stats.meanLOT = mean(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); % ms

% Compute the std open time
stats.stdLOT =   std(nonzeros(sinogram(1:end-1,:)*ProjectionTime)); % ms

stats.LOT100cp  = zeros(NCP-1,1);
stats.LOT50cp   = zeros(NCP-1,1);
stats.LOT30cp   = zeros(NCP-1,1);
stats.LOTpt20cp = zeros(NCP-1,1);

% Iteration over the projections
for cp=1:NCP-1 % Projections = NCP - 1
    % Indexes of leaves open at this projection
    openleaves = find(sinogram(cp,:)>0);
    
    % Percentage of open leaves with LOT < 100 ms
    stats.LOT100cp(cp,1)  = nnz(sinogram(cp, openleaves)*ProjectionTime < 100)/ ... 
         length(openleaves)*100;
    
    if isinf(stats.LOT100cp(cp,1))
        stats.LOT100cp(cp,1) = NaN;
    end
    
    % Percentage of open leaves with LOT <  50 ms
    stats.LOT50cp(cp,1)   = nnz(sinogram(cp, openleaves)*ProjectionTime <  50)/ ... 
         length(openleaves)*100;
    
    if isinf(stats.LOT50cp(cp,1))
        stats.LOT50cp(cp,1) = NaN;
    end
    
    % Percentage of open leaves with LOT <  30 ms
    stats.LOT30cp(cp,1)   = nnz(sinogram(cp, openleaves)*ProjectionTime <  30)/ ...
         length(openleaves)*100;
    
    if isinf(stats.LOT30cp(cp,1))
        stats.LOT30cp(cp,1) = NaN;
    end
    
    % Percentage of open leaves with LOT > (pT - 20) ms
    stats.LOTpt20cp(cp,1) = nnz(sinogram(cp, openleaves)*ProjectionTime > ...
        (ProjectionTime - 20))/ length(openleaves)*100;
    
    if isinf(stats.LOTpt20cp(cp,1))
        stats.LOTpt20cp(cp,1) = NaN;
    end
end

% Averages and stds over all projections
stats.LOT100plan = mean(stats.LOT100cp, 'omitnan');
stats.LOT100std  = std( stats.LOT100cp, 'omitnan');

stats.LOT50plan = mean(stats.LOT50cp, 'omitnan');
stats.LOT50std  = std( stats.LOT50cp, 'omitnan');

stats.LOT30plan = mean(stats.LOT30cp, 'omitnan');
stats.LOT30std  = std( stats.LOT30cp, 'omitnan');

stats.LOTpt20plan = mean(stats.LOTpt20cp, 'omitnan');
stats.LOTpt20std  = std( stats.LOTpt20cp, 'omitnan');


%% LOTVcalc

sinogram = [0 2 6 0 1 2 0 0 2 4 0 0 ;
            0 0 0 0 0 0 0 0 0 0 0 0 ;
            0 0 4 5 2 0 3 2 1 3 0 0 ;
            0 1 1 2 4 0 0 3 0 2 3 0; 
            0 0 0 0 0 0 0 0 0 0 0 0];

sinogram = sinogram/10;

Nleaves = size(sinogram,2);

NCP = size(sinogram,1);

ProjectionTime = 1000; % ms --> 1 s

% Maxium LOT for each leaf across all CPs
tmax = max(sinogram, [], 1);

% Find the open leaves
activeleaves = find(tmax>0);

% Allocate memory for the LOTV of each leaf
LOTVleaf = zeros(1,size(sinogram,2));

% Computation of LOTV 

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

% Compute the standard deviation over all leaves
LOTVstd  = std(LOTVleaf, 'omitnan');



%% PSTVcalc 

sinogram = [0 2 6 0 1 2 0 0 2 4 0 0 ;
            0 0 0 0 0 0 0 0 0 0 0 0 ;
            0 0 4 5 2 0 3 2 1 3 0 0 ;
            0 1 1 2 4 0 0 3 0 2 3 0; 
            0 0 0 0 0 0 0 0 0 0 0 0];

sinogram = sinogram/10;

Nleaves = size(sinogram,2);

NCP = size(sinogram,1);

ProjectionTime = 1000; % ms --> 1 s

% Computation of PSTV

% Compute the PSTV metric at each projection (NProjections = NCP - 1)
PSTVcp = sum(abs(sinogram(1:end-2,1:end-1) - sinogram(1:end-2,2:end)),2) ...
         + sum(abs(sinogram(1:end-2, :) - sinogram(2:end-1, :)),2);

% Compute the average over all CPs
PSTVplan = mean(PSTVcp);

% Compute the std over all CPs
PSTVstd  = std(PSTVcp);


%% LNScalc

sinogram = [0 2 6 0 1 2 0 0 2 4 0 0 ;
            0 0 0 0 0 0 0 0 0 0 0 0 ;
            0 0 4 5 2 0 3 2 1 3 0 0 ;
            0 1 1 2 4 0 0 3 0 2 3 0; 
            0 0 0 0 0 0 0 0 0 0 0 0]; %Last CP is always empty

sinogram = sinogram/10;
Nleaves = size(sinogram,2);
NCP = size(sinogram,1);

% Select the leaves which are open at each projection
openleaves = sinogram(1:end-1,:) > 0;

% Allocate the matrix with the numbers of open neighbors of each leaf
% The entries are initialized to 9 (arbitrary number > 2, with 2 the 
% maximum number of neighbor a leaf can have) so that at
% the end the closed leaves will all have nb = -9. This is done in
% order not to have problem with 0 valued entries which can be either
% open or closed leaves and where only open are needed. 
nb = 9*ones(NCP-1, size(sinogram,2));

% Count the number of neighbors of each leaf

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

% Compute the L#NS metrics

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
L0NSstd  = std(L0NScp, 'omitnan');

L1NSplan = mean(L1NScp, 'omitnan');
L1NSstd  = std(L1NScp, 'omitnan');

L2NSplan = mean(L2NScp, 'omitnan');
L2NSstd  = std(L2NScp, 'omitnan');

%   Check if L0NScp + L1NScp + L2NScp == 100 \%   
%     if (nnz(L0NScp+L1NScp+L2NScp - 100) ~= 0)
%         disp(['Error:' num2str(nnz(L0NScp+L1NScp+L2NScp - 100))]);
%     end


%% CLScalc

sinogram = [0 2 6 0 1 2 0 0 2 4 0 0 ;
            0 0 0 0 0 0 0 0 0 0 0 0 ;
            0 0 4 5 2 0 3 2 1 3 0 0 ;
            0 1 1 2 4 0 0 3 0 2 3 0; 
            0 0 0 0 0 0 0 0 0 0 0 0]; %Last CP is always empty

sinogram = sinogram/10;
Nleaves = size(sinogram,2);
NCP = size(sinogram,1);

% Compute the CLS metrics: percentage ratio of closed leaves to all leaves

% Select the leaves which are closed at each CP
closedleaves = sinogram(1:end-1,:) == 0;

% Compute the CLS at each CP
CLScp   = sum(closedleaves,2)/size(closedleaves,2)*100;

% Compute the average over all CPs
CLSplan = mean(CLScp, 'omitnan');

% Compute the std over all CPs
CLSstd  = std(CLScp, 'omitnan');

clear closedleaves

% Percentage ratio of closed leaves within the treatment area.

% Allocate the CLSin array
CLSin = zeros(NCP - 1,1);

for ii=1:NCP - 1 % Number of projections = number of CPs - 1
    % Select the ii-th projection
    tmp = sinogram(ii,:);

    % Get the indices of non-zero elements (open leaves)
    idx = find(tmp>0);

    % Count the number of closed leaves in the treatment area (between
    % idx(1) and idx(end)
    if (nnz(idx)>0)
        % Count the closed leaves within the treatment area
        closedleaves = nnz(tmp(1,idx(1):idx(end))==0);

        % Compute the percentage ratio of close leaves between idx(min) and
        % idx(max). Add one to the denominator due to matlab numbering
        % (startin from 1) otherwise I would loose an element in the
        % counting
        CLSin(ii) = closedleaves / Nleaves * 100; %(idx(end)-idx(1)+1) * 100;
    end
end

% Compute the arithmetic average over all projections
CLSinplan = mean(CLSin, 'omitnan');

% Compute the standard deviation over all projections
CLSinstd  = std(CLSin, 'omitnan');


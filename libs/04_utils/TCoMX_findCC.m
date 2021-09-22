function [openidx, closedidx, connected_components] = TCoMX_findCC(A)

% Take the absolute values of the sinogram entries (useless)
A = abs(A);

% Select all the open leaves
A(A>0) = 1;

% Select all the closed leaves
A(A~=1)= 0;

% Find the indexes of the open leaves 
openidx = find(A>0);

% Select the indexes of the closed leaves whithing the treatment area
closedidx = find(A(openidx(1):openidx(end))==0);

% Shift the indexes to be consistent with the leaf position
closedidx  = closedidx + openidx(1) - 1;

% Add the first and last open to make the differences
closedidx = [openidx(1)-1, closedidx, openidx(end)+1];

% Compute the length of the components
connected_components = diff(closedidx)-1;

% Take only nonzero-length components
connected_components = connected_components(connected_components>0);

end
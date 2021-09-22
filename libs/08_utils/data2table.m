function T = data2table(data, rownames, colnames)

% Create table to export the results of the correlations as .xlsx file
% Row are the metrics, colums the different gamma analysis
% First columns contains the names of the metrics
T = array2table(rownames.');
%T.Properties.VariableNames = cellstr([""]);

% From 2 column to the end the correlation and the p-values are reported
T1 = array2table(data);
T1.Properties.VariableNames = cellstr(colnames);

% Merge together the first column and the others
T = [T T1];

end
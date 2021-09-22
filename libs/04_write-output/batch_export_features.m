function batch_export_features(inputpath, outputfld)

if ~exist(fullfile(inputpath,'1FeatureResultSet_Result', outputfld), 'dir')
    mkdir(fullfile(inputpath, '1FeatureResultSet_Result',  outputfld));
    
    files = dir(fullfile(inputpath, '1FeatureResultSet_Result', '*.xlsx'));

    for fn = 1:length(files)
        create_feature_struct(inputpath, files(fn).name, fullfile(inputpath,'1FeatureResultSet_Result', outputfld));
    end
    
else
    disp('Existing results directory found! Delete/rename it if you want to proceed.');
end

function create_feature_struct(inputpath, fname, outputpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   DESCRIPTION
%   This function works on the feature .xlsx file provided by IBEX and
%   creates a structure with a table for each case in cases. It needs a
%   feature file for each feature category
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    feature_table = readtable(fullfile(inputpath, '1FeatureResultSet_Result', fname), 'Sheet', 'Result');
    feature_names = readtable(fullfile(inputpath, '1FeatureResultSet_Result', fname), 'Sheet', 'Feature Info.');
    data_info     = readtable(fullfile(inputpath, '1FeatureResultSet_Result', fname), 'Sheet', 'Data Info.');
    
    struct.info.Category = feature_names{4,1};
 
    feature_names = feature_names{4:end-1, 3};
    
    data_info = data_info(:, [3 4 10]);
    
    struct.info.nfeatures = length(feature_names);
    struct.info.feature_names = feature_names;
    
    startidx = find(strcmpi([feature_table{:, 1}], "D1"));
    
    feature_table = feature_table(startidx:end,[2 5:end]);
    
    feature_table.Properties.VariableNames = ['plan_name'; feature_names];
    struct.data.features = feature_table;
    
    add_features_to_dataset(feature_table, data_info, inputpath);
    
    save(fullfile(outputpath, [fname(1:end-5) '.mat']), 'struct');
end

    function add_features_to_dataset(feature_table, data_info, inputpath)
        
        inputpar = read_input_parameters();
        
        load(fullfile(inputpar.inputfolder, 'dataset_finale_precision_features.mat'), 'dataset');
        load(fullfile(inputpar.inputfolder, 'match_table.mat'), 'match_table');
        matfiles = dir(fullfile(inputpath, '1FeatureDataSet_ImageROI', '*.mat'));
        load(fullfile(matfiles(1).folder, matfiles(1).name), 'DataSetsInfo');

        dataset.metrics.names = [dataset.metrics.names, convertCharsToStrings(feature_table.Properties.VariableNames(2:end))];
        
        feature_matrix = zeros(numel(dataset.registry), length(feature_table.Properties.VariableNames)-1);
        
        for didx = 1:size(feature_table,1)

            nameidx = find(contains(data_info{:,2}, dataset.registry(didx).Name, 'IgnoreCase', true));
            name = dataset.registry(didx).Name;
            surnameidx = find(contains(data_info{:,2}, dataset.registry(didx).Surname, 'IgnoreCase', true));
            surname = dataset.registry(didx).Surname;
     
            tidx = intersectall(nameidx, surnameidx);
            
            if length(tidx)==1
                feature_matrix(didx, :) = feature_table{tidx, 2:end};
            else  
                for fidx=1:length(tidx)
                    srcpath = DataSetsInfo(tidx(fidx)).SrcPath;
                    srcpath = strrep(srcpath, '\', '/');
                    srcpath = strrep(srcpath, 'R:', '/home/samu/Documenti/FS');
                    info = dicominfo(fullfile(srcpath, 'DICOMInfo', 'ImageSet_0CT.dcm'));
                    matchidx = find(contains(convertCharsToStrings({match_table.SOPInstanceUID}), convertCharsToStrings(info.SOPInstanceUID)));
                    feature_matrix(match_table(matchidx).dataset_position, :) = feature_table{tidx(fidx), 2:end};
                    
                end
            end
            
        end
        
        dataset.metrics.values = [dataset.metrics.values, feature_matrix];
        save(fullfile(inputpar.inputfolder, 'dataset_finale_precision_features.mat'), 'dataset');
    end

end
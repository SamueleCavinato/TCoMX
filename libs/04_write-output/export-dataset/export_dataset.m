function export_dataset(dataset_name, fname, varargin)

datasetvarname = 'dataset';

for vi=1:numel(varargin)
    if strcmpi(varargin{vi}, 'datasetvarname')
        datasetvarname = varargin{vi+1};
    end
end


[inputpar,~] = read_input_parameters();

savepath = fullfile(inputpar.inputfolder, fname); 

load(fullfile(inputpar.inputfolder, [dataset_name '.mat']), datasetvarname);

dataset = eval(datasetvarname);

registry = struct2table(dataset.registry);
writetable(registry,[savepath '.xlsx'],'Sheet','registry');

plans  = struct2table(dataset.plans);

writetable([registry(:,2:3),plans(:,1:end-1)],[savepath '.xlsx'],'Sheet','plans');
    
try 
    for aa = 1:length(dataset.metrics.names)
        name = dataset.metrics.names{aa};
        idx  = find(isspace(name));
        if idx ~= 0
            name = name(1:idx-1);
        end
        dataset.metrics.names{aa} = name;
    end

    tabnames = cellstr(dataset.metrics.names);
    %tabnames = strcat('F', tabnames);
    metrics = array2table(dataset.metrics.values);
    metrics.Properties.VariableNames = tabnames;
catch
    disp('Names not valid');
end

gamma = struct2table(dataset.gamma);
writetable([registry(:, 2:3), plans(:,3), gamma],[savepath '.xlsx'],'Sheet','gamma');
try
    writetable([registry(:, 2:3), plans(:,3), metrics],[savepath '.xlsx'],'Sheet','metrics');
catch
end

end

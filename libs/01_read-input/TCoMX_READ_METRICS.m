function METRICS_LIST = TCoMX_READ_METRICS

fid  = fopen('input/METRICS.in');
file_content = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

METRICS_LIST = [];

categories = {'LOT statistics';
              'Sinogram';};

subcategories = {{'Absolute LOT'; 'Relative LOT';};
                 {'Modulation'; 'Geometry';}};

cat_indexes = [];
cat_flag    = [];

for cat = 1:numel(categories)
    tmp = find(contains(file_content{1,1}, categories{cat,1}));
    if ~isempty(tmp)
        cat_indexes = [cat_indexes; tmp];
        cat_flag = [cat_flag; cat];
    end
end

cat_indexes(end+1) = length(file_content{1,1})+1;

clear cat tmp

for cat_idx = 1:length(cat_flag)
    
    categories{cat_flag(cat_idx),1} = strrep(categories{cat_flag(cat_idx),1}, ':', '');
    categories{cat_flag(cat_idx),1} = strrep(categories{cat_flag(cat_idx),1}, ' ', '_');
    
    subcat_indexes = [];
    subcat_flag    = [];
    
    for subcat = 1:numel(subcategories{cat_flag(cat_idx),1})
        tmp = find(contains(file_content{1,1}, subcategories{cat_flag(cat_idx),1}{subcat,1}));
        if ~isempty(tmp)
            subcat_indexes = [subcat_indexes; tmp];
            subcat_flag = [subcat_flag; subcat];
        end
    end
    
    clear tmp subcat
    
    try 
        subcat_indexes(length(subcat_indexes)+1) = cat_indexes(cat_flag(cat_idx)+1);
    catch
        subcat_indexes(length(subcat_indexes)+1) = cat_indexes(cat_flag);
    end
    
    for subcat_idx = 1:length(subcat_flag)
        
        subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1} = strrep(subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1}, ':', '');
        subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1} =  strrep(subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1}, ' ', '_');
        
        metrics = file_content{1,1}(subcat_indexes(subcat_idx)+1:subcat_indexes(subcat_idx+1)-1,1);
        
        for met_idx = 1:numel(metrics)
            
            metrics{met_idx,1} = strrep(metrics{met_idx,1}, ' ', '');
            metrics{met_idx,1} = strrep(metrics{met_idx,1}, '\n', '');
            
            if ~isempty(metrics{met_idx,1})
                
                check_parameters = find(contains(metrics{met_idx,1}, '->'));
                
                if isempty(check_parameters)
                    
                    METRICS_LIST.(categories{cat_flag(cat_idx),1}).(subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1}).(metrics{met_idx,1}).parameters = [];
                    
                else
                    
                    tmp_idx = strfind(metrics{met_idx,1}, '->');
                    
                    METRICS_LIST.(categories{cat_flag(cat_idx),1}).(subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1}).(metrics{met_idx,1}(1:tmp_idx-1)).parameters = {};
                    
                    parameters = metrics{met_idx,1}(tmp_idx+2:end);
                    
                    separator_idx = strfind(parameters, ',');
                    
                    separator_idx = [0 separator_idx length(parameters)+1];
                    
                    for sep_idx = 1:length(separator_idx)-1
                        
                        METRICS_LIST.(categories{cat_flag(cat_idx),1}).(subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1}).(metrics{met_idx,1}(1:tmp_idx-1)).parameters{length(METRICS_LIST.(categories{cat_flag(cat_idx),1}).(subcategories{cat_flag(cat_idx),1}{subcat_flag(subcat_idx),1}).(metrics{met_idx,1}(1:tmp_idx-1)).parameters)+1} = parameters(separator_idx(sep_idx)+1:separator_idx(sep_idx+1)-1);
                        
                    end
                    
                end
            end
        end
        
    end
    
end

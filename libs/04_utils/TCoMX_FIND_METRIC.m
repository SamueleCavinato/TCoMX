function output = TCoMX_FIND_METRIC(METRICS_LIST, name)

    output = [];
    
    categories = fieldnames(METRICS_LIST);
    
    for cat_idx = 1:length(categories)
        
        subcategories = fieldnames(METRICS_LIST.(categories{cat_idx,1}));
        
        for subcat_idx = 1:length(subcategories)
        
            metrics = fieldnames(METRICS_LIST.(categories{cat_idx,1}).(subcategories{subcat_idx,1}));
            idx = find(strcmpi(metrics, name));
            
            if ~isempty(idx)
                
               output.category = categories{cat_idx,1};
               output.subcategory = subcategories{subcat_idx,1};
               output.metric = name;
               output.parameters = METRICS_LIST.(categories{cat_idx,1}).(subcategories{subcat_idx,1}).(metrics{idx}).parameters;
               
               break
               
            end
                        
        end
        
    end

end
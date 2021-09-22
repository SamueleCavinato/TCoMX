function metrics_table = TCoMX_export_metrics_table(patients)

    metrics_table = [];
    
    for pidx = 1:numel(patients)
        
        table_row = [];
        
        categories = fieldnames(patients(pidx).patient);

        for catidx = 1:numel(categories)
            
            subcategories = fieldnames(patients(pidx).patient.(categories{catidx}));
            
            for subcatidx = 1:numel(subcategories)
                
                try
                    table_row = [table_row struct2table(patients(pidx).patient.(categories{catidx}).(subcategories{subcatidx}))];
                catch
                    keyboard
                end
                
            end
            
        end
        
        metrics_table = [metrics_table; table_row];
        
    end

end
function idx_to_remove = remove_qa_sessions(dataset)

load(fullfile('/home/samu/Documenti/FS/R4.RadixActComplexity/2.1.TEST-RadixActComplexitLongRun/utils', 'plans_to _remove.mat'), 'plans_to_remove');

idx_to_remove = [];

for dt=1:numel(dataset.registry)
    
    idx = find(strcmpi([plans_to_remove.Surname], dataset.registry(dt).Surname));
    
    if ~isempty(idx)
        
        idx = intersectall(idx, find(strcmpi([plans_to_remove.Name], dataset.registry(dt).Name)));
        
        if ~isempty(idx)
            
            idx = intersectall(idx, find(strcmpi([plans_to_remove.RTPlanName], dataset.plans(dt).RTPlanName)));
            
            if length(idx)==1
                
                idx_to_remove = [idx_to_remove; dt];
                
            end
            
        end
    end
    
end

end


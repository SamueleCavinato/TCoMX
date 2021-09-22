function match_table = create_match_table(dicompath)

    folders = dir(dicompath);
    
    inputpar = read_input_parameters();
    
    load(fullfile(inputpar.inputfolder, 'dataset_finale_precision.mat'), 'dataset');
    
    match_table = [];
    
    globalidx = 0;
    
    for fldidx = 3:numel(folders)
       
        files = dir(fullfile(dicompath, folders(fldidx).name, 'CT*'));
        
        for fidx = 1:numel(files)
            globalidx = globalidx + 1;

            idx = strfind(files(fidx).name, '_');
            
            match_table(globalidx).ID = folders(fldidx).name;
            match_table(globalidx).dataset_position = str2num(files(fidx).name(idx(1)+1:idx(2)-1));
            match_table(globalidx).Name = dataset.registry(match_table(globalidx).dataset_position).Name;
            match_table(globalidx).Surname = dataset.registry(match_table(globalidx).dataset_position).Surname;
            match_table(globalidx).RTPlanName = dataset.plans(match_table(globalidx).dataset_position).RTPlanName;
            info = dicominfo(fullfile(dicompath, folders(fldidx).name, files(fidx).name));
            match_table(globalidx).SOPInstanceUID = info.SOPInstanceUID;
            match_table(globalidx).NCP = dataset.plans(match_table(globalidx).dataset_position).tomoplan.NCP;
            match_table(globalidx).CTName = files(fidx).name;
            
        end
        
    end

end


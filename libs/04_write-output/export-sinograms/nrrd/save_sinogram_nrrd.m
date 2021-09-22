function save_sinogram_nrrd(nGL)

    [inputpar,~] = read_input_parameters();

    load(fullfile(inputpar.inputfolder, 'dataset.mat'), 'dataset');
    
    savefld = inputpar.inputfolder();
    
    subfld = '/sinograms_nrrd';
    
    if ~exist([savefld, subfld], 'dir')
        disp('>>   Creating the following folders:');
        disp(['>>      ' savefld, subfld]);
        disp(['>>      ' savefld, subfld,'/images']);
        disp(['>>      ' savefld, subfld '/masks']);
        mkdir([savefld, subfld]);
        mkdir([savefld, subfld, '/images']);
        mkdir([savefld, subfld, '/masks']);
        
    else
        if ~exist([savefld, subfld, '/images'], 'dir')
            disp('>>   Creating the following folders:');
            disp(['>>      ' savefld, subfld, '/images']);
        end
        if ~exist([savefld, subfld, '/masks'], 'dir')
            disp('>>   Creating the following folders:');
            disp(['>>      ' savefld, subfld, '/masks']);
        end
    end
    
    for ld = 1:numel(dataset.registry)
        disp(['>>   Creating nrrd file for patient ', num2str(ld), ':', num2str(dataset.registry(ld).ID)]);
        
        % Load the sinogram for the current plan
        sinogram = dataset.plans(ld).tomoplan.sinogram;
        
        % Define the scaling factor for the discretization
        SF = max(sinogram(:))/(nGL-1);
        
        % Create a 3D matrix to contain the sinogram
        image = zeros(size(sinogram,1), size(sinogram,2),2);
        
        % Add to the first slice the discretized sinogram
        image(:,:,1) = round(sinogram/SF);  
        
        % Define the mask (whole sinogram area)
        mask = zeros(size(sinogram,1), size(sinogram,2),2);
        
        for pj = 1:size(sinogram,1) 
            idx = find(sinogram(pj,:) > 0);
            if ~isempty(idx)
             mask(pj, idx(1):idx(end),1) = 1;
            end
        end
         
        % Save the image
        disp(['>>       Saving image...']);
        filename = fullfile(savefld, subfld, '/images', ['pt_' num2str(ld) '_' dataset.registry(ld).ID '_' dataset.registry(ld).BirthDate '_image.nrrd']);                
        nrrdWriter(filename, image, [1,1,1], [0,0,0], 'ascii');
        
        % Save the mask
        disp(['>>       Saving mask...']);
        filename = fullfile(savefld, subfld,'/masks', ['pt_' num2str(ld) '_' dataset.registry(ld).ID '_' dataset.registry(ld).BirthDate '_mask.nrrd']);  
        nrrdWriter(filename, mask, [1,1,1], [0,0,0], 'ascii');
             
    end

end
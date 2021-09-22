path = ["R:\R4.RadixActComplexity\1.RadixActComplexity\P1_tomo_results\0-RAYSTATION-NORMALIZED-METRICS-20212913597.098";
        "R:\R4.RadixActComplexity\1.RadixActComplexity\P1_tomo_results\0-PRECISION-NORMALIZED-METRICS-20212914225.719"];
        
for pt=1:length(path)
    %names = ["MF", "TTDF", "meanLOT", "stdLOT", "medianLOT", "modeLOT", "LOT100", "LOT50", "LOT30", "LOTpt20", "LOTV", "PSTV", "MI", "L0NS", "L1NS", "CLS", "CLSin", "Pitch", "FieldWidth", "ProhjectioTime" "GantryPeriod", "TreatmentTime", "TargetLength", "CouchSpeed", "CouchTranslation"];
%     names = {'MF', 'TTDF', 'meanLOT', 'stdLOT', 'medianLOT', 'modeLOT', 'LOT100', 'LOT50', 'LOT30', 'LOTpt20', 'LOTV', 'PSTV', 'MI', 'L0NS', 'L1NS', 'CLS', 'CLSin', 'Pitch', 'Field Width', 'ProjectioTime', 'GantryPeriod', 'TreatmentTime', 'TargetLength', 'CouchSpeed', 'CouchTranslation'};
    
    load(fullfile(path(pt), 'variables.mat'));
    T = array2table(tomometrics(:,:));
    
    indexes = 1:size(tomometrics,2);
    
    A = cellstr(tomometricsnames(indexes));    
    
    for aa = 1:length(tomometricsnames(indexes))
        name = A{aa};
        idx  = find(isspace(name));
        if idx ~= 0
           name = name(1:idx-1);
        end
        A{aa} = name;
    end
%     
     T.Properties.VariableNames = A;
    
     writetable(T, fullfile(path(pt), 'tomometrics.xlsx'));
    
end

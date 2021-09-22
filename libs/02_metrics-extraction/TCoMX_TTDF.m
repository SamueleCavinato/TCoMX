function patient = TCoMX_TTDF(tomoplan, METRICS_LIST, patient)
%
%%%%%%%%%%%%% DA SISTEMARE!!!!!!
%
%
%
%% Compute the TreatmentTime/FractionDose metric

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'TTDF');

if ~isempty(output)
    
    if isempty(output.parameters)

        metricname = 'TTDF';
        
        patient.(output.category).(output.subcategory).(metricname) = tomoplan.TreatmentTime / FractionDose; % [s/cGy]

    end
    
end
clear patients FractionDose
end


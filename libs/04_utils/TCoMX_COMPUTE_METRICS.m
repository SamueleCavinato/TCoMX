function patient = TCoMX_COMPUTE_METRICS(tomoplan, METRICS_LIST)
    
functions = {@TCoMX_MF, ...
             @TCoMX_LOTstats, ...
             @TCoMX_nOC, ...
             @TCoMX_PSTV, ...
             @TCoMX_LOTV, ...
             @TCoMX_MI, ...
             @TCoMX_LNS, ...
             @TCoMX_CLS, ...
             @TCoMX_FOT, ...
             @TCoMX_MSA};

patient = [];

for funcidx = 1:numel(functions)

    patient = functions{funcidx}(tomoplan, METRICS_LIST, patient);
    
end

% LOTV(planidx).LOTV = LOTVcalc(tomoplan);
% 
% TTDF(planidx).TTDF = TTDFcalc(tomoplan, dataset.plans(planidx).DoseFractionCGy);
%  
% MI(planidx).MI = MIcalc(tomoplan);
% 
% LNS(planidx).LNS = LNScalc(tomoplan);
% 
% [CLS(planidx).CLS, area(planidx).area] = CLScalc(tomoplan);
% 
% LOTh(planidx) = LOThistogram(tomoplan);
% 
% FOT(planidx).FOT = FOTcalc(tomoplan);
% 
    
end
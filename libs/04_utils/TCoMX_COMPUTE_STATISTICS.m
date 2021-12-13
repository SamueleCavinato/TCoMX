function metrics_statistics = TCoMX_COMPUTE_STATISTICS(metrics_table)

    metrics_statistics = [];
    
    metrics_statistics = [metrics_statistics; mean(metrics_table{:,:}, 1, 'omitnan')];
    metrics_statistics = [metrics_statistics; median(metrics_table{:,:}, 1, 'omitnan')];
    metrics_statistics = [metrics_statistics; mode(metrics_table{:,:})];
    metrics_statistics = [metrics_statistics; std(metrics_table{:,:}, 1, 'omitnan')];
    metrics_statistics = [metrics_statistics; min(metrics_table{:,:}, [], 1, 'omitnan')];
    metrics_statistics = [metrics_statistics; max(metrics_table{:,:}, [], 1, 'omitnan')];

    metrics_statistics = array2table(metrics_statistics);
    RowNames = cell2table({'Mean'; 'Median'; 'Mode'; 'SD'; 'Min'; 'Max'});
    metrics_statistics.Properties.VariableNames = metrics_table.Properties.VariableNames;
    metrics_statistics = [RowNames metrics_statistics];
    metrics_statistics.Properties.VariableNames{1,1} = 'stat';

end
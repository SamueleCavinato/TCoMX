function [mean_data, median_data, std_data, meanCI, distribution, date] = compute_sw_average(tpos, tdata, deltat, deltas)

mean_data   = [];
median_data = [];
std_data    = [];

meanCI     = [];
date   = {};

distribution = [];

for gg = 1:length(tdata)
    if 1+gg*deltas+deltat <= length(tdata)
        date_set = tpos(1+(gg-1)*deltas:1+(gg-1)*deltas+deltat);
        tmpdate  = date_set(round(deltat/2));
        
        date{end+1} = datestr(datenum(num2str(tmpdate, '%d'), 'yyyymmdd'), 'dd-mmm-yyyy');
                
        distribution = [distribution, tdata(1+(gg-1)*deltas:1+(gg-1)*deltas+deltat)'];
        
        tmp_data = tdata(1+(gg-1)*deltas:1+(gg-1)*deltas+deltat);
        outlier_idx = isoutlier(tmp_data,'percentiles',[0 100]);
        tmp_data    = tmp_data(outlier_idx==0);

        mean_data   = [mean_data mean(tmp_data)];
        median_data = [median_data median(tmp_data)];
        std_data  = [std_data std(tmp_data)];
        ts = tinv([0.1585 0.8415],sqrt(deltat)-1);                           % T-Score
        meanCI = [meanCI; mean_data(end) + ts*std_data(end)/sqrt(deltat)]; % Confidence Intervals
    end
end


end


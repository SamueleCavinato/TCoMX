function plans_to_keep = remove_period(dates, period)
    
    for pp=1:size(period,1)
        
        if pp == 1
            try
            plans_to_keep = find([dates]<period(pp, 1));
            plans_to_keep = [plans_to_keep, find([dates]>period(pp, 2))];
            catch
                keyboard
            end
        else
            try
            plans_to_keep = intersect(plans_to_keep, find([dates]<period(pp,1)));
            plans_to_keep = [plans_to_keep, find([dates]>period(pp,2))];
            catch
                keyboard
            end
        end
        
    end

end
function plot_grid(minx,maxx, miny, maxy)
    %         Plot horizontal lines
    
    hold on
    
    for yy=miny:maxy
        plot([minx+0.5, maxx+0.5], [yy+0.5, yy+0.5], 'k-');
        hold on
    end

    %         Plot vertical lines
    for xx=minx:maxx
        plot([xx+0.5, xx+0.5], [miny+0.5, maxy+0.5], 'k-');
        hold on
    end

end

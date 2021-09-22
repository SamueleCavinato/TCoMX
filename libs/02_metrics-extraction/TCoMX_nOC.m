function patient = TCoMX_nOC(tomoplan, METRICS_LIST, patient)

output  = TCoMX_FIND_METRIC(METRICS_LIST, 'nOC');

if ~isempty(output)

    if isempty(output.parameters)
        sinogram = tomoplan.sinogram;

        sinogram(sinogram == 1)  = -1;
        sinogram(sinogram > 0)   = 1;
        sinogram(sinogram == -1) = 2;

        leafmov = zeros(1, tomoplan.Nleaves);

        for nl=1:tomoplan.Nleaves
            for cp = 1:tomoplan.NCP-1
                if sinogram(cp, nl) == 0
                    if sinogram(cp+1, nl) == 2
                        leafmov(nl) = leafmov(nl)+1;  
                    end
                end

                if sinogram(cp,nl) == 1
                    leafmov(nl) = leafmov(nl)+2;
                    if sinogram(cp+1, nl) == 2
                        leafmov(nl) = leafmov(nl)+1;
                    end
                end

                if sinogram(cp, nl) == 2
                    if sinogram(cp+1, nl) == 0
                        leafmov(nl) = leafmov(nl)+1;
                    elseif sinogram(cp+1, nl) == 1
                        leafmov(nl) = leafmov(nl)+1;
                    end
                end    
            end
        end

        patient.(output.category).(output.subcategory).(output.metric)  = mean(leafmov)/(tomoplan.NCP-1);

    end
end

end
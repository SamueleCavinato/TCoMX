function output_vector = TCoMX_READ_VECTOR_PARAMETER(parameter)

    start_idx  = strfind(parameter, '[');
    end_idx    = strfind(parameter, ']');
    sep_idx    = strfind(parameter, ';');

    xx = str2num(parameter(start_idx+1:sep_idx-1));
    yy = str2num(parameter(sep_idx+1:end_idx-1));

    output_vector = [xx yy];
    
end
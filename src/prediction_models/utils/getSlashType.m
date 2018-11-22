function slashtype = getSlashType()
    if ismac
        % Code to run on Mac plaform
        slashtype='/';
    elseif ispc
        % Code to run on Windows platform
        slashtype='\';
    else
        error('System Type not defined.')
    end

end
function foundWarning = catchWarning(functionName, warningMsg)
    foundWarning = false;
    logFile = '.testCatch.log';

    % run the function in diary mode
    diary(logFile);
    eval(functionName);
    diary off

    % loop through the temporary diary file
    fid = fopen(logFile);
    tline = fgetl(fid);
    while ischar(tline)
        tline = fgetl(fid);
        disp(tline);
        if ~isempty(tline) && contains(tline, warningMsg)
            foundWarning = true;
            break;
        end
    end
    fclose(fid);

    % remove the temporary diary file
    delete(logFile);
end
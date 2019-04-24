function success = verifyFunctionWarning(functionCall, warningMessage, varargin)
% Tests if the warning message fits to the provided warning
%
% USAGE:
%
%    success = verifyFunctionWarning('functionCall', warningMessage, varargin)
%
% INPUTS:
%    functionCall:       The name of a function.
%    warningMessage:     The warning message that we want to capture
%
% OUPUTS: 
%    success:            Catch the provided warning message in tline
%
% EXAMPLE:
%    % Test whether PaCER function throws the provided warning message: 
%    verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT})
%
% AUTORS:
%    Laurent Heirendt, April 2019
%    Loic Marx, April 2019
%
% NOTE: 
%    This function has been adapted from
%    https://github.com/opencobra/cobratoolbox/blob/master/test/verifyCobraFunctionError.m
%    [5aa9ccd]

parser = inputParser();
parser.addRequired('functionCall', @ischar)
parser.addRequired('warningMessage', @ischar)
parser.addParamValue('inputs', {}, @iscell)
parser.addParamValue('outputArgCount', 0, @(x) isnumeric(x) && mod(x,1) == 0);
parser.parse(functionCall, warningMessage, varargin{:});

outputArgcount = parser.Results.outputArgCount;
inputs = parser.Results.inputs;
functionCall = str2func(functionCall);

% initialize the test 
success = false; 
% create an hidden file 
logFile = '.testCatch.log'; 
% run the function in diary mode
diary(logFile);
try   
    if outputArgcount > 0
        outArgs = cell(outputArgcount, 1);
        [outArgs{:}] = functionCall(inputs{:});
    else
        functionCall(inputs{:});
    end 
end 
    diary off
    
% loop through the temporary diary file
    fid = fopen(logFile);
    tline = fgetl(fid);
    counter = 0;
    % Read one line at a time until you reach the end of the file
    while ~feof(fid) 
        % Concatenate the text if the provided warning message is found in the 3 next line, otherwise tline is empty
        tline = [tline ' ' fgetl(fid)];
        if ~isempty(tline) && contains(tline, warningMessage)
            success = true;
            break;
        end
        if counter > 3
            tline = '';
            counter = 0;
        end
        counter = counter + 1;
    end
    
    fclose(fid);
    % remove the temporary diary file
    delete(logFile);
end

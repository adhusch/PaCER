function success = verifyFunctionWarning(functionCall, warningMessage, varargin)
% Tests if the warning message fits to the warning provided
%
% USAGE:
%
%    success = verifyFunctionWarning(functionCall, warningMessage, varargin)
%
% INPUTS:
%    functionCall:       The name of a function.
%    warningMessage:     The warning message that we want to capture
%
% OUPUTS: 
%    success:            Catch the provided warning message
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
parser.addParamValue('inputs',{},@iscell)
parser.addParamValue('outputArgCount',0,@(x) isnumeric(x) && mod(x,1) == 0);

parser.parse(functionCall, warningMessage, varargin{:});

outputArgcount = parser.Results.outputArgCount;
%warningMessage = ~any(ismember('warningMessage',parser.UsingDefaults));
%message = parser.Results.warningMessage;
inputs = parser.Results.inputs;

functionCall = str2func(functionCall);
success = false;

logFile = '.testCatch.log';
diary(logFile); % run the function in diary mode
try   
    if outputArgcount > 0
        outArgs = cell(outputArgcount,1);
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
    while ~feof(fid)
        tline = [tline ' ' fgetl(fid)];
        %disp(tline);
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

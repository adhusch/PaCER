% The PaCER Toolbox: testInvPolyArcLength3.m
%
% Purpose:
%     - test the invPolyArcLength3 function
%
% Author:
%     - Loic Marx, May 2019

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

%% setup the reference data to capture the warning message 
polyCoeff = [1 2; -1 1];
arcLength = -1;  
t_ref = 0; 

% call the function 
t_new = invPolyArcLength3(polyCoeff, arcLength);

% compare the reference data and the new generated data
assert(isequal(t_ref, t_new)); 

% capture the warning message 
warningMessage = 'invPolyArcLength3: given arcLength is negative! Forcing t=0. This is wrong but might be approximatly okay for the use case! Check carefully!';
assert(verifyFunctionWarning('invPolyArcLength3', warningMessage, 'inputs', {polyCoeff_ref, arcLength_ref}));

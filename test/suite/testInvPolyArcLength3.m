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
polyCoeff = [1, 2, 3];
arcLength = -1;  
t_ref = 0; 

% generate the new output  
t_new = invPolyArcLength3(polyCoeff, arcLength);

% compare the reference data and the new generated data
assert(isequal(t_ref, t_new)); 

% capture the warning message 
warningMessage = 'invPolyArcLength3: given arcLength is negative! Forcing t=0. This is wrong but might be approximatly okay for the use case! Check carefully!';
assert(verifyFunctionWarning('invPolyArcLength3', warningMessage, 'inputs', {polyCoeff, arcLength}));

%% setup the reference data to test if ~arcLength(i)<0
polyCoeff;
arcLength_2 = 10; 
t_ref2 = 0; 

% generate the new output 
t_new2 = invPolyArcLength3(polyCoeff, arcLength_2);

% compare the reference data and the new generated data
assert(isequal(t_ref2, t_new2));

% change back to the current directory
cd(currentDir);

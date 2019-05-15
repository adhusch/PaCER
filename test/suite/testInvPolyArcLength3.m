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

% setup the inputs arguments to capture the warning message 
polyCoeff = [1 1 1; 2 3 4]; % degree 1 polynomial in 3d, i.e. a straight line through 3d space with bias (1) in each x,y,z direction and a slope of 2 in x, 3 in y and 4 and z direction.
arcLength = -1;  

% reference data hard-coded
t_ref = 0; 

% generate the new output  
t_new = invPolyArcLength3(polyCoeff, arcLength);

% compare the reference data and the new generated data
assert(isequal(t_ref, t_new)); 

% capture the warning message when arcLength is negative
warningMessage = 'invPolyArcLength3: given arcLength is negative! Forcing t=0. This is wrong but might be approximatly okay for the use case! Check carefully!';
assert(verifyFunctionWarning('invPolyArcLength3', warningMessage, 'inputs', {polyCoeff, arcLength}));

% setup the inputs arguments to satisfy the condition when ~arcLength(i)<0
polyCoeff;
arcLength_positive = 10; 
tol = 1e-4; % tolerence value for the comparison between reference data and the new output

% reference data hard-coded
t_ref_positive = 5.7735; 

% generate the new output using a positive value for arcLength 
t_new_positive = invPolyArcLength3(polyCoeff, arcLength_positive);

% compare the reference data and the new generated data
assert(norm(t_ref_positive - t_new_positive) < tol);

% change back to the current directory
cd(currentDir);

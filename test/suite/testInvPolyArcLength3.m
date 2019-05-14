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

% setup the reference data 
polyCoeff = [1 2; -1 1];
arcLength = 0; 

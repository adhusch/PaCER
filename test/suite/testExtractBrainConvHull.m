% The PaCER Toolbox: testExtractBrainConvHull.m
%
% Purpose:
%     - test the extractBrainConvHull function
%
% Author:
%     - Loic Marx, March 2019

global refDataPath
global inputDataPath
global PACERDIR

%% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);


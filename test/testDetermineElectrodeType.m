% The PaCER Toolbox: testDetermineElectrodeType.m
%
% Purpose:
%     - test the determineElectrodeType function
%
% Author:
%     - Loic Marx, March 2019

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load reference data
load('RefData_determineElectrodeType.mat');

% define input argument
peakDistances_new = [0.7500 1.75];

% generate new output 
[elecStruct_new, rms_new, d_new] = determineElectrodeType(peakDistances_new);

% comparison between refData and new generated output
assert(isequal(elecStruct_ref, elecStruct_new))
assert(isequal(rms_ref, rms_new))
assert(isequal(d_ref, d_new))

% change back to the current directory
cd(currentDir); 



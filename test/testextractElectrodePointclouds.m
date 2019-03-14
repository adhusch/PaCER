% The PaCER Toolbox: testextractElectrodePointclouds.m
%
% Purpose:
%     - test the extractElectrodePointclouds function
%
% Author:
%     - Loic Marx, March 2019

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load reference data
refData = load ([getenv('PACER_DATA_PATH') filesep 'refData_extractElectrodePC.m'])

% generate data
niiCT_new = NiftiMod([getenv('PACER_DATA_PATH') filesep 'ct_post.nii.gz'])
[elecsPointcloudStruct_new, brainMask_new] = extractElectrodePointclouds(niiCT)

% compare the reference data 



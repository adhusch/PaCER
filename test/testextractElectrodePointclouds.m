% The PaCER Toolbox: testExtractElectrodePointclouds.m
%
% Purpose:
%     - test the extractElectrodePointclouds function
%
% Author:
%     - Loic Marx, March 2019

global refDataPath
global inputDataPath

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load reference data
refData = load([refDataPath filesep 'refData_extractElectrodePC.mat']);
niiCT_new = load ([inputDataPath filesep 'ct_post.nii.gz']);

% generate new data
[elecsPointcloudStruct_new, brainMask_new] = extractElectrodePointclouds(niiCT_new);

% compare the new data against the reference data 
assert(isequal(elecsPointcloudStruct_new, refData.elecsPointcloudStruct_ref))
assert(isequal(brainMask_new, refData.brainMask_ref))

% apply post CT brain mask
niiCT_brainMask_ref = NiftiMod([getenv('PACER_DATA_PATH') filesep 'input' filesep 'ct_post.nii.gz'])
brainMask_ref = NiftiMod([getenv('PACER_DATA_PATH') filesep 'input' filesep 'ct_post_mask.nii'])

[elecsPointcloudStruct_brainMask_ref, brainMask_brainMask_ref] = extractElectrodePointclouds(niiCT_brainMask_ref,'brainMask',brainMask_ref);



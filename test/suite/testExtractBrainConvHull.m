% The PaCER Toolbox: testExtractBrainConvHull.m
%
% Purpose:
%     - test the extractBrainConvHull function
%
% Author:
%     - Loic Marx, May 2019

global refDataPath
global inputDataPath
global PACERDIR

%% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load reference data (function implemented with niiCT model)
refData = load ([getenv('PACER_DATA_PATH') filesep 'ref' filesep 'refData_extractBrainConvHull.mat']);

% generate the new output
niiCT = NiftiMod([getenv('PACER_DATA_PATH') filesep 'input' filesep 'ct_post.nii.gz']);
[convHullBrainMask_new, roughBrainMask_new] = extractBrainConvHull(niiCT);

% comparison between the new output and the reference data 
assert(isequal(refData.convHullBrainMask_ref, convHullBrainMask_new));
assert(isequal(refData.roughBrainMask_ref, roughBrainMask_new)); 

% test the warning message
warningMessage = 'Uncommon fraction of CT data in threshold range (15-60 HU). Trying to compensate. Make sure to use "soft tissue" reconstruction filters for the CT (e.g. J30 kernel) if this fails.'; 
assert(verifyFunctionWarning('extractBrainConvHull', warningMessage, 'inputs', {niiCT}));

% change back to the current directory
cd(currentDir);
% The PaCER Toolbox: testPaCER.m
%
% Purpose:
%     - test the PaCER function
%
% Author:
%     - Loic Marx, March 2019

global refDataPath
global inputDataPath

%% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

%% load reference data (function implemented only with niiCT model)
refData = load([refDataPath filesep 'refData_PaCER_niiCT.mat']);

% Load post OP CT 
niiCT_PostOP_new = NiftiMod([inputDataPath filesep 'CT_POSTOP_with_XML.nii.gz']);

% generate the new output (testing only niiCT input argument)
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(NiiCT_PostOp_ref);

% compare the new data against the reference data


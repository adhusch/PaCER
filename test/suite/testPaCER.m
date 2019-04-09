% The PaCER Toolbox: testPaCER.m
%
% Purpose:
%     - test the PaCER function
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

%% load reference data (function implemented only with niiCT model)
%refData = load([refDataPath filesep 'refData_PaCER_niiCT.mat']);
refData = load ([getenv('PACER_DATA_PATH') filesep 'ref' filesep 'refData_PaCER_niiCT.mat']);

% Load post OP CT 
%niiCT_PostOP_new = NiftiMod([inputDataPath filesep 'CT_POSTOP_with_XML.nii.gz']);
niiCT_PostOP_new = NiftiMod([getenv('PACER_DATA_PATH') filesep 'input' filesep 'CT_POSTOP_with_XML.nii.gz']);

% generate the new output (testing only niiCT input argument)
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_PostOP_new);

% compare the new data against the reference data
%assert(isequal (elecModels_new, refData.elecModels_ref))
assert(isequal(elecPointCloudsStruct_new, refData.elecPointCloudsStruct_ref))
assert(isequal(intensityProfiles_new, refData.intensityProfiles_ref))
assert(isequal(skelSkelmms_new, refData.skelSkelmms_ref))

%% load reference data (provide brain mask to the CT post OP)
refData_brainMask = load([getenv('PACER_DATA_PATH') filesep 'ref' filesep 'refData_PaCER_WithBrainMask.mat']);

% define input arguments (testing niiCT and brainMask)
niiCT_brainMask_new = NiftiMod([getenv('PACER_DATA_PATH') filesep 'input' filesep 'ct_post.nii.gz']);
brainMaskPath = [getenv('PACER_DATA_PATH') filesep 'input' filesep 'ct_post_mask.nii'];

% generate the new output (testing niiCT and brainMask)
[elecModels_Mask_new, elecPointCloudsStruct_Mask_new, intensityProfiles_Mask_new, skelSkelmms_Mask_new] = PaCER(niiCT_brainMask_new,'brainMask', brainMaskPath);

% compare the new data against the reference data using a BrainMask
%assert(isequal(elecModels_Mask_new{1, 1}, refData_brainMask.elecModels_Mask_Ref{1, 1}))
assert(isequal(elecPointCloudsStruct_Mask_new, refData_brainMask.elecPointCloudsStruct_Mask_Ref))
assert(isequal(intensityProfiles_Mask_new, refData_brainMask.intensityProfiles_Mask_Ref))
assert(isequal(skelSkelmms_Mask_new, refData_brainMask.skelSkelmms_Mask_Ref))
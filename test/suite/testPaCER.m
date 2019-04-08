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

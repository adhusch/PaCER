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


% The PaCER Toolbox: testElectrodePointCloudModelEstimate.m
%
% Purpose:
%     - test the electrodePointCloudModelEstimate function
%
% Author:
%     - Loic Marx, June 2019

global refDataPath
global inputDataPath

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load the input arguments (obtained from function PaCER implemented only with CT_POSTOP_with_XML.nii.gz)
electrodePointCloudModelEstimate_inputs = load([inputDataPath filesep 'input_ElectrodePointCloudModelEstimate.mat']);

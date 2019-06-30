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

% setup tolerence value for comparison
tol = 1e-6; 

% test if nargin < 2 
%load reference data 
refData_elecPointCloudMm = load('refData_testElectrodePointCloudModelEstimate_elecPointCloudMm.mat');

% generate the new output 
[r3polynomial_new, tPerMm_new, skeleton_new, totalLengthMm_new] = electrodePointCloudModelEstimate(electrodePointCloudModelEstimate_inputs.elecPointCloudMm);

% compare the reference data and the new outputs
assert(norm(r3polynomial_new - r3polynomial_ref) < tol)
assert(norm(tPerMm_new - tPerMm_ref) < tol)
assert(norm(skeleton_new - skeleton_ref) < tol)
assert(norm(totalLengthMm_new - totalLengthMm_ref) < tol)
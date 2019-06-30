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
assert(norm(r3polynomial_new - refData_elecPointCloudMm.r3polynomial_ref) < tol)
assert(norm(tPerMm_new - refData_elecPointCloudMm.tPerMm_ref) < tol)
assert(norm(skeleton_new - refData_elecPointCloudMm.skeleton_ref) < tol)
assert(norm(totalLengthMm_new - refData_elecPointCloudMm.totalLengthMm_ref) < tol)

% generate the new output if nargin = 2
[r3polynomial_var1_new, tPerMm_var1_new, skeleton_var1_new, totalLengthMm_var1_new] = electrodePointCloudModelEstimate(electrodePointCloudModelEstimate_inputs.elecPointCloudMm, electrodePointCloudModelEstimate_inputs.varargin{1, 1});


% compare the reference data and the new outputs
assert(norm(r3polynomial_var1_new - refData_elecPointCloudMm.r3polynomial_var1_ref) < tol)
assert(norm(tPerMm_var1_new - refData_elecPointCloudMm.tPerMm_var1_ref) < tol)
assert(norm(skeleton_var1_new - refData_elecPointCloudMm.skeleton_var1_ref) < tol)
assert(norm(totalLengthMm_var1_new - refData_elecPointCloudMm.totalLengthMm_var1_ref) < tol)

% generate the new output if nargin = 3
[r3polynomial_var2_new, tPerMm_var2_new, skeleton_var2_new, totalLengthMm_var2_new] = electrodePointCloudModelEstimate(electrodePointCloudModelEstimate_inputs.elecPointCloudMm, electrodePointCloudModelEstimate_inputs.varargin{1, 1}, electrodePointCloudModelEstimate_inputs.varargin{1, 2});

% compare the reference data and the new outputs
assert(norm(r3polynomial_var2_new - refData_elecPointCloudMm.r3polynomial_var2_ref) < tol)
assert(norm(tPerMm_var2_new - refData_elecPointCloudMm.tPerMm_var2_ref) < tol)
assert(norm(skeleton_var2_new - refData_elecPointCloudMm.skeleton_var2_ref) < tol)
assert(norm(totalLengthMm_var2_new - refData_elecPointCloudMm.totalLengthMm_var2_ref) < tol)

% capture the warning message when nargin < 2 
warningMessage = 'No Reference image for intensity weighting given! Accuracy is thus limited to voxel size!';
assert(verifyFunctionWarning('electrodePointCloudModelEstimate', warningMessage, 'inputs', {electrodePointCloudModelEstimate_inputs.elecPointCloudMm}));

% use another input argument to test error message 
[r3polynomial_error_new, tPerMm_error_new, skeleton_error_new, totalLengthMm_error_new] = electrodePointCloudModelEstimate(refData_elecPointCloudMm.elecPointCloudMm_error);

% compare the reference data and the new outputs
assert(norm(r3polynomial_error_new - refData_elecPointCloudMm.r3polynomial_error_ref) < tol)
assert(norm(tPerMm_error_new - refData_elecPointCloudMm.tPerMm_error_ref) < tol)
assert(norm(skeleton_error_new - refData_elecPointCloudMm.skeleton_error_ref) < tol)
assert(norm(totalLengthMm_error_new - refData_elecPointCloudMm.totalLengthMm_error_ref) < tol)

% capture the warning message if ~(length(zPlanes) < length(elecPointCloudMm))
warningMessage = 'CT planes in Z direction are not exactly aligned. Trying with 0.1 mm tolerance';
assert(verifyFunctionWarning('electrodePointCloudModelEstimate', warningMessage, 'inputs', {refData_elecPointCloudMm.elecPointCloudMm_error}));

% change back to the current directory
cd(currentDir);
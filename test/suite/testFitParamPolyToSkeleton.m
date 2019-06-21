% The PaCER Toolbox: testFitParamPolyToSkeleton.m
%
% Purpose:
%     - test the fitParamPolyToSkeleton function
%
% Author:
%     - Loic Marx, June 2019

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load the input arguments (function PaCER implemented only with CT_POSTOP_with_XML.nii.gz)
fitParamPolyToSkeleton_inputs = load([inputDataPath filesep 'input_fitParamPolyToSkeleton.mat']);

% load reference data 
refData = load([refDataPath filesep 'refData_fitParamPolyToSkeleton.mat']);

% generate the new output
[r3polynomial_new, avgTperMm_new] = fitParamPolyToSkeleton(fitParamPolyToSkeleton_inputs.skeleton, fitParamPolyToSkeleton_inputs.degree);

% compare the new output with the ref data 
assert(isequal(refData.r3polynomial, r3polynomial_new))
assert(isequal(refData.avgTperMm, avgTperMm_new))

% change back to the current directory
cd(currentDir);

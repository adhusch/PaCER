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

% load the input arguments (obtained from function PaCER implemented only with CT_POSTOP_with_XML.nii.gz)
fitParamPolyToSkeleton_inputs = load([inputDataPath filesep 'input_fitParamPolyToSkeleton.mat']);

% setup tolerence value for comparison
tol = 1e-6; 

% load reference data 
refData = load([refDataPath filesep 'refData_fitParamPolyToSkeleton.mat']);

% generate the new output
[r3polynomial_new, avgTperMm_new] = fitParamPolyToSkeleton(fitParamPolyToSkeleton_inputs.skeleton, fitParamPolyToSkeleton_inputs.degree);

% compare the new output with the ref data 
assert(isequal(refData.r3polynomial, r3polynomial_new))
assert(isequal(refData.avgTperMm, avgTperMm_new))

% test if degree is setup to 3 when only the input argument skeleton is provided
[r3polynomial_skel_new, avgTperMm_skel_new] = fitParamPolyToSkeleton(fitParamPolyToSkeleton_inputs.skeleton)

% load the reference data with degree = 3
refData_skel = load('refData_testFitParamPolyToSkeleton_skeleton.mat');

% compare reference data and generated output
assert(norm(refData_skel.r3polynomial_skel_ref - r3polynomial_skel_new)< tol)
assert(norm(refData_skel.avgTperMm_new_skel_ref - avgTperMm_skel_new)< tol)

% change back to the current directory
cd(currentDir);

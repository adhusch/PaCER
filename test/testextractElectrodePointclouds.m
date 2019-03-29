% The PaCER Toolbox: testExtractElectrodePointclouds.m
%
% Purpose:
%     - test the extractElectrodePointclouds function
%
% Author:
%     - Loic Marx, March 2019

global refDataPath
global inputDataPath

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which(mfilename));
cd(fileDir);

% load reference data
refData = load([refDataPath 'refData_extractElectrodePC.mat']);

% generate new data
niiCT_new = NiftiMod([inputDataPath 'ct_post.nii.gz'])
[elecsPointcloudStruct_new, brainMask_new] = extractElectrodePointclouds(niiCT_new);

% compare the new data against the reference data 
assert(isequal(elecsPointcloudStruct_new, refData.elecsPointcloudStruct_ref))
assert(isequal(brainMask_new, refData.brainMask_ref))

% apply post CT brain mask
refData_brainMask = load ([refDataPath 'refData_extractElectrodePC_withBrainMask.mat'])
niiCT_brainMask_new = NiftiMod([inputDataPath 'ct_post.nii.gz'])
brainMaskPath = [inputDataPath 'ct_post_mask.nii']
[elecsPointcloudStruct_brainMask_new, brainMask_brainMask_new] = extractElectrodePointclouds(niiCT_brainMask_new, 'brainMask', brainMaskPath);

% compare the new data against the reference data using a BrainMask
assert(isequal(elecsPointcloudStruct_brainMask_new, refData_brainMask.elecsPointcloudStruct_brainMask_ref))
assert(isequal(brainMask_brainMask_new, refData_brainMask.brainMask_brainMask_ref))

% load reference data for CT post OP with the corresponding XML file
refData_Xml = load([refDataPath 'refData_extractElectrodePC_xmlPlan.mat']);
niiCT_Xml_new = NiftiMod([inputDataPath 'CT_POSTOP_with_XML.nii.gz'])
xml_Plan_new = [inputDataPath 'CT_POSTOP_with_XML.xml'];
[elecsPointcloudStruct_Xml_new, brainMask_Xml_new] = extractElectrodePointclouds(niiCT_Xml_new, 'medtronicXMLPlan', xml_Plan_new);

% compare the new data against the reference data using a XML plan
assert(isequal(elecsPointcloudStruct_Xml_new, refData_Xml.elecsPointcloudStruct_Xml_ref))
assert(isequal(brainMask_Xml_new, refData_Xml.brainMask_Xml_ref))
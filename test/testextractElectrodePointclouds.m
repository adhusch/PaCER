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

% load reference data for CT post OP with XML file
refData_Xml = load([refDataPath 'refData_extractElectrodePC_xmlPlan']);
niiCT_Xml_new = NiftiMod([inputDataPath 'CT_POSTOP_with_XML.nii.gz'])
xml_Plan_new = [inputDataPath 'CT_POSTOP_with_XML.xml'];

[elecModels_xml_new, elecPointCloudsStruct_xml_new] = PaCER(niiCT_Xml_new, 'medtronicXMLPlan', xml_Plan_new, 'electrodeType', 'Medtronic 3389');

% compare the new data against the reference data using a XML plan

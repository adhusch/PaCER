% The PaCER Toolbox: testPaCER.m
%
% Purpose:
%     - test the PaCER function (main function)
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

% set a tolerance for numerical comparison
tol = 1e-6;

% load reference data (function implemented only with niiCT model)
refData = load([refDataPath filesep 'refData_PaCER_niiCT.mat']);

% Load post OP CT
niiCT_PostOP_new = NiftiMod([inputDataPath filesep 'CT_POSTOP_with_XML.nii.gz']);

% generate the new output (testing only niiCT input argument)
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_PostOP_new);

% compare the new data against the reference data
structureComparison(refData.elecModels_ref, elecModels_new)
assert(isequal(elecPointCloudsStruct_new, refData.elecPointCloudsStruct_ref));
for k=1:length(intensityProfiles_new)
    assert(norm(intensityProfiles_new{k} - refData.intensityProfiles_ref{k}) < tol);
end
for k=1:length(skelSkelmms_new)
    assert(norm(skelSkelmms_new{k} - refData.skelSkelmms_ref{k}) < tol);
end

% test the function with XML plan
% load reference data for CT post OP with the corresponding XML file
refData_XML = load ([refDataPath filesep 'refData_PaCER_xmlPlan.mat']);

% define input arguments (testing niiCT and Xml Plan)
niiCT_Xml_new = niiCT_PostOP_new;
xml_Plan_new = [inputDataPath filesep 'CT_POSTOP_with_XML.xml'];

% generate the new output (function implemented with XML plan)
[elecModels_XML_new, elecPointCloudsStruct_XML_new, intensityProfiles_XML_new, skelSkelmms_XML_new] = PaCER(niiCT_Xml_new,'medtronicXMLPlan', xml_Plan_new);

% compare the new data against the reference data using a XML plan
structureComparison(refData_XML.elecModels_XML_ref, elecModels_XML_new)
assert(isequal(elecPointCloudsStruct_XML_new, refData_XML.elecPointCloudsStruct_XML_ref));
for k=1:length(intensityProfiles_XML_new)
    assert(norm(intensityProfiles_XML_new{k} - refData_XML.intensityProfiles_XML_ref{k}) < tol);
end
for k=1:length(skelSkelmms_XML_new)
    assert(norm(skelSkelmms_XML_new{k} - refData_XML.skelSkelmms_XML_ref{k}) < tol);
end

% load reference data (provide brain mask to the CT post OP)
refData_brainMask = load([refDataPath filesep 'refData_PaCER_WithBrainMask.mat']);

% define input arguments (testing niiCT and brainMask)
niiCT_brainMask_new = NiftiMod([inputDataPath filesep  'ct_post.nii.gz']);
brainMaskPath = [inputDataPath filesep 'ct_post_mask.nii'];

% generate the new output (testing niiCT and brainMask)
[elecModels_Mask_new, elecPointCloudsStruct_Mask_new, intensityProfiles_Mask_new, skelSkelmms_Mask_new] = PaCER(niiCT_brainMask_new,'brainMask', brainMaskPath);

% compare the new data against the reference data using a BrainMask
structureComparison(refData_brainMask.elecModels_Mask_Ref, elecModels_Mask_new)
assert(isequal(elecPointCloudsStruct_Mask_new, refData_brainMask.elecPointCloudsStruct_Mask_Ref))
for k=1:length(intensityProfiles_Mask_new)
    assert(norm(intensityProfiles_Mask_new{k} - refData_brainMask.intensityProfiles_Mask_Ref{k}) < tol);
end
for k=1:length(skelSkelmms_Mask_new)
    assert(norm(skelSkelmms_Mask_new{k} - refData_brainMask.skelSkelmms_Mask_Ref{k}) < tol);
end

%% test different electrode type:
% load the reference data
refData_electrodeType = load([refDataPath filesep 'refData_PaCER_electrodeType.mat']);
% define the input argument
niiCT_electrodesType = niiCT_PostOP_new;
xml_Plan_new;

% generate the new output with Medtronic 3387 electrode type.
[elecModels_Medtronic3387_new, elecPointCloudsStruct_Medtronic3387_new, intensityProfiles_Medtronic3387_new, skelSkelmms_Medtronic3387_new] = PaCER(niiCT_electrodesType, 'medtronicXMLPlan', xml_Plan_new, 'electrodeType', 'Medtronic 3387');

% compare the new data against the reference data using XML plan and
% providing electrode type (Medtronic 3387)
structureComparison(elecModels_Medtronic3387_new, refData_electrodeType.elecModels_Medtronic3387_ref)
assert(isequal(elecPointCloudsStruct_Medtronic3387_new, refData_electrodeType.elecPointCloudsStruct_Medtronic3387_ref))
for k=1:length(intensityProfiles_Medtronic3387_new)
    assert(norm(intensityProfiles_Medtronic3387_new{k} - refData_electrodeType.intensityProfiles_Medtronic3387_ref{k}) < tol);
end
for k=1:length(skelSkelmms_Medtronic3387_new)
    assert(norm(skelSkelmms_Medtronic3387_new{k} - refData_electrodeType.skelSkelmms_Medtronic3387_ref{k}) < tol);
end
 
% generate the new output with Medtronic 3389 electrode type.
[elecModels_Medtronic3389_new, elecPointCloudsStruct_Medtronic3389_new, intensityProfiles_Medtronic3389_new, skelSkelmms_Medtronic3389_new] = PaCER(niiCT_electrodesType, 'medtronicXMLPlan', xml_Plan_new, 'electrodeType', 'Medtronic 3389');

% compare the new data against the reference data using XML plan and
% providing electrode type (Medtronic 3389)
structureComparison(elecModels_Medtronic3389_new, refData_electrodeType.elecModels_Medtronic3389_ref)
assert(isequal(elecPointCloudsStruct_Medtronic3389_new, refData_electrodeType.elecPointCloudsStruct_Medtronic3389_ref));
for k=1:length(intensityProfiles_Medtronic3389_new)
    assert(norm(intensityProfiles_Medtronic3389_new{k} - refData_electrodeType.intensityProfiles_Medtronic3389_ref{k}) < tol);
end
for k=1:length(skelSkelmms_Medtronic3389_new)
    assert(norm(skelSkelmms_Medtronic3389_new{k} - refData_electrodeType.skelSkelmms_Medtronic3389_ref{k}) < tol);
end

% generate the new output with Boston electrode type.
[elecModels_Boston_new, elecPointCloudsStruct_Boston_new, intensityProfiles_Boston_new, skelSkelmms_Boston_new] = PaCER(niiCT_electrodesType, 'medtronicXMLPlan', xml_Plan_new, 'electrodeType', 'Boston Vercise Directional');

% compare the new data against the reference data using XML plan and
% providing electrode type (Boston Vercise Directional)
structureComparison(elecModels_Boston_new, refData_electrodeType.elecModels_Boston_ref)
assert(isequal(elecPointCloudsStruct_Boston_new, refData_electrodeType.elecPointCloudsStruct_Boston_ref))
for k=1:length(intensityProfiles_Boston_new)
    assert(norm(intensityProfiles_Boston_new{k} - refData_electrodeType.intensityProfiles_Boston_ref{k}) < tol);
end
for k=1:length(skelSkelmms_Boston_new)
    assert(norm(skelSkelmms_Boston_new{k} - refData_electrodeType.skelSkelmms_Boston_ref{k}) < tol);
end

%% test the warning messages
% test if slice thickness is greater than 1 mm
warningMessage = 'Slice thickness is greater than 1 mm! Independent contact detection is most likly not possible. Forcing contactAreaCenter based method.';
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_PostOP_new}))

% test if Uncommon fraction of CT data in threshold range
warningMessage = 'Uncommon fraction of CT data in threshold range (15-60 HU). Trying to compensate. Make sure to use "soft tissue" reconstruction filters for the CT (e.g. J30 kernel) if this fails. ';
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_PostOP_new}))

% test if No electrode specification given
warningMessage = 'No electrode specification given! Set electrodeType option! Trying to estimate type by contactAreaWidth only which might be wrong! ';
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_PostOP_new}))

% test if PaCER cannot detect independent electrode contacts
warningMessage = 'Could NOT detect independent electrode contacts. Check image quality. ';
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_PostOP_new}))

% test if slice thickness is greater than 0.7 mm
warningMessage = 'Slice thickness is greater than 0.7 mm! Independet contact detection might not work reliable in this case. However, for certain electrode types with large contacts spacings you might be lucky.';
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_brainMask_new}))

%% test different case 
% load reference data including the new condition for
% peakWaveCenter,'displayProfiles' true, 'displayMPR' true and final degree setup to 1
refData_case = load([refDataPath filesep 'refData_PaCER_different_case.mat']);

% if contact detection set to peakWaveCenter
[elecModels_peakWaveCenter_new, elecPointCloudsStruct_peakWaveCenter_new, intensityProfiles_peakWaveCenter_new, skelSkelmms_peakWaveCenter_new] = PaCER(niiCT_brainMask_new,'contactDetectionMethod','peakWaveCenter');

% compare reference data and new outputs
structureComparison(elecModels_peakWaveCenter_new, refData_case.elecModels_peakWaveCenter_ref)
assert(isequal(elecPointCloudsStruct_peakWaveCenter_new, refData_case.elecPointCloudsStruct_peakWaveCenter_ref))
for k=1:length(intensityProfiles_peakWaveCenter_new)
    assert(norm(intensityProfiles_peakWaveCenter_new{k} - refData_case.intensityProfiles_peakWaveCenter_ref{k}) < tol);
end
for k=1:length(skelSkelmms_peakWaveCenter_new)
    assert(norm(skelSkelmms_peakWaveCenter_new{k} - refData_case.skelSkelmms_peakWaveCenter_ref{k}) < tol);
end

% if 'displayProfiles' is true
[elecModels_displayProfiles_new, elecPointCloudsStruct_displayProfiles_new, intensityProfiles_displayProfiles_new, skelSkelmms_displayProfiles_new] = PaCER(niiCT_brainMask_new,'displayProfiles', true);

% compare reference data and new outputs
structureComparison(elecModels_displayProfiles_new, refData_case.elecModels_displayProfiles_ref)
assert(isequal(elecPointCloudsStruct_displayProfiles_new, refData_case.elecPointCloudsStruct_displayProfiles_ref))
for k=1:length(intensityProfiles_displayProfiles_new)
    assert(norm(intensityProfiles_displayProfiles_new{k} - refData_case.intensityProfiles_displayProfiles_ref{k}) < tol);
end
for k=1:length(skelSkelmms_displayProfiles_new)
    assert(norm(skelSkelmms_displayProfiles_new{k} - refData_case.skelSkelmms_displayProfiles_ref{k}) < tol);
end

% if 'displayMPR' is true
[elecModels_displayMPR_new, elecPointCloudsStruct_displayMPR_new, intensityProfiles_displayMPR_new, skelSkelmms_displayMPR_new] = PaCER(niiCT_brainMask_new,'displayMPR', true);

% compare reference data and new outputs
structureComparison(elecModels_displayMPR_new, refData_case.elecModels_displayMPR_ref)
assert(isequal(elecPointCloudsStruct_displayMPR_new, refData_case.elecPointCloudsStruct_displayMPR_ref))
for k=1:length(intensityProfiles_displayMPR_new)
    assert(norm(intensityProfiles_displayMPR_new{k} - refData_case.intensityProfiles_displayMPR_ref{k}) < tol);
end
for k=1:length(skelSkelmms_displayMPR_new)
    assert(norm(skelSkelmms_displayMPR_new{k} - refData_case.skelSkelmms_displayMPR_ref{k}) < tol);
end

% if final degree setup to 1 
%[elecModels_degree_ref, elecPointCloudsStruct_degree_ref, intensityProfiles_degree_ref, skelSkelmms_degree_ref] = PaCER(niiCT_brainMask_new,'finalDegree', 1);
[elecModels_degree_new, elecPointCloudsStruct_degree_new, intensityProfiles_degree_new, skelSkelmms_degree_new] = PaCER(niiCT_brainMask_new,'finalDegree', 1);

% compare reference data and new outputs
structureComparison(elecModels_degree_new, refData_case.elecModels_degree_ref)
assert(isequal(elecPointCloudsStruct_degree_new, refData_case.elecPointCloudsStruct_degree_ref))
for k=1:length(intensityProfiles_degree_new)
    assert(norm(intensityProfiles_degree_new{k} - refData_case.intensityProfiles_degree_ref{k}) < tol);
end
for k=1:length(skelSkelmms_degree_new)
    assert(norm(skelSkelmms_degree_new{k} - refData_case.skelSkelmms_degree_ref{k}) < tol);
end

%% Use extra dataset to test error message 
% test if PaCER thrown an error when No electrode artifact are found in the CT supplied
w = warning ('off','all');
niiCT_inputs = NiftiMod([inputDataPath filesep 'PaCER_ct_post_OK_2.nii.gz']); 
try
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_inputs,'noMask',false);
catch ME
    assert(length(ME.message) > 0)
end
w = warning ('on','all');

%%
niiCT_error_1 = NiftiMod([inputDataPath filesep 'PaCER_postop_error_1.nii.gz']);
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_error_1)

warningMessage = 'invPolyArcLength3: given arcLength is negatie! Forcing t=0. This is wrong but might be approximatly okay for the use case! Check carefully!';
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_error_1}))

% catch error message if 'finalDegree' is invalid
w = warning ('off','all');
niiCT_error_1;
try
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_error_1,'medtronicXMLPlan')
catch ME
    assert(length(ME.message) > 0)
end
w = warning ('on','all');


niiCT_error_2 = NiftiMod([inputDataPath filesep 'PaCER_postop_error_2.nii.gz']);
warningMessage = 'checkNifti: qform_code == sform_code, however the transformation defined in the qform differes from the sform! This might indicate a serious flaw in the nifti header and lead to unexpected results as different tools/algorithms might deal differently with this situation. Fix the nifti header of your file before continuing.';
assert(verifyFunctionWarning('checkNiftiHdr', warningMessage, 'inputs', {niiCT_error_2}))

warningMessage = 'CT planes in Z direction are not exactly aligned. Trying with 0.1 mm tolerance'
assert(verifyFunctionWarning('PaCER', warningMessage, 'inputs', {niiCT_error_2}))

warningMessage_1 = 'determineElectrodeType: Could NOT detect electrode type! Electrode contact detection might by flawed. To low image resolution (to large slice thickness)!? Set electrode type manually if you want to continue with this data';
warningMessage_2 = 'Could NOT detect independent electrode contacts. Check image quality. ';


%for n = 1:2     
%assert(verifyFunctionWarning('PaCER', sprintf('warningMessage_%d', n), 'inputs', {niiCT_error_2}))
%end 
assert(verifyFunctionWarning('PaCER', warningMessage_1, 'inputs', {niiCT_error_2}))
assert(verifyFunctionWarning('PaCER', warningMessage_2, 'inputs', {niiCT_error_2}))

%%testing additional parameter
niiCT_PaCER_9 = NiftiMod([inputDataPath filesep 'PaCER_ct_post_OK_9.nii.gz']);
[elecModels_new_9, elecPointCloudsStruct_new_9, intensityProfiles_new_9, skelSkelmms_new_9] = PaCER(niiCT_PaCER_9, 'reverseDir', true, 'contactAreaCenter','peak')

structureComparison(refData.elecModels_ref_9, elecModels_new_9)
assert(isequal(elecPointCloudsStruct_new_9, refData.elecPointCloudsStruct_ref_9));
for k=1:length(intensityProfiles_new_9)
    assert(norm(intensityProfiles_new_9{k} - refData.intensityProfiles_ref_9{k}) < tol);
end
for k=1:length(skelSkelmms_new_9)
    assert(norm(skelSkelmms_new_9{k} - refData.skelSkelmms_ref_9{k}) < tol);
end


niiCT_PaCER_8 = NiftiMod([inputDataPath filesep 'PaCER_ct_post_OK_8.nii.gz']);
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_PaCER_8, 'reverseDir', true, 'contactAreaCenter','peakWaveCenter')

niiCT_PaCER_6 = NiftiMod([inputDataPath filesep 'PaCER_ct_post_OK_6.nii.gz']);
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_PaCER_6, 'reverseDir', true, 'contactDetectionMethod','peak')

niiCT_PaCER_5 = NiftiMod([inputDataPath filesep 'PaCER_ct_post_OK_5.nii.gz']);
[elecModels_new, elecPointCloudsStruct_new, intensityProfiles_new, skelSkelmms_new] = PaCER(niiCT_PaCER_5, 'reverseDir', true, 'contactDetectionMethod','contactAreaCenter')


%% change back to the current directory
cd(currentDir);

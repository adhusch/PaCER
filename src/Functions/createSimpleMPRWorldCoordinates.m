function [mpr, oc] = createSimpleMPRWorldCoordinates(nii)
% Convenience Wrapper for the MPRWorldCoordinate Class by Florian Bernard
%
% USAGE:
%
%    [mpr, oc] = createSimpleMPRWorldCoordinates(nii)
%
% INPUT:
%    nii:       NiftiModality object to visualize as multi-planar-reformatting (MPR)
%
% OUTPUTS:
%    mpr:       Handle to MPR
%    oc:        optional orientation cube (deprecated)
%
% .. AUTHOR:
%       - Andreas Husch, Original file
%       - Daniel Duarte, Documentation

axesObj = gca; %axesObj = axes('Parent', mprPanel); %mprPanel = uipanel('Parent', gcf);
mpr = MPRWorldCoordinates(axesObj, nii.img, [0 0 0], nii);
view(160,10);
%oc = OrientationCube(mprPanel, axesObj);
%axes(axesObj);
end
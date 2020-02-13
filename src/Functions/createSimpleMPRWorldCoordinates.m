function [mpr] = createSimpleMPRWorldCoordinates(nii)
% Convenience Wrapper for the MPRWorldCoordinate Class by Florian Bernard
%
% USAGE:
%
%    [mpr] = createSimpleMPRWorldCoordinates(nii)
%
% INPUT:
%    nii:       NiftiModality object to visualize as multi-planar-reformatting (MPR)
%
% OUTPUTS:
%    mpr:       Handle to MPR
%
% .. AUTHOR:
%       - Andreas Husch, Original file
%       - Daniel Duarte, Documentation

axesObj = gca; %axesObj = axes('Parent', mprPanel); %mprPanel = uipanel('Parent', gcf);
mpr = MPRWorldCoordinates(axesObj, nii.img, [0 0 0], nii);
view(160,10);
end
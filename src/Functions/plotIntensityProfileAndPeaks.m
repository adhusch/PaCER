function [peakLocs, peakWaveCenters, peakValues, threshIntensityProfile, threshold] = getIntensityPeaks(intensityProfile, skelScaleMm, filterIdxs);
%
% USAGE:
%
%    [peakLocs, peakWaveCenters, peakValues, threshIntensityProfile, threshold]
%    = getIntensityPeaks(intensityProfile, skelScaleMm, filterIdxs);
%
% INPUTS: 
%    intensityProfile:      
%    skelScaleMm:           
%    filterIdxs:            
%
% OUTPUTS: 
%    peakLocs                   
%    peakWaveCenters:           
%    peakValues:                
%    threshIntensityProfile:    
%    threshold:                 
%
% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation

filterIdxs = find(skelScaleMm <= 20); % restrict to first 20mm

figure('Name', 'Intensity Profile');
ax = gca;
xlabel('Length [mm]');
ylabel('Intensity Measure [HU]');
ylim([0 max(intensityProfile(filterIdxs))*1.05]);
xlim([0 20]) % show only first 20 mm
hold on;
hProfile = plot(skelScaleMm, intensityProfile);
plot(peakLocs, peakValues + 0.03 * peakValues, 'v', 'MarkerFaceColor', hProfile.Color, 'MarkerEdgeColor', hProfile.Color);
ax.ColorOrderIndex = ax.ColorOrderIndex - 1;
plot(skelScaleMm(filterIdxs), threshIntensityProfile(filterIdxs));
scatter(peakWaveCenters, repmat(threshold,1,length(peakWaveCenters)), 'filled');
grid on;
end


% function plotIntensityProfileAndPeaks(intensityProfile, skelScaleMm)

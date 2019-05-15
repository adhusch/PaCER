function plotIntensityProfileAndPeaks(intensityProfile, skelScaleMm)
%
% USAGE:
%
%    plotIntensityProfileAndPeaks(intensityProfile, skelScaleMm)
%
% INPUTS: 
%    intensityProfile:      a 1D Intensity profile
%    skelScaleMm:           Estimated scale (mm per intensity sample)
%
% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation

filterIdxs = find(skelScaleMm <= 20); % restrict to first 20mm
[peakLocs, peakWaveCenters, peakValues, threshIntensityProfile, threshold] = getIntensityPeaks(intensityProfile, skelScaleMm, filterIdxs);

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



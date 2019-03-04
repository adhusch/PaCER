function [elecStruct, rms, d] = determineElectrodeType(peakDistances)
% gets the most suitable electrode type based on the euclidean distance between 
% detected and specified peaks in the collected data. Data should should be provided 
% in the form of the file 'electrodeGeometries.mat'. 
%
% USAGE:
%
%    [electStruct, rms, d] = determineElectrodeType(peakDistances)
%
% INPUT: 
%    peakDistances:     The peak distances between the signals, provided by the inserted 
%                       data sheet.   
%
% OUTPUTS: 
%    electStruct:       Electrode Type.
%    rms:               Root-mean-square of the distance between the electrode signals.
%    d:                 ?
%
% .. AUTHOR:
%       - Andreas Husch, Original file
%       - Daniel Duarte, Documentation

electrodeGeometries = load('electrodeGeometries.mat');
electrodeGeometries = electrodeGeometries.electrodeGeometries;

distances = nan(1,length(electrodeGeometries));
rms = nan(1,length(electrodeGeometries));

for i=1:length(electrodeGeometries)   
    try
        distances(i) = norm(diff(peakDistances) - electrodeGeometries(i).diffsMm);
        rms(i) = sqrt(mean((diff(peakDistances) - electrodeGeometries(i).diffsMm).^2));
    catch
        distances(i) = Inf;
        rms(i) = Inf;

    end
end

if all(distances == Inf)
    warning('determineElectrodeType: Could NOT detect electrode type! Electrode contact detection might by flawed. To low image resolution (to large slice thickness)!? Set electrode type manually if you want to continue with this data');
    elecStruct = electrodeGeometries(end);
    return
end
[d,idx] = min(distances);
rms = rms(idx);
disp(['determineElectrodeType: data to model peak/contact spacing RMS distance is ' num2str( rms ) ' [mm]']); % CHECK NORM VS RMS (MEAN  / VS SUM)
elecStruct = electrodeGeometries(idx);
end
function t = invPolyArcLength3(polyCoeff, arcLength)
% Numerically calculate the parameter (t) of parameterized [0,1] -> R^3 polynomial
% *given* an arc length (measured from 0) i.e. find the corresponding t to an arc length
% (e.g. given in [mm] from the origin), or in other words numerically invert polyArcLength3
%
% USAGE:
%
%    t = invPolyArcLength3(polyCoeff, arcLength)
%
% INPUTS: 
%    polyCoeff:     Coefficient matrix
%    arcLength:     
%
% OUTPUT: 
%    t:     
%
% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation

t = zeros(size(arcLength)); % default t=0 (i.e. in case arcLength is 0)
for i = 1:length(arcLength)
    if(arcLength(i)<0)
        warning('invPolyArcLength3: given arcLength is negative! Forcing t=0. This is wrong but might be approximatly okay for the use case! Check carefully!');
    else
        t(i) = fminsearch( @(b)(abs(arcLength(i) - polyArcLength3(polyCoeff,0,b))), 0);
    end
    
end
end
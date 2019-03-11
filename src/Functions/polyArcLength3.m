function arcLength = polyArcLength3(polyCoeff, lowerLimit, upperLimit)
%
% USAGE:
%
%    arcLength = polyArcLength3(polyCoeff, lowerLimit, upperLimit)
%
% INPUTS: 
%    polyCoeff:     Coefficient matrix
%    lowerLimit:    Lower limit, taken as scalar or vector input. If put in as a vector,
%                   arc lengths are returned for all pairs of intervals between the lower   
%                   and upper limit.
%    upperLimit:    Upper limit, taken as scalar or vector input. If put in as a vector,
%                   arc lengths are returned for all pairs of intervals between the upper   
%                   and lower limit.
%
% OUTPUT: 
%    arcLength:     Length of the arc.
%
% .. AUTHOR:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation

epsilon = 0.001; % avoid numerical accuracy problems in assertion
assert(all(lowerLimit(:) <= upperLimit(:) + epsilon));

regX = polyCoeff(:,1);
regY = polyCoeff(:,2);
regZ = polyCoeff(:,3);

x_d = polyder(regX);
y_d = polyder(regY);
z_d = polyder(regZ);

arcLength = nan(size(lowerLimit));

for i = 1:length(lowerLimit)
    f = @(t) sqrt(polyval(x_d, t).^2 + polyval(y_d, t).^2 + polyval(z_d, t).^2); % The arc length is defined as the integral of the norm of the derivatives of the parameterized equations.
    arcLength(i) = integral(f,lowerLimit(i),upperLimit(i));
end

end
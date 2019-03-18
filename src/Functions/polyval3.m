function val = polyval3(polyCoeffs, evalAt)
% evaluate an (independent component) polynomial in R3
%
% USAGE:
%
%    val = polyval3(polyCoeffs, evalAt)
%
% INPUTS: 
%    polyCoeffs:    Coefficient matrix
%    evalAt:        
%
% OUTPUT: 
%    val:       
%
% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation

    x = polyval(((polyCoeffs(:,1))), evalAt); 
    y = polyval(((polyCoeffs(:,2))), evalAt);
    z = polyval(((polyCoeffs(:,3))), evalAt);
    val = [x y z];
end
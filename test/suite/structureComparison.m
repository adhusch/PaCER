function structureComparison(structure_ref, structure_new)
% Loop and compare the fieldname of the dedicated structure for reference
% data and the new generated data.
%
% USAGE:
%
%    structureComparison(structure_ref, structure_new)
%
% INPUT: 
%    structure_ref:   reference structure
%    structure_new:   newly generated structure
%
% OUTPUTS: 
%   The comparison succeed if both structure compared (reference data and
%   new generated data) are identical.
%
% .. AUTHOR:
%       - Loic MARX, MAY 2019

    for j=1:length(structure_ref)
        fn = fieldnames(structure_ref{j});
        for k = 1:length(fn) 
            if (~isnumeric(getfield(structure_new{j}, fn{k})) && ~isnumeric(getfield(structure_ref{j}, fn{k})))
                assert(isequal(getfield(structure_new{j}, fn{k}), getfield(structure_ref{j}, fn{k})))
            end
        end
    end
end

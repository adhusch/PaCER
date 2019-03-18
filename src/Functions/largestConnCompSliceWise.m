function binaryMask = largestConnCompSliceWise(img3d)
%
% USAGE:
%
%    binaryMask = largestConnCompSliceWise(img3d)
%
% INPUT: 
%    img3d:     
%
% OUTPUT: 
%    binaryMask:    
%
% .. AUTHORS:
%       - Andreas Husch, Original File
%       - Daniel Duarte Tojal, Documentation


binaryMask = false(size(img3d));

for i = 1:size(img3d,3) % z
    cc = bwconncomp(img3d(:,:,i));
    ccProps = regionprops(cc, 'Area', 'PixelIdxList');
    [~, idx] = sort([ccProps.Area]);
    brainMaskIdxs = [];
    if (~isempty(idx))
        brainMaskIdxs = ccProps(idx(end)).PixelIdxList;
    end
    binarySlice = false(size(img3d(:,:,i)));
    binarySlice(brainMaskIdxs) = true;
    binaryMask(:,:,i) = binarySlice;
end
end
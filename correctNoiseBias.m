function signal = correctNoiseBias(signal, sigma, nCoilElements)
% Input:
%   signal          - array of to be corrected signal values
%   sigma           - noise standard deviation
%   nCoilElements   - number of receive elements in sum-of-squares reco


%%
if exist('noiseBiasLookupTable.mat', 'file') == 2

    lookupTable = load('noiseBiasLookupTable');

else
    
    error('The .mat file noiseBiasLookupTable must be on the search path')

end


%%
Index = lookupTable.nElements == nCoilElements;

if nnz(Index) == 0
    error(['Desired number of coil elements not in lookup table.', ...
                ' Use createLookupTable to generate corresponding entry'])
end


%%
signal = lookupTableEstimate(signal, sigma,...
                    lookupTable.Apoints, lookupTable.Mpoints(Index, :));



function [AEstimate] = lookupTableEstimate(image, sigma, Apoints, Mpoints)

% All images are scalled to sigma=1 to be able to use the same lookup table
% Can take a complete image or just one value as input.
% Uses a simple interpolation between points

image = abs(image)./sigma;
AEstimate = zeros(size(image));

spacing = Apoints(2)-Apoints(1);

for ii = 1:numel(image)

    if image(ii) >= max(Mpoints)
        AEstimate(ii) = sigma*image(ii);
    elseif image(ii)<= min(Mpoints)
        AEstimate(ii) = 0;
    else

    larger = Mpoints >= image(ii);
    firstLarger = find(larger,1);

    AEstimate(ii) = Apoints(firstLarger-1) + spacing*(image(ii) - Mpoints(firstLarger-1))/(Mpoints(firstLarger) - Mpoints(firstLarger-1));
    AEstimate(ii) = sigma*AEstimate(ii);
    
    end
end

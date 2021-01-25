function signal = correctNoiseBias(signal, sigma, nCoilElements)
% performs noise bias correction for (root) sum-of-squares reconstructed
% MRI magnitude data following the methodology of R. Henkelman "Measurement
% of signal intensities in the presence of noise in MR images" (1985)
%
% See Constantinides, Atalar, McVeigh "Signal-to-Noise Measurements in 
% Magnitude Images from NMR Phased Arrays" (1997) for details regarding
% multiple receive element coils.
%
% See Starke, Niendorf and Waiczies "Data Preparation Protocol for Low 
% Signal-to-Noise Ratio Fluorine-19 MRI" (2021) for a usage example.
%
% 
% A lookup table is used to improve performance compared to repeated
% evaluation of the non-central chi distribution mean. As the function
% computing the lookup table depends on laguerreL, which is only included
% in newer versions of the symbolic math toolbox, the computation is 
% relegated to a separate function and tables for 1, 2, 4, 8, 16, 32 
% and 64 elements are provided by default. 
%
%
% Input:
%   signal          - array of to be corrected signal values
%   sigma           - noise level, defined as the standard deviation of
%                     Gaussian noise in the individual receive channels
%   nCoilElements   - number of receive elements
%
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin; 21-01-25
%
% License: GNU GPLv3 


% load lookup tables
if exist('noiseBiasLookupTable.mat', 'file') == 2
    lookupTable = load('noiseBiasLookupTable');
else
    error('The .mat file noiseBiasLookupTable must be on the search path')
end


% select correct table
Index = lookupTable.nElements == nCoilElements;

if nnz(Index) == 0
    error(['Desired number of coil elements not in lookup table.', ...
                ' Use createLookupTable to generate corresponding entry'])
end


% perform correction
signal = lookupTableEstimate(signal, sigma,...
                    lookupTable.Apoints, lookupTable.Mpoints(Index, :));

end

%%
function [AEstimate] = lookupTableEstimate(image, sigma, Apoints, Mpoints)

% All images are scalled to sigma=1 to be able to use the same lookup table
% Can take a complete image or just one value as input.
% Uses a simple linear interpolation between points

image = abs(image)./sigma;
AEstimate = zeros(size(image));

% values below the background expectation
mask_below = image <= min(Mpoints);
AEstimate(mask_below) = 0;

% values above the lookup table range
mask_above = image > max(Mpoints);
AEstimate(mask_above) = image(mask_above);

% values inside the lookup table range
mask_inside = (~mask_below) & (~mask_above);
AEstimate(mask_inside) = interp1(Mpoints, Apoints, image(mask_inside), 'linear', 0);

% rescaling
AEstimate = sigma*AEstimate;


end

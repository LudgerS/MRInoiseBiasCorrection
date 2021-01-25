%
% createLookupTable.m
%
% creates a lookup-table for the mean of the non-central chi distribution
%
% See function 'expectationValueMultiReceiverCoil' below for details.
% Keep sigma = 1 for compatibility with function 'correctNoiseBias' from
% the MRInoiseBiasCorrection tool.
%
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin; 21-01-25
%
% License: GNU GPLv3 

clear

sigma = 1;
nElements = [1, 2, 4, 8, 16, 32, 64];


minA = 0;
maxA = 40;
points = 10^4;

Apoints = linspace(minA,maxA,points);

Mpoints = zeros(numel(nElements), numel(Apoints));

for ii = 1:numel(nElements)
    
    Mpoints(ii, :) = expectationValueMultiReceiverCoil(sigma, Apoints, nElements(ii));

    fprintf('%d receive elements done\n', nElements(ii))

end

save('noiseBiasLookupTable', 'nElements', 'Apoints', 'Mpoints')


function [y] = expectationValueMultiReceiverCoil(sigma, An, nElements)

% Expectation value of non-central chi distribution
% 
% Compare Constantinides "Signal-to-Noise Measurements in Magnitude Images from
% NMR Phased Arrays" and https://en.wikipedia.org/wiki/Noncentral_chi_distribution
% with x = M_n/sigma and lambda = A_n/sigma
%
% Valid for 1 or more receive elements when the image is reconstructed as
% the (root) sum-of-squares.
%
% As what is given on wikipedia is the expectation value of the normalized signal 
% A_n/sigma, it is rescaled by multiplication with sigma.

y = sigma*sqrt(pi/2)*laguerreL(1/2,nElements-1,-An.^2./(2*sigma^2));


end

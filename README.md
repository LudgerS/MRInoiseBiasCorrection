# MRInoiseBiasCorrection
This repository contains simple Matlab / Octave code to correct the noise induced bias in (root) sum-of-square reconstructed MR magnitude images.

Contains:

- correctNoiseBias.m        : the core function you might want to include in your project
- createLookupTable.m       : a script to create new lookup tables if the desired number of coil elements is not provided by default
- noiseBiasLookupTable.mat  : lookup tables for 1, 2, 4, 8, 16, 32 or 64 channel coils
- testNoiseBiasCorrection.m : a short script to test the correction and show its effect on the measured mean signal intensity

See commentary in functions for details and references.

Everything is licensed under GNU GPLv3 

Ludger Starke; Max Delbrück Center for Molecular Medicine in the Helmholtz Association, Berlin; 21-01-25

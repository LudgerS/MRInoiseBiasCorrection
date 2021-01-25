%
% testNoiseBiasCorrection.m
%
% Run to test function 'correctNoiseBias.m'
%
% Written by Ludger Starke; Max Delbrück Center for Molecular Medicine in
% the Helmholtz Association, Berlin; 21-01-25
%
% License: GNU GPLv3 

clear, close all

nCoilElements = 4;
sigma = 5;


%% simulate noisy data
nSignalLevels = 200;
nRepetitions = 10^4;

maxSnr = 25;
trueSignal = linspace(0, maxSnr, nSignalLevels)*sigma;


channelSignal = repmat(trueSignal/sqrt(nCoilElements), [nRepetitions, 1, nCoilElements]);
dim = size(channelSignal);                    
channelSignal = channelSignal + sigma*(randn(dim) + 1i*randn(dim));

sosReco = sqrt(sum(abs(channelSignal).^2, 3));

%% correct bias

correctedSignal = correctNoiseBias(sosReco, sigma, nCoilElements);


%% plot results

meanSosReco = mean(sosReco, 1);
meanCorrected = mean(correctedSignal, 1);


set(0,'DefaultAxesFontSize', 30)
set(0,'defaultLineLineWidth', 2)
set(0,'defaultAxesLineWidth', 2)

Fig = figure;

    set(Fig, 'position', [100, 100, 1000, 800])
    
    plot(trueSignal/sigma, meanSosReco/sigma, '-')
    hold on
    plot(trueSignal/sigma, meanCorrected/sigma, '-')
    
    refHdl = refline(1, 0);
    refHdl.LineStyle = '-.';
    refHdl.Color = [1,1,1]*0.4;
    
    xlabel('True signal / \sigma')
    ylabel('Mean measured signal / \sigma')
    
    legend('w/o correction', 'with correction', 'location', 'northWest')
    



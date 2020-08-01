clc, clear, close all

datafolder = fullfile('C:\Users\timot\Desktop\TCC\Speech Commands');

addpath(fullfile(matlabroot,'toolbox','audio','audiodemos'))
ads = audioexample.Datastore(datafolder, ...
    'IncludeSubfolders',true, ...
    'FileExtensions','.wav', ...
    'LabelSource','foldernames', ...
    'ReadMethod','File')
ads0 = copy(ads);

commands = ["yes","no","up","down","left","right","on","off","stop","go"];

isCommand = ismember(ads.Labels,categorical(commands));
isUnknown = ~ismember(ads.Labels,categorical([commands,"_background_noise_"]));

probIncludeUnknown = 0.1;
mask = rand(numel(ads.Labels),1) < probIncludeUnknown;
isUnknown = isUnknown & mask;
ads.Labels(isUnknown) = categorical("unknown");

ads = getSubsetDatastore(ads,isCommand|isUnknown);
countEachLabel(ads)

[adsTrain,adsValidation,adsTest] = splitData(ads,datafolder);
addpath(fullfile(matlabroot,'examples','audio','main'))

epsil = 1e-6;
segmentDuration = 1;
frameDuration = 0.025;
hopDuration = 0.010;
numBands = 40;

XTrain = speechSpectrograms(adsTrain,segmentDuration,frameDuration,hopDuration,numBands);
XTrain = log10(XTrain + epsil);

XValidation = speechSpectrograms(adsValidation,segmentDuration,frameDuration,hopDuration,numBands);
XValidation = log10(XValidation + epsil);

XTest = speechSpectrograms(adsTest,segmentDuration,frameDuration,hopDuration,numBands);
XTest = log10(XTest + epsil);

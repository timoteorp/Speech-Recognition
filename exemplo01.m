% clc, clear, close all
% 
% datafolder = fullfile('D:\Potin\Desktop\Programação\Database');
% 
% addpath(fullfile(matlabroot,'toolbox','audio','audiodemos'))
% ads = audioDatastore(datafolder, ...
%     'IncludeSubfolders',true, ...
%     'FileExtensions','.wav', ...
%     'LabelSource','foldernames')
% ads0 = copy(ads);
% 
% commands = ["yes","no","up","down","left","right","on","off","stop","go"];
% isCommand = ismember(ads.Labels,categorical(commands));
% isUnknown = ~ismember(ads.Labels,categorical([commands,"_background_noise_"]));
% 
% probIncludeUnknown = 0.1;
% mask = rand(numel(ads.Labels),1) < probIncludeUnknown;
% isUnknown = isUnknown & mask;
% ads.Labels(isUnknown) = categorical("unknown");
% 
% ads = getSubsetDatastore(ads,isCommand|isUnknown);
% countEachLabel(ads)
% 
% [adsTrain,adsValidation,adsTest] = splitData(ads,datafolder);
% addpath(fullfile(matlabroot,'examples','audio','main'))
% 
% epsil = 1e-6;
% segmentDuration = 1;
% frameDuration = 0.025;
% hopDuration = 0.010;
% numBands = 40;

XTrain = speechSpectrograms(adsTrain,segmentDuration,frameDuration,hopDuration,numBands);
XTrain = log10(XTrain + epsil);

XValidation = speechSpectrograms(adsValidation,segmentDuration,frameDuration,hopDuration,numBands);
XValidation = log10(XValidation + epsil);

XTest = speechSpectrograms(adsTest,segmentDuration,frameDuration,hopDuration,numBands);
XTest = log10(XTest + epsil);

YTrain = adsTrain.Labels;
YValidation = adsValidation.Labels;
YTest = adsTest.Labels;

specMin = min(XTrain(:));
specMax = max(XTrain(:));
idx = randperm(size(XTrain,4),3);
figure('Units','normalized','Position',[0.2 0.2 0.6 0.6]);
for i = 1:3
    [x,fs] = audioread(adsTrain.Files{idx(i)});
    subplot(2,3,i)
    plot(x)
    axis tight
    title(string(adsTrain.Labels(idx(i))))

    subplot(2,3,i+3)
    spect = XTrain(:,:,1,idx(i));
    pcolor(spect)
    caxis([specMin+2 specMax])
    shading flat

    sound(x,fs)
    pause(2)
end
% 
% adsBkg = getSubsetDatastore(ads0, ads0.Labels=="_background_noise_");
% numBkgClips = 4000;
% volumeRange = [1e-4,1];
% 
% XBkg = backgroundSpectrograms(adsBkg,numBkgClips,volumeRange,segmentDuration,frameDuration,hopDuration,numBands);
% XBkg = log10(XBkg + epsil);
% 
% numTrainBkg = floor(0.8*numBkgClips);
% numValidationBkg = floor(0.1*numBkgClips);
% numTestBkg = floor(0.1*numBkgClips);
% 
% XTrain(:,:,:,end+1:end+numTrainBkg) = XBkg(:,:,:,1:numTrainBkg);
% XBkg(:,:,:,1:numTrainBkg) = [];
% YTrain(end+1:end+numTrainBkg) = "background";
% 
% XValidation(:,:,:,end+1:end+numValidationBkg) = XBkg(:,:,:,1:numValidationBkg);
% XBkg(:,:,:,1:numValidationBkg) = [];
% YValidation(end+1:end+numValidationBkg) = "background";
% 
% XTest(:,:,:,end+1:end+numTestBkg) = XBkg(:,:,:,1: numTestBkg);
% clear XBkg;
% YTest(end+1:end+numTestBkg) = "background";
% 
% YTrain = removecats(YTrain);
% YValidation = removecats(YValidation);
% YTest = removecats(YTest);
% 
% sz = size(XTrain);
% specSize = sz(1:2);
% imageSize = [specSize 1];
% augmenter = imageDataAugmenter(...
%     'RandXTranslation',[-10 10],...
%     'RandXScale',[0.8 1.2],...
%     'FillValue',log10(epsil));
% augimdsTrain = augmentedImageDatastore(imageSize,XTrain,YTrain,...
%     'DataAugmentation',augmenter,...
%     'OutputSizeMode','randcrop');
% 
% %% Rede
% classNames = categories(YTrain);
% classWeights = 1./countcats(YTrain);
% classWeights = classWeights/mean(classWeights);
% numClasses = numel(classNames);
% 
% dropoutProb = 0.2;
% layers = [
%     imageInputLayer(imageSize)
% 
%     convolution2dLayer(3,16,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
% 
%     maxPooling2dLayer(2,'Stride',2)
% 
%     convolution2dLayer(3,32,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
% 
%     maxPooling2dLayer(2,'Stride',2,'Padding',[0,1])
% 
%     dropoutLayer(dropoutProb)
%     convolution2dLayer(3,64,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
% 
%     dropoutLayer(dropoutProb)
%     convolution2dLayer(3,64,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
% 
%     maxPooling2dLayer(2,'Stride',2,'Padding',[0,1])
% 
%     dropoutLayer(dropoutProb)
%     convolution2dLayer(3,64,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
% 
%     dropoutLayer(dropoutProb)
%     convolution2dLayer(3,64,'Padding','same')
%     batchNormalizationLayer
%     reluLayer
% 
%     maxPooling2dLayer([1 13])
% 
%     fullyConnectedLayer(numClasses)
%     softmaxLayer
%     weightedCrossEntropyLayer(classNames,classWeights)];
% 
% %% Treinamento
% miniBatchSize = 128;
% validationFrequency = floor(numel(YTrain)/miniBatchSize);
% options = trainingOptions('adam', ...
%     'InitialLearnRate',5e-4, ...
%     'MaxEpochs',25, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'Shuffle','every-epoch', ...
%     'Plots','training-progress', ...
%     'Verbose',false, ...
%     'ValidationData',{XValidation,YValidation}, ...
%     'ValidationFrequency',validationFrequency, ...
%     'ValidationPatience',Inf, ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.1, ...
%     'LearnRateDropPeriod',20);
% 
% doTraining = false;
% if doTraining
%     trainedNet = trainNetwork(augimdsTrain,layers,options);
% else
%     s = load('commandNet.mat');
%     trainedNet = s.trainedNet;
% end
% 
% YValPred = classify(trainedNet,XValidation);
% validationError = mean(YValPred ~= YValidation);
% YTrainPred = classify(trainedNet,XTrain);
% trainError = mean(YTrainPred ~= YTrain);
% disp("Training error: " + trainError*100 + "%")
% disp("Validation error: " + validationError*100 + "%")
% 
% figure
% plotconfusion(YValidation,YValPred,'Validation Data')
% 
% save('commandNet.mat','trainedNet');

% 
% 

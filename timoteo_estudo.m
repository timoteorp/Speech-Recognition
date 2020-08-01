clc, clear, close all;
%% adicionando o dataset 

datafolder = fullfile('C:\Users\timot\OneDrive\Área de Trabalho\Projetos Faculdade\TCC\Speech Commands');
addpath(fullfile(matlabroot,'toolbox','audio','audiodemos'));

ads = audioexample.Datastore(datafolder, ...
    'IncludeSubfolders',true, ...
    'FileExtensions','.wav', ...
    'LabelSource','foldernames', ...
    'ReadMethod','File')
ads0 = copy(ads);
%%definindo os comandos, 

commands = categorical(["yes","no","up","down","left","right","on","off","stop","go"]);
%%comparando os comandos com o dataset excluindo o background noise

isCommand = ismember(ads.Labels,commands);
isUnknown = ~ismember(ads.Labels,[commands,"_background_noise_"]);

commands = string(commands)

includeFraction = 0.1;
mask = rand(numel(ads.Labels),1) < includeFraction;
isUnknown = isUnknown & mask;
ads.Labels(isUnknown) = categorical("unknown");

ads = getSubsetDatastore(ads,isCommand|isUnknown);
countEachLabel(ads)

%%Divisão dos dados entre Dados de treinamento, dados de validação e dados
%%de teste

[adsTrain,adsValidation,adsTest] = splitData(ads,datafolder);
addpath(fullfile(matlabroot,'examples','audio','main'));

epsil = 1e-6;
segmentDuration = 1;
frameDuration = 0.025;
hopDuration = 0.010;
numBands = 40;



% 
%  XTrain = speechSpectrograms(adsTrain,segmentDuration,frameDuration,hopDuration,numBands);
%  XTrain = log10(XTrain + epsil);
% % 
%  XValidation = speechSpectrograms(adsValidation,segmentDuration,frameDuration,hopDuration,numBands);
%  XValidation = log10(XValidation + epsil);
% % 
%  XTest = speechSpectrograms(adsTest,segmentDuration,frameDuration,hopDuration,numBands);
%  XTest = log10(XTest + epsil);
% % 
%  YTrain = adsTrain.Labels;
%  YValidation = adsValidation.Labels;
%  YTest = adsTest.Labels;
% 
% specMin = min(XTrain(:));
% specMax = max(XTrain(:));
% idx = randperm(size(XTrain,4),3);
% figure('Units','normalized','Position',[0.2 0.2 0.6 0.6]);
% for i = 1:3
%     [x,fs] = audioread(adsTrain.Files{idx(i)});
%     subplot(2,3,i)
%     plot(x)
%     axis tight
%     title(string(adsTrain.Labels(idx(i))))
% 
%     subplot(2,3,i+3)
%     spect = XTrain(:,:,1,idx(i));
%     pcolor(spect)
%     caxis([specMin+2 specMax])
%     shading flat
% 
%     sound(x,fs)
%     pause(2)
% end
% 
% figure
% histogram(XTrain,'EdgeColor','none','Normalization','pdf')
% axis tight
% ax = gca;
% ax.YScale = 'log';
% xlabel("Input Pixel Value")
% ylabel("Probability Density")
% 
% %adicionando ruido de fundo
% 
% adsBkg = getSubsetDatastore(ads0,ads0.Labels=="_background_noise_");
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
% figure('Units','normalized','Position',[0.2 0.2 0.5 0.5]);
% subplot(2,1,1)
% histogram(YTrain)
% title("Training Label Distribution")
% subplot(2,1,2)
% histogram(YValidation)
% title("Validation Label Distribution")
% 
% sz = size(XTrain);
% specSize = sz(1:2);
% imageSize = [specSize 1];
% augmenter = imageDataAugmenter( ...
%     'RandXTranslation',[-10 10], ...
%     'RandXScale',[0.8 1.2], ...
%     'FillValue',log10(epsil));
% augimdsTrain = augmentedImageDatastore(imageSize,XTrain,YTrain, ...
%     'DataAugmentation',augmenter);


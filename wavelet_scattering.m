% datafolder = fullfile('C:\Users\timot\OneDrive\Área de Trabalho\Projetos Faculdade\TCC\Speech Commands');
% ads = audioDatastore(datafolder, ...
%     'IncludeSubfolders',true, ...
%     'FileExtensions','.wav', ...
%     'LabelSource','foldernames')
% ads0 = copy(ads);
% 
% commands = categorical(["yes","no","up","down","left","right","on","off","stop","go"]);
% 
% isCommand = ismember(ads.Labels,commands);
% isUnknown = ~ismember(ads.Labels,[commands,"_background_noise_"]);
% 
% includeFraction = 0.2;
% mask = rand(numel(ads.Labels),1) < includeFraction;
% isUnknown = isUnknown & mask;
% ads.Labels(isUnknown) = categorical("unknown");
% 
% ads = subset(ads,isCommand|isUnknown);
% countEachLabel(ads)
% %% 
% LenSig = zeros(numel(ads.Files),1);
% nr = 1;
% while hasdata(ads)
%     digit = read(ads);
%     LenSig(nr) = numel(digit);
%     nr = nr+1;
% end
% reset(ads)
% histogram(LenSig)
% grid on
% xlabel('Signal Length (Samples)')
% ylabel('Frequency')
%% 
sf = waveletScattering('SignalLength',16000,'InvarianceScale',0.22,...
    'SamplingFrequency',16000,'OversamplingFactor',2);
rng default;
ads = shuffle(ads);
[adsTrain,adsTest] = splitEachLabel(ads,0.8);
countEachLabel(adsTrain)

%% 
Xtrain = [];
i = 1;
scatds_Train = transform(adsTrain,@(x)helperReadSPData(x));
while hasdata(scatds_Train)
    disp("Train: "+ i)
    smat = read(scatds_Train);
    Xtrain = cat(2,Xtrain,smat);
    i = i+1;
    
end
%% 
Xtest = [];
j = 1;
scatds_Test = transform(adsTest,@(x)helperReadSPData(x));
while hasdata(scatds_Test)
    disp("Test: " + j)
    smat = read(scatds_Test);
    Xtest = cat(2,Xtest,smat);
    j = j+1;
    
end

%% 
Strain = sf.featureMatrix(Xtrain);
Stest = sf.featureMatrix(Xtest);
%% 
TrainFeatures = Strain(2:end,:,:);
TrainFeatures = squeeze(mean(TrainFeatures,2))';
TestFeatures = Stest(2:end,:,:);
TestFeatures = squeeze(mean(TestFeatures,2))';

%% 
% template = templateSVM(...
%     'KernelFunction', 'polynomial', ...
%     'PolynomialOrder', 2, ...
%     'KernelScale', 'auto', ...
%     'BoxConstraint', 1, ...
%     'Standardize', true);
% classificationSVM = fitcecoc(...
%     TrainFeatures, ...
%     adsTrain.Labels, ...
%     'Learners', template, ...
%     'Coding', 'onevsone', ...
%     'ClassNames', categorical({'1'; '0'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'}));
% 
% %% 
% partitionedModel = crossval(classificationSVM, 'KFold', 5);
% [validationPredictions, validationScores] = kfoldPredict(partitionedModel);
% validationAccuracy = (1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError'))*100
% 
% 
% 
% 
% 



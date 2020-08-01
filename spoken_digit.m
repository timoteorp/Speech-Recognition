% ads = audioDatastore('C:\Users\timot\OneDrive\Área de Trabalho\Projetos Faculdade\TCC\Spoken Digit\free-spoken-digit-dataset-master\recordings')
% ads.Labels = helpergenLabels(ads);
% summary(ads.Labels)
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
% %% 
% sf = waveletScattering('SignalLength',8192,'InvarianceScale',0.22,...
%     'SamplingFrequency',8000,'OversamplingFactor',2);
% rng default;
% ads = shuffle(ads);
% [adsTrain,adsTest] = splitEachLabel(ads,0.8);
% countEachLabel(adsTrain)
% %% 
% Xtrain = [];
% scatds_Train = transform(adsTrain,@(x)helperReadSPData(x));
% while hasdata(scatds_Train)
%     smat = read(scatds_Train);
%     Xtrain = cat(2,Xtrain,smat);
%     
% end
% 
% Xtest = [];
% scatds_Test = transform(adsTest,@(x)helperReadSPData(x));
% while hasdata(scatds_Test)
%     smat = read(scatds_Test);
%     Xtest = cat(2,Xtest,smat);
%     
% end
% 
% %% 
% Strain = sf.featureMatrix(Xtrain);
% Stest = sf.featureMatrix(Xtest);
% 
% TrainFeatures = Strain(2:end,:,:);
% TrainFeatures = squeeze(mean(TrainFeatures,2))';
% TestFeatures = Stest(2:end,:,:);
% TestFeatures = squeeze(mean(TestFeatures,2))';

%% 
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    TrainFeatures, ...
    adsTrain.Labels, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', categorical({'0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'}));

partitionedModel = crossval(classificationSVM, 'KFold', 5);
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);
validationAccuracy = (1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError'))*100

predLabels = predict(classificationSVM,TestFeatures);
testAccuracy = sum(predLabels==adsTest.Labels)/numel(predLabels)*100


figure('Units','normalized','Position',[0.2 0.2 0.5 0.5]);
ccscat = confusionchart(adsTest.Labels,predLabels);
ccscat.Title = 'Wavelet Scattering Classification';
ccscat.ColumnSummary = 'column-normalized';
ccscat.RowSummary = 'row-normalized';





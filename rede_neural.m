%% Rede
% classNames = categories(YTrain);
% classWeights = 1./countcats(YTrain);
% classWeights = classWeights/mean(classWeights);
% numClasses = numel(classNames);
% imageSize = size(read(imgsTrain));

dropoutProb = 0.2;
layers = [
    imageInputLayer([40 98],'name','input')

    convolution2dLayer(3,16,'Padding','same','name','conv1')
    batchNormalizationLayer('name','norm1')
    reluLayer('name','relu1')

    maxPooling2dLayer(2,'Stride',2,'name','pooling1')

    convolution2dLayer(3,32,'Padding','same','name','conv2')
    batchNormalizationLayer('name','norm2')
    reluLayer('name','relu2')

    maxPooling2dLayer(2,'Stride',2,'Padding',[0,1],'name','pooling2')

    dropoutLayer(dropoutProb,'name','drop1')
    convolution2dLayer(3,64,'Padding','same','name','conv3')
    batchNormalizationLayer('name','norm3')
    reluLayer('name','relu3')

    dropoutLayer(dropoutProb,'name','drop2')
    convolution2dLayer(3,64,'Padding','same','name','conv4')
    batchNormalizationLayer('name','norm4')
    reluLayer('name','relu4')

    maxPooling2dLayer(2,'Stride',2,'Padding',[0,1],'name','pooling3')

    dropoutLayer(dropoutProb,'name','drop3')
    convolution2dLayer(3,64,'Padding','same','name','conv5')
    batchNormalizationLayer('name','norm5')
    reluLayer('name','relu5')

    dropoutLayer(dropoutProb,'name','drop4')
    convolution2dLayer(3,64,'Padding','same','name','conv6')
    batchNormalizationLayer('name','norm6')
    reluLayer('name','relu6')

    maxPooling2dLayer([1 13],'name','pooling4')

    fullyConnectedLayer(13,'name','fullyconnected')
    softmaxLayer('name','softmax')
    weightedCrossEntropyLayer(classNames,classWeights)];

%% Treinamento
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
% doTraining = true;
% if doTraining
%     trainedNet = trainNetwork(augimdsTrain,layers,options);
% else
%     s = load('commandNet.mat');
%     trainedNet = s.trainedNet;
% end
% 
% save('commandNet.mat','trainedNet');
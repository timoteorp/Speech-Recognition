 YValPred = classify(trainedNet,imgsValidation);
 validationError = mean(YValPred ~= YValidation);
 YTrainPred = classify(trainedNet,imgsTrain);
 trainError = mean(YTrainPred ~= YTrain);
 disp("Training error: " + trainError*100 + "%")
 disp("Validation error: " + validationError*100 + "%")
 
 figure
 plotconfusion(YValidation,YValPred,'Validation Data')
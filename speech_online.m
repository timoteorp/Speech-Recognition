clc, clear, close all; fclose all;

%% Deep Network
s = load('commandNet_no_background.mat');
trainedNet = s.trainedNet;

% %% Connect the serial port to Arduino
% baudrate = 57600;
% 
% s = serial('COM5','BaudRate',baudrate); % change the COM Port number as needed
% s.ReadAsyncMode = 'manual';
% set(s,'InputBufferSize',100);
% 
% try
%     fopen(s);
% catch err
%     fclose(instrfind);
%     error('Make sure you select the correct COM Port where the Arduino is connected.');
% end

%% teste online
epsil = 1e-6;
segmentDuration = 1;
frameDuration = 0.025;
hopDuration = 0.010;
numBands = 40;
fs = 16e3;
classificationRate = 20;
audioIn = audioDeviceReader('SampleRate',fs,'SamplesPerFrame',floor(fs/classificationRate));

specMin = -6;
specMax = 0.5340;

frameLength = frameDuration*fs;
hopLength = hopDuration*fs;
waveBuffer = zeros([fs,1]);

fb = cwtfilterbank('SignalLength',length(waveBuffer),...
    'SamplingFrequency',fs,...
    'VoicesPerOctave',16,'Wavelet','amor');

labels = trainedNet.Layers(end).ClassNames;
YBuffer(1:classificationRate/2) = "background";
probBuffer = zeros([numel(labels),classificationRate/2]);

h = figure('Units','normalized','Position',[0.2 0.1 0.6 0.8]);
addpath(fullfile(matlabroot,'examples','audio','main'))

while ishandle(h)

    % Extract audio samples from audio device and add to the buffer.
    x = audioIn();
    waveBuffer(1:end-numel(x)) = waveBuffer(numel(x)+1:end);
    waveBuffer(end-numel(x)+1:end) = x;

    % Compute the spectrogram of the latest audio samples.
%     spec = auditorySpectrogram(waveBuffer,fs, ...
%         'WindowLength',frameLength, ...
%         'OverlapLength',frameLength-hopLength, ...
%         'NumBands',numBands, ...
%         'Range',[50,7000], ...
%         'WindowType','Hann', ...
%         'WarpType','Bark', ...
%         'SumExponent',2);
%     spec = log10(spec + epsil);
    [cfs,frq] = wt(fb,waveBuffer);
    im = ind2rgb(im2uint8(rescale(abs(cfs))),jet(256));
    spec = imresize(im,[40 98]);
    % Classify the current spectrogram, save the label to the label buffer,
    % and save the predicted probabilities to the probability buffer.
    [YPredicted,probs] = classify(trainedNet,spec,'ExecutionEnvironment','cpu');
    YBuffer(1:end-1)= YBuffer(2:end);
    YBuffer(end) = YPredicted;
    probBuffer(:,1:end-1) = probBuffer(:,2:end);
    probBuffer(:,end) = probs';

    % Plot the current waveform and spectrogram.
    subplot(2,1,1);
    plot(waveBuffer)
    axis tight
    ylim([-0.2,0.2])

    subplot(2,1,2)
    %pcolor(spec)
    %caxis([specMin+2 specMax])
    image(im)
    shading flat

    % Now do the actual command detection by performing a very simple
    % thresholding operation. Declare a detection and display it in the
    % figure title if all of the following hold:
    % 1) The most common label is not |background|.
    % 2) At least |countThreshold| of the latest frame labels agree.
    % 3) The maximum predicted probability of the predicted label is at least |probThreshold|.
    % Otherwise, do not declare a detection.
    [YMode,count] = mode(YBuffer);
    countThreshold = ceil(classificationRate*0.2);
    maxProb = max(probBuffer(labels == YMode,:));
    probThreshold = 0.9;
    subplot(2,1,1);
    if YMode == "background" || count<countThreshold || maxProb < probThreshold
        title(" ")
    else
        title(YMode,'FontSize',20)
        if YMode == "go"
            fwrite(s,'1');
        end
        if YMode == "stop"
            fwrite(s,'0');
        end
        if YMode == "right"
            fwrite(s,'2');
        end
        if YMode == "left"
            fwrite(s,'3');
        end
    end

    drawnow

end

fclose(s);

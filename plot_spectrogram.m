idx = randperm(size(adsTrain.Files,1),3)
frameLength = round(frameDuration*fs);
hopLength = round(hopDuration*fs)
for i = 1:3
    [x,fs] = audioread(adsTrain.Files{idx(i)});
    subplot(3,3,i)
    plot(x)
    axis tight
    title(string(adsTrain.Labels(idx(i))))

    subplot(3,3,i+3)
    spect = auditorySpectrogram(x,fs, ...
        'WindowLength',frameLength, ...
        'OverlapLength',frameLength - hopLength, ...
        'NumBands',numBands, ...
        'Range',[50,7000], ...
        'WindowType','Hann', ...
        'WarpType','Bark', ...
        'SumExponent',2);;
    spect = log10(spect+epsil)
    pcolor(spect)
    specMin = min(spect(:));
    specMax = max(spect(:));
    caxis([specMin specMax])
    shading flat
    
    subplot(3,3,i+6)
    fb = cwtfilterbank('SignalLength',length(x),...
      'SamplingFrequency',fs,...
      'VoicesPerOctave',10,'Wavelet','amor');
    [cfs,frq] = wt(fb,x);
    %disp((numFiles-i) + " Remaining")
    t = (0:(length(x)-1))/fs;
    scal = log10(abs(cfs)+epsil)
    pcolor(t,frq,scal)
    caxis([min(scal(:)) max(scal(:))])
    set(gca,'Yscale','log')
    shading flat
        

    sound(x,fs)
    pause(2)
end
function im = scalogram_teste(sig,fs)


      fb = cwtfilterbank('SignalLength',length(sig),...
      'SamplingFrequency',fs,...
      'VoicesPerOctave',10,'Wavelet','amor');
        [cfs,frq] = wt(fb,sig);
        %disp((numFiles-i) + " Remaining")
        t = (0:(length(sig)-1))/fs;
        figure;
        pcolor(t,frq,abs(cfs));
        set(gca,'yscale','log');shading interp;axis tight;
        im = ind2rgb(im2uint8(rescale(abs(cfs))),jet(256));

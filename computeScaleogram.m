function [scalo] = computeScaleogram(ads)
[sig,info] = read(ads);
        fs=info.SampleRate;
    fb = cwtfilterbank('SignalLength',length(sig),...
    'SamplingFrequency',fs,...
    'VoicesPerOctave',10,'Wavelet','amor');

reset(ads);
imageRoot = 'C:\Users\timot\OneDrive\Área de Trabalho\Projetos Faculdade\TCC\Speech Commands\Imagens 40 90 10_voices';
labels = ads.Labels;

numFiles = length(ads.Files);
%scalo = zeros(numFiles,178,16000,3,'single');



for i=1:numFiles
    %if labels(i) == 'unknown'% | labels(i) == 'yes' | labels(i) == 'up'
      [sig,info] = read(ads);
         fs=info.SampleRate;
      fb = cwtfilterbank('SignalLength',length(sig),...
      'SamplingFrequency',fs,...
      'VoicesPerOctave',10,'Wavelet','amor');
        [cfs,frq] = wt(fb,sig);
        disp((numFiles-i) + " Remaining")
        t = (0:(length(sig)-1))/fs;
        %figure;pcolor(t,frq,abs(cfs));
        im = ind2rgb(im2uint8(rescale(abs(cfs))),jet(256));
        imgLoc = fullfile(imageRoot,char(labels(i)));
        imFileName = strcat(char(labels(i)),'_',num2str(i),'.jpg');
        imwrite(imresize(im,[40 98]),fullfile(imgLoc,imFileName));
        
        %scalo(i,:,:,:) = im;
         %set(gca,'yscale','log');shading interp;axis tight;
         %title('Scalogram');xlabel('Time (s)');ylabel('Frequency (Hz)')
    end 
end 
%teste = [t,abs(cfs),frq];
%Scalogram Background
background = getSubsetDatastore(ads0,ads0.Labels=="_background_noise_");
fb = cwtfilterbank('SignalLength',16000,...
    'SamplingFrequency',16000,...
    'VoicesPerOctave',16,'Wavelet','amor');
imageRoot = 'C:\Users\timot\OneDrive\Área de Trabalho\Projetos Faculdade\TCC\Speech Commands\Imagens 40 90 10_voices';
labels = background.Labels;
numBkgFiles = numel(background.Files)
numBkgClips = 400;
%numClipsPerFile = histcounts(1:numBkgClips,linspace(1,numBkgClips,numBkgFiles+1));
for k=1:numBkgFiles
    [wave,info] = read(background);
    len = linspace(1,length(wave)-info.SampleRate,numBkgClips);
    for i=1:numBkgClips
        disp(i)
        [cfs,frq] = wt(fb,wave(len(i):len(i)+16000-1));
        im = ind2rgb(im2uint8(rescale(abs(cfs))),jet(256));
        imgLoc = fullfile(imageRoot,char(labels(k)));
        imFileName = strcat(char(labels(k)),'_',num2str(k),num2str(i),'.jpg');
        imwrite(imresize(im,[40 98]),fullfile(imgLoc,imFileName));
        
    end
end





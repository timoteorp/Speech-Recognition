function[YPredicted] = teste_rede
load('commandNet_retrained.mat');
[s, fs] = audioread('0a7c2a8d_nohash_0.wav');
%go2 = resample(go,1,3)

fb = cwtfilterbank('SignalLength',length(s),...
'SamplingFrequency',fs,...
'VoicesPerOctave',10,'Wavelet','amor');
[cfs,frq] = wt(fb,s);
im = ind2rgb(im2uint8(rescale(abs(cfs))),jet(256));
teste = imresize(im,[40 98]);
[YPredicted,probs] = classify(trainedNet,teste,'ExecutionEnvironment','cpu');
YPredicted

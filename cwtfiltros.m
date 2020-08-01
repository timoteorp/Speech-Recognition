fb = cwtfilterbank('SignalLength',400,'SamplingFrequency',fs,'VoicesPerOctave',6,'Wavelet','amor')
%transformada = cwt(data,'Filterbank',fb)
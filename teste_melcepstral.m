%[data,fs] = audioread('0b40aa8e_nohash_0.wav')
emphasized(1) = data(1)
t=2:length(data)
pre_emphasis = 0.97
emphasized(t)=data(t)-pre_emphasis*data(t-1)

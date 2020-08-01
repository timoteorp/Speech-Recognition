function [S, frequency] = my_fft (s, fs)

normal = length(s);
aux = 0:normal-1;
T = normal/fs;
frequency = aux/T;
S = fftn(s)/normal;
fc = ceil(normal/2);
S = S(1:fc);

figure();
plot(frequency(1:fc),abs(S));
title('Analise de Espectro');
xlabel('Frequencia (Hz)');
ylabel('Amplitude');

end
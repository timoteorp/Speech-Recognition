fs = 16000;
[cfs,frq] = wt(fb,out);
 t = (0:(length(out)-1))/fs;
 figure;pcolor(t,frq,abs(cfs));
 set(gca,'yscale','log');shading interp;axis tight;
 title('Scalogram');xlabel('Time (s)');ylabel('Frequency (Hz)')
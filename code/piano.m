filepath='.//audio//';
filename='piano_';
fileid={'a','b' ,'bb' ,'c','c#','d','e','eb','f#','f','g#','g'};
filenumber=12;
filetail='.wav';
N=10000;

for i =1:filenumber
[filepath,filename,fileid(i),filetail]
[s,Fs]=audioread(cell2mat([filepath,filename,fileid(i),filetail]));
S=fft(s,N);
S1=fftshift(S);
S1=S1/(N/2);
nVals=(0:N-1)*Fs/N-Fs/2;
plot(nVals(N/2+1:N),abs(S1(N/2+1:N)))
xlabel('ÆµÂÊHz');
ylabel('·ù¶È')
saveas(gcf,cell2mat([filepath,filename,fileid(i),'.fig']));
title(i)
end
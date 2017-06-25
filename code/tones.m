clear all;close all;clc
base=importdata('base.txt');
fs=8000;%�ö����ֳ���Ƶ��
col=7;
f=base(col,1);%ĳ��λƵ������
[COL,ROW]=size(base);%���ݼ�����
time=fs*1;%����������ʱ��
N=length(time);%�ܳ�������
west=zeros(1,N);%West�������������
n=1;
for a=1:N   %a��1��N
    t=1/fs:1/fs:time(a)/fs;
    ss=zeros(1,length(t));
    ss=ss+0.01*sin(f/8*pi*100*t)+0.005*sin(f/4*pi*100*t);
    for i=1:(ROW-1)
        ss=ss+base(col,i+1)*sin(2*i*pi*f(a)*t);%г��
    end
    G=zeros(1,time(a));%�洢���������ݡ�������
    G(1:time(a))=exp(2:(-2/time(a)):1/8000);%���������
    west(n:n+time(a)-1)=ss.*G(1:time(a));%����ѭ������west������������
    n=n+time(a);
end
plot(west);
xlabel('ʱ��t');
ylabel('Ƶ��Hz');
saveas(gcf,'tone_g.jpg');
title('ʱƵ����1');
audiowrite('tone_g.wav',west,fs);
sound(west,fs);
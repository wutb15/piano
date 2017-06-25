clear all;close all;clc
base=importdata('base.txt');
fs=8000;%该段音乐抽样频率
col=7;
f=base(col,1);%某键位频率向量
[COL,ROW]=size(base);%数据集列数
time=fs*1;%各音调持续时间
N=length(time);%总抽样点数
west=zeros(1,N);%West向量储存抽样点
n=1;
for a=1:N   %a从1到N
    t=1/fs:1/fs:time(a)/fs;
    ss=zeros(1,length(t));
    ss=ss+0.01*sin(f/8*pi*100*t)+0.005*sin(f/4*pi*100*t);
    for i=1:(ROW-1)
        ss=ss+base(col,i+1)*sin(2*i*pi*f(a)*t);%谐波
    end
    G=zeros(1,time(a));%存储包络线数据——除噪
    G(1:time(a))=exp(2:(-2/time(a)):1/8000);%产生包络点
    west(n:n+time(a)-1)=ss.*G(1:time(a));%利用循环生成west向量抽样数据
    n=n+time(a);
end
plot(west);
xlabel('时间t');
ylabel('频率Hz');
saveas(gcf,'tone_g.jpg');
title('时频特性1');
audiowrite('tone_g.wav',west,fs);
sound(west,fs);
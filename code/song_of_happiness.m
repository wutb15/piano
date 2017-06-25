clear all;close all;clc
base=importdata('base.txt');
fs=8000;%该段音乐抽样频率
col=[      3,3,4,5,         5,4,3,2,         1,1,2,3,         3,2,2,        3,3,4,5,         5,4,3,2,         1,1,2,3,         2,1,1,        2,2,3,1,         2,3,4,3,1,           2,3,4,3,2,           1,2,-5,       3,3,3,4,5,           5,4,3,4,2,           1,1,2,3,         2,1,1];
time=fs*2*[1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4, 1/8,1/4,1/2,  1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4, 1/8,1/4,1/2,  1/4,1/4,1/4,1/4, 1/4,1/8,1/8,1/4,1/4, 1/4,1/8,1/8,1/4,1/4, 1/4,1/4,1/2,  1/8,1/8,1/4,1/4,1/4, 1/4,1/4,1/4,1/8,1/8, 1/4,1/4,1/4,1/4, 1/2,1/4,1/2];%各音调持续时间
N=length(time);%总抽样点数
west=zeros(1,N);%West向量储存抽样点
n=1;
d=2/12;
%f=base(col,1);%某键位频率向量
[COL,ROW]=size(base);%数据集列数
for a=1:N   %a从1到N
    flag_low1=0;
    flag_high1=0;
    t=1/fs:1/fs:time(a)/fs;
    if (col(a)==0)
        fcol=COL;
    elseif (col(a)<0)
        flag_low1=1;
        fcol=-col(a);
    elseif (col(a)>10)
        flag_high1=1;
        fcol=col(a)-10;
    else
        fcol=col(a);
    end
    if (flag_low1==1)
        f=base(fcol,1)/power(2,d+1);
    elseif (flag_high1==1)
        f=base(fcol,1)/power(2,d-1);
    else
        f=base(fcol,1)/power(2,d);
    end
    ss=zeros(1,length(t));
    ss=ss+0.01*sin(f/8*pi*100*t)+0.005*sin(f/4*pi*100*t);
    for i=1:(ROW-1)
        ss=ss+base(fcol,i+1)*sin(2*i*pi*f*t);%谐波
    end
%    G=zeros(1,time(a));%存储包络线数据——除噪
%    G(1:time(a))=exp(1:(-1/time(a)):1/8000);%产生包络点
%    west(n:n+time(a)-1)=ss.*G(1:time(a));%利用循环生成west向量抽样数据
    
    P=zeros(1,time(a));
    L=time(a)*[0,1/5,333/1000,333/500,1];
    T=[0.2,1.5,1,1,0.2];
    s=1;
    b=1:1:time(a);
    for k=1:4
        %折线型包络线（包络线的选择问题)
        P(s:L(k+1)-1)=(T(k+1)-T(k))/(L(k+1)-L(k))*(b(s:L(k+1)-1)-L(k+1)*ones(1,L(k+1)-s))+T(k+1)*ones(1,L(k+1)-s);
        s=L(k+1);
    end
    west(n:n+time(a)-1)=ss.*P(1:time(a));
    n=n+time(a);
end
plot(west);
xlabel('时间t');
ylabel('频率Hz');
saveas(gcf,'song_of_happiness1.jpg');
title('时频特性');
audiowrite('song_of_happiness.wav',west,fs);
spectrogram(west,2048,1024,1:2000,fs,'yaxis');
xlabel('时间t');
ylabel('频率Hz');
saveas(gcf,'song_of_happiness2.jpg');
title('时频特性');
sound(west,fs);
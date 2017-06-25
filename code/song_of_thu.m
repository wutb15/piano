clear all;close all;clc
base=importdata('base.txt');
fs=36000;%�ö����ֳ���Ƶ��
col=[       1,1,3,5,5,                6,11,6,5,5,               3,3,5,3,1,                -6,1,2,5         6,6,6,11,5, 3,2,3,2,1, 2,5,5,4,5, 6,6,7,6,5];
time=fs*10*[1/18,1/36,1/36,1/18,1/18, 1/18,1/36,1/36,1/18,1/18, 1/18,1/18,1/36,1/36,1/18, 1/18,1/36,1/36,1/9, 1/18,1/18,1/36,1/36,1/18, 1/18,1/18,1/36,1/36,1/18, 1/18,1/18,1/36,1/36,1/18, 1/18,1/18,1/36,1/36,1/9];%����������ʱ��
N=length(time);%�ܳ�������
west=zeros(1,N);%West�������������
n=1;
d=5/12;
[COL,ROW]=size(base);%���ݼ�����
for a=1:N   %a��1��N
    flag_low1=0;
    flag_high1=0;
    t=1/fs:1/fs:time(a)/fs;
    if (col(a)==0)%�ж�ʱ������
        fcol=COL;
    elseif (col(a)<0)%�Ͱ˶ȴ���
        flag_low1=1;
        fcol=-col(a);
    elseif (col(a)>10)%�߰˶ȴ���
        flag_high1=1;
        fcol=col(a)-10;
    else
        fcol=col(a);
    end
    if (flag_low1==1)%��Ϊ�Ͱ˶ȣ�Ƶ�ʳ���2
        f=base(fcol,1)/power(2,d+1);
    elseif (flag_high1==1)%��Ϊ�߰˶ȣ�Ƶ�ʳ�2
        f=base(fcol,1)/power(2,d-1);
    else
        f=base(fcol,1)/power(2,d);
    end
    ss=zeros(1,length(t));
    ss=ss+0.01*sin(f/8*pi*100*t)+0.005*sin(f/4*pi*100*t);%��Ƶ��ʹ��ƵԲ��
    for i=1:(ROW-1)
        ss=ss+base(fcol,i+1)*sin(2*i*pi*f*t);%����Ҷ��������
    end
%    G=zeros(1,time(a));%�洢���������ݡ�������
%    G(1:time(a))=exp(1:(-1/time(a)):1/8000);%���������
%    west(n:n+time(a)-1)=ss.*G(1:time(a));%����ѭ������west������������
    
    P=zeros(1,time(a));
    L=time(a)*[0,50/1000,300/1000,550/1000,1];
    T=[0.2,1.5,1,1,0.2];
    s=1;
    b=1:1:time(a);
    for k=1:4
        %�����Ͱ����ߣ������ߵ�ѡ�񡪡��������ɫ���)
        P(s:L(k+1)-1)=(T(k+1)-T(k))/(L(k+1)-L(k))*(b(s:L(k+1)-1)-L(k+1)*ones(1,L(k+1)-s))+T(k+1)*ones(1,L(k+1)-s);
        s=L(k+1);
    end
    west(n:n+time(a)-1)=ss.*P(1:time(a));%������Ƶ����
    n=n+time(a);
end
plot(west);
xlabel('ʱ��t');
ylabel('Ƶ��Hz');
saveas(gcf,'song_of_thu1.jpg');
title('ʱƵ����1');
audiowrite('song_of_thu.wav',west,fs);
spectrogram(west,2048,1024,1:2000,fs,'yaxis');
xlabel('ʱ��t');
ylabel('Ƶ��Hz');
saveas(gcf,'song_of_thu2.jpg');
title('ʱƵ����2');
sound(west,fs);

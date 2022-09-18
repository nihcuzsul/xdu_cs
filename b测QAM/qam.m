clear;
clc;
close all;
%生成随机信号并转换为0-(M-1）%
M = input('输入qam');
m=log2(M);
n=10000; %Random number.
x1=randi([0,1],m*n,1); %random bit stream.
[m1,n1] = size(x1);
fprintf('原始信号1 %d行%d列 最小值%d 最大值%d\n',m1,n1,min(x1),max(x1));
x2=reshape(x1,m,length(x1)/m);
[m2,n2] = size(x2);
fprintf('原始信号2 %d行%d列\n',m2,n2);
x3=bi2de(x2','left-msb');%将二进制随机序列转换为M进制序列
[m3,n3] = size(x3);
fprintf('原始信号3 %d行%d列 最小值%d 最大值%d 平均值%f\n',m3,n3,min(x3),max(x3),mean(x3));
%（1）对原始信号分别进行4QAM和16QAM调制，画出星座图
fprintf('%dQAM调制 可视化星座图\n',M);
y=qammod(x1,M,'bin','InputType','bit');
scatterplot(y);%MQAM星座图
text(real(y)+0.1,imag(y),dec2bin(x3));
hold on
%（2）采用高斯白噪声信道传输信号，画出信噪比为15dB时，
% 4QAM和16QAM的接收信号星座图；
y_noisy=awgn(y,15);
h=scatterplot(y_noisy,1,0,'b.');
hold on;
scatterplot(y,1,0,'r*',h);
title('接收信号星座图');
legend('含噪声接收信号','不含噪声信号');
hold on;
% （3）画出两种调制方式的眼图；
eyediagram(y,2);
eyediagram(y_noisy,2);
%基带信号和解调信号图示%
y_deqam1=qamdemod(y,M,'bin','OutputType','bit');%解调信号
figure
subplot(2,1,1);
stem(x1(1:100),'filled'); %基带信号前100位
title('基带二进制随机序列');
xlabel('比特序列');ylabel('信号幅度');
subplot(2,1,2);
stem(y_deqam1(1:100)); %画出相应的经过QAM调制解调后的信号的前100位 
title('解调后的二进制序列');
xlabel('比特序列');ylabel('信号幅度');
%基带信号和解调信号图示%
y_deqam2=qamdemod(y_noisy,M,'bin','OutputType','bit');%解调信号
figure
subplot(2,1,1);
stem(x1(1:100),'filled'); %基带信号前100位
title('基带二进制随机序列');
xlabel('比特序列');ylabel('信号幅度');
subplot(2,1,2);
stem(y_deqam2(1:100)); %画出相应的经过QAM调制解调后的信号的前100位 
title('解调后的二进制序列');
xlabel('比特序列');ylabel('信号幅度');
%实际误差值%
SNR_in_dB=0:1:24; %AWGN信道信噪比;
for j=1:length(SNR_in_dB)
format long;
y_noise = awgn(y,SNR_in_dB(j));%加入不同强度的高斯白噪声;
y_output = qamdemod(y_noise,M,'bin','OutputType','bit'); %对己调信号进行解调
num=0;
for i=1:length(x1)
if (y_output(i)~=x1(i))
num=num+1;
end
end
[number, ratio] = biterr(x1,y_output);
Pe0(j) = num/length(y_output);
Pe(j) = number/length(y_output); %t通过错误码元数与总码元数之比求误码率，不同j是不同信噪比下的误码
end
%理论误差值%
SNR_in_dB1=0:1:24;
format long;
berQ = berawgn(SNR_in_dB1,'qam',M);
for j=1:length(SNR_in_dB)
fprintf('信噪比：%d 实际误码率:%f %f \n',SNR_in_dB(j),Pe(j),Pe0(j));
end
%画图
figure();
semilogy(SNR_in_dB,Pe,'green*-');
hold on;
semilogy(SNR_in_dB1,berQ);
title('误码率比较');
legend('实际误码率','理论误码率');
hold on;
grid on;
xlabel('SNR/dB');
ylabel('Pe1');


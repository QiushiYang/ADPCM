% This is a script file used to execute the encoder and decoder function 
% for the audio file and draw the wave figures of original audio wave,
% the encoded-decoded audio wave and the comparision between both of them.

clc, clear;
filename = 'C:\Users\qiushi\Desktop\大三下文件\数字电视\DTV_task\ADPCM Codec\liangxiao.wav';
[x,fs] = audioread(filename);
x = x(10000:100000,1)'*100;   % Crop a piece of audio as input
t = (1:length(x));

subplot(311);
plot(t,x,'g');title('original audio');hold on;

subplot(312);
[x1,B0,B1,B2,B3] = encoder(x);
x2 = decoder(x1,B0,B1,B2,B3);
plot(t,x2,'b');title('encoded-decoded audio');hold on;

subplot(313);
% figure(2);
plot(t,x,'g','LineWidth',2);hold on;
plot(t,x2,'b','LineWidth',1);
title('Comparison between original and encoded-decoded audio');
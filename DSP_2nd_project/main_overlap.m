close all
clear 
clc
% This code was written by Seyed Abolfazl Mortazavi 9833063
%****************************************************************************************
%% This Code was written for overlap and overlap reconstract method
%read the files
filename = '607946-392-1.wav';
[y,Fs]= audioread(filename);

%filter paramethers
b_LPF=[-0.01060, 0.03288, 0.03084, -0.18703, -0.02798, 0.63088, 0.71485, 0.23038];
b_HPF=[0.23038, -0.71485, 0.63088, 0.02798, -0.18703, -0.03084, 0.03288, 0.01060];
b_LPF_g = [0.23038, 0.71485, 0.63088, -0.02798, -0.18703, 0.03084, 0.03288, -0.01060];
b_HPF_g = [0.01060, 0.03288, -0.03084, -0.18703,0.02798, 0.63088, -0.71485, 0.23038];

%threshold paramethers
N=100;
sigma = mad(y(1:N))/0.6745;
T = sigma*sqrt(2*log(N));

tic;

%wavelet packet decomposition
%level_1
[approx_1,detail_1] = overlap(y,b_LPF,b_HPF);

%level_2
[approx_21,detail_21] = overlap(approx_1,b_LPF,b_HPF);
[approx_22,detail_22] = overlap(detail_1,b_LPF,b_HPF);

%level_3
[approx_31,detail_31] = overlap(approx_21,b_LPF,b_HPF);
[approx_32,detail_32] = overlap(detail_21,b_LPF,b_HPF);
[approx_33,detail_33] = overlap(approx_22,b_LPF,b_HPF);
[approx_34,detail_34] = overlap(detail_22,b_LPF,b_HPF);

%thresholding 
decomposed = [approx_31,detail_31,approx_32,detail_32,approx_33,detail_33,approx_34,detail_34]';
%decomposed = threshold(decomposed,T,'MH');

approx_21 = overlap_reconstruct(approx_31,detail_31,b_LPF_g,b_HPF_g);
detail_21 = overlap_reconstruct(approx_32,detail_32,b_LPF_g,b_HPF_g);
approx_22 = overlap_reconstruct(approx_33,detail_33,b_LPF_g,b_HPF_g);
detail_22 = overlap_reconstruct(approx_34,detail_34,b_LPF_g,b_HPF_g);

approx_21 = overlap_reconstruct(decomposed(1,:),decomposed(2,:),b_LPF_g,b_HPF_g);
detail_21 = overlap_reconstruct(decomposed(3,:),decomposed(4,:),b_LPF_g,b_HPF_g);
approx_22 = overlap_reconstruct(decomposed(5,:),decomposed(6,:),b_LPF_g,b_HPF_g);
detail_22 = overlap_reconstruct(decomposed(7,:),decomposed(8,:),b_LPF_g,b_HPF_g);


approx_1 = overlap_reconstruct(approx_21,detail_21,b_LPF_g,b_HPF_g);
detail_1 = overlap_reconstruct(approx_22,detail_22,b_LPF_g,b_HPF_g);

y_new_FftOverlapAddMethod_method = overlap_reconstruct(approx_1,detail_1,b_LPF_g,b_HPF_g);

toc;

%play the sound and write it
sound(y_new_FftOverlapAddMethod_method,Fs)
audiowrite('overlap_method.wav',y_new_FftOverlapAddMethod_method,Fs);
figure()
for i=1:8
subplot(8,1,i)
plot(decomposed(i,:))
end

%****************************************************************************************
%% In this part functions which are used in previous part are written

function [approx,detail] = overlap(y,b_LPF,b_HPF)

%overlap add method by fft and n=1024
Y_approx = fftfilt(b_LPF,y,1024);
Y_detail = fftfilt(b_HPF,y,1024);

%downsampling
approx = downsample(Y_approx,2);
detail = downsample(Y_detail,2);

end

function y = overlap_reconstruct(approx,detail,b_LPF,b_HPF)

%upsampling
approx = upsample(approx,2);
detail = upsample(detail,2);

%reconstruct by overlapp add method fft 1024
y_approx = fftfilt(b_LPF,approx,1024);
y_detail = fftfilt(b_HPF,detail,1024);

%sum approximation and detail signals
y = y_approx + y_detail;

end
function y = threshold (y,T,method)

    switch method
        
        %hard threshold
        case 'hard'
        y(abs(y)<T)=0;
        
        %soft threshold
        case 'soft'
        y(abs(y)<T)=0;
        y = sign(y).*(abs(y)-T);
    
        %modified hard threshold
        case 'MH'
        u=255;
        yy=y(abs(y)<T);
        y(abs(y)<T) = T*((1/u)*(power((1+u),(yy/T))-1).*sign(yy));
        
    end
      
end




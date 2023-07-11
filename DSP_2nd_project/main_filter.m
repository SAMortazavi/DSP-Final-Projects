close all
clear all
clc
% This code was written by Seyed Abolfazl Mortazavi 9833063
%****************************************************************************************
%% This Code was written for filter method
%read audio
filename = '607946-392-1.wav';
[y,Fs]= audioread(filename);
%sound(y,Fs);

%filter paramethers
b_LPF=[-0.01060, 0.03288, 0.03084, -0.18703, -0.02798, 0.63088, 0.71485, 0.23038];
b_HPF=[0.23038, -0.71485, 0.63088, 0.02798, -0.18703, -0.03084, 0.03288, 0.01060];
b_LPF_g = [0.23038, 0.71485, 0.63088, -0.02798, -0.18703, 0.03084, 0.03288, -0.01060];
b_HPF_g = [0.01060, 0.03288, -0.03084, -0.18703,0.02798, 0.63088, -0.71485, 0.23038];

%threshold paramethers
N=100;
sigma = mad(y(1:N))/0.6745;
T = sigma*sqrt(2*log(N));

%wavelet packet decomposition

tic;

%level1
[approx_1,detail_1] = filter_method(y,b_LPF,b_HPF);


%level2
[approx_21,detail_21] = filter_method(approx_1,b_LPF,b_HPF);
[approx_22,detail_22] = filter_method(detail_1,b_LPF,b_HPF);

%level3
[approx_31,detail_31] = filter_method(approx_21,b_LPF,b_HPF);
[approx_32,detail_32] = filter_method(detail_21,b_LPF,b_HPF);
[approx_33,detail_33] = filter_method(approx_22,b_LPF,b_HPF);
[approx_34,detail_34] = filter_method(detail_22,b_LPF,b_HPF);


decomposed = [approx_31,detail_31,approx_32,detail_32,approx_33,detail_33,approx_34,detail_34]';
%decomposed = threshold(decomposed,T,'MH');

%reconstruction
approx_21 = filter_method_reconstruct(decomposed(1,:),decomposed(2,:),b_LPF_g,b_HPF_g);
detail_21 = filter_method_reconstruct(decomposed(3,:),decomposed(4,:),b_LPF_g,b_HPF_g);
approx_22 = filter_method_reconstruct(decomposed(5,:),decomposed(6,:),b_LPF_g,b_HPF_g);
detail_22 = filter_method_reconstruct(decomposed(7,:),decomposed(8,:),b_LPF_g,b_HPF_g);

approx_1 = filter_method_reconstruct(approx_21,detail_21,b_LPF_g,b_HPF_g);
detail_1 = filter_method_reconstruct(approx_22,detail_22,b_LPF_g,b_HPF_g);

y_new_filter_method = filter_method_reconstruct(approx_1,detail_1,b_LPF_g,b_HPF_g);

toc;

%play reconstructed sound
sound(y_new_filter_method,Fs);
audiowrite('filter_method.wav',y_new_filter_method,Fs);
figure()
for i=1:8
subplot(8,1,i)
plot(decomposed(i,:))
end
%****************************************************************************************
%% functions
function y = filter_method_reconstruct(approx,detail,b_LPF,b_HPF)

approx = upsample(approx,2);
detail = upsample(detail,2);

y_approx = filter(b_LPF,[1],approx);
y_detail = filter(b_HPF,[1],detail);

y = y_approx + y_detail;

end
function [approx,detail] = filter_method(y,b_LPF,b_HPF)
Y_approx = filter(b_LPF,[1],y);
Y_detail = filter(b_HPF,[1],y);

approx = downsample(Y_approx,2);
detail = downsample(Y_detail,2);

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

clear all
close all
clc

% First Part


% Import file to MATLAB
[sig1 , Fs_1] = audioread("First_part.WAV");
down_sample_half = downsample(sig1,2);
down_sample_quadro = downsample(sig1,4);
down_sample_oct = downsample(sig1,8);
down_sample_hex = downsample(sig1,16);

% in this part you can uncomment each line for listening every sounds
sound(down_sample_half,Fs_1/2);
% sound(down_sample_quadro,Fs_1/4);
% sound(down_sample_oct,Fs_1/8);
% sound(down_sample_hex,Fs_1/16);

% spectogram analyze
figure()
subplot(2,3,1);
spectrogram(sig1);
title('sig1');
subplot(2,3,2);
spectrogram(down_sample_half);
title('down sample half');
subplot(2,3,3);
spectrogram(down_sample_quadro);
title('down sample quadro');
subplot(2,3,4);
spectrogram(down_sample_oct);
title('down sample oct');
subplot(2,3,5);
spectrogram(down_sample_hex);
title('down sample hex');

%%
% *part 2*

% so we use ideal lowpass before down sampling to prevent anti_aliasing
sig1_filt_half = lowpass(sig1,pi/2,Fs_1);
down_sample_half_filt = downsample(sig1_filt_half,2);

sig1_filt_quadro = lowpass(sig1,pi/4,Fs_1);
down_sample_quadro_filt = downsample(sig1_filt_quadro,4);

sig1_filt_oct = lowpass(sig1,pi/8,Fs_1);
down_sample_oct_filt = downsample(sig1_filt_oct,8);

sig1_filt_hex = lowpass(sig1,pi/16,Fs_1);
down_sample_hex_filt = downsample(sig1_filt_hex,16);

% for listening each down sample uncomment each command below
% sound(down_sample_half_filt,Fs_1/2);
% sound(down_sample_quadro_filt,Fs_1/4);
% sound(down_sample_oct_filt,Fs_1/8);
% sound(down_sample_hex_filt,Fs_1/16);

% spectogram analyze
figure()
subplot(2,3,1);
spectrogram(sig1);
title('sig1');
subplot(2,3,2);
spectrogram(down_sample_half_filt);
title('down sample half filter');
subplot(2,3,3);
spectrogram(down_sample_quadro_filt);
title('down sample quadro filter');
subplot(2,3,4);
spectrogram(down_sample_oct_filt);
title('down sample oct filter');
subplot(2,3,5);
spectrogram(down_sample_hex_filt);
title('down sample hex filter');

%%
% *part 3*

% we use func "decimate", that filter before downsampling
down_sample_half_decimate = decimate(sig1,2);
down_sample_quadro_decimate = decimate(sig1,4);
down_sample_oct_decimate = decimate(sig1,8);
down_sample_hex_decimate = decimate(sig1,16);

% for listening each down sample uncomment each command below
% sound(down_sample_half_decimate,Fs_1/2);
% sound(down_sample_quadro_decimate,Fs_1/4);
% sound(down_sample_oct_decimate,Fs_1/8);
sound(down_sample_hex_decimate,Fs_1/16);

% spectogram analyze
figure()
subplot(2,3,1);
spectrogram(sig1);
title('sig1');
subplot(2,3,2);
spectrogram(down_sample_half_decimate);
title('down sample half filter decimate');
subplot(2,3,3);
spectrogram(down_sample_quadro_decimate);
title('down sample quadro filter decimate');
subplot(2,3,4);
spectrogram(down_sample_oct_decimate);
title('down sample oct filter decimate');
subplot(2,3,5);
spectrogram(down_sample_hex_decimate);
title('down sample hex filter decimate');

%%
% *part 4*

[sig2 , Fs_2] = audioread("Second_part.wav");
Fs_interpolate = 64e3;
t = (0:length(sig2)-1)/Fs_2;
t_interpolate = (0:round(length(sig2)*Fs_interpolate/Fs_2)-1)/Fs_interpolate;

% using interpolation command
sig2_interploate_manual = interp1(t,sig2,t_interpolate,"linear");

% using command "interp"
sig2_interp = interp(sig2,8);

% for listening each down sample uncomment each command below
% sound(sig2_interploate_manual,Fs_2*8);
% sound(sig2_interp,Fs_2*8);

% spectrogram analyze
figure()
subplot(3,1,1);
spectrogram(sig2);
title('sig2');
subplot(3,1,2);
% spectrogram(sig2_interploate_manual);
title('manual interpolation');
subplot(3,1,3);
spectrogram(sig2_interp);
title('interpolation by matlab func');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% filename: Computer_Asignment_4_Matlab.m                       %%%
%%% Author: Tom Painadath                                         %%% 
%%% Description: Extracts 5 seconds of audio from two audio file, %%%
%%%              Amplitude modulate them and input to a circuit   %%%
%%%              Get the demodulated output signal and play it    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
cutoff_frequency = 2*pi*2e3;  %cutoff frequency for the Butterworth low pass filter in radians per second
upsample_frequency = 120e3;   %frequency to upsample the filtered and normailized audio signals

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% low pass filtering, normailzing and upsampling of audio_1 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename1 = 'audio1.mp3';  %assign the variable 'filename' with the name of the audio1 file name
[audio_1,sampling_frequency_1] = audioread(filename1);  %load the audio_1 file and assign variables with the audio signal and sampling frequency
[m_1,n_1] = size(audio_1);  %assign the variables with the size of the audio_1 signal
audio_1 = audio_1(:,1);  %change the signal from stereo to mono
dt_1=1/sampling_frequency_1;  %assign the variable with the inverse of sampling frequency
time_1=dt_1*(0:m_1-1);  %assign the variable with the time vector for audio_1
idx = (time_1>=36) & (time_1<41);  %assign the variable with the time vector for the start and stop time
audio_1 = audio_1(idx);  %extract 5 seconds of audio from the audio signal
audio_1 = transpose(audio_1);  %transpose the audio
%p = audioplayer(a,fs);  %assign the variable with the audio signal extracted
%play(p);  %play the audio extracted
[num_1, den_1] = butter(5, cutoff_frequency, 's');  %assign the variables with the denominator and numberator coeffiecients of 5th order Butterworth filter
H_butter = tf(num_1,den_1);  %define the transfer function using the coefficients
new_sampling_frequnecy = sampling_frequency_1-0.2; %subtract 0.2 from sampling frequency to get an even number 
time_vector_1 = 0:1/new_sampling_frequnecy:5;  %define time vector for audio
filtered_audio_1 = lsim(H_butter,audio_1,time_vector_1);  %apply the filter on to audio_1 signal
greatest_sample_1 = maxk(filtered_audio_1,1);  %finds the value of the largest value of filtered audio_1
normalized_audio_1 = filtered_audio_1/greatest_sample_1;  %normalizes the filtered audio_1
normalized_audio_1 = normalized_audio_1+1;  %add one to the normalized audio to have a range from 0 to 2
upsampled_audio_1 = resample(normalized_audio_1,time_vector_1, upsample_frequency);  %upsample the normalized audio with 120khz sampling frequency
%subplot(2, 3, 1);  %place the plot in row 1 column 1
%myFFT(upsampled_audio_1,upsample_frequency); %produce myFFT plot for the upsampled audio_1

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% low pass filtering, normailzing and upsampling of audio_2 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename2 = 'audio2.mp3';  %assign the variable 'filename' with the name of the audio_2 file name
[audio_2,sampling_frequency_2] = audioread(filename2);  %load the audio_2 file and assign variables with the audio signal and sampling frequency
[m_2,n_2] = size(audio_2);  %assign the variables with the size of the audio_2 signal
audio_2 = audio_2(:,1);  %change the signal from stereo to mono
dt_2=1/sampling_frequency_2;  %assign the variable with the inverse of sampling frequency
time_2=dt_2*(0:m_2-1);  %assign the variable with the time vector for audio_2
idx_2 = (time_2>=148) & (time_2<153);  %assign the variable with the time vector for the start and stop time
audio_2 = audio_2(idx_2);  %extract 5 seconds of audio from the audio signal
audio_2 = transpose(audio_2); %transpose the audio
%p = audioplayer(audio_2,sampling_frequency_2);  %assign the variable with the audio signal extracted
%play(p);  %play the audio extracted
[num_2, den_2] = butter(5, cutoff_frequency, 's');  %assign the variables with the denominator and numberator coeffiecients of 5th order Butterworth filter
H_butter = tf(num_2,den_2);  %define the transfer function using the coefficients
sample_2 = sampling_frequency_2-0.2;  %subtract 0.2 from sampling frequency to get an even number 
time_vector_2 = 0:1/sample_2:5;  %define time vector for audio
filtered_audio_2 = lsim(H_butter,audio_2,time_vector_2);  %apply the filter on to audio_2 signal
greatest_sample_2 = maxk(filtered_audio_2,1);  %finds the value of the largest value of filtered audio_2
normalized_audio_2 = filtered_audio_2/greatest_sample_2;  %normalizes the filtered audio_2
normalized_audio_2 = normalized_audio_2+1;  %add one to the normalized audio to have a range from 0 to 2
upsampled_audio_2 = resample(normalized_audio_2,time_vector_2, upsample_frequency);  %upsample the normalized audio with 120khz sampling frequency

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% create carrier signals and modulate signals %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
carrier_frequency_1 = 20e3;  %assign the variable with carrier frequency of 20kHz
carrier_frequency_2 = 30e3;  %assign the variable with carrier frequency of 30kHz
carrier_sampling_frequency = upsample_frequency+0.4;  %add the upsampling frequency with 0.4 to make it even
time_vector_carrier_signal = 0:1/carrier_sampling_frequency:5;  %define time vector for carrier signals

carrier_signal_1 = cos(2*pi*carrier_frequency_1*time_vector_carrier_signal);  %define the carrier signal 1 
carrier_signal_1 = transpose(carrier_signal_1);  %transpose the carrier signal 1
amplitude_modulation_1 = (carrier_signal_1) .* (upsampled_audio_1);  %dot multiply the carrier signal 1 with upsampled audio 1
subplot(1, 3, 1);  %place the plot in row 1 column 1
myFFT(amplitude_modulation_1, carrier_frequency_1);  %produce myFFT plot for the amplitude modulated audio_1

carrier_signal_2 = cos(2*pi*carrier_frequency_2*time_vector_carrier_signal);  %%define the carrier signal 2
carrier_signal_2 = transpose(carrier_signal_2);  %transpose the carrier signal 2
amplitude_modulation_2 = (carrier_signal_2) .* (upsampled_audio_2);  %dot multiply the carrier signal 2 with upsampled audio 2
subplot(1, 3, 2);  %place the plot in row 1 column 2
myFFT(amplitude_modulation_2, carrier_frequency_2);  %produce myFFT plot for the amplitude modulated audio_1

amplitude_modulation = amplitude_modulation_1+amplitude_modulation_2;  %add both amplitude signals
subplot(1, 3, 3);  %place the plot in row 1 column 3
myFFT(amplitude_modulation, upsample_frequency);  %produce myFFt plot for the added amplitude modulated signals

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% save the modulated data in a multisim readable text file %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_vector_carrier_signal = transpose(time_vector_carrier_signal);  %transpose the time vector for carrier signal
data = [time_vector_carrier_signal amplitude_modulation];  %assign the columns in the matrix data with the time vector and modulated signal
save ('myFile.txt', 'data', '-ascii');  %save the data on to a multisim readable .txt file

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% load the demodulated audio signals and play them %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[demodulated_audio_1, new_sampling_frequency_1] = lvm_import('audio1_demodulated.lvm');  %import the demodulated audio_1 signal and it's sampling frequency
soundsc(demodulated_audio_1, new_sampling_frequency_1);  %play the demodulated audio_1

[demodulated_audio_2, new_sampling_frequency_2] = lvm_import('audio2_demodulated.lvm');  %import the demodulated audio_2 signal and it's sampling frequency
%soundsc(demodulated_audio_2, new_sampling_frequency_2);  %play the demodulated audio_1

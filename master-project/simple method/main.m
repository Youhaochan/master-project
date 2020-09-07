% main function

clear all;
% close all;
% define parameters 
%% these two parameters are the threshold of highlights detection method
alpha = 0.41;
tau = 0.03;
window_size=19; %% it has to be odd
%% reading image;
ImageName = 'original/01055.png';
% method = 'fast';
method = 'slow';
tic
I=imread(ImageName);  
I = im2double(I);      
%% Specular highlight detection 
[X_SVG,index_matrix] = highlight_detection_set(alpha,I,tau);
%% inpaint the highlight region
I_ = replace_by_colors_around_fast(I,X_SVG,window_size,alpha,tau,method);
figure,subplot(1,2,1),imshow(I);title('before');
subplot(1,2,2),imshow(I_);title('After');
toc


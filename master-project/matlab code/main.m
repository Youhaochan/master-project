% main function

clear all;
close all;
% define parameters 
alpha = 0.4;
beta1 = 0.01;
beta2 = 0.01;
tau = 0.1;
h_k = 0.3; % step length
dim=5;
% reading image
I=imread('test1.png');
imshow(I)
I = im2double(I);


[x_max, y_max, z_max] = size(I);
tic
%% initialise
m_d = ones(x_max,y_max);
m_s = ones(x_max,y_max);
p  = ones(x_max,y_max,2);
q = ones(x_max,y_max,2);
%% Specular highlight detection 
X_SVG = highlight_detection_set(alpha,I,tau);
figure
imshow(I)
hold on
scatter(X_SVG(:,2),X_SVG(:,1),'r')
toc
%% correction of hue and saturation
tic 
HSV=rgb2hsv(I);
H=HSV(:,:,1);
S=HSV(:,:,2);
V=HSV(:,:,3);
[H_corrected,S_corrected] = correction_hue_saturation(H,S,I,alpha,X_SVG);
%% Diffuse chromaticity estimate
hsv(:,:,1) = H_corrected;
hsv(:,:,2) = S_corrected;
[row,col] = size(H_corrected);
V = ones(row,col);
hsv(:,:,3) = V;
Lambda = hsv2rgb(hsv);
% %% begin  optimize and update parametersq
Gamma = compute_A(I,X_SVG,dim); %% modified illumination chromaticity

%% initialise
figure
[m_d_new,m_s_new,p,q] = update_parameters_fast(m_d, m_s, h_k,p,q,I,Lambda,Gamma,beta1,beta2);
I_d1 =m_d_new.*Lambda;
figure
subplot(1,2,1);
imshow(I)
subplot(1,2,2)
imshow(I_d1);
toc

% main function
clear all;
close all;
% define parameters 
%% these two parameters are the threshold of highlights detection method
alpha = 0.41;
tau = 0.03;
window_size=21; %% it has to be odd
%%
file_input = 'original size data/000';
rootdir = file_input;
subdir=dir(rootdir);
disp(length(subdir))
for i=1:length(subdir)
    subdirpath=fullfile(rootdir,subdir(i).name,'*.png');
    images=dir(subdirpath);
    for j=1:length(images)
        ImageName=fullfile(rootdir,subdir(i).name,images(j).name);
        I=imread(ImageName);   
        I = im2double(I);
        %% Specular highlight detection 
        [X_SVG,index_matrix] = highlight_detection_set(alpha,I,tau);
%% inpaint the highlight region
        I_ = replace_by_colors_around_fast(I,X_SVG,35,alpha,tau);
        sprintf('this is the %d image',j)
    end
end



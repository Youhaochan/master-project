% main function

clear all;
close all;
% define parameters 
file_input = 'data';
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
        %% image sharpen
        Image_sharpened = imsharpen(I);
%    figure,imshow(I);title('\fontsize{28}Before image sharpening')
%    figure, imshow(Image_sharpened);title('\fontsize{28}After image sharpening');

      %% intensity equalization
    HSV = rgb2hsv(I);
    Heq = adapthisteq(HSV(:,:,3),'NumTiles',[9 9],'clipLimit',0.005,'Distribution','uniform');
    HSV_mod = HSV;
    HSV_mod(:,:,3) = Heq;
    output = hsv2rgb(HSV_mod);
%   figure,imshow(I);title('\fontsize{28}Before Histogram Equalization')
%   igure, imshow(output);title('\fontsize{28}After Histogram Equalization');
  sprintf('this is the %d image',j)
    end
end



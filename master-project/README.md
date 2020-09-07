# master-project
matlab code for image process
this repository includes the code for highlight removal and image sharpening and histogram equalization, while the later two methods are based on the Matlab Library
Highlight removal method is based on the paper "A Global Optimization Method for Specular Highlight Removal from A Single Image". It seems that this method can not perform well on our data set, although the error is decreasing when running this optimization method. Besides, this method is working very slow. Therefore, I tried to develop a simple version which detects the specular region firstly, and inpaint the highlights by computing the average values of its neighbourhood of highlights

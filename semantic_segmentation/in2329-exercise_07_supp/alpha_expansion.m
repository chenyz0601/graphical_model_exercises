raw_img = imread('1_9_s.bmp');
raw_img = im2double(raw_img);
[H,W,C] = size(raw_img);
file_name = fopen('1_9_s.c_unary');
precision = 'ubit1';
unary = fread(file_name,[21,H*W],precision);
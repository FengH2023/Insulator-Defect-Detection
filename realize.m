clear all; 
close all;
% imag1 = imread('缺损绝缘子.jpg');  %读取关键帧
% Insulator1 = sobel(imag1);
% 
% imag2 = imread('完好绝缘子.jpg');  %读取关键帧
% Insulator2 = sobel(imag2);
% 
% 1. 读取图片  
imag = imread('C:\Users\Administrator\Desktop\paper_realize\New realize\旋转图片\5 旋转0°.jpg'); % 替换为绝缘子图片文件名 
%imag = imread('论文1(1)加白黑点.jpg');






%imag3 = imread('大面积破损绝缘子(1).jpg');  %读取关键帧
Insulator3 = ShiXian(imag,[149,438],7500);
% 
% imag4 = imread('小面积破损绝缘子.jpg');  %读取关键帧
% Insulator4 = sobel(imag4);

% imag5 = imread('Computer vision/论文1(2)加黑点.jpg');  %读取关键帧
% Insulator5 = sobel(imag5);

% x=[1,2,3,4,5,6,7,8,9,10,11];
% plot(x,Insulator1,'-k',x,Insulator2,'-b',x,Insulator3,'-g',x,Insulator4,'-r',x,Insulator5,'-y')
% ylabel('NCC'); xlabel('相邻伞裙比较结果');
% legend('绝缘子1','绝缘子2','绝缘子3','绝缘子4','绝缘子5');
imag = imread('F:\新建文件夹\paper_realize\New realize\旋转图片\1 旋转10.jpg');

img= imresize(imag,[200 438],'bicubic');
grayImg = rgb2gray(img);  
  
blurredImg = rgb2gray(img); 
 
points = detectHarrisFeatures(blurredImg, 'MinQuality', 0.001);  
  
po = ones(149,438);
h = points.Location(:,1);
L = points.Location(:,2);
for i = 1:1:size(h)
   
        po(round(L(i,1)),round(h(i,1))) = 0;
        
    
end

[~,max_y_index] = max(L);  
max_y_point = h(max_y_index);  

max_xy_sum = -inf;  
max_xy_sum_index = 0;  

for i = 1:length(h)  
    xy_sum = points.Location(i,1) + points.Location(i,2);  
    if xy_sum > max_xy_sum  
        max_xy_sum = xy_sum;  
        max_xy_sum_index = i;  
    end  
end  
  
max_x = points.Location(max_xy_sum_index,1);  

max_y = points.Location(max_xy_sum_index,2); 


if max_y>100
   
for i = 1:length(h)  
    xy_sum = points.Location(i,1) + 5*points.Location(i,2);  
    if xy_sum > max_xy_sum  
        max_xy_sum = xy_sum;  
        max_xy_sum_index = i;  
    end  
end  
  
max_x = points.Location(max_xy_sum_index,1);  

max_y = points.Location(max_xy_sum_index,2);  
end

vis = [h(max_y_index),L(max_y_index);max_x,max_y];

visPoints = insertMarker(img, points.Location, '+', 'color', 'y');  
figure;imshow(visPoints );  
  
selectedPoints = vis(1:2,:)  ;
  
vec = selectedPoints(2,:) - selectedPoints(1,:);  
  
angle_rad = atan2(vec(2), vec(1)); 

angle_deg = rad2deg(angle_rad);  
  
if angle_deg < 0  
    angle_deg = angle_deg + 180;  
end  
  
fprintf('Estimated angle with horizontal: %f degrees\n', 180-angle_deg);  
  
title(['倾斜角度: ', num2str(180-angle_deg), ' °']); 

Deangle = -(180-angle_deg);  
  
rotated_img = imrotate(imag, Deangle, 'bicubic', 'crop');  
imag= imresize(rotated_img,[149 438],'bicubic');
  
figure;
imshow(imag);

imag= imresize(imag,[900 1352],'bicubic');

imag = rgb2gray(imag);

[high,width] = size(imag);
F2 = double(imag); 
U = double(imag); 
magnitude = imag;

for i = 2:high - 1
for j = 2:width - 1
Gy = (U(i-1,j+1) + 2*U(i,j+1) + F2(i+1,j+1)) - (U(i-1,j-1) + 2*U(i,j-1) + F2(i+1,j-1));
magnitude(i,j) = Gy;
end
end 

[m1,n1] = size(magnitude);
for i = 1 : 1 : m1
for j = 1 : 1 : n1
magnitude(i,j) = magnitude(i,j) *5;
end
end

binaryImage = imbinarize(magnitude,0.18);

if size(binaryImage, 3) == 3
binaryImage = rgb2gray(binaryImage);
end

if ~islogical(binaryImage)
error('The image must be a binary image.');
end

[labels, num] = bwlabel(binaryImage);

areaThreshold = 7500;

largeSkirts = [];

totalArea = 0;

for k = 1:num
props = regionprops(labels == k, 'Area');

if props.Area > areaThreshold
skirtImage = labels == k;

largeSkirts{end+1} = skirtImage;

totalArea = totalArea + props.Area;
end
end

figure;
for i = 1:length(largeSkirts)
subplot(ceil(sqrt(length(largeSkirts))), ceil(sqrt(length(largeSkirts))), i);
imshow(largeSkirts{i});
title(['伞裙 ', num2str(i)]);
end

figure;
subplot(1,3,1), imshow(imag);title('原图'); 
subplot(1,3,2), imshow(magnitude);title('sobel边缘检测后');
subplot(1,3,3), imshow(binaryImage);title('二值化后');

for i = 1:length(largeSkirts)

    if i == 11
        nccValue = normxcorr2(double(largeSkirts{11}),double(largeSkirts{1}));
        [maxNCC, maxLoc]= max(nccValue(:));
        NCC(i) = maxNCC; 
        if maxNCC >0.7 && maxNCC < 1
             fprintf('伞裙 %d 和伞裙 %d 之间无缺陷。\n',i,1);
        else
             fprintf('伞裙 %d 和伞裙 %d 之间有缺陷。\n',i,1);
        end
    else
         nccValue = normxcorr2(double(largeSkirts{i}),double(largeSkirts{i+1}));
         [maxNCC, maxLoc]= max(nccValue(:));
         NCC(i) = maxNCC; 
         if maxNCC >0.7 && maxNCC < 1
             fprintf('伞裙 %d 和伞裙 %d 之间无缺陷。\n',i,i+1);
         else
             fprintf('伞裙 %d 和伞裙 %d 之间有缺陷。\n',i,i+1);
         end
    end
end
figure;
x=1:11;
plot(x,NCC(1:11),'-k');
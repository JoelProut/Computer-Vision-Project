function result = colorsegmentation(I)
%figure, imshow(I), title("Apple");

lab_img = rgb2lab(I);

ab = lab_img(:,:,2:3);
ab = im2single(ab);
nColors = 2;

% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab, nColors, 'NumAttempts', 3);
%imshow(pixel_labels, []), title("Image Labeled by Cluster Index");

% Extract
mask1 = pixel_labels==2;
cluster = I .* uint8(mask1);
bin = im2bw(cluster, 0.25);
bin = bwareafilt(bin, 1);
hsv = rgb2hsv(cluster);

figure, subplot(2,3,1), imshow(cluster), title("Objects in Cluster");
subplot(2,3,2), imshow(bin), title("binary");
subplot(2,3,3), imshow(hsv), title("hsv");
% Iterate through the cluster image, wherever the binary image is 1
[col, row] = size(I);

for x = 1 : col
    for y = 1 : row
        if bin(x, y) == 1
            
        end
    end
end









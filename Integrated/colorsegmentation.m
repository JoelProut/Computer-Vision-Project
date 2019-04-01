function [fruit, meanHue] = colorsegmentation(I)
%figure, imshow(I), title("Apple");

lab_img = rgb2lab(I);

ab = lab_img(:,:,2:3);
ab = im2single(ab);
nColors = 2;

%% Cluster the Image
% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab, nColors, 'NumAttempts', 3);
%imshow(pixel_labels, []), title("Image Labeled by Cluster Index");

% Extract
mask1 = pixel_labels==2;
cluster = I .* uint8(mask1);
bin = im2bw(cluster, 0.25);
bin = bwareafilt(bin, 1);

%% Convert to HSV
hsv = rgb2hsv(cluster);
[h s v] = imsplit(hsv);


%% Display HSV & Binary Images
%figure, subplot(2,3,1), imshow(cluster), title("Objects in Cluster");
%subplot(2,3,2), imshow(bin), title("binary");
%subplot(2,3,3), imshow(h), title("h");

% Iterate through the cluster image, wherever the binary image is 1
count = 0;
sum = 0;
for x = 1 : size(I, 1)
    for y = 1 : size(I, 2)
        if bin(x,y) == 1
            sum = sum + hsv(x,y,1);
            count = count + 1;
        end
    end
end

meanHue = sum/count;
fruit = "N/A";

% Print Result
if meanHue < 0.14
    %subplot(2,3,4), imshow(I), title("Orange (" + meanHue + ")");
    fruit = "Orange";
elseif meanHue > 0.14 && meanHue < 0.22
    %subplot(2,3,4), imshow(I), title("Banana (" + meanHue + ")");
    fruit = "Banana";
elseif meanHue > 0.4 && meanHue < 0.8
    %subplot(2,3,4), imshow(I), title("Apple (" + meanHue + ")");
    fruit = "Apple";
else
    %subplot(2,3,4), imshow(I), title("Unable to Determine (" + meanHue + ")");
    fruit = "N/A";
end

return










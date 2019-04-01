%% Webcam
webcamlist

camName = 'Integrated Webcam';

% Create a webcam object
cam = webcam(camName);

%view camera live feed
preview(cam);

closePreview(cam);

recentAssessment = "N/A";
count = 0;

while true
   pause(0.10)
   % Acquire a single image.
   rgbImage = snapshot(cam);
    
   [fruit, meanHue] = colorsegmentation(rgbImage);
  
   imshow(rgbImage)
   
   if count == 7
       % DO SOMETHING
       title(fruit + " (" + meanHue + ")");
       if recentAssessment ~= fruit
           count = 0;
           title("Calculating");
       end
   elseif recentAssessment == fruit
       count = count + 1;
       title("Calculating");
   else
       count = 0;
       recentAssessment = fruit;
       title("Calculating");
   end
end

clear('cam');
%% TEST LINES
% test1 = imread("orange.jpeg");
% test2 = imread("orange2.jpg");
% test3 = imread("orange3.jpg");
% test4 = imread("orange4.jpg");
% test5 = imread("apple.jpg");
% test6 = imread("apple2.jpg");
% test7 = imread("apple3.jpg");
% test8 = imread("apple4.jpg");
% test9 = imread("apple5.jpg");
% test10 = imread("banana.jpg");
% test11 = imread("lettuce.jpg");
% 
% [fruit1, meanHue1] = colorsegmentation(test1);
% [fruit2, meanHue2] = colorsegmentation(test2);
% [fruit3, meanHue3] = colorsegmentation(test3);
% [fruit4, meanHue4] = colorsegmentation(test4);
% [fruit5, meanHue5] = colorsegmentation(test5);
% [fruit6, meanHue6] = colorsegmentation(test6);
% [fruit7, meanHue7] = colorsegmentation(test7);
% [fruit8, meanHue8] = colorsegmentation(test8);
% [fruit9, meanHue9] = colorsegmentation(test9);
% [fruit10, meanHue10] = colorsegmentation(test10);
% [fruit11, meanHue11] = colorsegmentation(test11);
% 
% figure, subplot(3,4,1), imshow(test1), title([fruit1] + [meanHue1]);
% subplot(3,4,2), imshow(test2), title([fruit2] + [meanHue2]);
% subplot(3,4,3), imshow(test3), title([fruit3] + [meanHue3]);
% subplot(3,4,4), imshow(test4), title([fruit4] + [meanHue4]);
% subplot(3,4,5), imshow(test5), title([fruit5] + [meanHue5]);
% subplot(3,4,6), imshow(test6), title([fruit6] + [meanHue6]);
% subplot(3,4,7), imshow(test7), title([fruit7] + [meanHue7]);
% subplot(3,4,8), imshow(test8), title([fruit8] + [meanHue8]);
% subplot(3,4,9), imshow(test9), title([fruit9] + [meanHue9]);
% subplot(3,4,10), imshow(test10), title([fruit10] + [meanHue10]);
% subplot(3,4,11), imshow(test11), title([fruit11] + [meanHue11]);

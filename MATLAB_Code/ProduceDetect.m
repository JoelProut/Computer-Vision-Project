%Capture Test
webcamlist;

%Type in name from list
camName = 'Integrated Webcam';

%Create a webcam object
cam = webcam(camName);

%view camera live feed
preview(cam);

closePreview(cam);

while true
   % Acquire a single image.
   rgbImage = snapshot(cam);

   % Convert RGB to grayscale.
   grayImage = rgb2gray(rgbImage);
   bwImage = im2bw(grayImage, 0.2);

   % Find circles.
%    [centers, radii] = imfindcircles(bwImage, [40 100]);

   % Display the image.
   subplot(1,2,1), imshow(rgbImage)
  
%    hold on;
%    viscircles(centers, radii);
%    drawnow
   subplot(1,2,2), imshow(bwImage)
end

clear('cam');
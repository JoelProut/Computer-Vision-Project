%% Image Processing
I = imread("FrostedFlakes.jpg");
Igray = rgb2gray(I);
S = strel('disk',15);
I2 = imopen(Igray,S);  
E = edge(I2, 'canny',.2,1);
E2 = bwpropfilt(E,'perimeter',10);
E2 = bwpropfilt(E2,'MajorAxisLength',3);
figure, imshow(E2, []);
E3 = imclose(E2,strel('line',5,90));
E3 = imclose(E2,strel('line',5,0));
S = strel('line',5,90);
S2 = strel('line',5,0);
E4 = imopen(E3,S);
E5 = imopen(E3,S2);
figure, imshow(E4,[]),title('E4');
figure, imshow(E5,[]),title('E5');
figure, imshow(E3,[]),title('E3');

%% Hough
[H,T,R] = hough(E3);
peaks = houghpeaks(H,4000,'Threshold',5);
lines = houghlines(E3,T,R,peaks,'FillGap',20,'MinLength',10);
H = mat2gray(H);
figure,imshow(H,'InitialMagnification','fit'),axis normal; 
figure, imshow(Igray);
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    line(xy(:,1),xy(:,2),'LineWidth',2,'Color','r');
end
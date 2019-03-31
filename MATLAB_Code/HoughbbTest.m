%% Image Processing
I = imread("FrootLoops.jpg");
Igray = rgb2gray(I);
S = strel('disk',15);
I2 = imopen(Igray,S);  
E = edge(I2, 'canny',.2,1);


[L,N] = bwlabel(E);
props = regionprops(L,'all');
bb = props.BoundingBox;
imshow(I),title("TEST"),hold on;
rectangle('position',bb,'EdgeColor','r');
imtool(I);
hold off;
%%
E2 = bwpropfilt(E,'perimeter',10);
E2 = bwpropfilt(E2,'MajorAxisLength',3);
figure, imshow(E2, []);
E3 = imclose(E2,strel('line',5,90));
E3 = imclose(E3,strel('line',5,0));
S = strel('line',15,90);
S2 = strel('line',15,0);
E4 = imopen(E3,S);
E5 = imopen(E3,S2);
E6 = im2bw(imsubtract(E3,E4));
E6 = im2bw(imsubtract(E6,E5));
E7 = imsubtract(E3,E6);
E7 = imclose(E7,strel('line',100,90));
% E7 = imclose(E7,strel('line',10,0));
figure, imshow(E4,[]),title('E4');
figure, imshow(E5,[]),title('E5');
figure, imshow(E3,[]),title('E3');
figure, imshow(E6,[]),title('E6');
figure, imshow(E7,[]),title('E7');

%% Hough
[H,T,R] = hough(E2);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
disp(x);
disp(y);
%boundingBox = [bb(1), bb(2); bb(1) + bb(3), bb(2); bb(1) + bb(3), bb(2) + bb(4); bb(1), bb(2) + bb(4); bb(1), bb(2)];

lines = houghlines(E2,T,R,P,'FillGap',300,'MinLength',10);
figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
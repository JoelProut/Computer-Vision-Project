%% C)
I = imread('FrostedFlakes.jpg');
i = 1;
for alpha = 0.02:0.02:0.10
    [r,c] = getcorners(I,'h',1,0.3,alpha);
    figure(i), imshow(I), title(['Harris Cornerness Measure = ',num2str(alpha)]), hold on
    plot(c,r,'rs');
    hold off;
    i = i + 1;
end


function [r,c] = getcorners(I,method,sigma,thresh,alpha)
if(size(I,3)>1)
    I = rgb2gray(I);
end
I = im2double(I);

if nargin == 2
    sigma = 1;
    thresh = 0.5;
    alpha = 0.4;
elseif nargin == 3
    thresh = 0.5;
    alpha = 0.4;
elseif nargin == 4
    alpha = 0.4;
end

% 1. compute x and y derivatives
dx = [ -1, -1, -1; 0 0 0; 1 1 1];
dy = dx';
Ix = imfilter(I,dx,'same');
Iy = imfilter(I,dy,'same');
%2 2. Sxx and Syy
w = fspecial('gaussian',round(6*sigma), sigma);
Sxx = conv2(Ix.^2, w, 'same');
Syy = conv2(Iy.^2, w, 'same');
Sxy = conv2(Ix.*Iy, w, 'same');
% Compute R
if method == "h"
    %% Harris cornerness measure
    R = (Sxx.*Syy - Sxy.^2)-alpha*((Sxx + Syy).^2); 
elseif method == "s"
    %% Szeliski cornerness measure
    R = (Sxx.*Syy)./(Sxx + Syy);
else
    disp("Invalid method, please use 'h' or 's'.");
    return; % Returns out of function    
end
% Threshold R and find local maxima
radius = 5; % Just a guess?
N = 2 * radius + 1; % Size of mask.
Rdilated = imdilate(R, strel('disk',N));% Grey-scale dilate.
corners = (R > thresh) & (R == Rdilated); % Find local maxima.
[r,c] = find(corners);  % Find row,col coords. 
end
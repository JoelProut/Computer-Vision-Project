% Uses SURF to detect a desired product based on a selection of trainer
% images.
% For the sake of testing I'm only having two options, LuckyCharms
% CaptainCrunch, or Frootloops
function Ifinal = findProduct(product)
%test product
product = "FrostedFlakes";
if(product == "CaptainCrunch")
    template = imread('CaptainCrunchTemplate.jpg');
elseif (product == "LuckyCharms")
    template = imread('LuckyCharmsTemplate.jpg');
elseif (product == "FrootLoops")
    template = imread('FrootLoops.jpg');
elseif (product == "FrostedFlakes")
    template = imread('FrostedFlakes.jpg');
else
    disp("Invalid Product");
    return; % Returns out of function
end

template = rgb2gray(template);
figure, imshow(template),title("template");
scene = rgb2gray(imread("testImage.jpg"));
figure, imshow(scene), title("scene");

%% Feature Detection
tempPoints = detectSURFFeatures(template);
scenePoints = detectSURFFeatures(scene);
%Strongest template features
figure, imshow(template), title('100 Strongest Feature Points')
hold on;
plot(tempPoints.selectStrongest(100));
hold off;
%Strongest scene features
figure, imshow(scene), title('500 Strongest Scene Points')
hold on;
plot(scenePoints.selectStrongest(500));
hold off;

%% Feature Descriptors
tempFeatures = extractFeatures(template, tempPoints);
sceneFeatures = extractFeatures(scene, scenePoints);
featurePairs = matchFeatures(tempFeatures, sceneFeatures);
matchedTempPoints = tempPoints(featurePairs(:,1),:);
matchedScenePoints = scenePoints(featurePairs(:,2),:);
figure, showMatchedFeatures(template, scene, matchedTempPoints, matchedScenePoints, 'montage');
title('Matched Points with Outliers');
%% Locate object and remove outlying matches
[tform, inlierTempPoints, inlierScenePoints] = estimateGeometricTransform(matchedTempPoints, matchedScenePoints, 'affine', 'MaxNumTrials',2000,'MaxDistance',16);
figure, showMatchedFeatures(template, scene, inlierTempPoints, inlierScenePoints, 'montage');
 %% Box image
% Edge detection
S = strel('disk',15);
I2 = imopen(template,S);  
E = edge(I2, 'canny',.2,1);
%Find bb
[L,N] = bwlabel(E);
props = regionprops(L,'all');
bb = props.BoundingBox; %[x,y,w,h]
%convert bb to line coordinates
boundingBox = [bb(1), bb(2); bb(1) + bb(3), bb(2); bb(1) + bb(3), bb(2) + bb(4); bb(1), bb(2) + bb(4); bb(1), bb(2)]; %[x1,y1; x2, y1; x2, y2; x1,y1; x1,y1]
newbb = transformPointsForward(tform, boundingBox); % Use the geometric transform to project the bounding box into the scene image

imshow(scene);
disp(newbb(:,1));
hold on;
line(newbb(:,1), newbb(:,2), 'Color', 'r');
title('Detected Box');
 


end
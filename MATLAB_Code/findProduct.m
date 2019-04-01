% Uses SURF to detect a desired product based on a selection of trainer
% images.
% For the sake of testing I'm only having two options, LuckyCharms
% CaptainCrunch, or Frootloops
function Ifinal = findProduct(product,scene)
%test product
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
% figure, imshow(template),title("template");
scene = rgb2gray(scene);
% figure, imshow(scene), title("scene");

%% Feature Detection
tempPoints = detectSURFFeatures(template);
scenePoints = detectSURFFeatures(scene);
% %Strongest template features
% figure, imshow(template), title('100 Strongest Feature Points')
% hold on;
% plot(tempPoints.selectStrongest(100));
% hold off;
% %Strongest scene features
% figure, imshow(scene), title('500 Strongest Scene Points')
% hold on;
% plot(scenePoints.selectStrongest(500));
% hold off;

%% Feature Descriptors
tempFeatures = extractFeatures(template, tempPoints);
sceneFeatures = extractFeatures(scene, scenePoints);
featurePairs = matchFeatures(tempFeatures, sceneFeatures);
matchedTempPoints = tempPoints(featurePairs(:,1),:);
matchedScenePoints = scenePoints(featurePairs(:,2),:);
% figure, showMatchedFeatures(template, scene, matchedTempPoints, matchedScenePoints, 'montage');
% title('Matched Points with Outliers');
%% Locate object and remove outlying matches
if size(matchedTempPoints,1) >= 4 && size(matchedTempPoints,1) >= 4
    [tform, inlierTempPoints, inlierScenePoints] = estimateGeometricTransform(matchedTempPoints, matchedScenePoints, 'projective','MaxDistance',20);

% figure, showMatchedFeatures(template, scene, inlierTempPoints, inlierScenePoints, 'montage');
%% Box image using a transformation matrix
        boxPolygon = [1, 1;... % top-left
        size(template, 2), 1;... % top-right
        size(template, 2), size(template, 1);... % bottom-right
        1, size(template, 1);... % bottom-left
        1, 1]; % top-left again to close the polygon
	
        newBoxPolygon = transformPointsForward(tform, boxPolygon);
        %Draw a yellow bounding box around the detected image
        imshow(scene),hold on;
        line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'r');
        hold off;
else
    return;
end


end
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

templateGrey = rgb2gray(template);
% figure, imshow(template),title("template");
sceneGrey = rgb2gray(scene);
% figure, imshow(scene), title("scene");

%% Feature Detection
tempPoints = detectSURFFeatures(templateGrey);
scenePoints = detectSURFFeatures(sceneGrey);
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
tempFeatures = extractFeatures(templateGrey, tempPoints);
sceneFeatures = extractFeatures(sceneGrey, scenePoints);
featurePairs = matchFeatures(tempFeatures, sceneFeatures);
matchedTempPoints = tempPoints(featurePairs(:,1),:);
matchedScenePoints = scenePoints(featurePairs(:,2),:);
% figure, showMatchedFeatures(template, scene, matchedTempPoints, matchedScenePoints, 'montage');
% title('Matched Points with Outliers');
%% Locate object and remove outlying matches
if size(featurePairs,1) >= 20
    [tform, inlierTempPoints, inlierScenePoints,status] =...
        estimateGeometricTransform(matchedTempPoints, matchedScenePoints, 'projective','MaxDistance',15);
    disp(status);
%      if status == 0
         %showMatchedFeatures(template, scene, inlierTempPoints, inlierScenePoints, 'montage');
%% Box image using a transformation matrix
        boxPolygon = [1, 1;... % top-left
        size(template, 2), 1;... % top-right
        size(template, 2), size(template, 1);... % bottom-right
        1, size(template, 1);... % bottom-left
        1, 1]; % top-left again to close the polygon
	
        newBoxPolygon = transformPointsForward(tform, boxPolygon);
       
        imshow(scene),hold on;
        set(gcf,'MenuBar','none');
        set(gca,'DataAspectRatioMode','auto');
        set(gca,'Position',[0 0 1 1]);
        line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'r');
        hold off;
%     else
%         imshow(scene);
%     end
else
        imshow(scene);
        set(gcf,'MenuBar','none');
        set(gca,'DataAspectRatioMode','auto');
        set(gca,'Position',[0 0 1 1]);
end


end
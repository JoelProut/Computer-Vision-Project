clc; clear all; close all;
%Capture Test
webcamlist
%Type in name from list
camName = 'Integrated Webcam';
%Create a webcam object
cam = webcam(camName);
%view camera live feed
%preview(cam)

found = false;

userInput = input("Enter Fruit or Cereal: ", 's');

if userInput == "Fruit"
    % Ask User for Type of Fruit
    userInput2 = input("What type of fruit do you want?", 's');
    if (userInput2 ~= "Apple" && userInput2 ~= "Orange" && userInput2 ~= "Banana")
        % INVALID INPUT
    else
        recentAssessment = "N/A";
        count = 0;
        % RUN COLOR SEGMENTATION
        while true
           pause(0.10)
           % Acquire a single image.
           rgbImage = snapshot(cam);

           [fruit, meanHue, BB] = colorsegmentation(rgbImage);
%            figure, imshow(rgbImage)
            h = imshow(rgbImage);
            imshow(rgbImage, 'Parent', h.Parent);
            
           if count == 7
               % DO SOMETHING
               title(fruit + " (" + meanHue + ")");
               rectangle('Position', [BB(1),BB(2),BB(3),BB(4)],...
                 'EdgeColor','r','LineWidth',2 )
                break;
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
    end
elseif(userInput == "Cereal")
    while true
        img = snapshot(cam);
        findProduct("FrostedFlakes",img);
    end
end
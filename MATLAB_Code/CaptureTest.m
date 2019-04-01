clc; clear all; close all;
%Capture Test
webcamlist
%Type in name from list
camName = 'USB2.0 PC CAMERA';
%Create a webcam object
cam = webcam(camName);
%view camera live feed
%preview(cam)

while true
    img = snapshot(cam);
    findProduct("FrostedFlakes",img);
end
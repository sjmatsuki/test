%buildingDir = fullfile(toolboxdir('Latinx'));
%buildingScene = imageSet(buildingDir);

% Display images to be stitched
%montage(buildingScene.ImageLocation)
%I = read(buildingScene, 1);

grayImage = rgb2gray(panorama);
[y,x,m] = harris(grayImage,1000,'tile',[2 2],'disp');
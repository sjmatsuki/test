%https://www.mathworks.com/examples/matlab-computer-vision/mw/vision_product-FeatureBasedPanoramicImageStitchingExample-feature-based-panoramic-image-stitching

% Load images.
buildingDir = fullfile(toolboxdir('wall'));
buildingScene = imageSet(buildingDir);

% Display images to be stitched
montage(buildingScene.ImageLocation)

%Register Image Pairs


% Read the first image from the image set.
I = read(buildingScene, 1);

% Initialize features for I(1)
%grayImage = rgb2gray(I);
%points = detectSURFFeatures(grayImage);
%[features, points] = extractFeatures(grayImage, points);
grayImage = rgb2gray(I);
[pointx, pointy, features] = harris(grayImage,1000,'tile',[4 4],'disp');
Location = [pointx, pointy];
points = SURFPoints(Location);

% Initialize all the transforms to the identity matrix. Note that the
% projective transform is used here because the building images are fairly
% close to the camera. Had the scene been captured from a further distance,
% an affine transform would suffice.
tforms(buildingScene.Count) = projective2d(eye(3));

% Iterate over remaining image pairs
for n = 2:buildingScene.Count
    
    % Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;
        
    % Read I(n).
    I = read(buildingScene, n);
    
    % Detect and extract SURF features for I(n).
    %grayImage = rgb2gray(I);    
    %points = detectSURFFeatures(grayImage);    
    %[features, points] = extractFeatures(grayImage, points);
    
    grayImage = rgb2gray(I);
    [pointx, pointy, features] = harris(grayImage,1000,'tile',[4 4],'disp');
    Location = [pointx, pointy];
    points = SURFPoints(Location);
    
    % Find correspondences between I(n) and I(n-1).
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);
       
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);        
    
    % Estimate the transformation between I(n) and I(n-1).
    tforms(n) = estimateGeometricTransform(matchedPoints, matchedPointsPrev,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    
    % Compute T(1) * ... * T(n-1) * T(n)
    tforms(n).T = tforms(n-1).T * tforms(n).T; 
end

%%
% At this point, all the transformations in |tforms| are relative to the
% first image. This was a convenient way to code the image registration
% procedure because it allowed sequential processing of all the images.
% However, using the first image as the start of the panorama does not
% produce the most aesthetically pleasing panorama because it tends to
% distort most of the images that form the panorama. A nicer panorama can
% be created by modifying the transformations such that the center of the
% scene is the least distorted. This is accomplished by inverting the
% transform for the center image and applying that transform to all the
% others.
%
% Start by using the |projective2d| |outputLimits| method to find the
% output limits for each transform. The output limits are then used to
% automatically find the image that is roughly in the center of the scene.

imageSize = size(I);  % all the images are the same size

% Compute the output limits  for each transform
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);    
end

%%
% Next, compute the average X limits for each transforms and find the image
% that is in the center. Only the X limits are used here because the scene
% is known to be horizontal. If another set of images are used, both the X
% and Y limits may need to be used to find the center image.

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);

%%
% Finally, apply the center image's inverse transform to all the others.

Tinv = invert(tforms(centerImageIdx));

for i = 1:numel(tforms)    
    tforms(i).T = Tinv.T * tforms(i).T;
end

%% Step 3 - Initialize the Panorama
% Now, create an initial, empty, panorama into which all the images are
% mapped. 
% 
% Use the |outputLimits| method to compute the minimum and maximum output
% limits over all transformations. These values are used to automatically
% compute the size of the panorama.

for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I);

%% Step 4 - Create the Panorama
% Use |imwarp| to map images into the panorama and use
% |vision.AlphaBlender| to overlay the images together.

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:buildingScene.Count
    
    I = read(buildingScene, i);   
   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                  
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, warpedImage(:,:,1));
end

figure
imshow(panorama)

%% Conclusion
% This example showed you how to automatically create a panorama using
% feature based image registration techniques. Additional techniques can be
% incorporated into the example to improve the blending and alignment of
% the panorama images[1]. 

%% References
% [1] Matthew Brown and David G. Lowe. 2007. Automatic Panoramic Image
%     Stitching using Invariant Features. Int. J. Comput. Vision 74, 1
%     (August 2007), 59-73.

displayEndOfDemoMessage(mfilename)

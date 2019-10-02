%% Script implementing the terrain neural net
% You must have created the images in TerrainImages with CreateTerrainImages
% before running this script.

%% Get the images
cd TerrainImages
label = load('Label');
cd ..

t          = categorical(label.t);
nClasses   = max(label.t);
imds       = imageDatastore('TerrainImages','labels',t);
labelCount = countEachLabel(imds);

% Display a few snapshots
NewFigure('Terrain Snapshots');
n = 4;
m = 5;
ks = sort(randi(length(label.t),1,n*m)); % random selection
for i = 1:n*m
	subplot(n,m,i);
	imshow(imds.Files{ks(i)});
  title(sprintf('Image %d: %d',ks(i),label.t(ks(i))))
end

% We need the size of the images for the input layer
img = readimage(imds,1);

% Split into training and testing sets
fracTraining = 0.8;
[imdsTrain,imdsTest] = splitEachLabel(imds,fracTraining,'randomized');

%% Training
% This gives the structure of the convolutional neural net
layers = [
    imageInputLayer(size(img))  
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)   
    
    fullyConnectedLayer(nClasses)
    softmaxLayer
    classificationLayer
        ];
disp(layers)
     
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',6, ...
    'MiniBatchSize',100,...
    'ValidationData',imdsTest, ...
    'ValidationFrequency',10, ...
    'ValidationPatience',inf,...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress');
disp(options)
fprintf('Fraction for training %8.2f%%\n',fracTraining*100);

  
terrainNet = trainNetwork(imdsTrain,layers,options);
 
 %% Test the neural net
predLabels  = classify(terrainNet,imdsTest);
testLabels  = imdsTest.Labels;

accuracy = sum(predLabels == testLabels)/numel(testLabels);
fprintf('Accuracy is %8.2f%%\n',accuracy*100)

save('TerrainNet','terrainNet')


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
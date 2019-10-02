%% Get the images
cd Ellipses
type = load('Type');
cd ..
t    = categorical(type.t);
imds = imageDatastore('Ellipses','labels',t);

labelCount = countEachLabel(imds);

% Display a few ellipses
NewFigure('Ellipses')
n = 4;
m = 5;
ks = sort(randi(length(type.t),1,n*m)); % random selection
for i = 1:n*m
	subplot(n,m,i);
	imshow(imds.Files{ks(i)});
end

% We need the size of the images for the input layer
img     = readimage(imds,1);

% Split into training and testing sets
fracTrain     = 0.8;
numTrainFiles = fracTrain*0.5*length(imds.Labels);
[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainFiles,'randomize');

%% Training
% This gives the structure of the convolutional neural net
layers = [
    imageInputLayer(size(img))  
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    leakyReluLayer
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    leakyReluLayer    
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    leakyReluLayer  
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
        ];
      
      
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MiniBatchSize',16, ...
    'MaxEpochs',5, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsTest, ...
    'ValidationFrequency',2, ...
    'Verbose',false, ...
    'Plots','training-progress');
  
 net = trainNetwork(imdsTrain,layers,options);
 
 %% Test the neural net
predLabels  = classify(net,imdsTest);
testLabels  = imdsTest.Labels;

accuracy = sum(predLabels == testLabels)/numel(testLabels);
fprintf('Accuracy is %8.2f%%\n',accuracy*100)


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

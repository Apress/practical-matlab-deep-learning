%% Implement and test the neural net to classify circles from ellipses
%% See also:
% categorical, imageDatastore, countEachLabel, splitEachLabel, imageInputLayer,
% convolution2dLayer, batchNormalizationLayer, reluLayer, maxPooling2dLayer,
% softmaxLayer, classificationLayer, trainingOptions, trainNetwork, classify

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
  title(sprintf('Image %d: %d',ks(i),type.t(ks(i))))
end

% We need the size of the images for the input layer
img = readimage(imds,1);

% Split the data into training and testing sets
fracTrain             = 0.8;
[imdsTrain,imdsTest]  = splitEachLabel(imds,fracTrain,'randomize');

%% Define the layers for the net
% This gives the structure of the convolutional neural net
layers = [
    imageInputLayer(size(img))  
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer    
    
    maxPooling2dLayer(2,'Stride',2)   
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer  
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
        ];
      
%% Training   
% The mini-batch size should be less than the data set size; the mini-batch is
% used at each training iteration to evaluate gradients and update the weights. 
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

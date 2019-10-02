%% Script to train and test the Orbit LSTM
% It will estimate the orbit semi-major axis and eccentricity from a time
% sequence of angle measurements.
%% See also
% Orbits, sequenceInputLayer, bilstmLayer, dropoutLayer, fullyConnectedLayer,
% regressionLayer, trainingOptions, trainNetwork, predict

s           = load('OrbitData');
n           = length(s.data);
nTrain      = floor(0.9*n);

%% Set up the training and test sets 
kTrain      = randperm(n,nTrain);
aMean       = mean([s.el(:).a]);
xTrain      = s.data(kTrain);
nTest       = n-nTrain;

elTrain     = s.el(kTrain);
yTrain      = [elTrain.a;elTrain.e]';
yTrain(:,1) = yTrain(:,1)/aMean;
kTest       = setdiff(1:n,kTrain);
xTest       = s.data(kTest);

elTest      = s.el(kTest);
yTest       = [elTest.a;elTest.e]';
yTest(:,1)	= yTest(:,1)/aMean;

%% Train the network with validation
numFeatures       = 1;
numHiddenUnits1   = 100;
numHiddenUnits2   = 100;
numClasses        = 2;

layers = [ ...
    sequenceInputLayer(numFeatures)
    bilstmLayer(numHiddenUnits1,'OutputMode','sequence')
    dropoutLayer(0.2)
    bilstmLayer(numHiddenUnits2,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    regressionLayer]
  
maxEpochs = 20;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'Shuffle','every-epoch', ...
    'ValidationData',{xTest,yTest}, ...
    'ValidationFrequency',5, ...
    'Verbose',0, ...
    'Plots','training-progress');
  
net = trainNetwork(xTrain,yTrain,layers,options);
  
%% Test the network
yPred       = predict(net,xTest);
yPred(:,1)  = yPred(:,1)*aMean;
yTest(:,1)  = yTest(:,1)*aMean;
yM          = mean(yPred-yTest,1);
fprintf('\nbiLSTM\n');
fprintf('Mean semi-major axis error %12.4f (km)\n',yM(1));
fprintf('Mean eccentricity    error %12.4f\n',yM(2));

%% Plot the results
yL  = {'a' 'e'};
yLeg = {'Predicted','True'};
PlotSet(1:nTest,[yPred';yTest'],'x label','Test','y label',yL,...
'figure title','Predictions using biLSTM','plot set',{[1 3] [2 4]},...
'legend',{yLeg yLeg});


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
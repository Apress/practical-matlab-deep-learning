%% Train and test the sentence completion neural net
% Loads the Sentences mat-file.
%% See also
% PrepareSequences, sequenceInputLayer, bilstmLayer, fullyConnectedLayer,
% softmaxLayer, classificationLayer, classify

clear all

%% Load the data
s = load('Sentences');
n = length(s.c);        % number of sentences

% Make sure the sequences are valid. One in every 5 is complete.
for k = 1:10
  fprintf('Category: %d',s.c(k));
  fprintf('%5d',s.nZ{k})
  fprintf('\n')
  if( mod(k,5) == 0 )
    fprintf('\n')
  end
end

%% Set up the network
numFeatures = 1;
numClasses = 2;

% 
layers = [ ...
    sequenceInputLayer(numFeatures)
    bilstmLayer(80,'OutputMode','sequence')
    fullyConnectedLayer(numClasses)
    dropoutLayer(0.4)
    bilstmLayer(60,'OutputMode','sequence')
    fullyConnectedLayer(numClasses)
    dropoutLayer(0.2) % 0.2 was pretty good
    bilstmLayer(20,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
disp(layers)

%% Train the network
kTrain      = randperm(n,0.85*n);
xTrain      = s.nZ(kTrain);             % sentence indices, in order
yTrain      = categorical(s.c(kTrain)); % complete or not?

% Test this network
kTest       = setdiff(1:n,kTrain);
xTest       = s.nZ(kTest);
yTest       = categorical(s.c(kTest));
  
options = trainingOptions('adam', ...
    'MaxEpochs',60, ...
    'GradientThreshold',1, ...
    'ValidationData',{xTest,yTest}, ...
    'ValidationFrequency',10, ...
    'Verbose',0, ...
    'Plots','training-progress');
  
disp(options)

net         = trainNetwork(xTrain,yTrain,layers,options);
yPred       = classify(net,xTest);

% Calculate the classification accuracy of the predictions.
acc         = sum(yPred == yTest)./numel(yTest);
disp('All')
disp(acc);

j       = find(yTest == '1');
yPredC  = classify(net,xTest(j));
accC    = sum(yPredC == yTest(j))./numel(yTest(j));
disp('Correct')
disp(accC);


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

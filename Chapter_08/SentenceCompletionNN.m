%% Train and test the sentence completion neural net
% Loads the Sentences mat-file.
%% See also
% PrepareSequences, sequenceInputLayer, bilstmLayer, fullyConnectedLayer,
% softmaxLayer, classificationLayer, classify

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
numHiddenUnits = 400;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(numFeatures)
    bilstmLayer(numHiddenUnits,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];
  
disp(layers)
  
options = trainingOptions('adam', ...
    'MaxEpochs',60, ...
    'MiniBatchSize',20,...
    'GradientThreshold',1, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',1, ...
    'InitialLearnRate',0.01,...
    'Plots','training-progress');
%    'SequenceLength','longest', ...
  
%% Train the network - Uniform set
nSentences  = n/5; % number of complete sentences in the database
nTrain      = floor(0.75*nSentences);       % use 75% for training
xTrain      = s.nZ(1:5*nTrain);             % sentence indices, in order
yTrain      = categorical(s.c(1:5*nTrain)); % complete or not?
net         = trainNetwork(xTrain,yTrain,layers,options);

% Test this network - 80% accuracy
xTest       = s.nZ(5*nTrain+1:end);
yTest       = categorical(s.c(5*nTrain+1:end));
yPred       = classify(net,xTest);

% Calculate the classification accuracy of the predictions.
acc         = sum(yPred == yTest)./numel(yTest);
disp('Uniform set')
disp(acc);

%% Train the network using randomly selected sentences
kTrain	= randperm(n,5*nTrain); % nTrain (30!) integers in range 1:n
xTrain  = s.nZ(kTrain);
yTrain  = categorical(s.c(kTrain));
net     = trainNetwork(xTrain,yTrain,layers,options);

% Test the network
kTest = setdiff(1:n,kTrain);
xTest = s.nZ(kTest);
yTest = categorical(s.c(kTest));
yPred = classify(net,xTest);

% Calculate the classification accuracy of the predictions.
acc = sum(yPred == yTest)./numel(yTest);

disp('Random set')
disp(acc);


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
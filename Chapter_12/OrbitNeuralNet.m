%% Train and test the Orbit Neural Net
%% See also:
% Orbits, fitnet, configure, train, sim, cascadeforwardnet, feedforwardnet

s       = load('OrbitData');
n       = length(s.data);
nTrain  = floor(0.9*n);

%% Set up the training and test sets 
kTrain	= randperm(n,nTrain);
sTrain  = s.data(kTrain);
nSamp   = size(sTrain{1},2);
xTrain  = zeros(nSamp,nTrain);
aMean   = mean([s.el(:).a]);

for k = 1:nTrain
  xTrain(:,k) = sTrain{k}(1,:);
end

elTrain     = s.el(kTrain);
yTrain      = [elTrain.a;elTrain.e];
yTrain(1,:) = yTrain(1,:)/aMean; % Normalize the data
kTest       = setdiff(1:n,kTrain);
sTest       = s.data(kTest);
nTest       = n-nTrain;
xTest       = zeros(nSamp,nTest);
for k = 1:nTest
  xTest(:,k) = sTest{k}(1,:);
end

elTest      = s.el(kTest);
yTest       = [elTest.a;elTest.e];
yTest(1,:)   = yTest(1,:)/aMean;

%% Train the network
net       = fitnet(10); 

net       = configure(net, xTrain, yTrain);
net.name  = 'Orbit';
net       = train(net,xTrain,yTrain);

%% Test the network
yPred       = sim(net,xTest);
yPred(1,:)  = yPred(1,:)*aMean;
yTest(1,:)  = yTest(1,:)*aMean;
yM          = mean(yPred-yTest,2);
yTM         = mean(yTest,2);
fprintf('\nFit Net\n');
fprintf('Mean semi-major axis error %12.4f (km) %12.2f %%\n',yM(1),100*abs(yM(1))/yTM(1));
fprintf('Mean eccentricity    error %12.4f      %12.2f %%\n',yM(2),100*abs(yM(2))/yTM(2));

%% Plot the results
yL  = {'a' 'e'};
yLeg = {'Predicted','True'};
PlotSet(1:nTest,[yPred;yTest],'x label','Test','y label',yL,...
'figure title','Predictions using Fitnet','plot set',{[1 3] [2 4]},...
'legend',{yLeg yLeg});

%% Train the cascade forward network
net       = cascadeforwardnet(10); 

net       = configure(net, xTrain, yTrain);
net.name  = 'Orbit';
net       = train(net,xTrain,yTrain);

%% Test the network
yPred       = sim(net,xTest);
yPred(1,:) = yPred(1,:)*aMean;
yM = mean(yPred-yTest,2);
fprintf('\nCascade Forward Net\n');
yM          = mean(yPred-yTest,2);
yTM         = mean(yTest,2);
fprintf('Mean semi-major axis error %12.4f (km) %12.2f %%\n',yM(1),100*abs(yM(1))/yTM(1));
fprintf('Mean eccentricity    error %12.4f      %12.2f %%\n',yM(2),100*abs(yM(2))/yTM(2));

%% Plot the results
yL  = {'a' 'e'};
yLeg = {'Predicted','True'};
PlotSet(1:nTest,[yPred;yTest],'x label','Test','y label',yL,...
'figure title','Predictions using Cascade Forward Network','plot set',{[1 3] [2 4]},...
'legend',{yLeg yLeg});

%% Train the feed forward network
net       = feedforwardnet(10); 

net       = configure(net, xTrain, yTrain);
net.name  = 'Orbit';
net       = train(net,xTrain,yTrain);

%% Test the network
yPred       = sim(net,xTest);
yPred(1,:) = yPred(1,:)*aMean;
yM = mean(yPred-yTest,2);
fprintf('\nFeed Forward Net\n');
yM          = mean(yPred-yTest,2);
yTM         = mean(yTest,2);
fprintf('Mean semi-major axis error %12.4f (km) %12.2f %%\n',yM(1),100*abs(yM(1))/yTM(1));
fprintf('Mean eccentricity    error %12.4f      %12.2f %%\n',yM(2),100*abs(yM(2))/yTM(2));

%% Plot the results
yL  = {'a' 'e'};
yLeg = {'Predicted','True'};
PlotSet(1:nTest,[yPred;yTest],'x label','Test','y label',yL,...
'figure title','Predictions using Feed Forward Network','plot set',{[1 3] [2 4]},...
'legend',{yLeg yLeg});


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.



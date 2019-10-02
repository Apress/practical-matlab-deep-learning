%% Demo of classifying images with pre-trained networks
% alexnet is a pretrained convolutional neural network that is available as an
% Add-On to the Deep Learning toolbox. It has 1000 object categories. You must
% install alexnet from the Add-Ons for this demo.
%% See also
% alexnet, classify, imshow

%% Load the network
% Access the trained model. This is a SeriesNetwork. 
net = alexnet;
net

% See details of the architecture 
net.Layers 

%% Load a test image and classify it
% Read the image to classify 
I = imread('peppers.png');  % ships with MATLAB

% Adjust size of the image to the net's input layer
sz = net.Layers(1).InputSize;
I = I(1:sz(1),1:sz(2),1:sz(3)); 

% Classify the image using AlexNet 
[label, scorePeppers] = classify(net, I);

%  Show the image and the classification results 
NewFigure('Pepper'); ax = gca;
imshow(I); 
title(ax,label);

PlotSet(1:length(scorePeppers),scorePeppers,'x label','Category',...
        'y label','Score','plot title','Peppers');
      
% What other categories are similar?
disp('Categories with highest scores for Peppers:')
kPos = find(scorePeppers>0.01);
[vals,kSort] = sort(scorePeppers(kPos),'descend');
for k = 1:length(kSort)
  fprintf('%13s:\t%g\n',net.Layers(end).Classes(kPos(kSort(k))),vals(k));
end

%% Try the cat
% Adjust size of the image 
I0 = imread('Cat.png'); % included with this textbook
I  = imresize(I0,[227 227]);

% Classify the image 
[label, scoreCat] = classify(net, I);

% Show the image and the classification results 
NewFigure('Tabby Cat'); ax = gca;
imshow(I) 
title(ax,label);
PlotSet(1:length(scoreCat),scoreCat,'x label','Category','y label','Score',...
       'plot title','Tabby Cat');

% What other categories are similar?
disp('Categories with highest scores for Cat:')
kPos = find(scoreCat>0.01);
[vals,kSort] = sort(scoreCat(kPos),'descend');
for k = 1:length(kSort)
  fprintf('%20s:\t%g\n',net.Layers(end).Classes(kPos(kSort(k))),vals(k));
end

%% Next test a picture of a box - this one is hard
% This shiny metal box gets identified as a 'hard disc'

% Read and adjust size of the image 
I0 = imread('Box.jpg');      % included with this textbook
I  = imresize(I0,[227 227]);

% Classify the image 
[label, scoreBox] = classify(net, I);

% Show the image and the classification results 
NewFigure('Box'); ax = gca;
imshow(I); 
title(ax,label);

PlotSet(1:length(scoreBox),scoreBox,'x label','Category','y label','Score',...
        'plot title','Box');

% What other categories are similar?
disp('Categories with highest scores for Box:')
kPos = find(scoreBox>0.05);
[vals,kSort] = sort(scoreBox(kPos),'descend');
for k = 1:length(kSort)
  fprintf('%13s:\t%g\n',net.Layers(end).Classes(kPos(kSort(k))),vals(k));
end


%% A summary
disp('AlexNet results summary:')
fprintf('\nPepper  %12.4f\nCat     %12.4f\nBox     %12.4f\n\n',...
  max(scorePeppers),max(scoreCat),max(scoreBox));

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


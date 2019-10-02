%% Create ellipses to train and test the deep learning algorithm
% The ellipse images are saved  as jpegs in the folder Ellipses.

% Parameters
nEllipses = 1000;
nCircles  = 1000;
nBits     = 32;
maxAngle  = pi/4;
rangeA    = [0.5 1];
rangeB    = [1 2];
maxThick  = 3.0;
tic
[s, t] = GenerateEllipses(rangeA,rangeB,maxAngle,maxThick,nEllipses,nCircles,nBits);
toc
cd Ellipses
kAdd = 10^ceil(log10(nEllipses+nCircles)); % to make a serial number
for k = 1:length(s)
  imwrite(s{k,2},sprintf('Ellipse%d.jpg',k+kAdd));
end

% Save the labels
save('Type','t');
cd ..


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


%% Use the Deep Learning Toolbox to create the terrain neural net

net = feedforwardnet(2); 

% For use by TerrainCamera
nPixels   = 672; % Dimensions of base image
wTerrain	= 222; % x dimension of the image

% Create training pairs
h = NewFigure('Earth Segment');
i = imread('TerrainClose.jpg');
image(i);
grid

NewFigure('Terrain Camera');
wPixel = wTerrain/nPixels;

x     = linspace(-111+9*wPixel,111-9*wPixel,672-16);
y     = x;
nX    = length(x);
nS    = nX^2;
p(nS) = struct('p',[],'r',[0;0]);
rGB   = zeros(3,nS);

i     = 0;
for k = 1:nX
  for j = 1:nX
    i         = i + 1;
    p(i)      = TerrainCamera( [x(k);y(j)], h, 16, wTerrain, [nPixels nPixels] );
    rGB(:,i)	= mean(mean(p(i).p));
  end
end

PlotSet(1:nS,rGB,'x label','Image','y label',{'r' 'b' 'g'});


% net       = configure(net, x, y);
% net.name  = 'Terrain';
% net       = train(net,x,y);

save TerrainNet net


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
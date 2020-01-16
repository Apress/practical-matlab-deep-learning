%% TERRAINCAMERA Models a camera taking a photo of terrain
% Type TerrainCamera for a demo.
%% Input
% r       (3,1) Position with respect to the terrain center (m)
% h       (1,1) Handle to the figure with the terrain image
% nBits 	(1,1) Pixels in the image from the camera
% w       (1,1) x dimension of the base image 
% nP      (1,2) Dimensions of base image
%
%% Output
% d       (.)   Data structure
%               .p (n,n,3) Pixel map
%               .r (2,1) [x;y]

function d = TerrainCamera( r, h, nBits, w, nP )

% Demo
if( nargin < 1 )
  Demo;
  return
end

if( nargin < 3 )
  nBits = [];
end

if( nargin < 4 )
  w = [];
end

if( nargin < 5 )
  nP = 64;
end

if( isempty(w) )
  w = 4000;
end

if( isempty(nBits) )
  nBits = 16;
end

dW = w/nP;

x0 = -w/2 + (nBits/2)*dW;
y0 =  w/2 - (nBits/2)*dW;
k  = floor((r(1) - x0)/dW) + 1;
j  = floor((y0 - r(2))/dW) + 1;


kR = k:(k-1 + nBits);
kJ = j:(j-1 + nBits);

[~,~,i] = getimage(h);

d.p   	= i(kR,kJ,:);
d.r     = r(1:2);

if( nargout < 1 )
  image(d.p)
  axis off
  axis image
  clear p
end

%% CreateTerrain>Demo
function Demo

h = NewFigure('Earth Segment');
i = imread('TerrainClose64.jpg');
image(i);
grid

NewFigure('Terrain Camera');
x = linspace(0,10,20);
for k = 1:20
  TerrainCamera( [x(k);0], h );
  pause( 0.1 );
end

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

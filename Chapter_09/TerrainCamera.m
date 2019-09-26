%% Models a camera
%
% Type TerrainCamera for a demo.

%% Input
% r       (3,1) Position with respect to the terrain center (m)
% h       (1,1) Handle to image
% n       (1,1) Pixels in the image
% w       (1,1) x dimension of the image
% nP      (1,2) Dimensions of base image

%% Output
% d       (.)   Data structure
%               .p (n,n,3) Pixel map
%               .r (2,1) [x;y]

function d = TerrainCamera( r, h, n, w, nP )

% Demo
if( nargin < 1 )
  Demo;
  return
end

if( nargin < 3 )
  n = [];
end

if( nargin < 4 )
  w = [];
end

if( nargin < 5 )
  nP = [672 672];
end

if( isempty(w) )
  w = 222;
end

if( isempty(n) )
  n = 16;
end

xToPix  = nP(1)/w;
cXY     = r(1:2)*xToPix;
xLim    = floor([cXY(1) - n/2 cXY(1) + n/2] + nP(1)/2);
yLim    = floor([cXY(2) - n/2 cXY(2) + n/2] + nP(2)/2);
[~,~,i] = getimage(h);
d.p   	= i(xLim(1):xLim(2),yLim(1):yLim(2),:);
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
i = imread('TerrainClose.jpg');
image(i);
grid

NewFigure('Terrain Camera');
x = linspace(0,10,20);
for k = 1:20
  TerrainCamera( [x(k);0], h );
  pause( 0.1 );
end


%% DCOIL Draw a D shaped coil
%% Form:
%    [v,f] = DCoil( w, x, y )
%
%% Inputs
%   w            (1,1) Width of hoop segment
%   x            (1,1) X-axis scale
%   x            (1,1) Y-axis scale
%
%% Outputs
%   v            (:,3) Vertices
function [v,f] = DCoil( w, x, y )

if( nargin < 1 )
  w = 0.01;
  x = 1;
  y = 1;
  DCoil( w, x, y )
  return
end

if( nargin < 3 )
  y = x;
end

yFlip = 264;

c = [582.0  242.5 0;...
     582.0  220.0 0;...
     582.0  197.5 0;...
     586.0  177.0 0;...
     607.0  167.5 0;...
     621.0  167.5 0;...
     656.0  167.5 0;...
     684.0  177.0 0;...
     702.0  191.5 0;...
     718.0  211.5 0;...
     728.0  242.5 0 ];
xS =  max(c(:,1)) - min(c(:,1));

   
% Add the bottom
cB      = ([1 0 0;0 -1 0;0 0 1]*c')';
cB(:,2) = cB(:,2) + 2*yFlip;
c       = [c;flipud(cB)];

c(:,1) = c(:,1)/xS;
c(:,2) = c(:,2)/xS;

c(:,2) = c(:,2) - mean(c(:,2));
c(:,1) = c(:,1) - mean(c(:,1));

c(:,1) = x*c(:,1);
c(:,2) = y*c(:,2);
  

[v,f]  = SquareHoop(w,c');

% Rotate about x
%v       = ([1 0 0;0 0 -1;0 1 0]*v')';


% Default output
if( nargout < 1 )
	NewFigure('D Coil');
  c = [0.4 0.4 0.4];
	shading flat
  lighting gouraud
  patch('vertices',v,'faces',f,'facecolor',c,'edgecolor',c,'ambient',1,'facealpha',0.2);
  axis image
  xlabel('x')
  ylabel('y')
  zlabel('z')
  view([0 0 1])
  grid on
  rotate3d on
  clear v
end

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
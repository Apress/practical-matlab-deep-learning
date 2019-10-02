
%% CONE Compute the vertices for a cone.
% The cone points along +z
%% Form:
%   [v, f] = Cone( r, h, n )
%
%% Inputs
%   r            (1,1) Base radius
%   h            (1,1) Height
%   n            (1,1) Number of divisions
%
%% Outputs
%   v            (:,3) Vertices
%   f            (:,3) Faces

function [v, f] = Cone( r, h, n )

if( nargin < 1 )
  Cone( 1, 2, 20 );
  return;
end

a	= linspace(0,2*pi,n);
c	= cos(a);
s	= sin(a);

v	= [0 0 h;...
     r*c',r*s',zeros(n,1)];
k = (1:n)';
f = [ones(n,1),k,k+1];

if( nargout < 1 )
	NewFigure('Cone');
  c = [0.4 0.4 0.4];
	shading flat
  lighting gouraud
  patch('vertices',v,'faces',f,'facecolor',c,'edgecolor',c,'ambient',1,'facealpha',0.2);
  axis image
  xlabel('x')
  ylabel('y')
  zlabel('z')
  view(3)
  grid on
  rotate3d on
  clear v
end

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

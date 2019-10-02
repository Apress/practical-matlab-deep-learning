%% SQUAREHOOP Draw a square hoop about the z-axis
%% Form:
%   [v, f] = SquareHoop(w,r,n)
%
%% Inputs
%   w            (1,1) Width of hoop segment
%   r            (1,1) Radius
%   n            (1,1) Number of divisions
%
%% Outputs
%   v            (:,3) Vertices
%   f            (:,3) Faces

function [v,f] = SquareHoop(w,r,n)

if( nargin < 1 )
  w = 0.4;
  r = 2;
  n = 10;
  SquareHoop(w,r,n)
  return
end

if( nargin < 3 )
  n = 100;
end

if( length(r) == 1 )
  a = linspace(0,2*pi-2*pi/n,n);
  c = r*[cos(a);sin(a);zeros(1,n)];
else
  c = r;
  a = atan2(r(2,:),r(1,:));
  n = length(a);
end

% Vertices in the xz-plane
v0 = 0.5*w*[-1 0 -1;1 0 -1;1 0 1;-1 0 1];
v  = zeros(4*n,3);
cA = cos(a);
sA = sin(a);
for k = 1:n
  i      	= 4*k-3:4*k;
  m       = [cA(k) -sA(k) 0;sA(k) cA(k) 0;0 0 1];
  v(i,:)  = (m*v0')';
  v(i,1)  = v(i,1) + c(1,k);
  v(i,2)  = v(i,2) + c(2,k);  
end

% 8 faces per block
f = zeros(8*n,3);

for k = 1:n-1
  i       = 8*k-7:8*k;
  f(i,:)  = AddFaces(k,k+1);
end
i       = 8*n-7:8*n;
f(i,:)  = AddFaces(n,1);

% Default output
if( nargout < 1 )
	NewFigure('Square Hoop');
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

%% SquareHoop>AddFaces 
function f = AddFaces( k, j )

i       = 4*k-3:4*k;
p       = 4*j-3:4*j;

f       = zeros(8,3);

f(1,:)  = [i(2) p(2) p(3)];
f(2,:)  = [i(2) p(3) i(3)];

f(3,:)  = [i(3) p(3) p(4)];
f(4,:)  = [i(3) p(4) i(4)];

f(5,:)  = [i(1) i(4) p(4)];
f(6,:)  = [i(1) p(4) p(1)];

f(7,:)  = [i(1) p(1) p(2)];
f(8,:)  = [i(1) p(2) i(2)];



%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

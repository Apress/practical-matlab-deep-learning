%% DRAWTOKAMAK Draw a tokamak
% Draw a tokamak
%% Form:
%   DrawTokamak(rMajor,rMinor)
%
%% Inputs
%   rMajor     (1,1) Major radius
%   rMinor     (1,1) Minor radius
%
%% Outputs
%   None

function DrawTokamak(rMajor,rMinor)

if( nargin < 1 )
  DrawTokamak(2,0.5)
  return
end

% Poloidal coils
rP      = 1.4*rMajor;
[v,f]   = SquareHoop(0.07*rP,rP);
z       = 1.4*rMinor;
v(:,3)  = v(:,3) + z;
vP      = v;
fP      = [f;f+size(vP,1)];
v(:,3)  = v(:,3) - 2*z;
vP      = [vP;v];

% Center stack     
n       = 6;
h       = 2.2*rMinor;
dZ      = 2*h/6;
w       = 0.5*dZ;
r       = 0.6*(rMajor-rMinor);
[v,f]   = SquareHoop(w,r);
z       = h-dZ/2;
v(:,3)  = v(:,3) + z;
vC      = v;
fC      = f;
for k = 2:n
  v(:,3) = v(:,3) - dZ;
  fC     = [fC;f+size(vC,1)];
  vC     = [vC;v];
end

% D coils
n = 13;

a = linspace(pi/4,7*pi/4,13);

c = cos(a);
s = sin(a);

fD = [];
vD = [];

[v,f] = DCoil(0.1,1.5);
v     = ([1 0 0;0 0 -1;0 1 0]*v')';

for k = 1:n
  x       = rMajor*c(k);
  y       = rMajor*s(k);
  vX      = ([c(k) -s(k) 0;s(k) c(k) 0; 0 0 1]*v')';
  vX(:,1) = vX(:,1) + x;
  vX(:,2) = vX(:,2) + y;
  fD      = [fD;f+size(vD,1)];
  vD      = [vD;vX];
end
  
% Toroid    
[vT,fT] = Torus(rMajor,rMinor);

% Default output
NewFigure('Tokamak');
c = [0.4 0.4 0.4];
shading flat
lighting gouraud
patch('vertices',vP,'faces',fP,'facecolor',c,'edgecolor',c,'ambient',1);
c = [0.0 0.4 0.0];
patch('vertices',vC,'faces',fC,'facecolor',c,'edgecolor',c,'ambient',1);
c = [0.0 0.0 0.4];
patch('vertices',vD,'faces',fD,'facecolor',c,'edgecolor',c,'ambient',1);
c = [0.4 0.4 0.0];
patch('vertices',vT,'faces',fT,'facecolor',c,'edgecolor',c,'ambient',1,'facealpha',0.4,'edgealpha',0.4);
axis image
xlabel('x')
ylabel('y')
zlabel('z')
view(3)
grid on
rotate3d on



%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
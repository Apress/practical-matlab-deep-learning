%% CP2I Transformation matrix from the perifocal frame to the inertial frame.
%% Form:
%   c = CP2I( i, L, w )
%
%% Inputs
%   i               (3,1) Inclination (rad)
%   L               (3,1) Longitude of the ascending node (rad)
%   w               (3,1) Argument of perigee (rad)
%
%% Outputs
%   c               (3,3) Transformation matrix
%
%% References: 
% Bate, Roger R., Fundamentals of Astrodynamics, Dover Publications, Inc., New
% York, 1971, pp. 82-83.

function c = CP2I( i, L, w )

if( nargin < 3 )
  w = 0;
end

if( nargin < 2 )
  L = 0;
end

if( nargin < 1 )
  i = 0;
end

ci = cos(i);
si = sin(i);

cw = cos(w);
sw = sin(w);

cL = cos(L);
sL = sin(L);

c = [ cL*cw-sL*sw*ci,-cL*sw-sL*cw*ci, sL*si;...
      sL*cw+cL*sw*ci,-sL*sw+cL*cw*ci,-cL*si;...
               sw*si,          cw*si,    ci];

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

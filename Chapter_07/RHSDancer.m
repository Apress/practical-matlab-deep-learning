%% RHSDANCER Implements dancer dynamics 
% This is a model of dancer with one degree of translational freedom
% and 5 degrees of rotational freedom including the head and an internal
% rotational degree of freedom.
%% Form:
%   xDot = RHSDancer( x, ~, d )
%% Inputs
%   x       (11,1)	State vector [r;v;q;w;wHDot;wIDot]
%   t       (1,1)   Time (unused) (s)
%   d       (1,1)   Data structure for the simulation
%                   .torque   (3,1) External torque (Nm)
%                   .force    (1,1) External force (N)
%                   .inertia  (3,3) Body inertia (kg-m^2)
%                   .inertiaH (1,1) Head inertia (kg-m^2)
%                   .inertiaI (1,1) Inner inertia (kg-m^2)
%                   .mass     (1,1) Dancer mass (kg)
%
%% Outputs
%   xDot    (11,1)	d[r;v;q;w;wHDot;wIDot]/dt

function xDot = RHSDancer( ~, x, d )

% Default data structure
if( nargin < 1 )
   % Based on a 0.15 m radius, 1.4 m long cylinders
  inertia = diag([8.4479    8.4479    0.5625]);
  xDot    = struct('torque',[0;0;0],'force',0,'inertia',inertia,...
  'mass',50,'inertiaI',0.0033,'inertiaH',0.0292,'torqueH',0,'torqueI',0);
  return
end

% Use local variables
v     = x(2); 
q     = x(3:6);
w     = x(7:9);
wI    = x(10);
wH    = x(11);

% Unit vector
u     = [0;0;1];

% Gravity
g     = 9.806;

% Attitude kinematics (not mentioned in the text)
qDot	= QIToBDot( q, w );

% Rotational dynamics Equation 7.6
wDot	= d.inertia\(d.torque - Skew(w)*(d.inertia*w + d.inertiaI*(wI + w(3))...
      + d.inertiaH*(wH + w(3))) - u*(d.torqueI + d.torqueH));
wHDot = d.torqueH/d.inertiaH - wDot(3);
wIDot = d.torqueI/d.inertiaI - wDot(3);

% Translational dynamics
vDot  = d.force/d.mass - g;

% Assemble the state vector
xDot	= [v; vDot; qDot; wDot; wHDot; wIDot; w(3)];

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


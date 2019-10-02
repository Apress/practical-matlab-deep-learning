%% CONICSECTIONELLIPSE Computes the location of an ellipse on a cone.
% The ellipse is rotate about the y-axis.
%
%% Form:
%   [z,phi,x] = ConicSectionEllipse(a,b,r0,h)
%
%% Inputs
%   a       (1,1) Major axis
%   b       (1,1) Semi-major axis
%   theta   (1,1) Opening angle
%
%%   Outputs
%   h       (1,1) Distance from apex
%   phi     (1,1) Rotation angle
%   x       (1,1) X location of the axis of rotation

function [h,phi,x] = ConicSectionEllipse(a,b,theta)

if( nargin < 1 )
  [h, phi, y] = ConicSectionEllipse(2,1,pi/4);
  fprintf('h   = %12.4f\n',h);
  fprintf('phi = %12.4f (rad)\n',phi);
  fprintf('x   = %12.4f\n',y);
  clear h
  return
end

phi   = pi/2 - atan(sqrt(1-b^2/a^2));

alpha = pi/2 - phi;
c     = cos(alpha);
s     = sin(alpha);
gamma = cos(theta);
f     = a*[-gamma*s - c;c - gamma*s];
q     = [1 -gamma;1 gamma]\f;
x     = q(1);
h     = q(2);

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

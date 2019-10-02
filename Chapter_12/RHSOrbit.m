%% RHSORBIT Orbit dynamics RHS.
%% Form:
%   xDot = RHSOrbit(~,x,d)
%
%% Inputs
%   t	(1,1) Time (s) (unused)
%   x	(4,1) State [x;y;v_x;v_y]
%   d (.) Data structure
%         .mu (1,1) Gravitational parameter
%         .a  (2,1) Acceleration
%
%% Outputs
%   xDot	(4,1) Time derivative of the state
%

function xDot = RHSOrbit(~,x,d)

r     = x(1:2);
v     = x(3:4);
xDot  = [v;-d.mu*r/(r'*r)^1.5 + d.a];

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
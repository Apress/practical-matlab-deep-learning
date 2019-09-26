%% RHSAIRTURBINE Air turbine dynamics model.
% Right-hand-side of an air turbine model. This is a linear model in state
% space form. If no arguments are entered it will return the default data
% structure.
%
%% Form
%      d = RHSAirTurbine()
%   xDot = RHSAirTurbine( t, x, d )
%
%% Inputs
%   t   (1,1)  Time
%   x		(2,1)  State [p;omega]
%   d   (.)   Input data structure
%
%% Outputs
%   xDot	(2,1)  State derivative
%
%% Reference
% J. S. Meserole, Jr., "Detection Filters for Fault-Tolerant Control of
% Gas Turbine Engines." MIT PhD Thesis, Department of Aeronautics and
% Astronautics, 1981.

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc.
% All rights reserved.

function xDot = RHSAirTurbine( ~, x, d )	

% Default data structure
if( nargin < 1 )
  kP   = 1;
  kT   = 2;
  tauP = 10;
  tauT = 40;
  c    = eye(2);
  b    = [kP/tauP;0];
  a    = [-1/tauP 0; kT/tauT -1/tauT];
  
  xDot = struct('a',a,'b',b,'c',c,'u',0);
  if( nargout == 0)
    disp('RHSAirTurbine struct:');
  end
  return
end

% Derivative
xDot = d.a*x + d.b*d.u;
  

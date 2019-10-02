%% EQUILIBRIUMCONTROLS Finds controls to maintain equilibrium.
% Type EquilibriumControls for a demo.
%% Form
%   d = EquilibriumControls( x, d )
%%
%% Inputs
%   x     (6,1) State [v;gamma;psi;xE;yN;h]
%   d     (.)   Data structure see RHSPointMassAircraft
%
%% Outputs
%   d     (.)   Data structure see RHSPointMassAircraft
%

function d = EquilibriumControls( x, d )

if( nargin < 1 )
  Demo
  return
end

[~,~,drag]  = RHSPointMassAircraft( 0, x, d );
u0          = [drag;0];
opt         = optimset('fminsearch');
u           = fminsearch( @RHS, u0, opt, x, d );
d.thrust    = u(1);
d.alpha     = u(2);

%% EquilibriumControls>RHS
function c = RHS( u, x, d )

d.thrust  = u(1);
d.alpha   = u(2);
xDot      = RHSPointMassAircraft( 0, x, d );
c         = xDot(1)^2 + xDot(2)^2;

%% EquilibriumControls>DefaultDataStructure
function Demo

d     = RHSPointMassAircraft;
d.phi = 0.4;
x     = [250;0;0.02;0;0;10000];
d     = EquilibriumControls( x, d );
r     = x(1)^2/(d.g*tan(d.phi));

fprintf('Thrust          %8.2f N\n',d.thrust);
fprintf('Altitude        %8.2f km\n',x(6)/1000);
fprintf('Angle of attack %8.2f deg\n',d.alpha*180/pi);
fprintf('Bank angle      %8.2f deg\n',d.phi*180/pi);
fprintf('Turn radius     %8.2f km\n',r/1000);
  
%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

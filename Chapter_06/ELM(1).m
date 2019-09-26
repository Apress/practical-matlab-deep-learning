
%% Disturbance in a Tokamak plasma due to edge localized modes (ELMs). 
% These disturbances repeat. Thus, every tau3, set t = 0.
%--------------------------------------------------------------------------
%   Form:
%   eLM = ELM( tau1, tau2, k, t )
%--------------------------------------------------------------------------
%
%% Inputs
%   tau1	(1,1) Time constant 1
%   tau2	(1,1) Time constant 2
%   k    	(1,1) Gain
%   t    	(1,:) Time
%
%% Outputs
%   d    	(2,:) ELM and its derivative
%
%--------------------------------------------------------------------------
%   Reference: Scibile, L. and B. Kouvaritakis (2001.) "A Discrete Adaptive
%              Near-Time Optimum Control for the Plasma Vertical Position 
%              in a Tokamak." IEEE Transactions on Control System 
%              Technology. Vol. 9, No. 1, January 2001.
%--------------------------------------------------------------------------

function eLM = ELM( tau1, tau2, k, t )

% Constants from the reference
if( nargin < 3 )
  tau1 = 6.0e-4;
  tau2 = 1.7e-4;
  k    = 6.5;
end

% Reproduce the reference results
if( nargin < 4 )
  t = linspace(0,12e-3);
end

d = k*[ exp( -t/tau1 ) - exp( -t/tau2 );...
        exp( -t/tau2 )/tau2 - exp( -t/tau1 )/tau1 ];

if( nargout == 0 )
  PlotSet( t*1000, d, 'x label', 'Time (ms)', 'y label', {'d' 'dd/dt'}, 'figure title', 'ELM' )
else
  eLM = d;
end


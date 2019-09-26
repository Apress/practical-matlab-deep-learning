%% DETECTIONFILTER Builds and updates a linear detection filter.
%% Forms
%   d = DetectionFilter( 'initialize', d, tau, dT )
%   d = DetectionFilter( 'update', u, y, d )
%   d = DetectionFilter( 'reset', d )
%
%% Description
% The detection filter gain matrix d is designed during the initialize
% action. The continuous matrices are then discretized using the internal
% function CToDZOH. The esimated state and residual vectors are initialized
% to the size dictated by a. During the update action, the residuals and
% new estimated state are calculated and stored in the data structure d.
%
% The residuals calculation is
%
% $$r   = y - c\hat{x}$$
%
% The estimated state calculated with the detection filter gains is
%
% $$\hat{x}_{k+1} = a*\hat{x} + +b*u + d*r$$
%
%% Inputs
%   action      (1,:) 'initialize' or 'update'
%   d           (.)   Data structure
%                      .a (:,:) State space continuous a matrix
%                      .b (:,1) State space continuous b matrix
%                      .c (:,:) State space continuous c matrix
%   tau         (:,1) Vector of time constants
%   dT          (1,1) Time step
%   u           (:,1) Actuation input
%   y           (:,1) Measurement vector
%
%% Outputs
%   d           (.)   Updated data structure
%                      .a (:,:) State space discrete a matrix
%                      .b (:,1) State space discrete b matrix
%                      .c (:,:) State space discrete c matrix
%                      .d (:,:) Detection filter gain matrix
%                      .x (:,1) Estimated states
%                      .r (:,1) Residual vector
%
%% See also
% DetectionFilter>CToDZOH

%% Copyright
% Copyright (c) 2015 Princeton Satellite Systems, Inc. 
% All rights reserved.

function d = DetectionFilter( action, varargin )

switch lower(action)
  case 'initialize'
    d   = varargin{1};
    tau = varargin{2};
    dT  = varargin{3};
    
    % Design the detection filter
    d.d = d.a + diag(1./tau);
    
    % Discretize both
    d.d        = CToDZOH( d.d, d.b, dT );
    [d.a, d.b] = CToDZOH( d.a, d.b, dT );
    
    % Initialize the state
    m   = size(d.a,1);
    d.x = zeros(m,1);
    d.r = zeros(m,1);
    
  case 'update'
    u   = varargin{1};
    y   = varargin{2};
    d   = varargin{3};
    r   = y - d.c*d.x;
    d.x = d.a*d.x + +d.b*u + d.d*r;
    d.r = r;
    
  case 'reset'
    d   = varargin{1};
    m   = size(d.a,1);
    d.x = zeros(m,1);
    d.r = zeros(m,1);
end

end

function [f, g] = CToDZOH( a, b, T )
%%% DetectionFilter>CToDZOH Create a discrete time system using a zero order hold.
% Utilizes expm for the discretization.
%
%  [f, g] = CToDZOH( a, b, T )
%

cB = size(b,2);
rA = size(a,1);

q  = expm([a*T b*T;zeros(cB,rA+cB)]);

f  = q(1:rA,1:rA);
g  = q(1:rA,rA+1:rA+cB); 

end

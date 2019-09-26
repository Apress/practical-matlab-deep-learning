function xDot = RHSTPVC( x, t, d )

%% Simulates a model of the vertical position of a plasma in a Tokamak.
%--------------------------------------------------------------------------
%   Form:
%   xDot = RHSTPVC( x, t, d )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   x           (3,1) State [wA4;wB4;h]
%   t           (1,1) Time
%   d           (1,1) Structure
%                     .a         (1,1) State space model
%                     .b         (1,1)
%                     .c         (1,1)
%                     .d         (1,1)
%                     .v         (1,1)
%                     .eLM       (1,1) Edge limited mode disturbance
%
%   -------
%   Outputs
%   -------
%   xDot        (3,1) State derivative
%
%--------------------------------------------------------------------------
%   Reference: Scibile, L. and B. Kouvaritakis (2001.) "A Discrete Adaptive
%              Near-Time Optimum Control for the Plasma Vertical Position 
%              in a Tokamak." IEEE Transactions on Control System 
%              Technology. Vol. 9, No. 1, January 2001.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   Copyright (c) 2001 Princeton Satellite Systems, Inc. 
%   All rights reserved.
%--------------------------------------------------------------------------


xDot = d.a*x + d.b*[d.v;d.eLM];

%--------------------------------------
% $Date: 2017-05-11 11:25:02 -0400 (Thu, 11 May 2017) $
% $Revision: 44537 $

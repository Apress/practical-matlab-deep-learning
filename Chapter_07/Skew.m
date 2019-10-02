%% SKEW: Converts a vector into a skew symmetric matrix.
%
%% Form:
%   s = Skew( v )
%
%% Inputs
%   v (3,1) Vector
%
%% Outputs
%   s (3,3) Skew symmetric matrix
%

function s = Skew( v )

s = [    0 -v(3)  v(2);...
      v(3)    0  -v(1);...
     -v(2)  v(1)     0];
   
   
%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


%% QCR Creates a regulator from a state space system.
% Create a regulator of the form
%
%   u = -Kx minimizing the cost functional
%   J = {(1/2)[u'ru + x'qx] + u'nx + x'nu}dt.
%
% Given the constraint:
%   .
%   x = ax + bu
%
%% Form:
%   [k, sinf] = QCR( a, b, q, r )
%
%% Inputs
%   a   (n,n)  Plant matrix
%   b   (n,m)  Input matrix
%   q   (n,n)  State cost matrix
%   r   (m,m)  Input cost matrix
%
%% Outputs
%   k    (1,n) Optimal gain
%

function k = QCR( a, b, q, r )

if( nargin < 1 )
  Demo
  return
end

bor = b/r;

[sinf,rr] = Riccati( [a,-bor*b';-q',-a'] );

if( rr == 1 ) 
  disp('Repeated roots. Adjust q or r');
end

 k = r\(b'*sinf);

%% QCR>Matrix Riccati equation
function [sinf, rr] = Riccati( g )

[w, e] = eig(g);

[rg,~] = size(g);

es = sort(diag(e));

% Look for repeated roots
if ( length(unique(es)) < length(es) )
  rr = 1;
else
  rr = 0;
end

% Sort the columns of w
ws   = w(:,real(diag(e)) < 0);

sinf = real(ws(rg/2+1:rg,:)/ws(1:rg/2,:)); 

%% QCR>Demo
function Demo

a = [0 1;0 0];
b = [0;1];
q = eye(2);
r = 1;

k = QCR( a, b, q, r );

e = eig(a-b*k);

fprintf('\nGain = [%5.2f %5.2f]\n\n',k);
disp('Eigenvalues');
disp(e)


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

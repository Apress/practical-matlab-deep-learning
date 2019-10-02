%% XORTRAINING Implements an XOR training function.
%% Form
%  w = XORTraining(a,b,c,w,n,eta)
%
%% Description
% Train the XOR net with back propagation derived for a tanh activation
% function. Includes a demo with random initial weights.
%
%% Inputs
%  a    (1,4) Input 1
%  b    (1,4) Input 2
%  c    (1,4) Output
%  w    (9,1) Weights and biases
%  n    (1,1) Number of iterations through all 4 inputs
%  eta  (1,1) Training weight
%
%% Outputs
%  w    (9,1)  Weights and biases
%% See also
% XOR

function w = XORTraining(a,b,c,w,n,eta)

if( nargin < 1 )
  Demo;
  return
end

e       = zeros(4,1);
y3      = XOR(a,b,w);
e(:,1)  = y3 - c;
wP      = zeros(10,n+1); % For plotting the weights
for k = 1:n
  wP(:,k) = [w;mean(abs(e))];
  for j = 1:4
    [y3,y1,y2]  = XOR(a(j),b(j),w);
    psi1        = 1 - y1^2; 
    psi2        = 1 - y2^2;
    e(j)        = y3 - c(j);
    psi3        = e(j); % Linear activation function
    dW          = psi3*[psi1*a(j);psi1*b(j);psi2*a(j);psi2*b(j);y1;y2;psi1;psi2;1];
    w           = w - eta*dW;
  end
end
wP(:,k+1) = [w;mean(abs(e))];

% For legend entries
wName = string;
for k = 1:length(w)
  wName(k) = sprintf('W_%d',k);
end
leg{1} = wName;
leg{2} = '';
  
PlotSet(0:n,wP,'x label','step','y label',{'Weight' 'Error'},...
  'figure title','Learning','legend',leg,'plot set',{1:9 10});


%% XORTraining>Demo
function Demo

a       = [0 0 1 1];
b       = [0 1 0 1];
c       = [0 1 1 0];
w       = [ 0.1892; 0.2482; -0.0495; -0.4162; -0.2710;...
            0.4133; -0.3476; 0.3258; 0.0383];
w       = XORTraining(a,b,c,w,25000,0.001)
c       = XOR(a,b,w);

fprintf('    a     b   c\n');
for k = 1:4
  fprintf('%5.0f %5.0f %5.2f\n',a(k),b(k),c(k));
end

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

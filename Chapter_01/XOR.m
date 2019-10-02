%% XOR Implement an 'Exclusive Or' neural net
% Uses the tanh function as the activation function for the hidden
% layer and a linear acivation funcion for the output layer. 
%% Form
%  c = XOR(a,b,w)
%
%% Description
% Implements an XOR function in a neural net. It accepts vector inputs.
%
%% Inputs
%  a  (1,:)  Input 1
%  b  (1,:)  Input 2
%  w  (9,1)  Weights and biases
%% Outputs
%  c  (1,:)  Output
%
function [y3,y1,y2] = XOR(a,b,w)

if( nargin < 1 )
  Demo
  return
end

y1 = tanh(w(1)*a  + w(2)*b  + w(7));
y2 = tanh(w(3)*a  + w(4)*b  + w(8));
y3 = w(5)*y1 + w(6)*y2 + w(9);
c  = y3;

%% XOR>Demo
function Demo

a = [1 0 0 1];
b = [0 1 0 1];
w = [1.7932 1.8155 -0.8536 -0.8592 1.3744 1.4892 -0.4974 1.1125 -0.5634];

c = XOR(a,b,w);
  
fprintf('\n    a     b   c\n');
for k = 1:4
  fprintf('%5.0f %5.0f %5.2f\n',a(k),b(k),c(k));
end

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

 
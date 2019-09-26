%% XOR Exclusive or neural net
% Uses the logistic function as the activation function
%% Form
%  c = XORB(a,b,w)
%
%% Description
% Implements an XOR function in a neural net.It accepts vector inputs.
%
%% Inputs
%  a  (1,:)  Input 1
%  b  (1,:)  Input 2
%  w  (9,1)  Weights and biases
%% Outputs
%  y3 (1,:)  Output
%

function [y3,y1,y2] = XORB(a,b,w)

if( nargin < 1 )
  Demo
  return
end

y1 = zeros(4,1);
y2 = zeros(4,1);
y3 = zeros(4,1);

f = w(1)*a  + w(2)*b;
y1(f>w(7)) = 1;
f = w(3)*a  + w(4)*b;
y2(f>w(8)) = 1;
f = w(5)*y1 + w(6)*y2;
y3(f>w(9)) = 1;

function Demo

a = [1 0 0 1];
b = [0 1 0 1];
w = [1 1 -1 -1 1 1 0.5 -1.5 1.5]';

c = XORB(a,b,w);
  
fprintf('\n    a     b   c\n');
for k = 1:4
  fprintf('%5.0f %5.0f %5.2f\n',a(k),b(k),c(k));
end

 
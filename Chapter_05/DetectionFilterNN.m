%% Script that creates a neural net for the detection filter
% Detects failures of an air turbine.
%% See also
% feedforwardnet, configure, train, sim

% Train the neural net
% Cases
% 2 layers
% 2 inputs
% 1 output

net       = feedforwardnet(2); 

%          [none both       tach         regulator]
residual = [0     0.18693851  0          -0.18693851;...
            0    -0.00008143 -0.09353033 -0.00008143];

% labels is a strings array
label     = ["none" "both"  "tach" "regulator"];

% How many sets of inputs
n   = 600;

% This determines the number of inputs and outputs
x   = zeros(2,n);
y   = zeros(1,n);

% Create training pairs
for k = 1:n
  j       = randi([1,4]);
  x(:,k)  = residual(:,j);
  y(k)    = label(j);
end

net       = configure(net, x, y);
net.name  = 'DetectionFilter';
net       = train(net,x,y);
c         = sim(net,residual);

fprintf('\nRegulator  Tachometer    Failed\n');
for k = 1:4
  fprintf('%9.2e %9.2e      %s\n',residual(1,k),residual(2,k),label(k));
end

% This only works for feedforwardnet(2); 
fprintf('\nHidden layer biases %6.3f %6.3f\n',net.b{1});
fprintf('Output layer bias   %6.3f\n',net.b{2});
fprintf('Input layer weights  %6.2f %6.2f\n',net.IW{1}(1,:));
fprintf('                     %6.2f %6.2f\n',net.IW{1}(2,:));
fprintf('Output layer weights %6.2f %6.2f\n',net.LW{2,1}(1,:));

fprintf('Hidden layer activation function %s\n',net.layers{1}.transferFcn);
fprintf('Output layer activation function %s\n',net.layers{2}.transferFcn);

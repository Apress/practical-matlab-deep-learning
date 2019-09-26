%% Linear neuron
% Look at a linear neuron with 3 activation functions 


%% Look at the activation functions
x       = linspace(-4,2,1000);
v4      = 2*x + 3;
v1      = tanh(v4);
v2      = 2./(1+exp(-v4)) - 1;
v3      = zeros(1,length(x));

k       = v4 >=0;
v3(k)   = 1;

PlotSet(x,[v1;v2;v3;v4],'x label','x', 'y label',...
  'y', 'figure title','Linear Neuron','plot title', 'Linear Neuron',...
  'plot set',{[1 2 3 4]},'legend',{{'Tanh','Exp' 'Binary Step','Linear'}});

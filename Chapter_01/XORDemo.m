%% Demonstrate training and back propagation of the XOR problem

%% Training data
a       = [0 1 0 1];
b       = [0 0 1 1];
c       = [0 1 1 0];

% First try random weights
w0      = [ 0.1892; 0.2482; -0.0495; -0.4162; -0.2710;...
            0.4133; -0.3476; 0.3258; 0.0383];
cR      = XOR(a,b,w0);

fprintf('\nRandom Weights\n')
fprintf('    a     b   c\n');
for k = 1:4
  fprintf('%5.0f %5.0f %5.2f\n',a(k),b(k),cR(k));
end

w       = XORTraining(a,b,c,w0,25000,0.001);
cT      = XOR(a,b,w);

fprintf('\nWeights and Biases\n')
fprintf('  Initial   Final\n')

for k = 1:9
  fprintf('  %7.4f %7.4f\n',w0(k),w(k));
end

fprintf('\nTrained\n')
fprintf('    a     b   c\n');
for k = 1:4
  fprintf('%5.0f %5.0f %5.2f\n',a(k),b(k),cT(k));
end


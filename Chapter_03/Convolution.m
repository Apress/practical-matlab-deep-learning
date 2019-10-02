%% Demonstrate convolution

filter = [1 0;1 1]
image  = [0 0 0 0 0 0;...
          0 0 0 0 0 0;...
          0 0 1 0 0 0;...
          0 0 1 1 0 0;...
          0 0 0 0 0 0]
        
out = zeros(3,3);
        
for k = 1:4
  for j = 1:4
    g = k:k+1;
    f = j:j+1;
    out(k,j) = sum(sum(filter.*image(g,f)));
  end
end

out

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.



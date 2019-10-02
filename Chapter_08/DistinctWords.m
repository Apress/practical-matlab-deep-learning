%% DISTINCTWORDS Creates a dictionary from a string
% Type DistinctWords for a demo.
%% Form:
%   d = DistinctWords( w )
%
%% Inputs
%   w   (1,:) String
%
%% Outputs
%   d   {:}   List of distinct words
%   n   (1,:) Sentence replaced with numbers
%
%% See also
% erase, split, 

function [d,n] = DistinctWords( w )

% Demo
if( nargin < 1 )
  Demo;
  return
end

% Remove punctuation
w = erase(w,';');
w = erase(w,',');
w = erase(w,'.');

% Find unique words
s = split(w)';
d = unique(s);

if( nargout > 1 )
  % find the numbers for the words
  n = zeros(1,length(s));
  for k = 1:length(s)
    for j = 1:length(d)
      if( d(j) == s(k) )
        n(k) = j;
        break;
      end
    end
  end
end


%% DistinctWords>Demo
function Demo
w   = "No one knew it then, but she was being held under a type of house "...
    + "arrest while the tax authorities scoured the records of her long "...
      + "and lucrative career as an actress, a luminary of the red carpet, "...
      + "a face of luxury brands and a successful businesswoman."
[d,n]  = DistinctWords(w)



%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

%% MAPTONUMBERS Map a sentence to a word dictionary.
%
% Type MapToNumbers for a demo.
%
%% Form:
%   n = MapToNumbers( w, d )
%
%% Inputs
%   w   (1,:) Sentence to map (string)
%   d   (1,:) Unique words dictionary (string array)
%
%% Outputs
%   n   (1,:) Sentence replaced with numbers
%
%% See also
% MapToNumbers>Demo

function n = MapToNumbers( w, d )

% Demo
if( nargin < 1 )
  Demo;
  return
end

w = erase(w,';');
w = erase(w,',');
w = erase(w,'.');
s = split(w)';  % string array

n = zeros(1,length(s));
for k = 1:length(s)
  ids = find(strcmp(s(k),d));
  if ~isempty(ids)
    n(k) = ids;
  end

end

n(n==0) = [];

function Demo
%%% MapToNumbers>Demo
% Find the distinct words in a sample sentence and map it to numbers. Output is
% displayed to the command line.

w   = "No one knew it then, but she was being held under a type of house "...
    + "arrest while the tax authorities scoured the records of her long "...
      + "and lucrative career as an actress, a luminary of the red carpet, "...
      + "a face of luxury brands and a successful businesswoman."
d = DistinctWords(w);
n = MapToNumbers( w, d )



%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
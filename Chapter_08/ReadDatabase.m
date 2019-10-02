%% READDATABASE Read in the sentence database.
% Reads in the sentence database file. Finds the sentences the range of 
% characters with underlines and the possible words. You need to have
% 'testing_data.txt' and 'test_answer.txt' in tab delimited format.
%% Form:
%   [s,u,v,a] = ReadDatabase
%
%% Inputs
%   None
%
%% Output Sentences
%   s {1040,1} Sentences
%   u (1040,2) Range of underlines in sentence
%   v {1040,5} Possible words including 4 imposters
%   a (1040,1) Which of the five words is correct


function [s,u,v,a] = ReadDatabase

f = fopen('testing_data.txt','r');

% We know the size of the file simplying the code.
u = zeros(1040,2);
a = zeros(1040,1);
s = strings(1040,1);
v = strings(1040,5);
t = sprintf('\t');
k = 1;

% Read in the sentences and words
while(~feof(f))
  q     = fgetl(f); % This is one line of text
  j     = [strfind(q,t) length(q)+1]; % This finds tabs that delimit words
  s(k)	= convertCharsToStrings(q(j(1)+1:j(2)-1)); % Convert to strings
  for i = 1:5
    v(k,i) = convertCharsToStrings(q(j(i+1)+1:j(i+2)-1)); % Make strings
  end
  ul      = strfind(s(k),'_'); % Find the space where the answers go
  u(k,:)  = [ul(1) ul(end)]; % Get the range of characters for the answer
  k       = k + 1;
end

fclose(f);

% Read in the test answers
f = fopen('test_answer.txt','r');

k = 1;
while(~feof(f))
  q     	= fgetl(f); 
  a(k,1)	= double(q)-96;
  k      	= k + 1;
end

fclose(f);



%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
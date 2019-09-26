%% Read in the database.
% Reads in the sentence database. Finds the sentences the range of 
% characters with underlines and the possible words. You need to have
% 'testing_data.txt' in tab delimited format.
%--------------------------------------------------------------------------
%% Form:
%   [s,u,v,a] = ReadDatabase
%
%% Inputs
%   None
%
%% Output Sentences
%   s {1040,1} Sentences
%   u (1040,2) Range of underlines in sentence
%   v {1024,5} Possible words
%   a (1024,1) Answers


function [s,u,v,a] = ReadDatabase

f = fopen('testing_data.txt','r');

% We know the size of the file simplying the code.
v = cell(1040,5);
s = cell(1040,1);
u = zeros(1040,2);
a = zeros(1040,1);
t = sprintf('\t');
k = 1;

% Read in the sentences and words
while(~feof(f))
  q         = fgetl(f);
  j         = [strfind(q,t) length(q)+1];
  s{k}      = q(j(1)+1:j(2)-1);
  for i = 1:5
    v{k,i} = q(j(i+1)+1:j(i+2)-1);
  end
  ul        = strfind(s{k},'_');
  u(k,:)    = [ul(1) ul(end)];
  k         = k + 1;
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




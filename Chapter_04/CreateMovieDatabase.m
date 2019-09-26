%% Read in the movie database.
% Reads in the movie database. The file needs to be in tab delimited
% format. In this case we create random ratings and lengths.
%--------------------------------------------------------------------------
%% Form:
%   d = CreateMovieDatabase( file )
%
%% Inputs
%   file (1,:) Name of movie file
%
%% Output
%   d (.) Database
%         .name   {.}
%         .rating (1,:)
%         .length (1,:)
%         .genre  {.}
%         .mPAA   {.}
%         


function d = CreateMovieDatabase( file )

if( nargin < 1 )
  Demo
  return
end

f = fopen(file,'r');

d.name    = {};
d.rating  = [];
d.length  = [];
d.genre   = {};
d.mPAA    = {};
t         = sprintf('\t');
k         = 0;

while(~feof(f))
  k             = k + 1;
  q             = fgetl(f);
  j             = strfind(q,t);
  d.name{k}     = q(1:j(1)-1);
  d.rating(1,k)	= str2double(q(j(1)+1:j(2)-1));
  d.genre{k}    = q(j(2)+1:j(3)-1);
	d.length(1,k)	= str2double(q(j(3)+1:j(4)-1));
  d.mPAA{k}     = q(j(4)+1:end);
end

if( max(d.rating) == 0 || isnan(d.rating(1)) )
  d.rating = randi(5,1,k);
end

if( max(d.length) == 0 || isnan(d.length(1)))
  d.length = 1.8 + 0.15*randn(1,k);
end

fclose(f);

%% CreateMovieDatabase>Demo
function Demo

file = 'Movies.txt';
d     = CreateMovieDatabase( file )
 



%% CREATEMOVIEVIEWERS Create a movie viewer database
% Creates a set of movie watchers.
%% Form:
%   mvr = CreateMovieViewers( nViewers, d )
%
%% Inputs
%  nViewers  (1,1) Number of viewers
%  d          (.)  Movie database
%
%% Output
%  mvr        {n}   A cell array with a list of movies each viewer has watched.
%
%% See also
% CreateMovieDatabase

function [mvr,pWatched] = CreateMovieViewers( nViewers, d )

if( nargin < 1 )
  Demo
  return
end

mvr   = cell(1,nViewers);
nMov  = length(d.name);
genre = { 'Animated', 'Comedy', 'Dance', 'Drama', 'Fantasy', 'Romance',...
          'SciFi', 'War', 'Horror', 'Music', 'Crime'};
mPAA  = {'PG-13','R','PG'};

% Loop through viewers. The inner loop is movies.
for j = 1:nViewers
  % Probability of watching each MPAA
  rMPAA = rand(1,length(mPAA));
  rMPAA = rMPAA/sum(rMPAA);
  
  % Probability of watching each Rating (1 to 5 stars)
  r = rand(1,5);
  r = r/sum(r);
  
  % Probability of watching a given Length
  mu    = 1.5 + 0.5*rand; % preferred movie length, between 1.5 and 2 hrs
  sigma = 0.5*rand;       % variance, up to 1/2 hour
  
  % Probability of watching by Genre
  rGenre = rand(1,length(genre));
  rGenre = rGenre/sum(rGenre);
  
  % Compute the likelihood the viewer watched each movie
  pWatched = zeros(1,nMov);
  for k = 1:nMov
    pRating   = r(d.rating(k));           % probability for this rating
    i         = strcmp(d.mPAA{k},mPAA);   % logical array with one match
    pMPAA     = rMPAA(i);                 % probability for this MPAA
    i         = strcmp(d.genre{k},genre); % logical array
    pGenre   	= rGenre(i);                % probability for this genre
    pLength   = Gaussian(d.length(k),sigma,mu);  % probability for this length
    pWatched(k) = 1 - (1-pRating)*(1-pMPAA)*(1-pGenre)*(1-pLength);
  end
  
  % Sort the movies and pick the most likely to have been watched
  nInterval = floor( [0.2 0.6]*nMov );
  nMovies = randi(nInterval);
  [~,i]   = sort(pWatched);  
  mvr{j}  = i(1:nMovies);
end

%% CreateMovieViewers>Gaussian
% The probability is 1 when x==mu and declines for shorter or longer movies
function p = Gaussian(x,sigma,mu)

p = exp(-(x-mu)^2/(2*sigma^2));

%% CreateMovieViewers>Demo
function Demo

s = load('Movies.mat');

mvr = CreateMovieViewers( 4, s.d )
 


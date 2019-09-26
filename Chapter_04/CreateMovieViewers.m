%% Create a movie viewer database
% Creates a set of movie watchers.
%--------------------------------------------------------------------------
%% Form:
%   d = CreateMovieViewers(n.d)
%
%% Inputs
%  n  (1,1) Number of viewers
%  d  (.)   Movie database
%
%% Output
%  d {n}    A cell array with a list of movies.
%         

function w = CreateMovieViewers( n, d )

if( nargin < 1 )
  Demo
  return
end

w     = cell(1,n);
m     = length(d.name);
genre = { 'Animated', 'Comedy', 'Dance', 'Drama', 'Fantasy', 'Romance',...
          'SciFi', 'War', 'Horror', 'Music', 'Crime'};
mPAA  = {'PG-13','R','PG'};

% Loop through viewers. The inner loop is movies.
for j = 1:n
  
  % MPAA
  rMPAA = rand(1,length(mPAA));
  rMPAA = rMPAA/sum(rMPAA);
  
  % Rating
  r     = rand(1,5);
  r     = r/sum(r);
  
  % Length
  mu    = 1.5*rand + 0.5;
  sigma = 0.5*rand;
  
  % Genre
  rGenre = rand(1,length(genre));
  rGenre = rGenre/sum(rGenre);
  
  % Rate the movies
  rating = zeros(1,m);
  for k = 1:m
    pRating   = r(d.rating(k));
    i         = strcmp(d.mPAA{k},mPAA);
    pMPAA     = rMPAA(i==1);
    i         = strcmp(d.genre{k},genre);
    pGenre   	= rGenre(i==1);
    pLength   = Gaussian(d.length(k),sigma,mu);
    rating(k) = 1 - (1-pRating)*(1-pMPAA)*(1-pGenre)*(1-pLength);
  end
  
  % Sort the movies by rating and pick the best rated
  nMovies = randi([0.2 0.6]*m);
  [~,i]   = sort(rating);  
  w{j}    = i(1:nMovies);
end

%% CreateMovieViewers>Gaussian
function p = Gaussian(x,sigma,mu)

p = exp(-(x-mu)^2/(2*sigma^2))/(sigma*sqrt(2*pi));

%% CreateMovieViewers>Demo
function Demo

s = load('Movies.mat');

w = CreateMovieViewers( 4, s.d )
 



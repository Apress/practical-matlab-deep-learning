%% STOCKMARKET Random stock stock market
% Generate a set of random stocks. The last two arguments are for plotting.
%% Form:
%   d = StockMarket( nStocks, s0Mean, s0Sigma, tEnd, nInt )
%% Inputs
%   nStocks (1,1) Number of stocks
%   s0Mean  (1,1) Mean stock price
%   s0Sigma (1,1) Stock price standard deviation
%   tEnd    (1,1) End time in years
%   n       (1,1) Number of intervals
%
%% Outputs
%   d       (.) Stock Market
%               .s0     (1,m) Initial prices
%               .r      (1,m) Drift
%               .sigma  (1.m) Volatility
%

function d = StockMarket(  nStocks, s0Mean, s0Sigma, tEnd, nInt )

if( nargin < 1 )
  Demo
  return
end

d.s0    = abs(s0Mean + s0Sigma*randn(1,nStocks));
d.r     = 0.5*rand(1,nStocks);
d.sigma = rand(1,nStocks);
s       = 'A':'Z';
for k = 1:nStocks
  j            = randi(26,1,3);
  d.symb(k,:)  = s(j);
end

% Output
if( nargout < 1 )
  s = StockPrice( d.s0, d.r, d.sigma, tEnd, nInt );
  t	= linspace(0,tEnd,nInt+1);
  PlotStock(t,s,d.symb);
  clear d
end

%% StockPrice>Demo
function Demo

nStocks = 15;    % number of stocks
s0Mean  = 8000;  % Mean stock preice
s0Sigma = 3000;  % Standard  dev of price
tEnd    = 5.75;  % years duration for market
nInt    = 1448;  % number of intervals
StockMarket( nStocks, s0Mean, s0Sigma, tEnd, nInt );


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

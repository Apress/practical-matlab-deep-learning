%% STOCKPRICE Random stock price generator
% Random stock price generator using a geometric Brownian Motion as
% proposed by Samuelson in 1965.
%
% The demo is for the Wilshire 5000 Total Market Index,
% an index of the market value of all stocks actively traded
% in the United States.
%
%% Form:
%   [s,t] = StockPrice( s0, r, sigma, tEnd, n )
%
%% Inputs
%   s0    (:,1) Initial price
%   r     (:,1) Drift (0 to 1)
%   sigma (:,1) Volatility (0 to 1)
%   tEnd  (1,1) End time in years
%   nInt  (1,1) Number of intervals
%
%% Outputs
%   s     (:,:) Stock price
%   t     (1,:) Time array 
%
%% Reference
% Steven,R. Dunbar, "Stochastic Processes and Advanced Mathematical
% Finance," University of Nebraska-Lincoln.

function [s, t] = StockPrice( s0, r, sigma, tEnd, nInt )

if( nargin < 1 )
  Demo
  return
end

delta   = tEnd/nInt;
sDelta  = sqrt(delta);
t       = linspace(0,tEnd,nInt+1);
m       = length(s0);
w       = [zeros(m,1) cumsum(sDelta.*randn(m,nInt))];
s       = zeros(1,nInt+1);
f       = r - 0.5*sigma.^2;
for k = 1:m
  s(k,:) = s0(k)*exp(f(k)*t + sigma(k)*w(k,:));
end

% Output
if( nargout < 1 )
	PlotStock(t,s,{});
  clear s;
end

%% StockPrice>Demo
function Demo

tEnd  = 5.75;
n     = 1448;
s0    = 8242.38;
r     = 0.1682262;
sigma = 0.1722922;
StockPrice( s0, r, sigma, tEnd, n );

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


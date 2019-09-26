	
%% Random stock price generator
% Random stock price generator using a geometric Brownian Motion as
% proposed by Samuelson in 1965.
%
% The demo is for the Wilshire 5000 Total Market Index
% an index of the market value of all stocks actively traded
% in the United States.
%
%--------------------------------------------------------------------------
%% Form:
%    s = StockPrice( s0, r, sigma, tEnd, n )
%
%% Inputs
%   s0    (:,1) Initial price
%   r     (:,1) Drift
%   sigma (:,1) Volatility
%   tEnd  (1,1) End time in years
%   n     (1,1) Number of intervals
%
%% Outputs
%   s     (:,:) Stock price
%
%% Reference
% Steven,R. Dunbar, "Stochastic Processes and Advanced Mathematical
% Finance," University of Nebraska-Lincoln.

function s = StockPrice( s0, r, sigma, tEnd, n )

if( nargin < 1 )
  Demo
  return
end

delta   = tEnd/n;
sDelta  = sqrt(delta);
t       = linspace(0,tEnd,n+1);
m       = length(s0);
w       = [zeros(m,1) cumsum(sDelta.*randn(m,n))];
s       = zeros(1,n+1);
f       = r - 0.5*sigma.^2;
for k = 1:m
  s(k,:) = s0(k)*exp(f(k)*t + sigma(k)*w(k,:));
end

% Output
if( nargout < 1 )
  PlotSet(t,s,'x label','Year','y label','Stock Price','figure title','Stocks');
  
  % Format the ticks
  yT  = get(gca,'YTick');
  yTL = cell(1,length(yT));
  for k = 1:length(yT)
    yTL{k} = sprintf('%5.0f',yT(k));
  end
  set(gca,'YTickLabel', yTL)
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


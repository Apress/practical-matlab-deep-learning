	
%% Random stock stock market
% Generate a set of random stocks. The last two arguments are for plotting.
%
%--------------------------------------------------------------------------
%% Form:
%    d = StockMarket( m, s0Mean, s0Sigma, tEnd, n )
%
%% Inputs
%   m       (1,1) Number of stocks
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

function d = StockMarket(  m, s0Mean, s0Sigma, tEnd, n )

if( nargin < 1 )
  Demo
  return
end

d.s0    = abs(s0Mean + s0Sigma*randn(1,m));
d.r     = 0.5*rand(1,m);
d.sigma = rand(1,m);
s       = 'A':'Z';
for k = 1:m
  j            = randi(26,1,3);
  d.symb(k,:)  = s(j);
end


% Output
if( nargout < 1 )
  s = StockPrice( d.s0, d.r, d.sigma, tEnd, n );
  t	= linspace(0,tEnd,n+1);

	PlotSet(t,s,'x label','Year','y label','Stock Price','figure title',...
    'Stocks','Plot Set',{1:m},'legend',{d.symb});
  
  % Format the ticks
  yT  = get(gca,'YTick');
  yTL = cell(1,length(yT));
  for k = 1:length(yT)
    yTL{k} = sprintf('%5.0f',yT(k));
  end
  set(gca,'YTickLabel', yTL)

  clear d
end

%% StockPrice>Demo
function Demo

StockMarket( 100, 8000, 3000, 5.75, 1448 );


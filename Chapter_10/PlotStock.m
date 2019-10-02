%% PLOTSTOCK Plot stocks
% Plot stocks with symbols.
%
%% Form:
%     PlotStock(t,s,symb)
%
%% Inputs
%   t       (1,:) Time (years)
%   s       (:,:) Stock time histories
%   symb    {:}   Stock symbols

function PlotStock(t,s,symb)

if( nargin < 1 )
  Demo;
  return;
end

m = size(s,1);

PlotSet(t,s,'x label','Year','y label','Stock Price','figure title',...
    'Stocks','Plot Set',{1:m},'legend',{symb});
  
% Format the ticks
yT  = get(gca,'YTick');
yTL = cell(1,length(yT));
for k = 1:length(yT)
	yTL{k} = sprintf('%5.0f',yT(k));
end
set(gca,'YTickLabel', yTL)


%% PlotStock>Demo
function Demo

tEnd  = 5.75;      % years
nInt  = 1448;      % intervals
s0    = 8242.38;   % initial price
r     = 0.1682262; % drift
sigma = 0.1722922;
[s,t] = StockPrice( s0, r, sigma, tEnd, nInt );
PlotStock(t,s,{})

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

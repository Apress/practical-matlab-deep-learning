%% REALTIMEPLOTS Draw data in real time
% Type RealTimePlots for a demo.
%% Form:
%   g = RealTimePlots( action, y, t, g )
%
%% Inputs
%   action      (1,:)    Action 'initialize' 'delete' 'update' 'reset'
%   y           (:,1)    Vector to add to plot
%   t           (1,1)    Time (sec)
%   g           (:)      Data structure
%                        .tLabel
%                        .tLim   (1,2) [start stop]
%                        .yLabel {:}   Cell array with y labels
%                        .title  ''    Title  
%                        .hFig   (1,1) Figure handles
%
%% Outputs
%   g           (:)      Data structure

function g = RealTimePlots( action, y, t, g )

% Demo
if( nargin < 1 )
  Demo
  return
end

switch( lower(action) )
  case 'initialize'
    g = Initialize( g, y, t );        
          
	case 'update'
    g = Update( g, y, t );
           
	case 'reset'
    g = Reset( g );
        
	case 'close'
    Close( g );
end

%% RealTimePlots>Initialize
function g = Initialize( g, y, t )

lY = length(g.yLabel);
if( isempty( y ) )
  y = zeros( lY,1);
end
   
% Create tLim if it does not exist
if( ~isfield(g, 'tLim' ) )
	g.tLim = [0 1];
end
 
g.tWidth  = g.tLim(2) - g.tLim(1);
g.hFig    = NewFig(g.title);
set(g.hFig, 'NumberTitle','off' );

g.lP = length(y);

for k = 1:g.lP
	subplot(g.lP,1,k);
	g.hAxes(k)  = gca;
	set(g.hAxes(k),'nextplot','add','xlim',g.tLim);
  g.hPlot(k)  = plot(0,0);
	YLabelS( g.yLabel{k} )
	grid on
end
XLabelS( g.tLabel );

%% RealTimePlots>Update the plots
function g = Update( g, y, t )

% See if the time limits have been exceeded
if( t > g.tLim(2) )
	g.tLim(2)  = g.tWidth + g.tLim(2);
	updateAxes = true;
else
	updateAxes = false;
end
 
set( 0, 'currentfigure', g.hFig );
        
for k = 1:g.lP
	subplot(g.lP,1,k);
  
	% Update the axes if the limits are changed
  yD = get(g.hPlot(k),'ydata');
  xD = get(g.hPlot(k),'xdata');
	if( updateAxes )
    set( gca, 'xLim', g.tLim );
    set( g.hPlot(k), 'xdata',[xD t],'ydata',[yD y(k)]); 
  else
    set( g.hPlot(k), 'xdata',[xD t],'ydata',[yD y(k)] ); 
  end
end

drawnow

%% RealTimePlots>Close
function Close

CloseFigure( g.hFig );

%% RealTimePlots>Demo
function Demo

g.title  = 'Position' ;
g.yLabel = {'x' 'y' };
g.tLabel = 'Time (sec)';
g.tLim   = [0 100];
g        = RealTimePlots( 'initialize', [], [], g );

for k = 1:200
  y = 0.1*[cos((k/100))-0.05;sin(k/100)];
  g = RealTimePlots( 'update', y, k, g );
  pause(0.1)
end

g = RealTimePlots( 'initialize', [], [], g );

for k = 1:200
  y = 0.1*[cos((k/100))-0.05;sin(k/100)];
  g = RealTimePlots( 'update', y, k, g );
  pause(0.1)
end


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.



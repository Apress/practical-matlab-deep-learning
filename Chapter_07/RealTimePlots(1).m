%% REALTIMEPLOTS Draw data in real time
%
%% Form:
%   g = RealTimePlots( action, y, t, g )
%
%% Description
%
%   Type RealTimePlots for a demo.
%
%% Inputs
%   action      (1,:)    Action 'initialize' 'delete' 'update'
%   y           (:,1)    Vector to add to plot
%   t           (1,1)    Time (sec)
%   g           (:)      Data structure
%                        .tLabel
%                        .tLim   (1,2) [start stop]
%                        .yLim   (:,2) [min max] if equal RealTimePlot will use [-1 1]
%                        .yLabel {:}   Cell array with y labels
%                        .page   {}    Cell array with indices to plots on each page
%                        .title  {}    Title for each page    
%                        .hFig   (1,:) Figure handles
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
         
	case 'close'
    Close( g );
end

%% RealTimePlots>Initialize
function g = Initialize( g, y, t )

lY = length(g.yLabel);
if( isempty( y ) )
  y = zeros( lY,1);
end
if( isempty( t ) )
	t = 0;
end
g.yLast = y;
g.tLast = t;
   
% Create tLim if it does not exist
if( ~isfield(g, 'tLim' ) )
	g.tLim = [0 1];
end
 
g.tWidth = g.tLim(2) - g.tLim(1);
   
% Create yLim if it does not exist
if( ~isfield( g, 'yLim' ) )
	g.yLim = [-ones(lY,1), ones(lY,1)];
end

% Create the plots
for j = 1:length(g.page)
	g.hFig(j)  = NewFig(char(g.title(j)));
	set(g.hFig(j), 'NumberTitle','off' );
	lP = length(g.page{j});
	for k = 1:lP
    subplot(lP,1,k);
    g.hPlot(j,k) = plot(0,0); 
    g.hAxes(j,k) = gca;
    i = g.page{j}(k);
    if( g.yLim(i,1) ~= g.yLim(i,2) )
      yLim        = g.yLim(i,:);
    else
      yLim        = [-1 1];
      g.yLim(i,:) = yLim;
    end
    g.yWidth = (g.yLim(i,2) - g.yLim(i,1))/2;
    set(g.hAxes(j,k),'nextplot','add','xlim',g.tLim,'ylim',yLim);
    YLabelS( char(g.yLabel{i}) )
    grid on
  end
	XLabelS( g.tLabel );
end


%% RealTimePlots>Update the plots
function g = Update( g, y, t )

% See if the time limits have been exceeded
if( t > g.tLim(2) )
	g.tLim(2)  = g.tWidth + g.tLim(2);
	updateAxes = true;
else
	updateAxes = false;
end
 
for j = 1:length(g.page)
	set( 0, 'currentfigure', g.hFig(j) );
        
	lP = length(g.page{j});
	for k = 1:lP
    subplot(lP,1,k);
    i = g.page{j}(k);
       
    % See if the y limits have been exceeded
    if( y(i) > g.yLim(i,2) )
      g.yLim(i,2) = g.yLim(i,2) + g.yWidth(i);
      updateAxes  = true;
    elseif( y(i) < g.yLim(i,1) )
      g.yLim(i,1) = g.yLim(i,1) - g.yWidth(i);
      updateAxes  = true;
    end
   
    % Update the axes if the limits are changed
    if( updateAxes )
      set( gca, 'xLim', g.tLim      );
      set( gca, 'yLim', g.yLim(i,:) );
      plot( [g.tLast t], [g.yLast(i) y(i)] ); 
    else
      plot( [g.tLast t], [g.yLast(i) y(i)] ); 
    end
	end
end

g.yLast = y;
g.tLast = t;

%% RealTimePlots>Close
function Close

for k = 1:length(g.hFig)
	CloseFigure( g.hFig(k) );
end

%% RealTimePlots>Demo
function Demo

g.title  = {'Position' 'Velocity'};
g.yLabel = {'x' 'y' 'z' 'u' 'v' 'w'};
g.tLabel = 'Time (sec)';
g.page   = {[1 2 3] [4 5 6]};
g.tLim   = [0 100];
g        = RealTimePlots( 'initialize', [], [], g );

for k = 1:200
  y = cos((k/100)*ones(6,1));
  g = RealTimePlots( 'update', y, k, g );
  pause(0.1)
end


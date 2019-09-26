%% GUIPLOTS Draw data in real time
%
%% Form:
%   g = GUIPlots( action, y, t, g )
%
%% Description
%
%   Type GUIPlots for a demo.
%
%% Inputs
%   action      (1,:)    Action 'initialize' 'update'
%   y           (:,1)    Vector to add to plot
%   t           (1,1)    Time (sec)
%   g           (:)      Data structure
%                        .tLabel  (1,:) Time label
%                        .tLim    (1,2) [start stop]
%                        .yLim    (:,2) [min max] if equal RealTimePlot will use [-1 1]
%                        .yLabel  {:}   Cell array with y labels
%                        .hFig    (1,:) Figure handles
%                        .pos     (1,4) [x y w h] Position of the first plot
%                        .width   (1,q) Line width
%                        .color   (1,:) 'b' or [1 1 1] for line color
%
%% Outputs
%   g           (:)      Data structure

function g = GUIPlots( action, y, t, g )

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

end

%% GUIPlots>Initialize
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
lP = length(g.yLabel);
y  = g.pos(2);
for k = 1:lP
  g.h(k) = subplot(lP,1,k);
  set(g.h(k),'position',[g.pos(1) y g.pos(3) g.pos(4)]);
  y = y - 1.4*g.pos(4);
  g.hPlot(k) = plot(0,0);
  g.hAxes(k) = gca;
  if( g.yLim(k,1) ~= g.yLim(k,2) )
    yLim        = g.yLim(k,:);
  else
    yLim        = [-1 1];
    g.yLim(k,:) = yLim;
  end
  g.yWidth(k) = (g.yLim(k,2) - g.yLim(k,1))/2;
  set(g.hAxes(k),'nextplot','add','xlim',g.tLim,'ylim',yLim);
  ylabel( char(g.yLabel{k}) )
  grid on
end
xlabel( g.tLabel );


%% GUIPlots>Update the plots
function g = Update( g, y, t )

% See if the time limits have been exceeded
if( t > g.tLim(2) )
  g.tLim(2)  = g.tWidth + g.tLim(2);
  updateAxes = true;
else
  updateAxes = false;
end
        
lP = length(g.yLabel);
for k = 1:lP
  subplot(g.h(k));
  
  % See if the y limits have been exceeded
  if( y(k) > g.yLim(k,2) )
    g.yLim(k,2) = g.yLim(k,2) + g.yWidth(k);
    updateAxes  = true;
  elseif( y(k) < g.yLim(k,1) )
    g.yLim(k,1) = g.yLim(k,1) - g.yWidth(k);
    updateAxes  = true;
  end
  
  % Update the axes if the limits are changed
  if( updateAxes )
    set( gca, 'xLim', g.tLim      );
    set( gca, 'yLim', g.yLim(k,:) );
    plot( [g.tLast t], [g.yLast(k) y(k)],g.color,'linewidth',g.width); 
  else
    plot( [g.tLast t], [g.yLast(k) y(k)],g.color,'linewidth',g.width );
  end
end

g.yLast = y;
g.tLast = t;

%% GUIPlots>Demo
function Demo

g.yLabel = {'x' 'y' 'z' 'u' 'v' 'w'};
g.tLabel = 'Time (sec)';
g.tLim   = [0 100];
g.pos    = [0.100    0.88    0.8    0.10];
g.width  = 1;
g.color  = 'b';

g.hFig  = NewFig('State');
set(g.hFig, 'NumberTitle','off' );

g        = GUIPlots( 'initialize', [], [], g );

for k = 1:200
  y = cos((k/100)*ones(6,1));
  g = GUIPlots( 'update', y, k, g );
  pause(0.1)
end


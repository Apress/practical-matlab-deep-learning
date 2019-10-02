%% GUIPLOTS Draw data in real time
% Type GUIPlots for a demo.
%% Form:
%   g = GUIPlots( action, y, t, g )
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
    g = Initialize( g );
  
  case 'update'
    g = Update( g, y, t );
   
end

%% GUIPlots>Initialize
function g = Initialize( g )

lY = length(g.yLabel);
   
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
y  = g.pos(2); % The starting y position
for k = 1:lP
  g.h(k) = subplot(lP,1,k);
  set(g.h(k),'position',[g.pos(1) y g.pos(3) g.pos(4)]);
  y = y - 1.4*g.pos(4);
  g.hPlot(k) = plot(0,0);
  g.hAxes(k) = gca;
  g.yWidth(k) = (g.yLim(k,2) - g.yLim(k,1))/2;
  set(g.hAxes(k),'nextplot','add','xlim',g.tLim);
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
  yD = get(g.hPlot(k),'ydata');
  xD = get(g.hPlot(k),'xdata');
  if( updateAxes )
    set( gca, 'xLim', g.tLim );
    set( g.hPlot(k), 'xdata',[xD t],'ydata',[yD y(k)]); 
  else
    set( g.hPlot(k), 'xdata',[xD t],'ydata',[yD y(k)] ); 
  end

end

%% GUIPlots>Demo
function Demo

g.yLabel = {'x' 'y' 'z' 'x_1' 'y_1' 'z_1'};
g.tLabel = 'Time (sec)';
g.tLim   = [0 100];
g.pos    = [0.100    0.88    0.8    0.10];
g.width  = 1;
g.color  = 'b';

g.hFig  = NewFig('State');
set(g.hFig, 'NumberTitle','off' );

g        = GUIPlots( 'initialize', [], [], g );

for k = 1:200
  y = 0.1*[cos((k/100))-0.05;sin(k/100)];
  g = GUIPlots( 'update', [y;y.^2;2*y], k, g );
  pause(0.1)
end

g        = GUIPlots( 'initialize', [], [], g );

for k = 1:200
  y = 0.1*[cos((k/100))-0.05;sin(k/100)];
  g = GUIPlots( 'update', [y;y.^2;2*y], k, g );
  pause(0.1)
end


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


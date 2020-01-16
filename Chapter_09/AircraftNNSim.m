%% Simulate a Gulfstream 350 in a banked turn

n       = 500;
dT      = 0.1;
rTD     = 180/pi;
mToKm   =	0.001;
r       = 600;
nBits   = 16;

%% Load the neural net
nN    = load('TerrainNet');
rI    = load('Loc');

%% Start by finding the equilibrium controls
d     = RHSPointMassAircraft;
v     = 120;
d.phi = atan(v^2/(r*d.g));
x     = [v;0;0;-r;0;10000];
d     = EquilibriumControls( x, d );

%% Simulation
xPlot = zeros(length(x)+3,n);

% Put the image in a figure so that we can read it
h = NewFigure('Earth Segment');
i = flipud(imread('TerrainClose64.jpg'));
image(i);
axis image

NewFigure('Camera');

for k = 1:n

  % Get the image for the neural net
  im          = TerrainCamera( x(4:5), h, nBits );
  subplot(1,2,1)
  image(im.p)
  axis image
  
  % Run the neural net
  l           = classify(nN.terrainNet,im.p);
  subplot(1,2,2)
  q = imread(sprintf('TerrainImages/TerrainImage%d.jpg',rI.iMI(l)));
  image(q);
  axis image
  
  % Plot storage
  i           = int32(l);
  xPlot(:,k)  = [x;rI.r(:,i);i];
  
  % Integrate
  x           = RungeKutta( @RHSPointMassAircraft, 0, x, dT, d );
  
  % A crash
  if( x(6) <= 0 )
    break;
  end
end

%% Plot the results
xPlot         = xPlot(:,1:k);
xPlot(2,:)    = xPlot(2,:)*rTD;
xPlot(4:6,:)  = xPlot(4:6,:);
yL            = {'v (m/s)' '\gamma (deg)' '\psi (deg)' 'x (m)'  'y (m)'...
                 'h (m)' 'x_c (m)', 'y_c (m)' };
[t,tL]        = TimeLabel(dT*(0:(k-1)));

PlotSet( t, xPlot(1:6,:), 'x label', tL, 'y label', yL(1:6),...
  'figure title', 'Aircraft State' );

k = [4 5 7 8];
PlotSet( t, xPlot(k,:), 'x label', tL, 'y label', yL(k),...
  'figure title', 'Aircraft Position' );

PlotSet( t, xPlot(9,:), 'x label', tL, 'y label', 'Image',...
  'figure title', 'Image Identified' );

i = imread('TerrainClose64.jpg');
PlotXYTrajectory( [xPlot(4,:);xPlot(7,:)], [xPlot(5,:);xPlot(8,:)],...
  i, 2000, 'Trajectory' );

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

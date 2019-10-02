%% PLOTXYTRAJECTORY Draw an xy trajectory over an image
% Can plot multiple sets of data. Type PlotXYTrajectory for a demo.
%% Input
% x       (:,:) X coordinates (m)
% y       (:,:) Y coordinates (m)
% i       (n,m) Image
% w       (1,1) x dimension of the image
% xScale  (1,1) Scale of x dimension
% name    (1,:) Figure name

function PlotXYTrajectory( x, y, i, xScale, name )

if( nargin < 1 )
  Demo
  return
end

s   = size(i);
xI  = [-xScale xScale];
yI  = [-xScale xScale]*s(2)/s(1);

NewFigure(name);
image(xI,yI,flipud(i));
hold on
n = size(x,1);
for k = 1:n
  plot(x(k,:),y(k,:),'linewidth',2)
end
set(gca,'xlim',xI,'ylim',yI);
grid on
axis image
xlabel('x (m)')
ylabel('y (m)')


%% PlotXYTrajectory>Demo
function Demo

i = imread('TerrainClose.jpg');
a = linspace(0,2*pi);
x = [30*cos(a);35*cos(a)];
y = [30*sin(a);35*sin(a)];
PlotXYTrajectory( x, y, i, 111, 'Trajectory' )


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
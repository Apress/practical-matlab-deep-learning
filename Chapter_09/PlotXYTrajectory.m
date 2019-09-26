%% Draw an xy trajectory overy an image
%
% Type PlotXYTrajectory for a demo.

%% Input
% x       (1,:) X coordinate
% y       (1,:) X coordinate
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

NewFigure(name)
image(xI,yI,flipud(i));
hold on
plot(x,y,'linewidth',2)
set(gca,'xlim',xI,'ylim',yI);
grid on
axis image
xlabel('x (km)')
ylabel('y (km)')

%% PlotXYTrajectory>Demo
function Demo

i = imread('TerrainClose.jpg');
a = linspace(0,2*pi);
x = 30*cos(a);
y = 30*sin(a);
PlotXYTrajectory( x, y, i, 111, 'Trajectory' )


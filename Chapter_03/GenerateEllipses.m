%% Generate random ellipses
%% Form
%  [d, v] = GenerateEllipses(a,b,phi,t,n,nC,nP)
%
%% Description
% Generates random e
%
%% Inputs
%  a    (1,2) Range of x sizes of ellipse
%  b    (1,2) Range of b sizes of ellipse
%  phi	(1,1) Max rotation angle of ellipse
%  t  	(1,1) Max line thickness
%  n  	(1,1) Number of ellipses
%  nC  	(1,1) Number of circles
%  nP   (1,1) Image is nP by nP
%
%% Outputs
%  d      {:}   Ellipses 
%  v      (1,:) 1 or 0

function [d, v] = GenerateEllipses(a,b,phi,t,n,nC,nP)

if( nargin < 1 )
  Demo;
  return
end

d     = cell(n+nC,2);
r     = 0.5*(mean(a) + mean(b))*rand(1,nC);
a     = (a(2)-a(1))*rand(1,n) + a(1);
b     = (b(2)-b(1))*rand(1,n) + b(1);
phi   = phi*rand(1,n);
cP    = cos(phi);
sP    = sin(phi);
theta = linspace(0,2*pi);
c     = cos(theta);
s     = sin(theta);
m     = length(c);
t     = 1+(t-1)*rand(1,n+nC);

% Generate circles
for k = 1:nC
  d{k,1} = r(k)*[c;s];
end

% Generate ellipses
for k = 1:n
  d{k+nC,1} = [cP(k) sP(k);-sP(k) cP(k)]*[a(k)*c;b(k)*s];
end

% True if the object is a circle
v       = zeros(1,nC+n);
v(1:nC) = 1;

% 3D Plot
NewFigure('Ellipses');
z  = -1;
dZ = 2*abs(z)/(n+nC);
o  = ones(1,m);
for k = 1:length(d)
  z   = z + dZ;
  zA  = z*o;
  plot3(d{k}(1,:),d{k}(2,:),zA,'linewidth',t(k));
  hold on
end
grid on
rotate3d on

% Create images
for k = 1:length(d)
  f = figure('Name','Image','visible','off','color',[1 1 1]);
  axes( 'Parent', f, 'box', 'off','color',[1 1 1] );
  plot(d{k}(1,:),d{k}(2,:),'linewidth',t(k),'color','k');
  axis off
  frame   = getframe(f);
  d{k,2}  = rgb2gray(imresize(frame2im(frame),[nP nP]));
  close(f)
end

% Draw the images
h = figure('name','Ellipse Images');
set(gca,'color',[1 1 1]);
for k = 1:length(d)
	imagesc(d{k,2});
	colormap(h,'gray');
	grid on
	set(gca,'xtick',1:nP)
	set(gca,'ytick',1:nP)
	colorbar
	pause(0.2)
end


%% GenerateEllipses>Demo
function Demo

GenerateEllipses([0.5 1],[1 2],pi/4,0.5,10,5,32);
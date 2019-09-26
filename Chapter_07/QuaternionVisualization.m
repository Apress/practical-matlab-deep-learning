%% QUATERNIONVISUALIZATION Draw a quaternion using an obj file
%
%% Form:
%       QuaternionVisualization( 'initialize', d )
%   m = QuaternionVisualization( 'update', x )
%% Description
%
%   Type QuaternionVisualization for a demo.
%
%% Inputs
%   x       (4,1) q
%   or
%   file    (1,:) OBJ file name
%
%% Outputs
%   m       (1,:) If there is an output it makes a movie
%

function m = QuaternionVisualization( action, x, f )

persistent p

% Demo
if( nargin < 1 )
  Demo
  return
end

switch( lower(action) )
    case 'defaults'
        m = Defaults;
        
    case 'initialize'
        if( nargin < 2 )
            d	= Defaults;
        else
            d	= x;
        end
        
        if( nargin < 3 )
          f = [];
        end
 
        p = Initialize( d, f );
        
    case 'update'
        if( nargout == 1 )
            m = Update( p, x );
        else
            Update( p, x );
        end
end

%% QuaternionVisualization>Initialize
function p = Initialize( file, f )

if( isempty(f) )
  p.fig	= NewFigure( 'Quaternion' );
else
  p.fig = f;
end

g     = LoadOBJ( file );
p.g   = g;

shading interp
lighting gouraud

c = [0.3 0.3 0.3];

for k = 1:length(g.component)
  p.model(k)	= patch('vertices', g.component(k).v, 'faces', g.component(k).f, 'facecolor',c,'edgecolor',c,'ambient',1,'edgealpha',0 );
end

xlabel('x');
ylabel('y');
zlabel('z');

grid
rotate3d on
set(gca,'DataAspectRatio',[1 1 1],'DataAspectRatioMode','manual')

light('position',10*[1 1 1])

view([1 1 1])

%% QuaternionVisualization>Update the picture
function m = Update( p, q )

s = QuaternionToMatrix( q );

for k = 1:length(p.model)
  v = (s*p.g.component(k).v')';
  set(p.model(k),'vertices',v);
end    

if( nargout > 0 )
	m = getframe;
else
	drawnow;
end

%% QuaternionVisualization>Defaults
function d = Defaults

d = 'Ballerina.obj';

%% QuaternionVisualization>Demo
function Demo
    
QuaternionVisualization( 'initialize', 'Ballerina.obj' );
a       = linspace(0,8*pi);

for k = 1:length(a)
  q       = [cos(a(k));0;0;sin(a(k))];
  QuaternionVisualization( 'update', q );
end

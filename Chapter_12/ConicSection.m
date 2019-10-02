%% Create a conic section

theta = pi/4;
h     = 4;
r0    = h*sin(theta);

ang   = linspace(0,2*pi);
a     = 2;
b     = 1;
cA    = cos(ang);
sA    = sin(ang);
n     = length(cA);
c     = 0.5*h*sin(theta)*[cA;sA;ones(1,n)];
e     = [a*cA;b*sA;zeros(1,n)];

% Show a planar representation
NewFigure('Orbits');
plot(c(1,:),c(2,:),'b')
hold on
plot(e(1,:),e(2,:),'g')
grid
xlabel('x')
ylabel('y')
axis image
legend('Circle','Ellipse');

[z,phi,x]   = ConicSectionEllipse(a,b,theta);
ang         = pi/2 + phi;
e           = [cos(ang) 0 sin(ang);0 1 0; -sin(ang) 0 cos(ang)]*e;
e(1,:)      = e(1,:) + x;
e(3,:)      = e(3,:) + h - z;

Cone(r0,h,40);
hold on
plot3(c(1,:),c(2,:),2*ones(1,n),'r','linewidth',2);
plot3(e(1,:),e(2,:),e(3,:),'b','linewidth',2);
line([x x],[-b b],[h-z h-z],'color','g','linewidth',2);
view([0 1 0])


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
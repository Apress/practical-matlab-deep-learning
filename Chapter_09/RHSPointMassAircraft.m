	
%% RHSPointMassAircraft Right hand side for a point mass airrcraft
%% Form
%   [xDot,lift,drag] = RHSPointMassAircraft( ~, x, d )
%%
%% Inputs
%   t     (1,1) Time (unused)
%   x     (6,1) State [v;gamma;psi;xE;yN;h]
%   d     (.)   Data structure
%
%% Outputs
%   xDot  (6,1) State derivative [v;gamma;psi;xE;yN;h]
%   lift  (1,1) Lift (N)
%   drag  (1,1) Drag (N)
%

function [xDot,lift,drag] = RHSPointMassAircraft( ~, x, d )

if( nargin < 1 )
  xDot = DefaultDataStructure;
  return
end

v         = x(1);
gamma     = x(2);
psi       = x(3);
h         = x(6);
cA        = cos(d.alpha);
sA        = sin(d.alpha);
cG        = cos(gamma);
sG        = sin(gamma);
cPsi      = cos(psi);
sPsi      = sin(psi);
cPhi      = cos(d.phi);
sPhi      = sin(d.phi);

mG        = d.m*d.g;
qS        = 0.5*d.s*Density( 0.001*h )*v^2;
cL        = d.cLAlpha*d.alpha;
cD        = d.cD0 + cL^2/(pi*d.aR*d.eps);
lift      = qS*cL;
drag      = qS*cD;
vDot      = (d.thrust*cA - drag - mG*sG)/d.m + d.f(1);
fN        = lift + d.thrust*sA;
gammaDot  = (fN*cPhi - mG*cG + d.f(2))/(d.m*v);
psiDot    = (fN*sPhi - d.f(3))/(d.m*v*cG);
xDot      = [vDot;gammaDot;psiDot;v*cG*sPsi;v*cG*cPsi;v*sG];

%% RHSPointMassAircraft>DefaultDataStructure
function d = DefaultDataStructure

d = struct('cD0',0.01,'aR',2.67,'eps',0.95,'cLAlpha',2*pi,'s',64.52,...
           'g',9.806,'alpha',0,'phi',0,'thrust',0,'m',19368.00,...
           'f',zeros(3,1),'W',zeros(3,1));
         
%% RHSPointMassAircraft>Density
function rho = Density( h )
    
rho = 1.225*exp(-0.0817*h^1.15);
  

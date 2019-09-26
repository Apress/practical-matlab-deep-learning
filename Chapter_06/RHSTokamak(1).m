function [xDot,z] = RHSTokamak( x, ~, d )

%% Simulates a model of the vertical position of a plasma in a Tokamak.
%
%% Form:
% [xDot,z] = RHSTokamak( x, t, d )
%
%% Inputs
%   x   (2,1) State [iA;iV;v] 
%   t  	(1,1) Time (s)
%   d  	(1,1) Structure
%             .aS  	(1,1) State matrix
%             .bS   (1,1) Input matrix
%             .cS   (1,1) Output matrix
%             .dS   (1,1) Feed through matrix
%             .tauT	(1,1) Input time constant (s)
%             .vC  	(1,1) Control voltage
%           	.eLM	(1,1) Edge limited mode disturbance
%             .iP   (1,1) Plasma current (A)
%
%% Outputs
%   xDot	(3,1) State derivative d[iA;iV;v]/dt
%
%% Reference:  
% Scibile, L. "Non-linear control of the plasma vertical
% position in a tokamak," Ph.D Thesis, University of Oxford, 1997.

if( nargin < 3 )
  if( nargin == 1 )
    xDot = UpdateDataStructure(x);
  else
    xDot = DefaultDataStructure;
  end

  return;
end

v    = x(3);
vDot = (d.vC - v)/d.tauT;
u    = [v;d.eLM];
xDot = [d.aS*x(1:2) + d.bS*u;vDot];
z    = (d.cS*x(1:2) + d.dS*u)/d.iP;

function d = DefaultDataStructure

d = struct( 'lAA', 42.5e-3, 'lAV', 0.432e-3, 'lVV', 0.012e-3,...
            'rAA', 35.0e-3, 'rVV',2.56e-3,'lAP',115.2e-6,'lVP',3.2e-6,...
            'aPP',0.449e-6,'tauT',310e-6,'iP',1.5e6,'aS',[],'bS',[],'cS',[],'dS',[],...
            'eLM',0,'vC',0);
          
d = UpdateDataStructure( d );
              
function d = UpdateDataStructure( d )

kAV   = d.lAV^2/(d.lAA*d.lVV);
oMKAV = 1 - kAV;
kA    = 1/(d.lAA*oMKAV);
mVP   = d.aPP*d.lVV/d.lVP^2;
mAP   = d.aPP*d.lAA/d.lAP^2;
oMMVP = 1 - mVP;

if( mVP >= 1 )
  fprintf('mVP = %f should be less than 1 for an elongated plasma in a resistive vacuum vessel. aPP is probably too large\n',mVP);
end

if( kAV >= 1 )
  fprintf('kAV = %f should be less than 1 for an elongated plasma in a resistive vacuum vessel\n',kAV);
end

d.aS    =  (1/oMKAV)*[ -d.rAA/d.lAA d.rVV*kAV/d.lAV;...
                    d.rAA*kAV/d.lAV -(d.rVV/d.lVV)*(kAV - mVP)/oMMVP];
d.bS    =  [ kA 0 0; -kAV/(d.lAV*oMKAV) 1/(d.lVP*oMMVP) 0];
d.cS    = -[d.lAP d.lVP]/d.aPP;
d.dS    =  [0 0 1]/d.aPP;

tV      = d.lVV*oMKAV/d.rVV;
a0      = (mVP-kAV)/oMMVP/tV;
a1      = d.rAA/d.lAA/oMKAV;
alpha   = a0 + kAV/tV;

disp('For gamma_p = 115, gamma_n = 2.67 k1 = 2.6, k2 = 2.23 b1 = -114.46, b0 = -570.01');
roots([1 -(a0-a1) -alpha*a1])
eig(d.aS)
k1 = d.lVP*d.lAV*kA*alpha/(d.lVV*d.aPP)/d.iP
k2 = (mVP-2)/(mVP-1)/d.aPP/d.iP
b1 = ((mVP-2)*(a1-a0) - alpha)/(mVP-2)
b0 = a1*alpha*(1-mVP)/(mVP-2)
aPP= d.aPP


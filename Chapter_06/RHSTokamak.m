%% RHSTOKAMAK Simulates a model of the vertical position of a plasma in a Tokamak.
%% Form:
% [xDot,z] = RHSTokamak( x, t, d )
%
%% Inputs
%   x   (3,1) State [iA;iV;v] [active coils;passive coils;delay state]
%   t  	(1,1) Time (s)
%   d  	(1,1) Structure
%             .aS  	(2,2) State matrix
%             .bS   (2,3) Input matrix
%             .cS   (1,2) Output matrix
%             .dS   (1,2) Feed through matrix
%             .tauT	(1,1) Input time constant (s)
%             .vC  	(1,1) Control voltage
%           	.eLM	(1,1) Edge localized mode disturbance
%             .iP   (1,1) Plasma current (A)
%
%% Outputs
%   xDot	(3,1) State derivative d[iA;iV;v]/dt
%   z     (1,1) Plasma position (m)
%
%% Reference:  
% Scibile, L. "Non-linear control of the plasma vertical
% position in a tokamak," Ph.D Thesis, University of Oxford, 1997.

function [xDot,z] = RHSTokamak( x, ~, d )

if( nargin < 3 )
  if( nargin == 1 )
    xDot = UpdateDataStructure(x);
  else
    xDot = DefaultDataStructure;
  end

  return;
end

u    = [d.vC;d.eLM];
vDot = (x(3) - d.vC)/d.tauT;
xDot = [d.aS*x(1:2) + d.bS*u;vDot];
z    = d.cS*x(1:2) + d.dS*u;

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
oMMVP = 1 - mVP;

if( mVP >= 1 )
  fprintf('mVP = %f should be less than 1 for an elongated plasma in a resistive vacuum vessel. aPP is probably too large\n',mVP);
end

if( kAV >= 1 )
  fprintf('kAV = %f should be less than 1 for an elongated plasma in a resistive vacuum vessel\n',kAV);
end

d.aS    =  (1/oMKAV)*[ -d.rAA/d.lAA d.rVV*kAV/d.lAV;...
                        d.rAA*kAV/d.lAV -(d.rVV/d.lVV)*(kAV - mVP)/oMMVP];
d.bS    =  [kA 0 0;kAV/(d.lAV*(1-kAV)) 1/(d.lVP*oMMVP) 0];
d.cS    = -[d.lAP d.lVP]/d.aPP/d.iP;
d.dS    =  [0 0 1]/d.aPP/d.iP;
eAS     = eig(d.aS);

disp('Eigenvalues')
fprintf('\n Mode 1 %12.2f\n Mode 2 %12.2f\n',eAS);


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.




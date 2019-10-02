%% M2E Generate the eccentric anomaly
% Eccentric anomaly from the mean anomaly and the eccentricity. Only works for
% ellipses.
%% Form:
%   eccAnom  = M2E( e, meanAnom, tol, nMax )
%
%% Inputs
%   e            (: or 1) Eccentricity
%   meanAnom     (:)      Mean anomaly
%   tol          (1,1)    Tolerance
%   nMax         (1,1)    Maximum number of iterations
%
%% Outputs
%   eccAnom     (:)       Eccentric anomaly

function eccAnom  = M2E( e, meanAnom, tol, nMax )

% Demo
if( nargin == 0 )
	disp('Eccentric anomaly for e = 0.8');
    M2E( 0.8 );
      return;
end

if( nargin < 2 )
  if( length(e) == 1 )
    meanAnom = linspace(0,2*pi);
  else
    error('PSS:M2E:error','If e is not a scalar you must enter mean anomaly')
  end
end

eL = length(e);
mL = length(meanAnom);
if( mL ~= eL && eL == 1 )
  e = DupVect(e,mL)';
end

eccAnom = zeros(size(meanAnom));

k = find(e >= 1); %#ok<EFIND>

if( ~isempty(k) )
  error('Cannot handle eccentricities >= 1');
end

if( nargin < 3 )
	eccAnom = M2EEl(e,meanAnom);
elseif( nargin == 3 )
	eccAnom = M2EEl(e,meanAnom,tol);
elseif( nargin == 4 )
	eccAnom = M2EEl(e,meanAnom,tol,nMax);
end

if( nargout == 0 && length(meanAnom) > 1 )
  PlotSet(meanAnom,eccAnom,'x label','Mean Anomaly (rad)',...
    'y label','Eccentric Anomaly (rad)','figure title','M to E');
  clear eccAnom;
end

%% M2E>M2EEL
function eccAnom = M2EEl( ecc, meanAnom, tol, nMax )

if( nargin < 2 )
  meanAnom = linspace(0,2*pi);
end

if( nargin < 3 )
  tol = 1.e-8;
end

% First guess
eccAnom  = M2EApp(ecc,meanAnom);
	
% Iterate
delta = tol + 1; 
n     = 0;
tau   = tol;

while ( max(abs(delta)) > tau )
  dE    	  = (meanAnom - eccAnom + ecc.*sin(eccAnom))./ ...
                   (1 - ecc.*cos(eccAnom));
  eccAnom    = eccAnom + dE;
  n           = n + 1;
  delta       = norm(abs(dE),'inf');
  tau         = tol*max(norm(eccAnom,'inf'),1.0);
  if ( nargin == 4 )
    if ( n == nMax )
      break
    end
  end
end


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.
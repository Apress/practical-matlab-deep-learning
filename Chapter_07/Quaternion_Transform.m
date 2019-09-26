	
%% Transforms a vector in the direction of the quaternion. 
%
% If the number of columns of q is 1 it will transform all of the vectors
% by that q. If it is greater than 1 it will transform each column of ua
% by the corresponding column of q. If the number of columns of q is > 1
% and the number of columns of ua is 1 it will create one column of ub
% for every column of q. This routine takes 30 floating point operations.
%--------------------------------------------------------------------------
%   Form:
%   ub = Quaternion_Transform(( q, ua )
%--------------------------------------------------------------------------
%
%% Inputs
%   q              (4,n or 1)  Quaternion from a to b
%   ua             (3,n or 1)  Vector in a
%
%% Outputs
%   ub             (3,n)       Vector in b
%
%--------------------------------------------------------------------------

function ub = Quaternion_Transform( q, ua )

% Get sizes
%----------
cQ = size(q,2);
cU = size(ua,2);

if( cQ == 1 )
  ub      = zeros(size(ua));
  x(1,:)  = q(3)*ua(3,:) - q(4)*ua(2,:);
  x(2,:)  = q(4)*ua(1,:) - q(2)*ua(3,:);
  x(3,:)  = q(2)*ua(2,:) - q(3)*ua(1,:);

  ub(1,:) = ua(1,:) + 2*( q(1)*x(1,:) + q(3)*x(3,:) - q(4)*x(2,:) );
  ub(2,:) = ua(2,:) + 2*( q(1)*x(2,:) + q(4)*x(1,:) - q(2)*x(3,:) );
  ub(3,:) = ua(3,:) + 2*( q(1)*x(3,:) + q(2)*x(2,:) - q(3)*x(1,:) );
  
elseif( cU == cQ )
  ub      = zeros(size(ua));
  x(1,:)  = q(3,:).*ua(3,:) - q(4,:).*ua(2,:);
  x(2,:)  = q(4,:).*ua(1,:) - q(2,:).*ua(3,:);
  x(3,:)  = q(2,:).*ua(2,:) - q(3,:).*ua(1,:);

  ub(1,:) = ua(1,:) + 2*( q(1,:).*x(1,:) + q(3,:).*x(3,:) - q(4,:).*x(2,:) );
  ub(2,:) = ua(2,:) + 2*( q(1,:).*x(2,:) + q(4,:).*x(1,:) - q(2,:).*x(3,:) );
  ub(3,:) = ua(3,:) + 2*( q(1,:).*x(3,:) + q(2,:).*x(2,:) - q(3,:).*x(1,:) );
  
elseif( cU == 1 )
  ub      = zeros(3,cQ);
  x(1,:)  = q(3,:)*ua(3) - q(4,:)*ua(2); 
  x(2,:)  = q(4,:)*ua(1) - q(2,:)*ua(3); 
  x(3,:)  = q(2,:)*ua(2) - q(3,:)*ua(1);

  ub(1,:) = ua(1) + 2*( q(1,:).*x(1,:) + q(3,:).*x(3,:) - q(4,:).*x(2,:) );
  ub(2,:) = ua(2) + 2*( q(1,:).*x(2,:) + q(4,:).*x(1,:) - q(2,:).*x(3,:) );
  ub(3,:) = ua(3) + 2*( q(1,:).*x(3,:) + q(2,:).*x(2,:) - q(3,:).*x(1,:) );
  
else
  error('q and ua cannot have different numbers of columns unless one has only one column')
end


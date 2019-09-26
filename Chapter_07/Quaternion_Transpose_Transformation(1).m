function ub = Quaternion_Transpose_Transformation( q, ua )
	
%--------------------------------------------------------------------------
%   Transforms a vector opposite the direction of the quaternion.
%   If the number of columns of q is 1 it will transform all of the vectors
%   by that q. If it is greater than 1 it will transform each column of ua
%   by the corresponding column of q. If the number of columns of q is > 1
%   and the number of columns of ua is 1 it will create one column of ub
%   for every column of q.
%
%--------------------------------------------------------------------------
%   Form:
%   ub = Quaternion_Transpose_Transformation( q, ua )
%--------------------------------------------------------------------------
%
%   ------
%   Inputs
%   ------
%   q              (4,n or 1)  quaternion from a to b
%   ua             (3,n or 1)  vector in frame b
%
%   -------
%   Outputs
%   -------
%   ub             (3,n)       vector in frame a
%
%   See also QForm.
%
%--------------------------------------------------------------------------


cQ = size(q,2);
cU = size(ua,2);

if( cQ == 1 )
  ub      = zeros(size(ua));
  x(1,:)  = q(4)*ua(2,:) - q(3)*ua(3,:);
  x(2,:)  = q(2)*ua(3,:) - q(4)*ua(1,:);
  x(3,:)  = q(3)*ua(1,:) - q(2)*ua(2,:);

  ub(1,:) = ua(1,:) + 2*( q(1)*x(1,:) - q(3)*x(3,:) + q(4)*x(2,:) );
  ub(2,:) = ua(2,:) + 2*( q(1)*x(2,:) - q(4)*x(1,:) + q(2)*x(3,:) );
  ub(3,:) = ua(3,:) + 2*( q(1)*x(3,:) - q(2)*x(2,:) + q(3)*x(1,:) );
  
elseif( cU == cQ )
  ub      = zeros(size(ua));
  x(1,:)  = q(4,:).*ua(2,:) - q(3,:).*ua(3,:);
  x(2,:)  = q(2,:).*ua(3,:) - q(4,:).*ua(1,:);
  x(3,:)  = q(3,:).*ua(1,:) - q(2,:).*ua(2,:);

  ub(1,:) = ua(1,:) + 2*( q(1,:).*x(1,:) - q(3,:).*x(3,:) + q(4,:).*x(2,:) );
  ub(2,:) = ua(2,:) + 2*( q(1,:).*x(2,:) - q(4,:).*x(1,:) + q(2,:).*x(3,:) );
  ub(3,:) = ua(3,:) + 2*( q(1,:).*x(3,:) - q(2,:).*x(2,:) + q(3,:).*x(1,:) );
  
elseif( cU == 1 )
  ub      = zeros(3,cQ);
  x(1,:)  = q(4,:).*ua(2) - q(3,:).*ua(3);
  x(2,:)  = q(2,:).*ua(3) - q(4,:).*ua(1);
  x(3,:)  = q(3,:).*ua(1) - q(2,:).*ua(2);

  ub(1,:) = ua(1,:) + 2*( q(1,:).*x(1,:) - q(3,:).*x(3,:) + q(4,:).*x(2,:) );
  ub(2,:) = ua(2,:) + 2*( q(1,:).*x(2,:) - q(4,:).*x(1,:) + q(2,:).*x(3,:) );
  ub(3,:) = ua(3,:) + 2*( q(1,:).*x(3,:) - q(2,:).*x(2,:) + q(3,:).*x(1,:) );
  
else
  error('q and ua cannot have different numbers of columns unless one has only one column')
end

%--------------------------------------
% $Date: 2019-04-05 14:04:51 -0400 (Fri, 05 Apr 2019) $
% $Revision: 48417 $

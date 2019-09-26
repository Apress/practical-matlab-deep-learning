	
%% Converts a quaternion to a transformation matrix.
% It does not check to see that m is orthonormal.
%--------------------------------------------------------------------------
%% Form:
%   m = QuaternionToMatrix( q )	
%--------------------------------------------------------------------------
%
%% Inputs
%   q		(4,1)  Equivalent quaternion
%
%% Outputs
%   m		(3,3)  Orthonormal transformation matrix
%
%--------------------------------------------------------------------------
%% References:
% Shepperd, S. W., Quaternion from Rotation Matrix,
% J. Guidance, Vol. 1, No. 3, May-June, 1978, pp. 223-224.
%--------------------------------------------------------------------------
function m = QuaternionToMatrix( q )	

m = [ q(1)^2+q(2)^2-q(3)^2-q(4)^2,...
      2*(q(2)*q(3)-q(1)*q(4)),...
      2*(q(2)*q(4)+q(1)*q(3));...
      2*(q(2)*q(3)+q(1)*q(4)),...
      q(1)^2-q(2)^2+q(3)^2-q(4)^2,...
      2*(q(3)*q(4)-q(1)*q(2));...
      2*(q(2)*q(4)-q(1)*q(3)),...
      2*(q(3)*q(4)+q(1)*q(2)),...
      q(1)^2-q(2)^2-q(3)^2+q(4)^2];

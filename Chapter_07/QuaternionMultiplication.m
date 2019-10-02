%% QUATERNIONMULTIPLICATION Multiply two quaternions.
% q2 transforms from A to B and q1 transforms from B to C
% so q3 transforms from A to C. It will handle multiple q1's and q2's.
%
%% Form:
%   q3 = QuaternionMultiplication( q2 ,q1 )	
%
%% Inputs
%   q2              (4,:)  Quaternion from a to b
%   q1              (4,:)  Quaternion from b to c
%
%% Outputs
%   q3              (4,:)  Quaternion from a to c
%

function q3 = QuaternionMultiplication( q2 ,q1 )

q3 = [  q1(1,:).*q2(1,:) - q1(2,:).*q2(2,:) - q1(3,:).*q2(3,:) - q1(4,:).*q2(4,:);...
        q1(2,:).*q2(1,:) + q1(1,:).*q2(2,:) - q1(4,:).*q2(3,:) + q1(3,:).*q2(4,:);...
        q1(3,:).*q2(1,:) + q1(4,:).*q2(2,:) + q1(1,:).*q2(3,:) - q1(2,:).*q2(4,:);...
        q1(4,:).*q2(1,:) - q1(3,:).*q2(2,:) + q1(2,:).*q2(3,:) + q1(1,:).*q2(4,:)];
      
if( q3(1) < 0 )
  q3 = -q3;
end
  
%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

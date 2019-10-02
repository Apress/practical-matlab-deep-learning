%% Script to read binary from the IMU

% Find available Bluetooth devices
btInfo = instrhwinfo('Bluetooth')
 
 % Display the information about the first device discovered
btInfo.RemoteNames(1)
btInfo.RemoteIDs(1)
 
% Construct a Bluetooth Channel object to the first Bluetooth device
b = Bluetooth(btInfo.RemoteIDs{1}, 1);

% Connect the Bluetooth Channel object to the specified remote device
fopen(b);

% Get a data structure
tic
t = 0;
for k = 1:100
  a   = fread(b,91);
  d   = DataFromIMU( a );
  fprintf('%12.2f [%8.1e %8.1e %8.1e] [%8.1e %8.1e %8.1e] [%8.1f %8.1f %8.1f %8.1f]\n',t,d.gyro,d.accel,d.quat);
  t = t + toc;
  tic
end

% Disconnect the object from the Bluetooth device
fclose(b);


%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


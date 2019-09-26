%% Read binary from the IMU

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
for k = 1:3
  a = fread(b,91);
  d = DataFromIMU( a );
  [k d.gyro'  d.accel' d.quat']
end

% Disconnect the object from the Bluetooth device
fclose(b);
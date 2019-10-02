%% DATAFROMIMU Extract data from the IMU binary
%% Form
%  d = DataFromIMU( a )
%
%% Description
% Extracts data from the IMU stream.
%
%% Inputs
%  a    (91,1) Bytes
%
%% Outputs
%  d      (.) Data structure 
%             .packetStart  (1,1) Hex
%             .openMATIDLSB (1,1) Hex
%             .openMATIDMSB (1,1) Hex
%             .cmdNoLSB     (1,1) Hex
%             .cmdNoMSB     (1,1) Hex
%             .dataLenLSB   (1,1) Hex
%             .dataLenMSB   (1,1) Hex
%             .timeStamp    (1,1) Time
%             .gyro         (3,1) Gyro rates
%             .accel        (3,1) Acceleration 
%             .quat         (4,1) Quaternion

function d = DataFromIMU( a )

d.packetStart   = dec2hex(a(1));
d.openMATIDLSB  = dec2hex(a(2));
d.openMATIDMSB  = dec2hex(a(3));
d.cmdNoLSB      = dec2hex(a(4));
d.cmdNoMSB      = dec2hex(a(5));
d.dataLenLSB    = dec2hex(a(6));
d.dataLenMSB    = dec2hex(a(7));
d.timeStamp     = BytesToFloat( a(8:11) );
d.gyro          = [ BytesToFloat( a(12:15) );...
                    BytesToFloat( a(16:19) );...
                    BytesToFloat( a(20:23) )];
d.accel         = [ BytesToFloat( a(24:27) );...
                    BytesToFloat( a(28:31) );...
                    BytesToFloat( a(32:35) )];
d.quat          = [ BytesToFloat( a(48:51) );...
                    BytesToFloat( a(52:55) );...
                    BytesToFloat( a(56:59) );...
                    BytesToFloat( a(60:63) )];
d.msgEnd1       = dec2hex(a(66));
d.msgEnd2       = dec2hex(a(67));
    
                 
%% DataFromIMU>BytesToFloat
function r = BytesToFloat( x )
  
r = typecast(uint8(x),'single');

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.


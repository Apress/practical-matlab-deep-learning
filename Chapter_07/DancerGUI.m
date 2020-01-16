%% DANCERGUI Interactive tool for dancer data acquisition.
% The input file must be of type .obj. 
%
% Type DancerGUI for a demo.
%
%% Form:
%   DancerGUI( file )
%
%% Inputs
%   file  (1,:) File name - needs to be a complete path name
%
%% Outputs
%   Saves to a MAT file
%

function DancerGUI( file )

% Demo
if( nargin < 1 )
  DancerGUI('Ballerina.obj');
  return
end

% Storage of data need by the deep learning system
kStore      = 1;
accelStore  = zeros(3,1000);
gyroStore   = zeros(3,1000);
quatStore   = zeros(4,1000);
timeStore   = zeros(1,1000);
time        = 0;
on3D        = false;
quitNow     = false;

sZ = get(0,'ScreenSize') + [99 99 -200 -200];

h.fig = figure('name','Dancer Data Acquisition','position',sZ,'units','pixels',...
  'NumberTitle','off','tag','DancerGUI','color',[0.9 0.9 0.9]);

% Plot display
gPlot.yLabel  = {'\omega_x' '\omega_y' '\omega_z' 'a_x' 'a_y' 'a_z'};
gPlot.tLabel  = 'Time (sec)';
gPlot.tLim    = [0 100];
gPlot.pos     = [0.45    0.88    0.46    0.1];
gPlot.color   = 'b';
gPlot.width   = 1;

% Calibration
q0            = [1;0;0;0];
a0            = [0;0;0];

dIMU.accel    = a0;
dIMU.quat     = q0;

% Initialize the GUI
DrawGUI;

% Get bluetooth information
instrreset; % Just in case the IMU wasn't close properly
btInfo  = instrhwinfo('Bluetooth');


if( ~isempty(btInfo.RemoteIDs) )
   % Display the information about the first device discovered
  btInfo.RemoteNames(1)
  btInfo.RemoteIDs(1)
  for iB = length(btInfo.RemoteIDs)
    if( strcmp(btInfo.RemoteNames(iB),'LPMSB2-4B31D6') )
      break;
    end
  end
  b       = Bluetooth(btInfo.RemoteIDs{iB}, 1);
	fopen(b); % No output allowed for some reason
  noIMU   = false;
	a       = fread(b,91);
	dIMU    = DataFromIMU( a );    
else
  warndlg('The IMU is not available.', 'Hardware Configuration')
  noIMU   = true;
end

% Wait for user input
uiwait;
% The run loop
time  = 0;
tic
while(1)
  if( noIMU )
    omegaZ      = 2*pi;
    dT          = toc;
    time        = time + dT;
    tic
    a           = omegaZ*time;
    q           = [cos(a);0;0;sin(a)];
    accel       = [0;0;sin(a)];
    omega       = [0;0;omegaZ];
  else
    % Query the bluetooth device
    a       = fread(b,91);
    pause(0.1); % needed so not to overload the bluetooth device

    dT      = toc;
    time    = time + dT;
    tic

    % Get a data structure
    if( length(a) > 1 )
      dIMU    = DataFromIMU( a );   
    end
    accel   = dIMU.accel - a0;
    omega   = dIMU.gyro;
    q       = QuaternionMultiplication(q0,dIMU.quat);
    
    timeStore(1,kStore)   = time;
    accelStore(:,kStore)	= accel; 
    gyroStore(:,kStore)   = omega; 
    quatStore(:,kStore)   = q; 
    kStore = kStore + 1;
  end
  
  if( quitNow )
    close( h.fig )
    return
  else
    if( on3D )
      QuaternionVisualization( 'update', q );
    end
    set(h.text(1),'string',sprintf('[%5.2f;%5.2f;%5.2f] m/s^2',accel));
    set(h.text(2),'string',sprintf('[%5.2f;%5.2f;%5.2f] rad/s',omega));
    set(h.text(3),'string',datestr(now));
    gPlot = GUIPlots( 'update', [omega;accel], time, gPlot );
  end
end

%% DancerGUI>DrawGUI
function DrawGUI
  
  % Plots
  gPlot = GUIPlots( 'initialize', [], [], gPlot );
 
  % Quaternion display
  subplot('position',[0.05 0.5 0.4 0.4],'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1] );
  QuaternionVisualization( 'initialize', file, h.fig );
   
  % Buttons
  f   = {'Acceleration', 'Angular Rates' 'Time'};
  n   = length(f);
  p   = get(h.fig,'position');
  dY  = p(4)/20;
  yH  = p(4)/21;
  y   = 0.5;
  x   = 0.15;
  wX  = p(3)/6;

  % Create pushbuttons and defaults
  for k = 1:n
    h.pushbutton(k) = uicontrol( h.fig,'style','text','string',f{k},'position',[x    y wX yH]);   
    h.text(k)       = uicontrol( h.fig,'style','text','string','',  'position',[x+wX y 2*wX yH]);   
    y               = y + dY;
  end
  
  h.onButton        = uicontrol( h.fig,'style','togglebutton','string','Start/Stop',...
                                  'position',[x y wX yH],'ForegroundColor','red','callback',@StartStop);   
  y = y + dY;
  h.clrButton       = uicontrol( h.fig,'style','pushbutton','string','Clear Data','position',[x y wX yH],'callback',@Clear);   
  y = y + dY;
  h.quitButton      = uicontrol( h.fig,'style','pushbutton','string','Quit','position',[x y wX yH],'callback',@Quit);   
  y = y + dY;
  h.calibrateButton = uicontrol( h.fig,'style','pushbutton','string','Calibrate','position',[x y wX yH],'callback',@Calibrate);   
  y = y + dY;
  h.saveButton      = uicontrol( h.fig,'style','pushbutton','string','Save',    'position',[x    y wX yH],'callback',@SaveFile);   y = y + dY;
	h.on3D            = uicontrol( h.fig,'style','togglebutton','string','3D on/off',...
                                  'position',[x y wX yH],'ForegroundColor','red','callback',@On3D);   

  h.matFile         = uicontrol( h.fig,'style','edit',      'string','MyDancer','position',[x+wX y wX yH]);  
  
    
	% 3D on/off button callback
  function On3D(~, ~, ~ )    
    on3D = ~on3D;
  end

  
  % Start/Stop button callback
  function StartStop(hObject, ~, ~ )    
    if( hObject.Value )
      uiresume;
    else
      SaveFile;
      uiwait
    end
  end
 
	% Quit button callback
  function Quit(~, ~, ~ )   
    button = questdlg('Save Data?','Exit Dialog','Yes','No','No');
    switch button
      case 'Yes'
        % Save data
      case 'No'
    end
    quitNow = true;
    uiresume
  end
      
	% Clear button callback
  function Clear(~, ~, ~ )  
    kStore      = 1;
    accelStore  = zeros(3,1000);
    gyroStore   = zeros(3,1000);
    quatStore   = zeros(4,1000);
    timeStore   = zeros(1,1000);
    time        = 0;
  end

	% Calibrate button callback
  function Calibrate(~, ~, ~ )
    a       = fread(b,91);
    dIMU    = DataFromIMU( a );    
    a0      = dIMU.accel;
    q0      = dIMU.quat;
    QuaternionVisualization( 'update', q0 )
  end

  % Save button call back
  function SaveFile(~,~,~)
    cd TestData
    fileName = get(h.matFile,'string'); 
    s = dir;
    n = length(s);
    fNames = cell(1,n-2);
    for kF = 3:n
      fNames{kF-2} = s(kF).name(1:end-4);
    end
    j = contains(fNames,fileName);
    m = 0;
    if( ~isempty(j) )
      for kF = 1:length(j)
        if( j(kF))
          f = fNames{kF};
          i = strfind(f,'_');
          m = str2double(f(i+1:end));
        end
      end
    end
    
    timeStore(kStore:end) = [];
    gyroStore(:,kStore:end) = [];
    quatStore(:,kStore:end) = [];
    accelStore(:,kStore:end) = [];
    
    state = [gyroStore;accelStore;quatStore];
    time  = timeStore;
    
    save(sprintf('%s_%d.mat',fileName,m+1), 'state','time');   
    
    kStore      = 1;
    accelStore  = zeros(3,1000);
    gyroStore   = zeros(3,1000);
    quatStore   = zeros(4,1000);
    timeStore   = zeros(1,1000);
    time        = 0;

    cd ..    
    
    gPlot = GUIPlots( 'initialize', [], [], gPlot );

  end
  
end

end

%% Copyright
%   Copyright (c) 2019 Princeton Satellite Systems, Inc.
%   All rights reserved.

%% Interactive tool for dancer data acquisition.
%
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
quatStore   = zeros(3,1000);
timeStore   = zeros(1,1000);
time        = 0;

quitNow = false;

h.fig = figure('name','Dancer Data Acquisition','position',[100 100 680 500],'units','pixels',...
  'NumberTitle','off','tag','DancerGUI','color',[0.9 0.9 0.9]);

% Plot display
gPlot.yLabel  = {'\omega_x' '\omega_y' '\omega_z' 'a_x' 'a_y' 'a_z'};
gPlot.tLabel  = 'Time (sec)';
gPlot.tLim    = [0 100];
gPlot.pos     = [0.500    0.88    0.46    0.08];
gPlot.color   = 'b';
gPlot.width   = 1;
imd           = imread('FemaleDancer.png');

% Calibration
q0            = [1;0;0;0];
a0            = [0;0;0];

% Initialize the GUI
DrawGUI;

% Get bluetooth information
instrreset; % Just in case the IMU wasn't close properly
btInfo  = instrhwinfo('Bluetooth');
if( ~isempty(btInfo.RemoteIDs) )
  for iB = length(btInfo.RemoteIDs)
    if( strcmp(btInfo.RemoteNames(iB),'LPMSB2-4B31D6') )
      break;
    end
  end
  b       = Bluetooth(btInfo.RemoteIDs{iB}, 1);
	fopen(b); % No output allowed for some reason
  noIMU   = false;
else
  warndlg('The IMU is not available.', 'Hardware Configuration')
  noIMU   = true;
end

% Wait for user input
uiwait;
% The run loop
t     = 0;
time  = 0;
tic
while(1)
  if( noIMU )
    omegaZ  = 2*pi;
    dT      = toc;
    t       = t + dT;
    tic
    a       = omegaZ*t;
    q       = [cos(a);0;0;sin(a)];
    accel   = [0;0;sin(a)];
    omega   = [0;0;omegaZ];
  else
    % Query the bluetooth device
    a       = fread(b,91);

    dT      = toc;
    time    = time + dT;
    tic

    % Get a data structure
    dIMU    = DataFromIMU( a );    
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
    close(h.fig);
    return;
  end
  
	QuaternionVisualization( 'update', q )
	set(h.text(1),'string',sprintf('[%5.2f;%5.2f;%5.2f] m/s^2',accel));
	set(h.text(2),'string',sprintf('[%5.2f;%5.2f;%5.2f] rad/s',omega));
	set(h.text(3),'string',datestr(now));
	gPlot = GUIPlots( 'update', [omega;accel], t, gPlot );
end

%% DancerGUI>DrawButtons
function DrawGUI
  
  % Plots
  gPlot = GUIPlots( 'initialize', [], [], gPlot );
   
  subplot('position',[0.7 0.02 0.2 0.2])
  imshow(imd);
 
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
  h.saveButton      = uicontrol( h.fig,'style','pushbutton','string','Save',    'position',[x    y wX yH],'callback',@SaveFile); 
  h.matFile         = uicontrol( h.fig,'style','edit',      'string','MyDancer','position',[x+wX y wX yH]);  
  
  % Start/Stop button callback
  function StartStop(hObject, ~, ~ )    
    if( hObject.Value )
      uiresume;
    else
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
  end
      accelStore(:,kStore) = accel;
      
	% Clear button callback
  function Clear(~, ~, ~ )  
    kStore          = 1;
    accelStore      = 0;
    gyroStore       = 0; %#ok<SETNU>
    quatStore       = 0; %#ok<SETNU>
    quatStore(1,:)  = 1;
    time            = 0;
  end

	% Calibrate button callback
  function Calibrate(~, ~, ~ )  
    a0 = dIMU.accel;
    q0 = dIMU.quat;
  end

  % Save button call back
  function SaveFile(~,~,~)         
    fileName = get(h.matFile,'string');    
    save(sprintf('%.mat',fileName), '-struct', 'accelStore', 'gyroStore','quatStore', 'timeStore','kStore');   
  end
  
end

end
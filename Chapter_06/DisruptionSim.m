%% Tokamak Plasma Vertical Control
% Simulates a model of the vertical position of an elongated plasma in a 
% Tokamak. The vertical position is unstable and can be represented by one
% unstable mode and one stable mode and a time delay.  Two major
% disturbances are due to the thyristor power supplies and the Edge
% Localized Modes (ELM).
% -------------------------------------------------------------------------
%  Reference: Scibile, L. and B. Kouvaritakis (2001.) "A Discrete Adaptive
%             Near-Time Optimum Control for the Plasma Vertical Position 
%             in a Tokamak." IEEE Transactions on Control System
%             Technology. Vol. 9, No. 1, January 2001.
% -------------------------------------------------------------------------

%% Constants
d           = RHSTokamak;                                      
tau1ELM     = 6.0e-4;    % ELM time constant 1
tau2ELM     = 1.7e-4;    % ELM time constant 2
kELM        = 6.5;       % ELM gain
tRepELM     = 48e-3;     % ELM repetition time (s)

%% The control sampling period and the simulation integration time step
dT          = 1e-4;

%% Number of sim steps
nSim        = 200;

%% Plotting array
xPlot       = zeros(6,nSim);

%% Initial conditions
x           = [0;0;0];
t           = 0;
tRep        = 0.001; % Time for the 1st ELM
tELM        = inf;

%% Run the simulation
for k = 1:nSim 
  d.v  	= 0;
  d.eLM	= ELM( tau1ELM, tau2ELM, kELM, tELM );
  tELM 	= tELM + dT;
  
  % Trigger another ELM
  if( t > tRep + rand*tRepELM )
	 tELM	= 0;
	 tRep	= t;
  end
  
  x           = RK4( @RHSTokamak, x, dT, t, d );
  [~,z]       = RHSTokamak( x, t, d );
  t           = t + dT; 
  xPlot(:,k)  = [x;z;d.eLM];   
end

%% Plot the results
tPlot = dT*(0:nSim-1)*1000;
yL    = {'I_A' 'I_V' 'V' 'Z' 'ELM' 'ELM Dot'};
PlotSet( tPlot, xPlot, 'x label', 'Time (ms)', 'y label', yL, 'figure title', 'Disruption Simulation' );

%% Script with simulation of an air turbine
% Simulates an air turbine.
%% See also
% RHSAirTurbine, RungeKutta, TimeLabel, PlotSet

%% Initialization
tEnd  = 1000; % sec

% State space system
d     = RHSAirTurbine;

% This is the regulator input.
d.u   = 100;

dT    = 0.02; % sec
n     = ceil(tEnd/dT);

% Initial state
x     = [0;0];

%% Run the simulation

% Plotting array
xP    = zeros(2,n);
t     = (0:n-1)*dT;

for k = 1:n
  xP(:,k) = x;
  x       = RungeKutta( @RHSAirTurbine, t(k), x, dT, d );
end

%% Plot the states and residuals
[t,tL] = TimeLabel(t);
yL     = {'p (N/m^2)' '\omega (rad/s)' };
tTL    = 'Air Turbine Simulation';
PlotSet( t, xP,'x label',tL,'y label',yL,'figure title',tTL)


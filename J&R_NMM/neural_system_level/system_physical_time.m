function [param] = system_physical_time(param)
%% Basic constants for real physical time simulation and integration
%%
%% Inputs
% param - empty structure
%% Outputs
% taumax - maximum of the lag distribution
% tau0 - center of the delay distribution 
% sigma0 - width of the delay distribution
% Tmax - total simulation time
% h - integration step in seconds
% Ns - number of segmnets for spectral analysis 
% Fmax - maximum frequency for analysis
%%
h       = 0.005; % 0.01E-3; % h(seconds) 
param.physical_time.h       = h; 

Tmax    = 12; % 4; % Tmax(seconds)
param.physical_time.Tmax    = Tmax; 

Nt      = floor(Tmax/h); % Number of time points in the simulation
param.physical_time.Nt      = Nt;

tspan   = (1:1:Nt)*h; % Phisical time linear space 
param.physical_time.tspan   = tspan;

Nseg    = 6; % 10; % integer 
param.physical_time.Nseg    = Nseg;

nu_max  = 50; % Fmax (Hz) 
param.physical_time.Fmax    = nu_max;

nu_min  = 0.1; % Fmax (Hz) 
param.physical_time.Fmin    = nu_min;
end
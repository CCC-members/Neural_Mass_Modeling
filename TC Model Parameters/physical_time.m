function [param] = physical_time(param)
%% Basic constants for real physical time simulation and integration (2.1	General model formulation)
%% Inputs
% param: parameters from "model_param"
%% Outputs
% taumax: maximum of the lag distribution
% Tmax: total simulation time
% h: integration step in seconds
% Nseg: number of segmnets for spectral analysis 
% nu_max: maximum frequency for analysis
% nu_min: minimum frequency for analysis

%% Defining physical time values (Table 3)
h       = 0.001; % 0.01E-3; % h(seconds) 
param.physical_time.h       = h; 

Tmax    = 12; % 4; % Tmax(seconds)
param.physical_time.Tmax    = Tmax; 

Nt      = floor(Tmax/h); % Number of time points in the simulation
param.physical_time.Nt      = Nt;

tspan   = (1:1:Nt)*h; % Phisical time linear space 
param.physical_time.tspan   = tspan;

Nseg    = 6; % 10; % integer 
param.physical_time.Nseg    = Nseg;

nu_max  = 50; %i n (Hz) 
param.physical_time.Fmax    = nu_max;

nu_min  = 0.1; % in (Hz) 
param.physical_time.Fmin    = nu_min;
end
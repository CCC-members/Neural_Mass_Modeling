close all
clear all
clc
%%
tic
%%
addpath('MEEG');
addpath('LL_integration');
addpath('neural_unit_level');
addpath('neural_population_level');
addpath('neural_system_level');
addpath('Biffurcation_analysis');
%% General simulation parameters 
param  = struct;
% Jansen and Rit Neural Mass model parameters 
param  = unit_jansen_and_rit_param(param); 
% Model physical time constants 
param  = system_physical_time(param);
%%
% Layer intrinsic parameters
% gamma (>30 Hz),  beta (12–30 Hz),alpha (8–12 Hz), theta (4–8 Hz), delta (1–4 Hz)   
% inhibitory gamma(4.8) beta(10.7)  alpha(20) theta(40.7) delta(52)
tau_inhibitory   = 10.7E-3;
% excitatory gamma(1) beta(4.5) alpha(10) theta(15) delta(20)
tau_excitatory   = 4.5E-3;
%% Prepare parameters for single unit simulation
param  = unit_response_param(param,tau_inhibitory,tau_excitatory); 
% Jacobian matrix exponential
param  = LL_jacobian_expm(param);
%%
%% Prepare parameters for population simulation
% Population network connectivity and lags
param  = population_network_param(param);
% Lagged connectivity tensor
param  = population_connectivity_tensor(param);
%%
%% Prepare parameters for system simulation
% System populations layer intrinsic parameters
param  = system_response_param(param);
% System Jacobian matrix exponential
param  = LL_system_jacobian_expm(param);
% System network connectivity and lags
param  = system_network_param(param);                                      
% Lagged connectivity tensor
param  = system_connectivity_tensor(param);
%%
%% LL Single unit integration 
[Y,X,Z,param]   = LL_unit_integration(param);
[figures,param] = spectral_analysis(Y,Z,param);
%%
%% LL Multi-unit population integration
[Y,X,Z,param]   = LL_population_integration(param);
[figures,param] = spectral_analysis(Y,Z,param); 
%%
%% LL Multi-population system integration
[Y,X,Z,param]   = LL_system_integration(param);
[figures,param] = system_spectral_analysis(Y,Z,param);
%%
%% Save param
save('Definitions.mat','param');
toc
%% MEEG simulation

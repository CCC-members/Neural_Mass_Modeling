%% Simulation for a single JR cortical column without delay
close all
clear all
clc
%% General simulation parameters 
param   = struct;
param  = physical_time(param);
%% Alpha rhythm intrinsic parameters
alpha_inhibitory  = 20E-3;
alpha_excitatory = 10E-3;
%% Prepare parameters for model simulation
param   = cortex_parameters(param); 
param   = pop_connectivity_matrix(param);      % population parameters
param   = cortex_response_param(param,alpha_inhibitory,alpha_excitatory);    % Cortex JR-Nm
param   = LL_jacobian_expm(param);    % Jacobian matrix exponential
%% Burn in and run in
% Loading parameters
Nm        = param.jansen_and_rit.neural_mass.Nm;
Nt          = param.physical_time.Nt;
% Initialization
Y_init    = zeros(Nm,Nt);
X_init    = zeros(Nm,Nt);
Z_init    = zeros(Nm,Nt);
tic 
for j=1:2
[X,Y,Z] = unit_LL_integration(param,Y_init,X_init,Z_init);
end
[figures] = model_plot(Z,param);
toc
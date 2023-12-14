%%
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
% param   = NN_connectivity_topology(param);
% param   = FC_connectivity_topology(param);
param   = SW_connectivity_topology(param);
param   = cortex_response_param(param,alpha_inhibitory,alpha_excitatory);
param   = LL_jacobian_expm(param);
param   = dirac_connectome_tensor(param);
% param   = single_peak_probability_density(param);
% param   = distributed_connectome_tensor(param);

%% Burn-in and Run-in
Nm_pop     = param.neural_mass.Nm_pop;
Nt       = param.physical_time.Nt;
Ntau   = param.connectivity_tensor.Ntau ;
Y_init = zeros(Nm_pop,Ntau);
X_init = zeros(Nm_pop,Ntau);
Z_init = zeros(Nm_pop,Ntau);

tic 
for j=1:2
    [X,Y,Z] = LL_integration(param,Y_init,X_init,Z_init);
    Y_init = Y(:,end-Ntau+1:end);
    X_init = X(:,end-Ntau+1:end);
    Z_init = Z(:,end-Ntau+1:end);
end
[figures] = model_plot(Z,param);
toc
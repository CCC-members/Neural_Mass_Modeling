close all
clear
clc
%% General simulation parameters 
param  = struct;
param  = physical_time(param);
%% Alpha rhythm intrinsic parameters
% gamma (>30 Hz),  beta (12–30 Hz),alpha (8–12 Hz), theta (4–8 Hz), delta (1–4 Hz)   
% inhibitory gamma(4.8) beta(10.7)  alpha(20) theta(40) delta(52)
alpha_inhibitory  = 20E-3;
% excitatory gamma(1) beta(4.5) alpha(10) theta(15) delta(20)
alpha_excitatory = 10E-3;
%% Prepare parameters for model simulation
param   = TC_parameters(param); 
param   = pop_connectivity_matrix(param);      % population parameters
param   = TC_response_param(param,alpha_inhibitory,alpha_excitatory);    %Thalamo-cortical JR-Nm
param   = LL_jacobian_expm(param);    % Jacobian matrix exponential
param   = dirac_connectome_tensor(param);
% param   = single_peak_probability_density(param);
% param   = double_peak_probability_density(param);
% param   = distributed_connectome_tensor(param);

%% Burn-in and Run-in
Nm_pop = param.neural_mass.Nm_pop;
Nt     = param.physical_time.Nt;
Ntau   = param.connectivity_tensor.Ntau ;
Y_init = zeros(Nm_pop,Ntau);
X_init = zeros(Nm_pop,Ntau);
Z_init = zeros(Nm_pop,Ntau);
tic 
for j=1:2
    [X,Y,Z] = LL_integration(param,Y_init,X_init,Z_init);
    Y_init  = Y(:,end-Ntau+1:end);
    X_init  = X(:,end-Ntau+1:end);
    Z_init  = Z(:,end-Ntau+1:end);
end
[figures]   = model_plot(Z,param);
toc
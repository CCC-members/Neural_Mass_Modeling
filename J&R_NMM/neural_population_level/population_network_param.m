function [param] = population_network_param(param)
%% Basic properties for the connectivity and delays of a neural mass model population 
%% Inputs
% param - parameters from "unit_response_param"
%%
%% Outputs
% H_excitatory - excitatory layer intrinsic amplitude parameter    

%%
%% Loading unit response parameters 
sigma_dwSte4        = param.spectral_response.stochastic_inputs.sigma_dwSte4;
tau_unit            = param.spectral_response.tau_unit;
%% Defining population parameters
Nunit               = 30;
Ipop                = eye(Nunit);
nu_pop              = 10; % population frequency (Hz) 
taumin              = 3*max(tau_unit);
connections         = [1 2; 2 1];
extensions          = [ceil(Nunit/3); ceil(Nunit/3); Nunit - 2*ceil(Nunit/3)];
options.connections = connections;
options.extensions  = extensions;
%% Creating syntetic directed connectivity and delays  
% Theta = (I-K)'*diag(1/sigma_dwpop)*(I-K)
[~,Theta_pop]       = hggm(Nunit,options);
% Theta_pop = U*D*U'
% Theta_pop = (U*sqrt(D))*(U*sqrt(D))'
[U,D]               = svd(Theta_pop);
Ddiag               = diag(D);
Ddiag_sqrt          = sqrt(Ddiag);
U                   = U*diag(Ddiag_sqrt);
% Theta_pop = (U*sqrt(D)*sqrt(Sigma_pop))*(1/Sigma_pop)*(U*sqrt(D)*sqrt(Sigma_pop))'
sigma_pop_sqrt      = sqrt(sigma_dwSte4)*ones(Nunit,1);
Sigma_pop_sqrt      = diag(sigma_pop_sqrt);
U                   = U*Sigma_pop_sqrt;
% K = I - (U*sqrt(D)*sqrt(Sigma_pop))'
K0                  = Ipop - U';
% K(nu_pop) = FT[abs(K).*delta(t-delays_pop)]
tau0                = (-angle(K0) + pi)/(2*pi*nu_pop) + taumin;
tau0                = tau0 - diag(diag(tau0));
sigma0              = tau0/3;
taumax              = 1.5*max(tau0(:));
K0                  = real(K0) - diag(diag(real(K0)));
%% Saving parameters
param.population_network.Nunit  = Nunit;
param.population_network.Ipop   = Ipop;
param.population_network.nu_pop = nu_pop;
param.population_network.K0     = K0;
param.population_network.tau0   = tau0;
param.population_network.taumax = taumax;
param.population_network.sigma0 = sigma0;
end
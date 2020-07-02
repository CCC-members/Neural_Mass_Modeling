function [param] = unit_response_param(param,tau_inhibitory,tau_excitatory)
%% Basic properties for the spectral response of a neural mass model unit 
%% Inputs
% param - parameters from "jansen_and_rit_param" and "physical_time_constants"
%%
%% Outputs
% H_excitatory - excitatory layer intrinsic amplitude parameter    
% tau_excitatory - excitatory layer intrinsic lump parameter 
% nu_excitatory - excitatory layer intrinsic frequency response parameter   
% H_inhibitory  - inhibitory layer intrinsic amplitude parameter      
% tau_inhibitory - inhibitory layer intrinsic lump parameter  
% nu_inhibitory - inhibitory layer intrinsic frequency response parameter   
% H - [H_excitatory; H_inhibitory; H_excitatory]
% tau - [tau_excitatory; tau_inhibitory; tau_excitatory]
% nu - [nu_excitatory; nu_inhibitory; nu_excitatory]
% miu_dwPyr23 - wiener process miu (mean) for Pyr23
% miu_dwInh23 - wiener process miu (mean) for Inh23
% miu_dwSte4  - wiener process miu (mean) for Ste4
% sigma_dwPyr23 - wiener process sigma (variance) for Pyr23
% sigma_dwInh23 - wiener process sigma (variance) for Inh23
% sigma_dwSte4  - wiener process sigma (variance) for Ste4
% miu_dw - wiener process miu (mean) [miu_dwPyr23; miu_dwInh23; miu_dwSte4];
% sigma_dw - wiener process sigma (variance) [sigma_dwPyr23; sigma_dwInh23; sigma_dwSte4];
%%
%% Loading Jansena and Rit model parameters 
Nlayers               = param.jansen_and_rit.layers.Nlayers; % Number of Layers
Pyr23                 = param.jansen_and_rit.layers.Pyr23;
Inh23                 = param.jansen_and_rit.layers.Inh23;
Ste4                  = param.jansen_and_rit.layers.Ste4;
%% Definition of parameters for neural mass model of Alpha spectral process
%% Defining Layer intrinsic parameters
% Constants for excitatory layers 
ratio_excitatory      = 325;
nu_excitatory         = 1/tau_excitatory;
H_excitatory          = tau_excitatory*ratio_excitatory;
% Constants for inhibitory layers
ratio_inhibitory = 1100;
nu_inhibitory         = 1/tau_inhibitory; 
H_inhibitory          = tau_inhibitory*ratio_inhibitory;
% Assign values to layers 
H                     = zeros(Nlayers, 1); 
tau_unit              = zeros(Nlayers, 1); 
nu_unit               = zeros(Nlayers, 1);
H([Pyr23 Ste4])       = H_excitatory;
tau_unit([Pyr23 Ste4])= tau_excitatory; 
nu_unit([Pyr23 Ste4]) = nu_excitatory;
H(Inh23)              = H_inhibitory;
tau_unit(Inh23)       = tau_inhibitory;
nu_unit(Inh23)        = nu_inhibitory;
% Stochastic inputs for layers  
miu_dwPyr23           = 0;
miu_dwInh23           = 0;
miu_dwSte4            = 3E0;
sigma_dwPyr23         = 0;
sigma_dwInh23         = 0;
sigma_dwSte4          = 1E0;
% Assign values to layers 
miu_dw                = [miu_dwPyr23; miu_dwInh23; miu_dwSte4];
sigma_dw              = [sigma_dwPyr23; sigma_dwInh23; sigma_dwSte4];
%%
%% Saving parameters
% layers response
param.spectral_response.H                                = H;
param.spectral_response.tau_unit                         = tau_unit;
param.spectral_response.nu_unit                          = nu_unit;
param.spectral_response.H_excitatory                     = H_excitatory;
param.spectral_response.tau_excitatory                   = tau_excitatory;
param.spectral_response.nu_excitatory                    = nu_excitatory;
param.spectral_response.H_inhibitory                     = H_inhibitory; 
param.spectral_response.tau_inhibitory                   = tau_inhibitory;
param.spectral_response.nu_inhibitory                    = nu_inhibitory;
% layers stochastic inputs 
param.spectral_response.stochastic_inputs.miu_dwPyr23    = miu_dwPyr23;
param.spectral_response.stochastic_inputs.miu_dwInh23    = miu_dwInh23;
param.spectral_response.stochastic_inputs.miu_dwSte4     = miu_dwSte4;
param.spectral_response.stochastic_inputs.sigma_dwPyr23  = sigma_dwPyr23;
param.spectral_response.stochastic_inputs.sigma_dwInh23  = sigma_dwInh23;
param.spectral_response.stochastic_inputs.sigma_dwSte4   = sigma_dwSte4;
param.spectral_response.stochastic_inputs.miu_dw         = miu_dw;
param.spectral_response.stochastic_inputs.sigma_dw       = sigma_dw;
end
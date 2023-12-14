function [param] = cortex_response_param(param,alpha_inhibitory,alpha_excitatory)
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
Nm          = param.jansen_and_rit.neural_mass.Nm; % Number of Neural Masses involved in the 
Ncc          = param.neural_mass.Ncc;
Pyr           = param.jansen_and_rit.neural_mass.Pyr;
Inh            = param.jansen_and_rit.neural_mass.Inh;
Ste           = param.jansen_and_rit.neural_mass.Ste;

%% Definition of parameters for neural mass model of Alpha spectral process
%% Defining Layer intrinsic parameters
% Constants for excitatory layers 
ratio_excitatory      = 325;
b_excitatory             = 1/alpha_excitatory;
a_excitatory             = alpha_excitatory*ratio_excitatory;
% Constants for inhibitory neural masses
ratio_inhibitory         = 1100;
b_inhibitory               = 1/alpha_inhibitory; 
a_inhibitory               = alpha_inhibitory*ratio_inhibitory;
% Assign values to layers 
a                                 = zeros(Nm, 1); 
alpha                          = zeros(Nm, 1); 
b                                  = zeros(Nm, 1);
a([Pyr Ste])         = a_excitatory;
alpha([Pyr Ste])  = alpha_excitatory; 
b([Pyr Ste])         = b_excitatory;
a(Inh)                  = a_inhibitory;
alpha(Inh)          = alpha_inhibitory;
b(Inh)                          = b_inhibitory;
a = repmat(a,Ncc,1);
b = repmat(b,Ncc,1);

% Stochastic inputs for layers  
miu_Pyr                      = 0;% 0.1;
miu_Inh                       = 0;% 0.1;
miu_Ste                      = 3; %0.1;
sigma_Pyr                  = 0;% 0.01;
sigma_Inh                   = 0;% 0.01;
sigma_Ste                  = 1; %0.01;

% Assign values to layers 
miu                               = [miu_Pyr; miu_Inh; miu_Ste ];
sigma                           = [sigma_Pyr; sigma_Inh; sigma_Ste];
%%
%% Saving parameters
% inhibitory and excitatory response
param.jansen_and_rit.PSP_parameters.a                                                = a;
param.jansen_and_rit.PSP_parameters.alpha                                         = alpha;
param.jansen_and_rit.PSP_parameters.b                                                = b;
param.jansen_and_rit.PSP_parameters.a_excitatory                             = a_excitatory;
param.jansen_and_rit.PSP_parameters.alpha_excitatory                      = alpha_excitatory;
param.jansen_and_rit.PSP_parameters.b_excitatory                             = b_excitatory;
param.jansen_and_rit.PSP_parameters.a_inhibitory                              = a_inhibitory; 
param.jansen_and_rit.PSP_parameters.alpha_inhibitory                       = alpha_inhibitory;
param.jansen_and_rit.PSP_parameters.b_inhibitory                              = b_inhibitory;
% stochastic inputs 
param.jansen_and_rit.stochastic_inputs.miu_Pyr     = miu_Pyr;
param.jansen_and_rit.stochastic_inputs.miu_Inh      = miu_Inh;
param.jansen_and_rit.stochastic_inputs.miu_Ste     = miu_Ste;
param.jansen_and_rit.stochastic_inputs.sigma_Pyr = sigma_Pyr;
param.jansen_and_rit.stochastic_inputs.sigma_Inh  = sigma_Inh;
param.jansen_and_rit.stochastic_inputs.sigma_Ste = sigma_Ste;
param.jansen_and_rit.stochastic_inputs.miu              = miu;
param.jansen_and_rit.stochastic_inputs.sigma          = sigma;
end
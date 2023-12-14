function param = TC_response_param(param,alpha_inhibitory,alpha_excitatory)
%% Assign stochastic inputs, inhibitory and excitatory parameters to the neural masses
%% Inputs
% param: parameters from "_param"
%% Outputs
% a, alpha, b, a_excitatory, alpha_excitatory, b_excitatory, a_inhibitory,
% alpha_inhibitory, b_inhibitory: inhibitory and excitatory response
% parameters for neural masses
% miu_Pyr, miu_Inh, miu_Ste, miu_Ret, miu_Tha, sigma_Pyr, sigma_Inh,
% sigma_Ste, sigma_Ret, sigma_Tha, miu, sigma: stochastic inputs for neural masses

%% Loading  parameters 
Nm          = param.jansen_and_rit.neural_mass.Nm; % Number of Neural Masses involved in the 
Ncc          = param.neural_mass.Ncc;
Pyr           = param.jansen_and_rit.neural_mass.Pyr;
Inh            = param.jansen_and_rit.neural_mass.Inh;
Ste           = param.jansen_and_rit.neural_mass.Ste;
Ret           = param.jansen_and_rit.neural_mass.Ret;
Tha           = param.jansen_and_rit.neural_mass.Tha;

%% Definition of parameters for NMM of Alpha spectral process (Table 5 and 6)
% Constants for excitatory neural masses 
ratio_excitatory       = 325;
b_excitatory             = 1/alpha_excitatory;
a_excitatory             = alpha_excitatory*ratio_excitatory;
% Constants for inhibitory neural masses
ratio_inhibitory         = 1100;
b_inhibitory               = 1/alpha_inhibitory; 
a_inhibitory               = alpha_inhibitory*ratio_inhibitory;
% Assign values to neural masses 
a                                 = zeros(Nm, 1); 
alpha                          = zeros(Nm, 1); 
b                                  = zeros(Nm, 1);
a([Pyr Ste Tha])         = a_excitatory;
alpha([Pyr Ste Tha])  = alpha_excitatory; 
b([Pyr Ste Tha])         = b_excitatory;
a([Inh Ret])                  = a_inhibitory;
alpha([Inh Ret])          = alpha_inhibitory;
b(Inh)                          = b_inhibitory;
b(Ret)                         = 40; 
a = repmat(a,Ncc,1);
b = repmat(b,Ncc,1);

% Stochastic inputs for neural masses  
miu_Pyr                      = 0;%0.1;
miu_Inh                       = 0;%0.1;
miu_Ste                      = 30; %0.1;
miu_Ret                      = 0;%0.1;
miu_Tha                      = 0;%0.1;
sigma_Pyr                  = 0;%0.01;
sigma_Inh                   = 0;%0.01;
sigma_Ste                  = 0; %0.01;
sigma_Ret                  = 0;%0.01;
sigma_Tha                 = 0;%0.01;
% Assign values to neural masses 
miu                               = [miu_Pyr; miu_Inh; miu_Ste; miu_Ret; miu_Tha];
sigma                           = [sigma_Pyr; sigma_Inh; sigma_Ste;sigma_Ret; sigma_Tha];
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
param.jansen_and_rit.stochastic_inputs.miu_Ret     = miu_Ret;
param.jansen_and_rit.stochastic_inputs.miu_Tha     = miu_Tha;
param.jansen_and_rit.stochastic_inputs.sigma_Pyr = sigma_Pyr;
param.jansen_and_rit.stochastic_inputs.sigma_Inh  = sigma_Inh;
param.jansen_and_rit.stochastic_inputs.sigma_Ste = sigma_Ste;
param.jansen_and_rit.stochastic_inputs.sigma_Ret = sigma_Ret;
param.jansen_and_rit.stochastic_inputs.sigma_Tha = sigma_Tha;
param.jansen_and_rit.stochastic_inputs.miu              = miu;
param.jansen_and_rit.stochastic_inputs.sigma          = sigma;
end
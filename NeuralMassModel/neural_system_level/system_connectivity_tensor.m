function param = system_connectivity_tensor(param)
%% 3D tensor extension of the population coupling strength matrix "K" for a neural population with delays 
%% Inputs 
% param - parameters from "jansen_and_rit_param", "physical_time_constants" and "spectral_process_param"
%% Outputs
% K - Nunit X Nunit X Ntau tensor with connectivities at multiple lags, Nunit is the number of units in the population and Ntau is the number of lags 
% D - lags distribution weights 
% tau - time lags 
%% Defining connectivity tensor
param    = distribution(param);
K0       = param.system_network.K0;
D        = param.system_network.connectivity_tensor.D;
Ntau     = param.system_network.connectivity_tensor.Ntau;
K        = repmat(K0,1,1,Ntau).*D;
%% Saving parameters 
param.system_network.connectivity_tensor.K    = K;
end 
%%
function [param] = distribution(param)
%% Inputs
% Nunit - number of units in the population
% h - step for integration
% tau0 - center of the distribution
% sigma0 - width of the distribution
% taumax - right bound of the distribution support
%% Outputs 
% D - lagg distribution weights
% tau - time lags
% Ntau - number of lags
%% Parameters
Nunit   = param.system_network.Nunit;
Isys    = param.system_network.Isys;
taumax  = param.system_network.taumax;
tau0    = param.system_network.tau0;
sigma0  = param.system_network.sigma0;
h       = param.physical_time.h;
%% Distribution
tau     = (0:1:(floor(taumax/h)-1))*h;
Ntau    = length(tau);
tau     = reshape(tau,1,1,Ntau);
if h > sigma0/10
    disp(' h>delta0/100, set a smaller step for integration')
    return;
end
tau3D    = repmat(tau,sum(Nunit),sum(Nunit),1);
tau03D   = repmat(tau0,1,1,Ntau);
sigma03D = repmat(sigma0 + Isys,1,1,Ntau);
Opop3D   = repmat(ones(sum(Nunit)) - Isys,1,1,Ntau);
D        = exp(-((tau3D-tau03D)./sigma03D).^2);
D        = D.*Opop3D;
%% Saving paremeters
param.system_network.connectivity_tensor.D    = D;
param.system_network.connectivity_tensor.tau  = tau;
param.system_network.connectivity_tensor.Ntau = Ntau;
end

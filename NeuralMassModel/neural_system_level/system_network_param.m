function [param] = system_network_param(param)
%% Basic properties for the connectivity and delays of a neural mass model population 
%% Inputs
% param - parameters from "unit_response_param"
%%
%% Outputs
% H_excitatory - excitatory layer intrinsic amplitude parameter    

%%
%% Loading unit response parameters 
sigma_dwSte4        = param.system_network.spectral_response.stochastic_inputs.sigma_dwSte4;
tau_sys             = param.system_network.spectral_response.tau_sys;
Npop                = param.system_network.Npop;
%% Defining population parameters
Nunit               = [10000 10000 10000 10000 10000];
Index_pop           = {[1:Nunit(1)]'...
    [(Nunit(1)+1):(Nunit(1)+Nunit(2))]'...
    [(Nunit(1)+Nunit(2)+1):(Nunit(1)+Nunit(2)+Nunit(3))]'...
    [(Nunit(1)+Nunit(2)+Nunit(3)+1):(Nunit(1)+Nunit(2)+Nunit(3)+Nunit(4))]'...
    [(Nunit(1)+Nunit(2)+Nunit(3)+Nunit(4)+1):(Nunit(1)+Nunit(2)+Nunit(3)+Nunit(4)+Nunit(5))]'};
Isys                = eye(sum(Nunit));
nu_sys              = [40 28 10 6 2]; % population frequency (Hz) 
taumin              = 3*max(tau_sys(:));
connections         = [1 3; 3 1; 1 2; 2 1; 2 3; 3 2; 3 4; 4 3; 2 4; 4 2; 3 5; 5 3; 5 4; 4 5];
extensions          = Nunit';
options.connections = connections;
options.extensions  = extensions;
%% Creating syntetic directed connectivity and delays  
% Theta = (I-K)'*diag(1/sigma_dwpop)*(I-K)
[~,Theta_pop]       = hggm(sum(Nunit),options);
% Theta_pop = U*D*U'
% Theta_pop = (U*sqrt(D))*(U*sqrt(D))'
[U,D]               = svd(Theta_pop);
Ddiag               = diag(D);
Ddiag_sqrt          = sqrt(Ddiag);
U                   = U*diag(Ddiag_sqrt);
% Theta_pop = (U*sqrt(D)*sqrt(Sigma_pop))*(1/Sigma_pop)*(U*sqrt(D)*sqrt(Sigma_pop))'
sigma_pop_sqrt      = [sqrt(sigma_dwSte4(1))*ones(Nunit(1),1);...
    sqrt(sigma_dwSte4(2))*ones(Nunit(2),1);...
    sqrt(sigma_dwSte4(3))*ones(Nunit(3),1);...
    sqrt(sigma_dwSte4(4))*ones(Nunit(4),1);...
    sqrt(sigma_dwSte4(5))*ones(Nunit(5),1)];
U                   = U*diag(sigma_pop_sqrt);
% K = I - (U*sqrt(D)*sqrt(Sigma_pop))'
K0                  = Isys - U';
% K(nu_pop) = FT[abs(K).*delta(t-delays_pop)]
tau0 = zeros(sum(Nunit));
for pop1 = 1:Npop
    index1 = Index_pop{pop1};
    for pop2 = 1:Npop
        index2 = Index_pop{pop2};
        if pop1 == pop2
            tau0(index1,index2) = (-angle(K0(index1,index2)) + pi)/(2*pi*nu_sys(pop1)) + taumin;
        else
            tau0(index1,index2) = (-angle(K0(index1,index2)) + pi)/(2*pi*(nu_sys(pop1)+nu_sys(pop2))) + taumin;
        end
    end
end
tau0                = tau0 - diag(diag(tau0));
sigma0              = tau0/3 + eye(length(tau0));
taumax              = 1.5*max(tau0(:));
K0                  = real(K0) - diag(diag(real(K0)));
%% Saving parameters
param.system_network.Nunit     = Nunit;
param.system_network.Index_pop = Index_pop;
param.system_network.Isys      = Isys;
param.system_network.nu_pop    = nu_sys;
param.system_network.K0        = K0;
param.system_network.tau0      = tau0;
param.system_network.taumax    = taumax;
param.system_network.sigma0    = sigma0;
end
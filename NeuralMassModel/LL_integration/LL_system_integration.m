function[Y,X,Z,param] = LL_system_integration(param)
%% Obtains time series by LL integration of the neural mass model for a population
%% Inputs
% param - parameters from "jansen_and_rit_param", % "physical_time_constants", "unit_response_param", % "population_connectivity_tensor"
%% Outputs
% Y 
% X
% Z
%% Parameters
Nlayers       = param.jansen_and_rit.layers.Nlayers;
Nt            = param.physical_time.Nt;
Nunit         = param.system_network.Nunit;
Index_pop     = param.system_network.Index_pop;
Npop          = param.system_network.Npop;
C             = param.jansen_and_rit.coupling.C;
K0            = param.system_network.K0;
taumax        = param.system_network.taumax;
tau0          = param.system_network.tau0;
sigma0        = param.system_network.sigma0;
h             = param.physical_time.h;
v0            = param.jansen_and_rit.sigmoid.v0;
r             = param.jansen_and_rit.sigmoid.r;
e0            = param.jansen_and_rit.sigmoid.e0;
Asys          = param.system_network.jacobian_expm.A;
Bsys          = param.system_network.jacobian_expm.B;
%% Lag distribution
tau           = (0:1:(floor(taumax/h)-1))*h;
Ntau          = length(tau);
if h > sigma0/10
    disp(' h>delta0/100, set a smaller step for integration')
    return;
end
%% Initialization 
miu_dw_unit   = param.system_network.spectral_response.stochastic_inputs.miu_dw;
sigma_dw_unit = param.system_network.spectral_response.stochastic_inputs.sigma_dw;
miu_dw        = [];
sigma_dw      = [];
for pop = 1:Npop
    miu_dw    = cat(2,miu_dw,repmat(miu_dw_unit(:,pop),1,Nunit(pop)));
    sigma_dw  = cat(2,sigma_dw,repmat(sigma_dw_unit(:,pop),1,Nunit(pop)));
end
dw_prev       = normrnd(miu_dw, sigma_dw, Nlayers, sum(Nunit));
Y             = zeros(Nlayers,sum(Nunit),Nt);
y             = zeros(Nlayers,sum(Nunit));
X             = zeros(Nlayers,sum(Nunit),Nt);
x             = zeros(Nlayers,sum(Nunit));
Z             = zeros(Nlayers,sum(Nunit),Nt);
z             = zeros(Nlayers,sum(Nunit));
%% Local Linearization integration of a population
hfig = waitbar(0,'generating model wait...');
for time = (Ntau+1):Nt
    waitbar(time/Nt)
    %% dw-update
    dw         = normrnd(miu_dw, sigma_dw, Nlayers, sum(Nunit));
    Ytau       = Y(:,:,(time-Ntau):(time-1));
    Ytau1      = Y(:,:,time-1);
    Xtau1      = X(:,:,time-1);
    Ztau1      = Z(:,:,time-1);
    for pop = 1:Npop
        A      = Asys(:,:,pop);
        B      = Bsys(:,:,pop);
        for unit = Index_pop{pop}'
            tau2D      = repmat(tau,sum(Nunit),1);
            tau02D     = repmat(tau0(unit,:)',1,Ntau);
            sigma02D   = repmat(sigma0(unit,:)',1,Ntau);
            D          = exp(-((tau2D-tau02D)./sigma02D).^2);
            K          = repmat(K0(unit,:)',1,Ntau);
            K          = K.*D;
            z(:,unit)  = LL_unit_z_outputs(Ytau,C,K,unit);
            z_dif      = z(:,unit) - Ztau1(:,unit);
            %% dw-update
            dw_dif     = dw(:,unit) - dw_prev(:,unit);
            %% Y-X-Update
            [y(:,unit), x(:,unit)] = LL_iteration(Ytau1(:,unit),Xtau1(:,unit),z(:,unit),z_dif,dw(:,unit),dw_dif,v0,r,e0,A,B,Nlayers);
        end
    end
    dw_prev     = dw;
    Y(:,:,time) = y;
    X(:,:,time) = x;
    Z(:,:,time) = z;
end
close(hfig)
end
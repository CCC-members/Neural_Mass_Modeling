function[Y,X,Z,param] = LL_population_integration(param)
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
Nunit         = param.population_network.Nunit;
Ntau          = param.population_network.connectivity_tensor.Ntau;
C             = param.jansen_and_rit.coupling.C;
K             = param.population_network.connectivity_tensor.K;
v0            = param.jansen_and_rit.sigmoid.v0;
r             = param.jansen_and_rit.sigmoid.r;
e0            = param.jansen_and_rit.sigmoid.e0;
A             = param.jacobian_expm.A;
B             = param.jacobian_expm.B;
%% Initialization 
miu_dw_unit   = param.spectral_response.stochastic_inputs.miu_dw;
miu_dw        = repmat(miu_dw_unit,1,Nunit);
sigma_dw_unit = param.spectral_response.stochastic_inputs.sigma_dw;
sigma_dw      = repmat(sigma_dw_unit,1,Nunit);
dw_prev       = normrnd(miu_dw, sigma_dw, Nlayers, Nunit);
Y             = zeros(Nlayers,Nunit,Nt);
y             = zeros(Nlayers,Nunit);
X             = zeros(Nlayers,Nunit,Nt);
x             = zeros(Nlayers,Nunit);
Z             = zeros(Nlayers,Nunit,Nt);
z             = zeros(Nlayers,Nunit);
%% Local Linearization integration of a population
hfig = waitbar(0,'generating model wait...');
for time = (Ntau+1):Nt
    waitbar(time/Nt)
    %% dw-update
    dw         = normrnd(miu_dw, sigma_dw, Nlayers, Nunit);
    Ytau       = Y(:,:,(time-Ntau):(time-1));
    Ytau1      = Y(:,:,time-1);
    Xtau1      = X(:,:,time-1);
    Ztau1      = Z(:,:,time-1);
    for unit = 1:Nunit
        %% Z-update
        z(:,unit)  = LL_unit_z_outputs(Ytau,C,K,unit);
        z_dif      = z(:,unit) - Ztau1(:,unit);
        %% dw-update
        dw_dif     = dw(:,unit) - dw_prev(:,unit);
        %% Y-X-Update
        [y(:,unit), x(:,unit)]= LL_iteration(Ytau1(:,unit),Xtau1(:,unit),z(:,unit),z_dif,dw(:,unit),dw_dif,v0,r,e0,A,B,Nlayers);
    end
    dw_prev     = dw;
    Y(:,:,time) = y;
    X(:,:,time) = x;
    Z(:,:,time) = z;
end
close(hfig)
end
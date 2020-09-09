function[Y,X,Z,param] = LL_unit_integration(param)
%% Obtains time series by LL integration of the neural mass model for a single unit
%% Inputs
% param - parameters from "jansen_and_rit_param", "physical_time_constants" and "spectral_process_param"
%% Outputs
% Y 
% X
% Z
%% Parameters
Nlayers       = param.jansen_and_rit.layers.Nlayers;
Nt            = param.physical_time.Nt;
C             = param.jansen_and_rit.coupling.C;
v0            = param.jansen_and_rit.sigmoid.v0;
r             = param.jansen_and_rit.sigmoid.r;
e0            = param.jansen_and_rit.sigmoid.e0;
A             = param.jacobian_expm.A;
B             = param.jacobian_expm.B;
%% Initialization 
miu_dw        = param.spectral_response.stochastic_inputs.miu_dw;
sigma_dw      = param.spectral_response.stochastic_inputs.sigma_dw;
dw_obj        = dsp.ColoredNoise(-2,Nt,Nlayers,'OutputDataType','single');
dw            = dw_obj();
dw            = repmat(miu_dw,1,Nt) + repmat(sigma_dw,1,Nt).*dw';
Y             = zeros(Nlayers,Nt);
X             = zeros(Nlayers,Nt);
Z             = zeros(Nlayers,Nt);
%% Local Linearization integration of a single unit
hfig = waitbar(0,'generating model wait...');
for time = 2:Nt
    waitbar(time/Nt) 
    %% Z-update
    Z(:,time)  = LL_unit_z_outputs(Y(:,time-1),C);
    z_dif      = Z(:,time) - Z(:,time-1); 
    %% dw-update 
    dw_dif     = dw(:,time) - dw(:,time-1); 
    %% Y-X-Update
    [Y(:,time), X(:,time)]= LL_iteration(Y(:,time-1),X(:,time-1),Z(:,time),z_dif,dw(:,time),dw_dif,v0,r,e0,A,B,Nlayers);
end
close(hfig)
end


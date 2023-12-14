function[X,Y,Z] = unit_LL_integration(param,Y,X,Z)
%% Obtains time series by LL integration of the neural mass model for a single unit
%% Inputs
% param - parameters from "jansen_and_rit_param", "physical_time_constants" and "spectral_process_param"
%% Outputs
% Y 
% X
% Z
%% Parameters
Nm          = param.jansen_and_rit.neural_mass.Nm;
Nt            = param.physical_time.Nt; 
C             = param.jansen_and_rit.connectivity_matrix.C ;
v0            = param.jansen_and_rit.sigmoid.v0;
a0            = param.jansen_and_rit.sigmoid.a0;
e0            = param.jansen_and_rit.sigmoid.e0;
A             = param.jacobian_expm.A;
B             = param.jacobian_expm.B;
miu          = param.jansen_and_rit.stochastic_inputs.miu;
sigma      = param.jansen_and_rit.stochastic_inputs.sigma;
%% Initialization 
dw_obj        = dsp.ColoredNoise(-2,Nt,Nm,'OutputDataType','single');
dw            = dw_obj();
dw            = repmat(miu,1,Nt) + repmat(sigma,1,Nt).*dw';

%% Local Linearization integration of a single unit
hfig = waitbar(0,'generating model wait...');
for time = 2:Nt
    waitbar(time/Nt) 
    %% Z-update
    Z(:,time)  = LL_z_outputs(Y(:,time-1),[],C);
    z_dif      = Z(:,time) - Z(:,time-1); 
    %% dw-update 
    dw_dif     = dw(:,time) - dw(:,time-1); 
    %% Y-X-Update
    [Y(:,time), X(:,time)]= LL_iteration(Y(:,time-1),X(:,time-1),Z(:,time),z_dif,dw(:,time),dw_dif,v0,a0,e0,A,B,Nm);
end
close(hfig)
end


function[X,Y,Z] = LL_integration(param,Y_init,X_init,Z_init)
%% Obtains time series by LL integration of the neural masses of the NMM (Section 2.2	Model for a single neural mass and algebraic integration)
%% Inputs
% param: parameters from "model_param", "physical_time_constants",
% "model_LL_jacobian_expm" and "model_response_param"
%% Outputs
% Y (Nm x Nt): time series
% X (Nm x Nt): its derivative
% Z (Nm x Nt):  algebraic term

%% Parameters
Nm_pop = param.neural_mass.Nm_pop;
Ncc         = param.neural_mass.Ncc;   
Nt            = param.physical_time.Nt;
Ntau        = param.connectivity_tensor.Ntau;
K             = param.connectivity_tensor.K ;
% C             = param.jansen_and_rit.connectivity_matrix.C ;
v0            = param.jansen_and_rit.sigmoid.v0;
a0            = param.jansen_and_rit.sigmoid.a0;
e0            = param.jansen_and_rit.sigmoid.e0;
A             = param.jacobian_expm.A;
B             = param.jacobian_expm.B;
miu          = param.jansen_and_rit.stochastic_inputs.miu;
sigma      = param.jansen_and_rit.stochastic_inputs.sigma;
%% Initialization 
% dw_obj        = dsp.ColoredNoise(-2,Nt,Nm_pop,'OutputDataType','single');
% dw            = dw_obj();
% dw            = repmat(miu,Ncc,Nt) + repmat(sigma,Ncc,Nt).*dw';
miu       = repmat(miu,Ncc,Nt);
sigma   = repmat(sigma,Ncc,Nt);
dw         = normrnd(miu, sigma);
Y            = zeros(Nm_pop,Nt);
X           = zeros(Nm_pop,Nt);
Z            = zeros(Nm_pop,Nt);
Y(:,1:Ntau) = Y_init;
X(:,1:Ntau) = X_init;
Z(:,1:Ntau) = Z_init;
%% Local Linearization integration of a single unit (Equation 7 and 8)
hfig = waitbar(0,'generating model wait...');
for time =  (Ntau+1):Nt
    waitbar(time/Nt) 
    %% Z-update
    Z(:,time)  = LL_z_outputs(Y(:,time-1:-1:time-Ntau),K,[]);  % Equation 24
    z_dif      = Z(:,time) - Z(:,time-1); 
    %% dw-update 
    dw_dif   = dw(:,time) - dw(:,time-1);
       %% Y-X-Update
    [Y(:,time), X(:,time)]= LL_iteration(Y(:,time-1),X(:,time-1),Z(:,time),z_dif,dw(:,time),dw_dif,v0,a0,e0,A,B,Nm_pop);
end
   
close(hfig)
end


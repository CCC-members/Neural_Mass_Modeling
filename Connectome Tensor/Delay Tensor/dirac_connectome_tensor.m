function param = dirac_connectome_tensor(param)
%% Building a instantaneous delay Connectome Tensor via delta-Dirac function (Section 2.1 General model formulation)
%% Input: 
% param: parameters from "model_param", "physical_time_constants"
%% Outputs
% tau: time lags
% Ntau: number of lags
% K(Nm x Nm x Ntau): delay Connectome Tensor via delta-Dirac function

%% Loading parameters
% Nm    = param.jansen_and_rit.neural_mass.Nm;
Nm_pop  = param.neural_mass.Nm_pop;
h       = param.physical_time.h;
K0      = param.connectivity_matrix.K0;
% C     = param.jansen_and_rit.connectivity_matrix.C;

%%  Filling the Connectome Tensor for Dirac delay
tau     = h:h:.5; % in seconds 
Ntau    = length(tau);
% d    = double(tau==0);
% D    = repmat(reshape(d,1,1,Ntau),Nm_pop,Nm_pop,1);
% K    = repmat(C,1,1,Ntau).*D;
K               = zeros(Nm_pop,Nm_pop,Ntau);
% TC model
K(:,:,10)  = K0;  % Dirac delay in 2
K         = reshape(K,Nm_pop,Nm_pop*Ntau);

%% Saving parameters
param.connectivity_tensor.tau  = tau;
param.connectivity_tensor.Ntau = Ntau; 
param.connectivity_tensor.K    = K;
end


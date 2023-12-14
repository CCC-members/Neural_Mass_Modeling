function param = distributed_connectome_tensor(param)
%% Construction of the distributed-delay Connectome Tensor (Section 2.1 General model formulation. Equation 3)
%% Inputs 
% param: parameters from "model_param" and probability density
%% Outputs
% K (Nm x Nm x Ntau): distributed-delay Connectome tensor
%% Loading Parameters
% Ntau = param.model.connectivity_tensor.Ntau;
% Nm        = param.jansen_and_rit.neural_mass.Nm;
Nm_pop  = param.neural_mass.Nm_pop;
D              = param.connectivity_tensor.D;
Ntau         = param.connectivity_tensor.Ntau;
% C           = param.jansen_and_rit.connectivity_matrix.C;
K0         = param.connectivity_matrix.K0;
%% Conforming Sparse Connectome Tensor
K          = repmat(K0,1,1,Ntau).*D;
% K = sparse(reshape(K,Nm_pop*Ntau,Nm_pop));   %create a sparse array with dimensions (Nm*Ntau x Nm)
K         = reshape(K,Nm_pop,Nm_pop*Ntau);
% K          = sparse(reshape(permute(K,[1,3,2]),Nm_pop*Ntau,Nm_pop));   %create a sparse array with dimensions (Nm*Ntau x Nm)
%% Saving parameters 
param.connectivity_tensor.K    = K;
end

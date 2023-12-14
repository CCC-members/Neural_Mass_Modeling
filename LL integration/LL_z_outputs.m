function z = LL_z_outputs(Y,K,C)
%% Algebraic term of the Local Linearization integration (Equation )
%% Inputs
%  Y (Nm x Ntau): state matrix up to the actual iteration
% C (Nm x Nm x Ntau): distributed-delay Connectome Tensor
%% Outputs
% z (Nm x 1): state vector
%%
[Nm_pop,~] = size(Y);
if Nm_pop ==3
    z = C*Y;
else
    z = K*Y(:);
end
end
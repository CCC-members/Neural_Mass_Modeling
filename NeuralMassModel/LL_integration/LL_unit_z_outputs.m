function [z] = LL_unit_z_outputs(Y,C,K,unit)
%% Algebraic term of the Local Linearization integration
%% Inputs
% 3xNt X-state matrix up to the actual iteration
% C - 3x3 matrix with interlayer coupling strength
%% Outputs
% 3x1 z-state vector
%% z-state vector
if nargin < 3
    z  = C*Y;
  else
    z    = C*Y(:,unit,end);
    z(3) = z(3) + sum(sum(K.*squeeze(Y(1,:,:))));
end
end
function [y_result,x_result] = LL_iteration(y,x,z,z_dif,dw,dw_dif,v0,r,e0,A,B,Nlayers)
%% Iteration update of the Local Linearization for a single unit
%% Inputs 
% x - 3x1 x-state vector in the previous iteration
% y - 3x1 y-state vector in the previous iteration (first time derivative of x)
% z - 3x1 z-state vector in the previous iteration (algebraic term of the neural mass model equations)
% z_dif - 3x1 vector of the z-state difference in the previous two iterations 
% dw - 3x1 vector of the noise process miu + sigma*(dw/dt), w is the Wiener process with unitary distribution 
% dw_dif - 3x1 vector of the dw difference in the previous two iterations 
%% Outputs 
% x_results - 3x1 x-state vector update
% y_results - 3x1 y-state vector update
%% LL noise process pertubation terms formula (2.10)       
z(z<-1e3) = -1e3;
e1        = dw + 2*e0 ./(1+exp(r .* (v0-z)));
e2        = dw_dif + z_dif.*(2 .* e0 .*r .* exp(r.*(v0-z))./(1+exp(r.*(v0-z))).^2);
%% LL iteration update
% y_result  = y + Ayy.*y + Ayx.*x + Bye1.*e1 + Bye2.*e2;
% x_result  = x + Axy.*y + Axx.*x + Bxe1.*e1 + Bxe2.*e2;
y_result  = y + A(1:Nlayers,1).*y + A((Nlayers+1):2*Nlayers,1).*x + B(1:Nlayers,1).*e1 + B((Nlayers+1):2*Nlayers,1).*e2;
x_result  = x + A(1:Nlayers,2).*y + A((Nlayers+1):2*Nlayers,2).*x + B(1:Nlayers,2).*e1 + B((Nlayers+1):2*Nlayers,2).*e2;
end
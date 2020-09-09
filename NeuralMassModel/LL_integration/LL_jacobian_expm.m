function param = LL_jacobian_expm(param)
%% Tensor with the matrix exponential of the Jacobian according to the derivation in "LL_symbolic"
%% Inputs
% Nlayers - number of neural layers 
% a - layer intrinsic amplitude parameter
% b - layer intrinsic lump parameter
% h - integration step in seconds
%% Outputs
% A - 2*Nlayers X 2*Nlayers matrix of the Jacobian exponential for the 2*Nlayers vector [x;y] 
% B - 2*Nlayers X 2*Nlayers matrix of the Jacobian exponential for the 2*Nlayers vector [e1;e2]
% J - 3x2x4 tensor with the Jacobian matrix exponential computed
% analytically by "LL_symbolic"
%% Parameters
Nlayers       = param.jansen_and_rit.layers.Nlayers;
Inlayers      = eye(Nlayers);
h             = param.physical_time.h;
H             = param.spectral_response.H;
nu            = param.spectral_response.nu_unit;
nuh           = nu.*h;
exp_nuh       = exp(nuh);
nu_exp_nuh    = nu.*exp_nuh;
%% Jacobian expm for [x;y]
Ayy           = (1 + nuh)./exp_nuh - 1;
Axy           = -(nu.*nuh)./exp_nuh;
Ayx           =  h./exp_nuh;
Axx           = (1 - nuh - exp_nuh)./exp_nuh;
A             = [Ayy, Axy; Ayx, Axx];
%% Jacobian expm for [e1,e2]
Bye1          = H.*(exp_nuh - nuh - 1)./nu_exp_nuh;
Bye2          = H.*(2.*(1 - exp_nuh) + nuh.*(1 + exp_nuh))./(nuh.*nu_exp_nuh);
Bxe1          = H.*nuh./exp_nuh;
Bxe2          = H.*(exp_nuh - nuh - 1)./(nuh.*exp_nuh);
B             = [Bye1, Bxe1; Bye2, Bxe2];
%% Jacobian expm tensor
J            = cat(3,[Ayy, Axy; Ayx, Axx],[Bye1, Bxe1; Bye2, Bxe2]);
%               |Bxy Bxx| 
% J(3x2x4)  =  |Byy Byx|       
%             |Axy Axx|
%            |Ayy Ayx|        
%% Saving parameters 
param.jacobian_expm.Inlayers      = Inlayers;
param.jacobian_expm.A             = A;
param.jacobian_expm.B             = B;
param.jacobian_expm.J             = J;
param.jacobian_expm.Aentries.Ayy  = Ayy;
param.jacobian_expm.Aentries.Ayx  = Ayx;
param.jacobian_expm.Aentries.Axx  = Axx;
param.jacobian_expm.Aentries.Axy  = Axy;
param.jacobian_expm.Bentries.Bye1 = Bye1;
param.jacobian_expm.Bentries.Bye2 = Bye2;
param.jacobian_expm.Bentries.Bxe1 = Bxe1;
param.jacobian_expm.Bentries.Bxe2 = Bxe2;
end
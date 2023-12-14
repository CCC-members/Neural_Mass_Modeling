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
% Nm_pop           = param.neural_mass.Nm_pop;
% Eye_Nm_pop  = eye(Nm_pop);
h               = param.physical_time.h;
a               = param.jansen_and_rit.PSP_parameters.a;
b               = param.jansen_and_rit.PSP_parameters.b;
bh             = b.*h;
exp_bh     = exp(bh);
b_exp_bh = b.*exp_bh;
%% Jacobian expm for [x;y] (Equation 16)
Ayy           = (1 + bh)./exp_bh - 1;
Axy           = -(b.*bh)./exp_bh;
Ayx           =  h./exp_bh;
Axx           = (1 - bh - exp_bh)./exp_bh;
A              = [Ayy, Axy; Ayx, Axx];
%% Jacobian expm for [e1,e2] (Equation 17)
Bye1        = a.*(exp_bh - bh - 1)./b_exp_bh;
Bye2        = a.*(2.*(1 - exp_bh) + bh.*(1 + exp_bh))./(bh.*b_exp_bh);
Bxe1        = a.*bh./exp_bh;
Bxe2        = a.*(exp_bh - bh - 1)./(bh.*exp_bh);
B              = [Bye1, Bxe1; Bye2, Bxe2];
%% Jacobian expm tensor (Equation 14)
J              = cat(3,[Ayy, Axy; Ayx, Axx],[Bye1, Bxe1; Bye2, Bxe2]);
%% Saving parameters 
% param.jacobian_expm.Eye_Nm_pop = Eye_Nm_pop;
param.jacobian_expm.A                      = A;
param.jacobian_expm.B                      = B;
param.jacobian_expm.J                       = J;
param.jacobian_expm.Aentries.Ayy    = Ayy;
param.jacobian_expm.Aentries.Ayx    = Ayx;
param.jacobian_expm.Aentries.Axx    = Axx;
param.jacobian_expm.Aentries.Axy    = Axy;
param.jacobian_expm.Bentries.Bye1  = Bye1;
param.jacobian_expm.Bentries.Bye2  = Bye2;
param.jacobian_expm.Bentries.Bxe1  = Bxe1;
param.jacobian_expm.Bentries.Bxe2  = Bxe2;
end
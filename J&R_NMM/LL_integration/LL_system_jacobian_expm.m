function param = LL_system_jacobian_expm(param)
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
H_sys         = param.system_network.spectral_response.H_sys;
nu_sys        = param.system_network.spectral_response.nu_sys;
Npop          = param.system_network.Npop;
%
Ayy           = zeros(Nlayers,Npop);
Axy           = zeros(Nlayers,Npop);
Ayx           = zeros(Nlayers,Npop);
Axx           = zeros(Nlayers,Npop);
A             = zeros(2*Nlayers,2,Npop);
Bye1          = zeros(Nlayers,Npop);
Bye2          = zeros(Nlayers,Npop);
Bxe1          = zeros(Nlayers,Npop);
Bxe2          = zeros(Nlayers,Npop);
B             = zeros(2*Nlayers,2,Npop);
J             = zeros(2*Nlayers,2,2,Npop);
for pop = 1:Npop
    H             = H_sys(:,pop);
    nu            = nu_sys(:,pop);
    %
    nuh           = nu.*h;
    exp_nuh       = exp(nuh);
    nu_exp_nuh    = nu.*exp_nuh;
    %% Jacobian expm for [x;y]
    Ayy(:,pop)    = (1 + nuh)./exp_nuh - 1;
    Axy(:,pop)    = -(nu.*nuh)./exp_nuh;
    Ayx(:,pop)    =  h./exp_nuh;
    Axx(:,pop)    = (1 - nuh - exp_nuh)./exp_nuh;
    A(:,:,pop)    = [Ayy(:,pop), Axy(:,pop); Ayx(:,pop), Axx(:,pop)];
    %% Jacobian expm for [e1,e2]
    Bye1(:,pop)   = H.*(exp_nuh - nuh - 1)./nu_exp_nuh;
    Bye2(:,pop)   = H.*(2.*(1 - exp_nuh) + nuh.*(1 + exp_nuh))./(nuh.*nu_exp_nuh);
    Bxe1(:,pop)   = H.*nuh./exp_nuh;
    Bxe2(:,pop)   = H.*(exp_nuh - nuh - 1)./(nuh.*exp_nuh);
    B(:,:,pop)    = [Bye1(:,pop), Bxe1(:,pop); Bye2(:,pop), Bxe2(:,pop)];
    %% Jacobian expm tensor
    J(:,:,:,pop)  = cat(3,[Ayy(:,pop), Axy(:,pop); Ayx(:,pop), Axx(:,pop)],[Bye1(:,pop), Bxe1(:,pop); Bye2(:,pop), Bxe2(:,pop)]);
    %               |Bxy Bxx|
    % J(3x2x4)  =  |Byy Byx|
    %             |Axy Axx|
    %            |Ayy Ayx|
    %% Saving parameters
    param.system_network.jacobian_expm.Inlayers      = Inlayers;
    param.system_network.jacobian_expm.A             = A;
    param.system_network.jacobian_expm.B             = B;
    param.system_network.jacobian_expm.J             = J;
    param.system_network.jacobian_expm.Aentries.Ayy  = Ayy;
    param.system_network.jacobian_expm.Aentries.Ayx  = Ayx;
    param.system_network.jacobian_expm.Aentries.Axx  = Axx;
    param.system_network.jacobian_expm.Aentries.Axy  = Axy;
    param.system_network.jacobian_expm.Bentries.Bye1 = Bye1;
    param.system_network.jacobian_expm.Bentries.Bye2 = Bye2;
    param.system_network.jacobian_expm.Bentries.Bxe1 = Bxe1;
    param.system_network.jacobian_expm.Bentries.Bxe2 = Bxe2;
end
end
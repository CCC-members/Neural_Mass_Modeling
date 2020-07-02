function param = unit_jansen_and_rit_param(param)
%% Basic properties of the Jansen and Rit model
%% Inputs
% param - empty structure
%%
%% Outputs
% Nlayers - number of neural layers 
% Pyr23 - Pyramidal layer 2 and 3 
% Inh23 - Inhibitory interneurons 2 and 3
% Ste4 - Spiny Stellate cells 
% e0 - Maximum of the sigmoid function
% v0 - Position of the threshold of the sigmoid function
% r  - Steepness of the sigmoid function
% C - interlayer coupling strength 
% Cmask - mask of coupling strength 
%% Defining Layers
Nlayers                              = 3;
Pyr23                                = 1;
Inh23                                = 2; 
Ste4                                 = 3; 
param.jansen_and_rit.layers.Nlayers  = Nlayers;
param.jansen_and_rit.layers.Pyr23    = Pyr23;  
param.jansen_and_rit.layers.Inh23    = Inh23;  
param.jansen_and_rit.layers.Ste4     = Ste4; 
%% Defining Sigmoid  
e0                                   = 2.5;
v0                                   = 6;
r                                    = 0.56;
param.jansen_and_rit.sigmoid.e0      = e0; 
param.jansen_and_rit.sigmoid.v0      = v0; 
param.jansen_and_rit.sigmoid.r       = r;
%% Defining interlayer coupling strength
C                                    = zeros(Nlayers, Nlayers);
%                                      |0  -c4 c3|
% C                                  = |c2  0  0 |
%                                      |c1  0  0 |
% Reference values for coupling strength
c                                    = 135; 
c1                                   = 1*c; 
c2                                   = 0.8*c; 
c3                                   = 0.25*c; 
c4                                   = 0.25*c;
% Filling coupling matrix C 
C(Ste4, Pyr23)                       = c1; 
C(Inh23, Pyr23)                      = c3; 
C(Pyr23, Ste4)                       = c2; 
C(Pyr23, Inh23)                      = -c4;
% Filling coupling matrix Cmask
Cmask                                = zeros(Nlayers,Nlayers);
Cmask(C~=0)                          = 1;
%% Saving parameters
param.jansen_and_rit.coupling.C      = C;
param.jansen_and_rit.coupling.Cmask  = Cmask;
end
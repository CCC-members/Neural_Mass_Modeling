function param = cortex_parameters(param)
%% Basic model parameters
%% Inputs:
% param: parameters from "model_param"
%% Outputs
% Nm: number of neural masses
% Pyr,Inh, Ste, Ret, Tha: neural masses involved in the model
% e0, v0,a0: sigmoid function parameters
% C(Nm x Nm): connectivity matrix

%% Defining Layers (Table 3)
Nm             = 3; 
Pyr             = 1;
Inh              = 2; 
Ste             = 3;
%% Defining Sigmoid  (Table 6)
e0               = 5;  %2.5;
v0                = 6;
a0                = 0.56;
%% Defining interlayer coupling strength (Equation 21)
C                 = zeros(Nm, Nm);
% Filling coupling matrix C 
C(Ste, Pyr) = 135;            
C(Inh, Pyr)  = 33.75;
C(Pyr, Ste) = 108;
C(Pyr, Inh)  = -33.75;
Cmask       = zeros(Nm,Nm);
Cmask(C~=0)  = 1;
%% Saving parameters
param.jansen_and_rit.neural_mass.Nm    = Nm;
param.jansen_and_rit.neural_mass.Pyr    = Pyr;  
param.jansen_and_rit.neural_mass.Inh     = Inh;  
param.jansen_and_rit.neural_mass.Ste    = Ste; 
param.jansen_and_rit.sigmoid.e0  = e0; 
param.jansen_and_rit.sigmoid.v0  = v0; 
param.jansen_and_rit.sigmoid.a0  = a0;
param.jansen_and_rit.connectivity_matrix.C   = C;
param.jansen_and_rit.connectivity_matrix.Cmask = Cmask;
end
function param = double_peak_probability_density(param)
%% Building a distributed delay tensor D3 via double-peak Nunez function  (Section 2.1 General model formulation)
%% Input: 
% param: parameters from "model_param", "physical_time_constants"
%% Outputs
% tau: time lags
% Ntau: number of lags
% D(Nm x Nm x Ntau): distributed-delay tensor

%% Loading parameters
% Nm           = param.jansen_and_rit.neural_mass.Nm;
Nm_pop  = param.neural_mass.Nm_pop;
h               = param.physical_time.h;
%% Building distributed delay
d               = 0.88;  % model distance in meters
n               = 4.5;   % Nunez parameters
% Case 1
a                     = 0.1;  % Nunez parameters
tau                  = 0:h:.5; % in seconds 
Ntau               = length(tau);
d                   = ((d./tau).^n.*exp(-a.*(d./tau))*d./tau.^2)*h; % Nunez function
d(1)                = 0;
d1                  = d./sum(d);      % single peak large connectivity
% Case 5
d4                  = zeros(1,Ntau);
d5                  = zeros(1,Ntau);
d6                  = zeros(1,Ntau);
d7                  = zeros(1,Ntau);
d8                  = zeros(1,Ntau);

d4(2:Ntau) = d1(1:Ntau-1);   % D=2
d5(4:Ntau) = d1(1:Ntau-3);   % D=4
d6(21:Ntau) = d1(1:Ntau-20);  %D=21
d7(42:Ntau) = d1(1:Ntau-41);  %D=42
d8(200:Ntau) = d1(1:Ntau-199);
% Case 6
D                    = 0.5*d4+0.5*d8;             % double peak large connectivity
Dn = normalize(D,'range');
% D                    = 0.5*d1+0.5*d5;             % double peak large connectivity
D           = repmat(reshape(D,1,1,Ntau),Nm_pop,Nm_pop,1);

%% Saving Parameters
param.connectivity_tensor.tau   = tau;
param.connectivity_tensor.Ntau = Ntau;
param.connectivity_tensor.D      = D;

end


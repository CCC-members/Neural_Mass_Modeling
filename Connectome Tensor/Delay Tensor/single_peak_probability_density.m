function param = single_peak_probability_density(param)
%% Building a distributed delay tensor D3 via single-peak Nunez function (Section 2.1 General model formulation)
%% Input: 
% param: parameters from "model_param", "physical_time_constants"
%% Outputs
% tau: time lags
% Ntau: number of lags
% D(Nm x Nm x Ntau): distributed-delay tensor

%% Loading parameters
Nm        = param.jansen_and_rit.neural_mass.Nm;
Nm_pop  = param.neural_mass.Nm_pop;
Ncc     = param.neural_mass.Ncc;
C       = param.jansen_and_rit.connectivity_matrix.C;
h       = param.physical_time.h;
%% Building distributed delay
dist    = 0.88;  % model distance in meters
n       = 4.5;   % Nunez parameter (peak)
a       = .1;    %original 0.6  % Nunez parameter (width)
a1      = .6;
tau     = h:h:.5; % in seconds 
Ntau    = length(tau);
d       = ((dist./tau).^n.*exp(-a.*(dist./tau))*dist./tau.^2)*h; % Nunez function
d1      = ((dist./tau).^n.*exp(-a1.*(dist./tau))*dist./tau.^2)*h; % Nunez function

d(1)   = 0;
d1(1) = 0;
d       = d./sum(d);      % single peak large connectivity
d_new   = zeros(1,Ntau);  
d_new(2:Ntau) = d(1:Ntau-1);  % to have the peak of the distribution in delay 2
d1      = d1./sum(d1);      % single peak large connectivity
d1_new   = zeros(1,Ntau);  
d1_new(2:Ntau) = d1(1:Ntau-1);  % to have the peak of the distribution in delay 2

Dsr     = repmat(reshape(d_new,1,1,Ntau),Nm_pop,Nm_pop,1);
D       = repmat(reshape(d1_new,1,1,Ntau),Nm_pop,Nm_pop,1);

%% Filing delays just for large connections
if Nm_pop~=3 || Nm_pop~=5
% Making delay zero in the JR connection positions
O       = ones(size(C));
Oc      = repmat({O}, 1, Ncc);
Out     = repmat(blkdiag(Oc{:}),1,1,Ntau);
ind     = find(Out);
Dsr     = Dsr.*Out;    % delays for JR connections
D(ind)  = 0; 
D       = Dsr+D;

% Making delay zero in the short connection positions
circ = @(x, N) (1 + mod(x-1, N));  % circular indexing
aux  = 1:1:Ncc;
for i=1:Ncc
    % connection to the left
    D(Nm*i,Nm*i-2,:)                    = d;   %in the same column
    D(Nm*i,Nm*(aux(circ(i-1,Ncc)))-2,:) = d;
    D(Nm*i,Nm*(aux(circ(i-2,Ncc)))-2,:) = d;
    D(Nm*i-2,Nm*i,:)                    = d;   %in the same column
    D(Nm*(aux(circ(i-1,Ncc)))-2,Nm*i,:) = d;
    D(Nm*(aux(circ(i-2,Ncc)))-2,Nm*i,:) = d;

    % connection to the right
    D(Nm*i,Nm*(aux(circ(i+1,Ncc)))-2,:) = d;
    D(Nm*i,Nm*(aux(circ(i+2,Ncc)))-2,:) = d;
    D(Nm*(aux(circ(i+1,Ncc)))-2,Nm*i,:) = d;
    D(Nm*(aux(circ(i+2,Ncc)))-2,Nm*i,:) = d;
end 
end
%% Saving Parameters
param.connectivity_tensor.tau  = tau;
param.connectivity_tensor.Ntau = Ntau;
param.connectivity_tensor.D    = D;
end
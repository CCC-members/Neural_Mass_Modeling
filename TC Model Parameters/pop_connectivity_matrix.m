function [param] = pop_connectivity_matrix(param)
%% Basic definitions of the Connectome Tensor for a population of neural mass model  
%% INccuts
% param - parameters from "unit_response_param"
%%
%% Outputs
% K0 (Nm x Nm): Connectivity matrix between cortical columns with different
% topologies
%% Loading parameters
Nm        = param.jansen_and_rit.neural_mass.Nm;
C           = param.jansen_and_rit.connectivity_matrix.C;

%% Defining population parameters
Ncc         = 1;                                              % number of cortical columns
Nm_pop = Nm*Ncc;                        % total number of neural masses in the simulation
% Short-range connections
Csr          = randi([6,7],1,Ncc);
% Large-range connections
Clr          = randi([30,50],1,Ncc);

%% Filling Connectivity matrix K0
K0 = zeros(Nm_pop); 
K0(1,Nm_pop) = Csr(Ncc);
K0(Nm_pop,1) = Csr(Ncc);

for i=1:Ncc-1
    K0(Nm*i+1,Nm*i) = Csr(i);
    K0(Nm*i,Nm*i+1) = Csr(i);
end

% Adding JR connectivity matrix into K0
O           = ones(size(C));
Oc         = repmat({O}, 1, Ncc);  
Out        = blkdiag(Oc{:});
ind         = find(Out);
K0(ind) =0;
Cjr         = repmat({C},1,Ncc);
Cblk      = blkdiag(Cjr{:}) ;
K0         = K0+Cblk;

% %% Creating Connectivity Matrix between cortical columns
% % Short range connexions via Exponential function
% x                                                      = 1:1:Ncc;
% C_sr                                               = 2*exp(-abs(x)./8); % Babajani and soltanian-zadeh, 2006
% % C_lr                                                = randi([0,1],1,n_lr).*(rand(1,n_lr)>.8); % Large range connections (randomly determined)
% C_lr                                                = 10+(30-10).*rand(1,Ncc);  % Large range connections (randomly determined)
% % Filling the general Connectivity Matrix (K0)
% con_vect                                        = zeros(Nm_pop,1); % connectivity vector
% con_vect(2:1+Ncc)                      = C_sr;
% con_vect(2+Ncc:Nm_pop-Ncc) = C_lr;
% con_vect(Nm_pop-Ncc+1:end)  = C_sr;
% K0                                                   = toeplitz(con_vect); % The SW network: A "small world" type of networking 
% 
% con_vect(2+Ncc:Nm_pop-Ncc) = zeros(1,Ncc);
% K0                                                   = toeplitz(con_vect); %The NN network: This type of network comprises only short-range without large-range connectivity 
%  
% con_vect(2+Ncc:end)                   = 10+(30-10).*rand(1,Nm_pop-1-Ncc);
% K0                                                    = toeplitz(con_vect);   %The FC network: A fully connected graph

%% Saving parameters
param.connectivity_matrix.K0 = K0;
param.neural_mass.Ncc          = Ncc;
param.neural_mass.Nm_pop = Nm_pop;
end


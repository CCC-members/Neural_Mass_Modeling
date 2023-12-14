function [param] = FC_connectivity_topology(param)
%% Basic definitions of the Connectome Tensor for a population of neural mass model  
%% Inputs
% param - parameters from "unit_response_param"
%%
%% Outputs
% K0 (Nm x Nm): Connectivity matrix between cortical columns with different
% topologies
%% Loading parameters
Nm        = param.jansen_and_rit.neural_mass.Nm;
C           = param.jansen_and_rit.connectivity_matrix.C;

%% Defining population parameters
Ncc = 4;
Nm_pop = Nm*Ncc;                        % total number of neural masses in the simulation
if rem(Ncc, 2) == 0
     sr = (floor(Nm_pop/2-Nm));
     lr = floor((Nm_pop-2*sr)/2); % number of sample points for the long range connectivity
else
    sr = (floor(Nm_pop/2-Nm-1));
    lr = floor((Nm_pop-2*sr-Nm)/2); % number of sample points for the long range connectivity
end
%% Creating Connectivity Matrix between cortical columns
% Short range connexions via Exponential function
x                           = 1:1:sr;
y                               =  1:1:lr;
Csr                        = exp(-abs(x)./8); % Babajani and soltanian-zadeh, 2006
Clr                        = sort(randi([3,5],1,lr)).*exp(-abs(y)./8); % Large range connections (randomly determined)
% Filling the general Connectivity Matrix (K0)
con_vect                    = zeros(Nm_pop,1); % connectivity vector
if rem(Ncc, 2) == 0
con_vect(1:sr)          = Csr;
con_vect(sr+1:sr+lr) = sort(Clr);
con_vect(sr+lr+1:Nm_pop-sr) = sort(Clr,'ascend');
else 
    con_vect(Nm+1:Nm+sr)          = Csr;
    con_vect(Nm+sr+1:Nm+sr+lr) = sort(Clr);
    con_vect(Nm+sr+lr+1:Nm_pop-sr) = sort(Clr,'ascend');
end
con_vect(Nm_pop-sr+1:Nm_pop)  = sort(Csr,'ascend');
K0                          = toeplitz(con_vect); %The FC network: A fully connected graph

% Adding JR connectivity values into K0
 for i=1:Ncc
    K0(Nm*i-1,:) = 0;
    K0(:,Nm*i-1) = 0;
end
O           = ones(size(C));
Oc         = repmat({O}, 1, Ncc);  
Out        = blkdiag(Oc{:});
ind         = find(Out);
K0(ind) =0;
Cjr         = repmat({C},1,Ncc);
Cblk      = blkdiag(Cjr{:}) ;
K0         = K0+Cblk;

%% Saving parameters
param.connectivity_matrix.K0 = K0;
param.neural_mass.Ncc          = Ncc;
param.neural_mass.Nm_pop = Nm_pop;
end


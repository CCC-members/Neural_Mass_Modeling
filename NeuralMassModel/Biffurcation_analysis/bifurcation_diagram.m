function param = bifurcation_diagram(param)
%% Input


%% Output


%% Parameters
taumax  = param.physical_time.taumax;
h       = param.physical_time.h;
sigma0  = param.physical_time.sigma0;
Nlayers = param.jansen_and_rit.layers.Nlayers;
C       = param.alpha_procces.C;
Ntau    = param.connectivity_tensor.Ntau;

%% Initialization
        Y = zeros(Nlayers,Nt);
        X = zeros(Nlayers,Nt);
        Z = zeros(Nlayers,Nt);
%% Distribution
for tau0 = 0.60:0.0046:0.88
    for sigma0 = 0.0025:0.0001:0.0084
        tau     = (0:1:(floor(taumax/h)-1))*h;
        d= exp(-((tau-tau0)./sigma0).^2);
        Ctensor = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
        %% LL integration
       [Y,X,Z,param] = LL_singleunit_integration(Y,X,Z,Ctensor,param);
        Fig1           = plot3(Y(1,:),Y(2,:),Y(3,:));
        
        title('Oscillatory Behavior');
        title('EEG Signal')
        hold on
    end
end
end
%%
function [fig] = bif_diagram(param)
%% Parameters
taumax  = param.physical_time.taumax;
h       = param.physical_time.h;
sigma0  = param.physical_time.sigma0;
Nlayers = param.jansen_and_rit.layers.Nlayers;
C       = param.alpha_procces.C;
Ntau    = param.connectivity_tensor.Ntau;
Tmax                              = param.physical_time.Tmax;
Nt                                = floor(Tmax/h);
for tau0 = 0.001:0.1:0.995
    %% Initial iteration
    Y = zeros(Nlayers,Nt);
    X = zeros(Nlayers,Nt);
    Z = zeros(Nlayers,Nt);
    for i=1:5
        tau           = (0:1:(floor(taumax/h)-1))*h;
        d             = exp(-((tau-tau0)./sigma0).^2);
        Ctensor       = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
        [Y,X,Z,param] = LL_singleunit_integration(Y,X,Z,Ctensor,param);
    end
    for i=1:3
        tau           = (0:1:(floor(taumax/h)-1))*h;
        d             = exp(-((tau-tau0)./sigma0).^2);
        Ctensor       = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
        [Y(i+1),X(i+1),Z(i+1),param] = LL_singleunit_integration(Y(i),X(i),Z(i),Ctensor(i),param);
        plot(tau0*ones(Nlayers,1), Y, '.', 'markersize', 2);
        hold on;
    end
    title('Bifurcation diagram of the logistic map');
    xlabel('tau0');  ylabel('Y_n');
    set(gca, 'xlim', [0.001 0.995]);
    hold off;
    
end

end
%%
%%   Parameters
taumax  = param.physical_time.taumax;
h       = param.physical_time.h;
Nlayers = param.jansen_and_rit.layers.Nlayers;
C       = param.alpha_procces.C;
Ntau    = param.connectivity_tensor.Ntau;
Tmax                              = param.physical_time.Tmax;
Nt                                = floor(Tmax/h);

%% Initialization
Y = zeros(Nlayers,Nt);
X = zeros(Nlayers,Nt);
Z = zeros(Nlayers,Nt);
sigma0 = [0.001  0.4970];
for tau0 = [0.001:0.1:0.995];
    tau           = (0:1:(floor(taumax/h)-1))*h;
    d             = exp(-((tau-tau0)./sigma0(1)).^2);
    Ctensor       = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
    [Y_s1,X_s1,Z,param] = LL_singleunit_integration(Y,X,Z,Ctensor,param);
end

for tau0 = [0.001:0.1:0.995];
    tau           = (0:1:(floor(taumax/h)-1))*h;
    d             = exp(-((tau-tau0)./sigma0(2)).^2);
    Ctensor       = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
    [Y_s2,X_s2,Z,param] = LL_singleunit_integration(Y,X,Z,Ctensor,param);
end

tau0 = [0.001 0.995];
for sigma0 = [0.001:0.1:0.4970];
    tau           = (0:1:(floor(taumax/h)-1))*h;
    d             = exp(-((tau-tau0(1))./sigma0).^2);
    Ctensor       = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
    [Y_t1,X_t1,Z,param] = LL_singleunit_integration(Y,X,Z,Ctensor,param);
end

for sigma0 = [0.001:0.1:0.4970];
    tau           = (0:1:(floor(taumax/h)-1))*h;
    d             = exp(-((tau-tau0(2))./sigma0).^2);
    Ctensor       = repmat(C,1,1,Ntau).*repmat(reshape(d,1,1,Ntau),Nlayers,Nlayers,1);
    [Y_t2,X_t2,Z,param] = LL_singleunit_integration(Y,X,Z,Ctensor,param);
end

%% Bifurcation Diagrams
figure
subplot(4,1,1)
plot (Y_s1, '-');
title('Bifurcation Diagram for sigma0 = 0.001')
xlabel('tau0 = 0.001:0.995')
xlim([0.5 3.5])
ylabel('Y')
ylim([-10 10])
subplot(4,1,2)
plot (Y_s2, '-');
title('Bifurcation Diagram for sigma0 = 0.001')
xlabel('tau0 = 0.001:0.995')
xlim([0.5 3.5])
ylabel('Y')
ylim([-1 3.5])
subplot(4,1,3)
plot (Y_t1, '-');
title('Bifurcation Diagram for tau0 = 0.001')
xlabel('sigma0 = 0.001:0.4970')
xlim([0.5 3.5])
ylabel('Y')
ylim([-1 3.5])
subplot(4,1,4)
plot (Y_t2, '-');
title('Bifurcation Diagram for tau0 = 0.995')
xlabel('sigma0 = 0.001:0.4970')
xlim([0.5 3.5])
ylabel('Y')
ylim([-1 3.5])




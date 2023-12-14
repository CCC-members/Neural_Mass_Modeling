function [figures] = model_plot(Z,param)
%% 
%%  Inputs
% param: parameters from "model_physical_time"
%% Outputs
% figures:  time series, dynamics and spectra of the model
% peak: alpha peak values obtained from the spectra

%% Loading parameters
h      = param.physical_time.h;
Nt     = param.physical_time.Nt;
Ncc    = param.neural_mass.Ncc;   
tspan  = param.physical_time.tspan;
tspan1 = tspan(2000:end);

% Ne        = 3000; % Number of selected elements
% % Zp         = reshape(Z(1,:),Nunit,Nt); 
% pp         = length(Z)-Ne; % possible possitions
% Znp       = zeros(Nunit,Ne);
%     for cc=1:Ncc
%         Rip             = randi(pp); % random initial possition
%         Rip_val(cc,1) = Rip; % vector with all random initial possition
%         Fp              = Rip+Ne-1;   % final point of the new time serie
%         Znp(cc,:)     = Zp(cc,Rip:Fp);
%     end
%    save Rip_val;
% tspan_unsync = tspan(1:Ne);


if size(Z,1)<=5
Act    = Z(1,2000:end);
% Act = Act'-mean(Act');
else
    G = zeros(Ncc,Nt);
    for i=1:Ncc
        G(i,:) = Z(3*i+1);
    end
Act    =  mean(Z(:,2000:end),1);
end
Act = Act'-mean(Act');

%% Ploting EEG signal
fig1 =  figure;
% subplot(2,2,[1,2])
plot(tspan1,Act,'b','LineWidth',1);
xlabel('time(s)')
ylabel('activation')
title('EEG simulation')
% subplot(212)
% TFR = morletcwt(transpose(Act), 3:0.5:20, 1/h, 9);
% TFR = log(1 + transpose(abs(squeeze(mean(TFR,3)))));
% imagesc(tspan1, 3:0.5:20, TFR); axis xy
% xlabel('time(s)')
% ylabel('Wavelets coefficients')
% title('Wavelet Spectrum')

%% Ploting the NMM
fig2 = figure;
% subplot(2,2,3)
plot3(Z(1,2500:end),Z(2,2500:end),Z(3,2500:end),'b','LineWidth',1.5);
xlabel('Pyramidal cell')
ylabel('Inhibitory cell')
zlabel('Stellate cell')
title('Unit oscillatory Behavior')

%% PSD estimation
% PSD estimate via the Thomson multitaper method (MTM).
% nw el half bandwidth product 
% f frecuencias del expectro
% fs = 1./h frecuencia de muestreo
% T = Nfft * Ts     tiempo de analais de los segemtmnos de fft,Ts es el periodo de muestreo
% [PSD,F] = pmtm(Act',2.5,200,1./h);

% Chronux
params.Fs     = 1000;
params.tapers = [1,2];%[6 11];
params.fpass  = [0 50];
params.pad    = 0;
params.err    = [1 0.05];
[S,f]         = mtspectrumc(Act,params);
S_mean        = mean(S,2);
fig3 = figure;
% subplot(2,2,4)
plot_vector(S_mean(10:end),f(10:end),[],[],'b',1.5);

% fig=gcf;
% dataObjs = findobj(fig,'-property','YData');
% x1    = dataObjs(1).XData;
% y1    =  dataObjs(1).YData;
% max_y1 =max(y1);
% y1_max_ind =  find(y1==max_y1);
% x1_max_ind = x1(y1_max_ind);
% 
% peak =zeros(1,2);
% peak(1,1) = x1_max_ind;
% peak(1,2) = max_y1;

xlabel('frequency (Hz)')
ylabel('psd coefficients')
title('Power Spectral Density')

%%
% figure
% TFR = morletcwt(Act', 3:0.5:20, 1/h, 7);
% imagesc(tspan, 3:0.5:20, abs(TFR).^2'); axis xy
% 
% window=2.56/h;
% m = floor(Nt./window);
% figure
% Act=reshape(Act(2000:m*window),window,m);
% s=mean(abs(fft(Act)).^2,2);
% T=window*h;
% df=1/T;    %resolucion spectral
% f=0:df:200;
% f=f(2:end);s=s(2:end);
% semilogy(f,s(2000:end));
%%


figures = [fig1 fig2 fig3];

end

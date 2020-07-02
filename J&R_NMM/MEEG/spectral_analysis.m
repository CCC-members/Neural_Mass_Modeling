function [figures,param] = spectral_analysis(Y,Z,param)
% Parameters
h      = param.physical_time.h;
tspan  = param.physical_time.tspan;
tspan1 = tspan(1000:end);
Act    = squeeze(Z(1,:,:));
Act    = Act(:,1000:end);
%% Ploting EEG signal
fig1 = figure;
subplot(211)
plot(tspan1,Act)
xlabel('time(s)')
ylabel('activation')
title('EEG simulation')
subplot(212)
TFR = morletcwt(transpose(Act), 3:0.5:20, 1/h, 9);
TFR = log(1 + transpose(abs(squeeze(mean(TFR,3)))));
imagesc(tspan1, 3:0.5:20, TFR); axis xy
xlabel('time(s)')
ylabel('Wavelets coefficients')
title('Wavelet Spectrum')
%% Ploting the NMM
fig2 = figure;
if length(size(Z))==2
    plot3(Y(1,:),Y(2,:),Y(3,:));
    xlabel('Pyramidal cell')
    ylabel('Inhibitory cell')
    zlabel('Stellate cell')
    title('Unit oscillatory Behavior')
else
    Y     = permute(Y,[2 1 3]);
    Y1    = Y(:,1,1);
    Y2    = Y(:,2,1);
    Y3    = Y(:,3,1);
    g     = scatter3(Y1,Y2,Y3,'Or') ;
    for time = 2:size(Y,3)
        Y1    = Y(:,1,time);
        Y2    = Y(:,2,time);
        Y3    = Y(:,3,time);
        set(g,'XData',Y1,'YData',Y2,'ZData',Y3) ;
        drawnow
        pause(0.005)
        xlabel('Pyramidal cell')
        ylabel('Inhibitory cell')
        zlabel('Stellate cell')
        title('Population dynamics')
    end
end
%% PSD estimation
% PSD estimate via the Thomson multitaper method (MTM).
fig3 = figure;
[PSD,F] = pmtm(Act',10,200,1./h);
PSD     = mean(PSD,2);
semilogy(F,PSD);xlim([0 50]);
xlabel('frequency (Hz)')
ylabel('psd coefficients')
title('Power Spectral Density')
%%
figures = [...
    ...
    ...
    ];
end


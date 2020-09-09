function [figures,param] = system_spectral_analysis(Y,Z,param)
%% Parameters
h         = param.physical_time.h;
tspan     = param.physical_time.tspan;
Npop      = param.system_network.Npop;
Index_pop = param.system_network.Index_pop;
%%
%% Segment of equilibria 
Nt0       = 1000;
tspan     = tspan(Nt0:end);
Act       = squeeze(Z(1,:,:));
Act       = Act(:,Nt0:end);

%% Wavelet morlet
TFR       = morletcwt(transpose(Act), 3:0.5:20, 1/h, 9);
%% Ploting signal
figure;
set(gcf,'Position',[0 50 3000 400]);
subplot(2,5,1)
plot(tspan,squeeze(Act(Index_pop{1},:)))
title('gamma time-frequency')
xlim([min(tspan) max(tspan)]);
xlabel('time'); ylabel('activation');


subplot(2,5,2)
plot(tspan,squeeze(Act(Index_pop{2},:)))
title('beta time-frequency')
xlim([min(tspan) max(tspan)]);
xlabel('time'); ylabel('activation');


subplot(2,5,3)
plot(tspan,squeeze(Act(Index_pop{3},:)))
title('alpha time-frequency')
xlim([min(tspan) max(tspan)]);
xlabel('time'); ylabel('activation');

subplot(2,5,4)
plot(tspan,squeeze(Act(Index_pop{4},:)))
title('theta time-frequency')
xlim([min(tspan) max(tspan)]);
xlabel('time'); ylabel('activation');

subplot(2,5,5)
plot(tspan,squeeze(Act(Index_pop{5},:)))
title('delta time-frequency')
xlim([min(tspan) max(tspan)]);
xlabel('time'); ylabel('activation');


subplot(2,5,6)
TFRpop = log(1 + transpose(abs(squeeze(mean(TFR(Index_pop{1},:,:),3)))));
imagesc(tspan, 3:0.5:20, TFRpop); 
xlabel('time'); ylabel('wavelet psd');
axis xy

subplot(2,5,7)
TFRpop = log(1 + transpose(abs(squeeze(mean(TFR(Index_pop{2},:,:),3)))));
imagesc(tspan, 3:0.5:20, TFRpop); 
xlabel('time'); ylabel('wavelet psd');
axis xy

subplot(2,5,8)
TFRpop = log(1 + transpose(abs(squeeze(mean(TFR(Index_pop{3},:,:),3)))));
imagesc(tspan, 3:0.5:20, TFRpop); 
xlabel('time'); ylabel('wavelet psd');
axis xy

subplot(2,5,9)
TFRpop = log(1 + transpose(abs(squeeze(mean(TFR(Index_pop{4},:,:),3)))));
imagesc(tspan, 3:0.5:20, TFRpop); 
xlabel('time'); ylabel('wavelet psd');
axis xy

subplot(2,5,10)
TFRpop = log(1 + transpose(abs(squeeze(mean(TFR(Index_pop{5},:,:),3)))));
imagesc(tspan, 3:0.5:20, TFRpop); 
xlabel('time'); ylabel('wavelet psd');
axis xy

%% PSD estimation
% PSD estimate via the Thomson multitaper method (MTM).
[PSD,F] = pmtm(Act',10,200,1./h);
figure;
set(gcf,'Position',[0 500 3000 200]);

subplot(1,5,1)
PSDpop  = mean(PSD(:,Index_pop{1}),2);
semilogy(F,PSDpop);xlim([0 50]);
title('gamma thomson psd')

subplot(1,5,2)
PSDpop  = mean(PSD(:,Index_pop{2}),2);
semilogy(F,PSDpop);xlim([0 50]);
title('beta thomson psd')

subplot(1,5,3)
PSDpop  = mean(PSD(:,Index_pop{3}),2);
semilogy(F,PSDpop);xlim([0 50]);
title('alpha thomson psd')

subplot(1,5,4)
PSDpop  = mean(PSD(:,Index_pop{4}),2);
semilogy(F,PSDpop);xlim([0 50]);
title('theta thomson psd')

subplot(1,5,5)
PSDpop  = mean(PSD(:,Index_pop{5}),2);
semilogy(F,PSDpop);xlim([0 50]);
title('delta thomson psd')

%% Ploting the NMM
Y     = permute(Y,[2 1 3]);
Y11 = Y(Index_pop{1},1,1); Y12 = Y(Index_pop{2},1,1); Y13 = Y(Index_pop{3},1,1); Y14 = Y(Index_pop{4},1,1); Y15 = Y(Index_pop{5},1,1);
Y21 = Y(Index_pop{1},2,1); Y22 = Y(Index_pop{2},2,1); Y23 = Y(Index_pop{3},2,1); Y24 = Y(Index_pop{4},2,1); Y25 = Y(Index_pop{5},2,1);
Y31 = Y(Index_pop{1},3,1); Y32 = Y(Index_pop{2},3,1); Y33 = Y(Index_pop{3},3,1); Y34 = Y(Index_pop{4},3,1); Y35 = Y(Index_pop{5},3,1);
figure
set(gcf,'Position',[0 750 3000 300]);
subplot(1,5,1)
g1  = scatter3(Y11,Y21,Y31,'Or');
title('gamma dynamics')
subplot(1,5,2)
g2  = scatter3(Y12,Y22,Y32,'Or');
title('beta dynamics')
subplot(1,5,3)
g3  = scatter3(Y13,Y23,Y33,'Or');
title('alpha dynamics')
subplot(1,5,4)
g4  = scatter3(Y14,Y24,Y34,'Or');
title('theta dynamics')
subplot(1,5,5)
g5  = scatter3(Y15,Y25,Y35,'Or');
title('delta dynamics')
for time = 2:size(Y,3)
    Y11 = Y(Index_pop{1},1,time); Y12 = Y(Index_pop{2},1,time); Y13 = Y(Index_pop{3},1,time); Y14 = Y(Index_pop{4},1,time); Y15 = Y(Index_pop{5},1,time);
    Y21 = Y(Index_pop{1},2,time); Y22 = Y(Index_pop{2},2,time); Y23 = Y(Index_pop{3},2,time); Y24 = Y(Index_pop{4},2,time); Y25 = Y(Index_pop{5},2,time);
    Y31 = Y(Index_pop{1},3,time); Y32 = Y(Index_pop{2},3,time); Y33 = Y(Index_pop{3},3,time); Y34 = Y(Index_pop{4},3,time); Y35 = Y(Index_pop{5},3,time);
    set(g1,'XData',Y11,'YData',Y21,'ZData',Y31);
    set(g2,'XData',Y12,'YData',Y22,'ZData',Y32);
    set(g3,'XData',Y13,'YData',Y23,'ZData',Y33);
    set(g4,'XData',Y14,'YData',Y24,'ZData',Y34);
    set(g5,'XData',Y15,'YData',Y25,'ZData',Y35);
    drawnow
    pause(0.005)
end

%%
figures = [...
    ...
    ...
    ];
end


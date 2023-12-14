function [fig] = ex_plot_spectra(Z,param)
% Loading parameters
h      = param.corticothalamic.physical_time.h;
tspan  = param.corticothalamic.physical_time.tspan;

tspan1 = tspan(2000:end);
Act    = squeeze(Z(1,:,:));
Act    = Act(:,2000:end);

window = 32768/4;
fs = 1/h; % frecuencia de muestreo
df = 1/(window*h); %resolucion spectral
f  = df:df:200;
% [pxx,f] = pwelch(Act',window,0,f,fs);
% [pxx,f] = pburg(Act',window,f,fs);
% semilogy(f(33:1613),pxx(33:1613))

Nt = length(Act);
m = floor(Nt./window);
x = reshape(Act(1:m*window),window,m);
s = mean(abs(fft(x)).^2,2);
fig = figure;
semilogy(s(2000:end))
end
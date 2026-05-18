% Yhean Fernandez
& Jeremias Olivares
&Benjamin Arango

% =========================================================================
% Laboratorio Presencial: Modulación FSK
% Transformada de Fourier de la envolvente compleja g(t)
%Actividad laboratorio
% =========================================================================
clear; clc; close all;

%% 1. Parámetros de Simulación
R = 100;             % Tasa de bits (100 bps)
Tb = 1/R;            % Tiempo de bit
fs = 10000;          % Frecuencia de muestreo (Hz)
N_bits = 30;         % Cantidad de bits a simular
t = 0:1/fs:(N_bits*Tb)-(1/fs); % Vector de tiempo

Ac = 1;              % Amplitud
Delta_f = 500;       % Desviación de frecuencia (Hz)

%% 2. Generación de m(t) y la envolvente compleja g(t)
% FSK requiere una señal modulante polar (-1 y 1) para subir y bajar la frecuencia
bits = randi([0 1], 1, N_bits); 
m_unipolar = repelem(bits, fs*Tb); 
m_polar = 2*m_unipolar - 1; % Conversión a polar (-1 a 1)

% Cálculo de la integral de m(t) usando suma acumulativa
integral_m = cumsum(m_polar) / fs;

% Envolvente compleja g(t) según la ecuación teórica de FM/FSK
g_t = Ac .* exp(1j * 2 * pi * Delta_f * integral_m);

%% 3. Transformada de Fourier de g(t)
N = length(g_t);
f_axis = (-N/2:N/2-1)*(fs/N); % Eje de frecuencias centrado en 0
G_f = fftshift(fft(g_t)) / N; % FFT

%% 4. Gráfica para el informe
figure('Name', 'Espectro de la Envolvente Compleja FSK');
plot(f_axis, 10*log10(abs(G_f).^2), 'b', 'LineWidth', 1.5); % Graficado en dB para emular un analizador de espectro

title('Transformada de Fourier de la Envolvente Compleja g(t) para FSK');
xlabel('Frecuencia (Hz)');
ylabel('Densidad Espectral de Potencia (dB)');
xlim([-1500 1500]); grid on;

% Líneas de los picos teóricos (Marca y Espacio)
xline(-Delta_f, '-g', 'Espacio (-\Delta f)', 'LabelVerticalAlignment', 'bottom');
xline(Delta_f, '-g', 'Marca (+\Delta f)', 'LabelVerticalAlignment', 'bottom');

% Líneas del Ancho de Banda Teórico (Regla de Carson)
BW_carson = 2*(Delta_f + R);
xline(-(BW_carson/2), '--r');
xline((BW_carson/2), '--r');
legend('Espectro g(t)', 'Frecuencias \pm \Delta f', 'Límites Regla de Carson');

%==========================================================================

% =========================================================================
% Transformada de Fourier de la envolvente compleja g(t) - Modulación OOK
% Actividad Previa
% =========================================================================
clear; clc; close all;

%% Parámetros
R = 10;              % Tasa de bits (bits por segundo)
Tb = 1/R;            % Tiempo de bit (s)
fs = 1000 * R;       % Frecuencia de muestreo
N_bits = 20;         % Número de bits simulados
t = 0:1/fs:(N_bits*Tb)-(1/fs); 

Ac = 1;              % Amplitud de la portadora

%% Generación de g(t)
bits = randi([0 1], 1, N_bits); % Generación de datos
m_t = repelem(bits, fs*Tb);     % Tren de pulsos unipolar
g_t = Ac .* m_t;                % Envolvente compleja

%% Transformada de Fourier
N = length(g_t);
f_axis = (-N/2:N/2-1)*(fs/N); 
G_f = fftshift(fft(g_t)) / N; 

%% Gráfica
figure('Name', 'Espectro Banda Base');
plot(f_axis, abs(G_f), 'b', 'LineWidth', 1.5);
title('Transformada de Fourier de la Envolvente Compleja g(t)');
xlabel('Frecuencia (Hz)'); ylabel('Magnitud |G(f)|');
xlim([-30 30]); grid on;

% Líneas de los nulos teóricos
xline(-R, '--r', 'Nulo Inferior (-R)');
xline(R, '--r', 'Nulo Superior (+R)');

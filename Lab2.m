%% LABORATORIO 2: ISI - ACTIVIDADES PREVIAS
clc; clear; close all;

% Parámetros definidos
f0 = 1;              % Ancho de banda a 6dB (Nyquist)
Ts = 1/(2*f0);       % Tiempo de muestreo óptimo (según teoría)
alphas = [0, 0.25, 0.75, 1];
t = 0:0.001:5;       % t >= 0 (según guía)
f = -2*f0:0.001:2*f0; % Rango de frecuencia [-2B, 2B]

% Configuración visual
figure('Name', 'Filtro Coseno Alzado', 'Position', [100, 100, 900, 600]);
colores = {'b', 'r', '#77AC30', 'k'}; % Azul, Rojo, Verde, Negro

for i = 1:length(alphas)
    a = alphas(i);
    f_delta = a * f0;
    f1 = f0 - f_delta;
    B_abs = f0 + f_delta;

    % --- 1. Respuesta al Impulso he(t) ---
    term1 = 2*f0 * sinc(2*f0*t); % Recordar que en MATLAB sinc(x) = sin(pi*x)/(pi*x)
    term2 = zeros(size(t));
    
    for k = 1:length(t)
        denominador = 1 - (4 * f_delta * t(k))^2;
        % Manejo seguro de la singularidad matemática (división por 0)
        if abs(denominador) < 1e-6 
            term2(k) = pi / 4; % Aplicación de regla de L'Hôpital
        else
            term2(k) = cos(2*pi*f_delta*t(k)) / denominador;
        end
    end
    he = term1 .* term2;

    % --- 2. Respuesta en Frecuencia He(f) ---
    He = zeros(size(f));
    for k = 1:length(f)
        abs_f = abs(f(k));
        if abs_f < f1
            He(k) = 1;
        elseif abs_f >= f1 && abs_f <= B_abs
            He(k) = 0.5 * (1 + cos( (pi*(abs_f - f1)) / (2*f_delta) ));
        else
            He(k) = 0;
        end
    end

    % --- Graficación ---
    subplot(2,1,1);
    plot(t, he, 'Color', colores{i}, 'LineWidth', 1.5); hold on;
    
    subplot(2,1,2);
    plot(f, He, 'Color', colores{i}, 'LineWidth', 1.5); hold on;
end

% Ajustes estéticos Gráfico 1
subplot(2,1,1);
title('Respuesta al Impulso h_e(t)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Tiempo (s)'); ylabel('Amplitud');
grid on; 
xline(Ts, '--m', 'Ts (Muestreo)', 'LabelVerticalAlignment', 'bottom'); % Marca de cruce por cero
legend('\alpha = 0', '\alpha = 0.25', '\alpha = 0.75', '\alpha = 1');

% Ajustes estéticos Gráfico 2
subplot(2,1,2);
title('Respuesta en Frecuencia H_e(f)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frecuencia (Hz)'); ylabel('Amplitud');
grid on; 
legend('\alpha = 0', '\alpha = 0.25', '\alpha = 0.75', '\alpha = 1');



%Parte 2 ACT:

%% LABORATORIO 2: ISI - DIAGRAMAS DE OJO
clc; clear; close all;

% Parámetros solicitados
% Parámetros solicitados

numBits = 10000; % 10^4 bits (NRZ-L)

sps = 8; % Muestras por símbolo (Frecuencia de muestreo)

span = 10; % Longitud del filtro generador en símbolos

SNR_dB = 15; % Nivel de ruido del canal AWGN (puedes variarlo)          

alphas = [0, 0.25, 0.75, 1];

bits = randi([0 1], numBits, 1);
simbolos_NRZL = 2*bits - 1; 

for i = 1:length(alphas)
    a = alphas(i);
    
    % 2. Diseño del Filtro
    h = rcosdesign(a, span, sps, 'normal');
    h = h / max(h); 
    
    % 3. Transmisión
    tx_signal = upfirdn(simbolos_NRZL, h, sps);
    
    % 4. Canal AWGN
    rx_signal = awgn(tx_signal, SNR_dB, 'measured');
    
    % 5. Compensación del retardo original (¡esto alinea el pico perfecto!)
    retardo = span * sps / 2;
    senal_valida = rx_signal(retardo + 1 : end - retardo);
    
    % 6. Generación del Diagrama de Ojo
    % Usamos sps (1 símbolo), 1 (periodo) y 0 (CERO offset)
    hFig = eyediagram(senal_valida(1:2000), sps, 1, 0);
    
    % --- Ajuste del eje X de 0 a 1 ---
    lineas = findobj(hFig, 'Type', 'line');
    for k = 1:length(lineas)
        lineas(k).XData = lineas(k).XData + 0.5;
    end
    set(gca, 'XLim', [0 1]); 
    
    % Estética
    set(hFig, 'Name', sprintf('Diagrama de Ojo (alpha = %.2f)', a));
    title(sprintf('Diagrama de Ojo con \\alpha = %.2f', a), 'FontSize', 12);
end

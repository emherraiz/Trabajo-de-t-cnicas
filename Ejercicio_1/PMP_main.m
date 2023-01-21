%% Pontraygin's Minimum Principle

%% Initialization
% Definimos bien los ciclos, donde tomaremos medidas en cada instante de
% tiempo

% Cargamos todos los archivos de la UDDS (datos de los dinamometros de
% conduccion urbana)
load('UDDS_drive_cycle.mat');

% Los siguientes datos son los correspondientes a cada ciclo:
% ts es la tasa de cambio en el tiempo, es decir, el tiempo de muestreo
Cycle.ts = 1;

% Cantidad de veces que realizamos el ciclo, esto se corresponde con el
% tiempo donde realizamos cada una de las mediciones.
% Para ello tenemos el tiempo discretizado de manera equidistintante
Cycle.N = length(t);

% Datos recogidos en cada t
Cycle.P_dem = P_dem';

%% Battery Inputs
% Datos recogidos en la batería

% Potencia máxima
Bat.P_max = 15; % Medido en kW (kilovatios, es decir Julios por segundo)

% Se establecen los límites inferiores y superiores del estado de carga (SOC) de la batería
Bat.lb_SOC = 0.3;       Bat.ub_SOC = 0.8;

% Se establecen los límites inferiores y superiores de la potencia suministrada de la batería
Bat.lb_P   = 0.1*Bat.P_max;   Bat.ub_P   = 0.9*Bat.P_max;

% Voltaje de circuito abierto de la batería.
Bat.U_oc = 320; % Medido en V (voltios)

% Capacidad de la batería
Bat.Q_bat = 18000; % Medido en Ah (Amperios por hora)

% Resistencia interna de la batería
Bat.R0_B = 0.001; % in Ohm

% Creamos provisinalmente un vector de ceros. Aquí almacenaremos la
% potencia de la batería en cada ciclo
Bat.P_bat = zeros(Cycle.N,1);

% Creamos provisinalmente un vector de ceros. Aquí almacenaremos el SOC(State of Charge)de
% cada ciclo
Bat.SOC = zeros(1,Cycle.N);

% Fijamos el estado de carga inicial establecido previamente en la linea 30
% Asumimos que empezamos el viaje con un 80 %
Bat.SOC(1,1) = Bat.ub_SOC;


%% Engine Modellling
% Modelado del motor

% Valores de potencia de motor
% 1000 puntos equiespaciados entre 1 y 20 kW
Engine.P_engine  = linspace(1,20,1000)';

% Para almacenar la potencia óptima en cada ciclo
Engine.P_opt_eng = zeros(Cycle.N,1);

% Flujo de combustible por el motor
Engine.fl_wy_en = 0.001;

% Potencia inicial del motor
Engine.P = Engine.P_engine(1,1);

% Eficiencia del motor
Engine.eff = 0.45;


%% PMP Implementation
% Principio mínimo de Pontryagin

% Para almacenar el costate de la funcion objetivo en cada ciclo.
% Esto es una medida de sensibilidad de la función objetivo
costate_p = zeros(Cycle.N,1);

% Para almacenar el peso de cada ciclo.
% Le da importancia a una variable frente a otra
w_factor =  zeros(Cycle.N,1);

% Obtenemos el estado de carga de la batería con dos valores iniciales
% diferentes
% Esto lo conseguimos pasando nuestros datos por la funcion creada en el
% fichero pontryagin
SOC_1 = pontryagin(100,Bat,Cycle,Engine);
SOC_2 = pontryagin(0,Bat,Cycle,Engine);

%% Plotting
% Graficamos los resultados obtenimos y vemos la comparación entre dos
% estados iniciales dierentes
figure
plot(SOC_1)
hold on
plot(SOC_2)
hold off
ylim([0 1]);
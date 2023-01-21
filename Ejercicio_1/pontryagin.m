%% Principio mínimo de Pontryagin
function soc = pontryagin(p0,Bat,Cycle,Engine)
% Objetivo: Encontrar el camino óptimo que satisface la función objetico y
% las ecuaciones de estado

% Valor inicial de la ecuacion de co-estado
costate_p(1,1) = p0;

% A partir de aquí iniciamos el algoritmo tomando los datos en cada
% instante de tiempo (Cycle.N = 1370) 
for i = 1:Cycle.N-1

    % Potencia de la batería, esto es la difetrncia entre la potencia
    % demandada y la potencia del motor
    Bat.P_bat = Cycle.P_dem(i) - Engine.P;

    % Determinamos si el estado de carga de la batería se situa entre los
    % límites establecidos, estableciendo los factores de peso
    if Bat.SOC(i)<=Bat.lb_SOC
        w_factor(i)=-10^8;    
    elseif Bat.SOC(i)>=Bat.ub_SOC 
        w_factor(i)=+10^8;
    else
        w_factor(i)=0;
    end    
    
    % Calculamos la corriente de la batería a partir de la ecuación de
    % estado
    I_bat = (Bat.U_oc-sqrt(Bat.U_oc^2-Bat.R0_B*Bat.P_bat*1000*4))/(Bat.R0_B*2);

    % Cambio en el SOC (variación)
    Del_soc = -(Cycle.ts*I_bat)/(0.9*Bat.Q_bat);

    % Valor de la función objetivo
    H = Engine.fl_wy_en*Cycle.ts*Engine.P_engine/Engine.eff + (costate_p(i)+w_factor(i))*Del_soc;
    
    % Establecemos el H actual como el mínimo y la potencia actual como la
    % óptima en el motor
    H_min = H;
    P_eng = Engine.P;
    
    % Recorremos los valores de la potencia del motor, para encontrar la
    % óptima
    for j =2:length(Engine.P_engine)

        % Asignamos la potencia del motor a la iteración correspondiente
        Engine.P = Engine.P_engine(j,1);

        % Diferencia entre la energía que se demanda y la que tenemos en el
        % motor
        Bat.P_bat = Cycle.P_dem(i)-Engine.P;

        % Calculamos H al igual que antes
        I_bat = (Bat.U_oc-sqrt(Bat.U_oc^2-Bat.R0_B*Bat.P_bat*1000*4))/(Bat.R0_B*2); 
        Del_soc = -(Cycle.ts*I_bat)/(0.9*Bat.Q_bat);
        H = Engine.fl_wy_en*Cycle.ts*Engine.P_engine/Engine.eff + (costate_p(i)+w_factor(i))*Del_soc;

        % Si el resultado es menor que el que teníamos actualizamos y
        % establecemos la potencia como óptima
        if H_min > H
            H_min = H;
            P_eng = Engine.P;
        end
    end
    
    % Nos quedamos con la potencia óptima obtenida
    Engine.P_opt_eng(i) = P_eng;

    % Volvemos a calcular la potencia y la coriente de la batería donde obtuvimos la óptima
    Bat.P_bat(i)     = Cycle.P_dem(i)-Engine.P_opt_eng(i);
    I_bat        = (Bat.U_oc-sqrt(Bat.U_oc^2-Bat.R0_B*Bat.P_bat(i)*1000*4))/(Bat.R0_B*2);


    % Calculamos el nuevo SOC y la nueva costate.
    % La siguiente iteración partirá de estos valores.
    Bat.SOC(i+1)     = Bat.SOC(i) - (Cycle.ts*I_bat/(0.9*Bat.Q_bat));
    del_p =  costate_p(i)* 1 / Bat.Q_bat * (1/(2*Bat.R0_B) - 1/(4*Bat.R0_B^2) * Bat.U_oc / sqrt(Bat.U_oc^2/(4*Bat.R0_B^2) - Bat.P_bat(i)*1000/Bat.R0_B)) * 1;  
    costate_p(i+1) = del_p*Cycle.ts + costate_p(i);
end

% Guardamos todos los estados de carga obtenidos durante cada una de las
% iteraciones
soc = Bat.SOC;
end

% (hoja)En resumen, este código es una implementación del principio mínimo de Pontryagin para optimizar la eficiencia energética en un sistema híbrido de batería-motor. Utiliza un enfoque de programación dinámica para calcular la potencia óptima del motor en cada ciclo y el estado de carga de la batería en función de la potencia demandada y los parámetros del sistema

%Enlace: https://kaputtengineers.wixsite.com/home/post/pontryagin-s-minimum-principle

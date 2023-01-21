hold on
% Definimos la función
n = 10;
x = -n: 0.01: n;
y =  x.^4 - 4*x.^3 + 6*x.^2 - 4*x + 1;

% Pedimos la condición inicial
xn = input('Ingrese la condición inicial de x: ');

% Pedimos el paso λ
lambda = input('Ingrese el paso λ: ');

% Definimos un umbral para ponerle fin al bucle, tomandolo como una
% solucion suficientemente buena
umbral = .001;

% Inicializamos el número de iteraciones
i = 1;

% Graficamos la funcion y la condición inicial
plot(x, y, 'k-')
plot(xn(1),xn(1)^2,'ro')

% Ejecutamos el método del gradiente descendiente
while sqrt((4*xn(i)^3 - 12*xn(i)^2 + 12*xn(i) - 4)^2) > umbral && i < 100000 
    xn(i+1) = xn(i) - lambda*(4*xn(i)^3 - 12*xn(i)^2 + 12*xn(i) - 4);
    y(i) = 4*xn(i)^3 - 12*xn(i)^2 + 12*xn(i) - 4;

    % Sobrescribimos cada punto en la grafica
    plot(xn(i), y(i), 'bo')
    i = i + 1;
end
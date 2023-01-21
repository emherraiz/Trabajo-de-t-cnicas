view(3)
hold on

% Definimos la función
N = 7;
x= -N: 0.01: N;
y= -N: 0.01: N;
[X, Y] = meshgrid(x, y);
z = (X - 2).^2 + (Y - 1).^2;

% Pedimos el paso λ
lambda = input('Ingrese el paso λ: ');

% Pedimos la condición inicial
xn(1) = input('Ingrese la condición inicial de x: ');
yn(1) = input('Ingrese la condición inicial de y: ');

% Definimos un umbral para ponerle fin al bucle, tomandolo como una
% solucion suficientemente buena
umbral = 0.001;

% Graficamos la funcion y la condición inicial
surf(X,Y,z)

gradiente = [2 * (xn(1) - 2), 2 * (yn(1) - 1)];
plot(xn(1), (xn(1) - 2)^2,'ro')
plot(yn(1), (yn(1) - 1)^2,'go')

% Inicializamos el número de iteraciones
i = 1;

% Sacamos el modulo
modulo = [sqrt(gradiente(1)^2 + gradiente(2)^2)];

% Ejecutamos el método del gradiente descendiente
while (modulo(i) > umbral) && (i < 10000)
    
    xn(i + 1)= xn(i) - lambda * gradiente(1);
    yn(i + 1)= yn(i) - lambda * gradiente(2);
    z(i + 1) = (xn(i) - 2)^2 + (yn(i) - 1)^2;
    
    plot3(xn(i), yn(i), z(i), 'bo')
    
    gradiente = [2 * (xn(i + 1) - 2), 2 * (yn(i + 1) - 1)];

    modulo(i + 1) = sqrt(gradiente(1)^2 + gradiente(2)^2);
    i = i + 1;

end
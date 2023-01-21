%% En un espacio tridimensional
% Vector director normal al plano
normal_vector = randi([-10, 10],1,3);

% Punto de referencia al plano
p_0 = randi([-10, 10],1,3);

% Calculamos los coeficientes del plano
A = normal_vector(1);
B = normal_vector(2);
C = normal_vector(3);
D = - (A*(p_0(1)) + B*(p_0(2)) + C* (p_0(3)));

% Evaluamos cualquier punto que le pasemos
x = input('Ingrese la coordenada x del punto: ');
y = input('Ingrese la coordenada y del punto: ');
z = input('Ingrese la coordenada z del punto: ');

resultado = A*x + B*y + C*z + D;

% Determina si el punto está a un lado o al otro del plano
if resultado > 0
disp('El punto está del lado opuesto al vector normal al plano.')
elseif resultado < 0
disp('El punto está del lado del vector normal al plano.')
else
disp('El punto está en el plano.')
end

disp('Probemos ahora con n dimendiones')
%% Generalizamos a n dimensiones
% Dimension del espacio
n = input('Dimensiones: ');

% Vector director normal
disp('Vector normal al plano')
normal_vector = randi([-10, 10],1,n)

% Punto de referencia
disp('Punto de referencia')
p_0 = randi([-10, 10],1,n)

% Calculamos los coeficientes
coeficientes = zeros(1, n+1);
termino_indep = 0;
for i = 1:n
    coeficientes(i) = normal_vector(i);
    termino_indep = termino_indep + coeficientes(i);
end
coeficientes(n+1) = - termino_indep;

% Evaluamos cualquier punto que le pasemos
p_a_evaluar = zeros(1, n);
resultado = 0;
for i = 1:n
    fprintf('Ingresa la coordenada x%d del punto: ', i),
    p_a_evaluar = input(' ');
    resultado = resultado + coeficientes(i) * p_a_evaluar;
end

resultado = resultado + termino_indep;

% Determina si el punto está a un lado o al otro del hiperplano
if resultado > 0
disp('El punto está del lado opuesto al vector normal al plano.')
elseif resultado < 0
disp('El punto está del lado del vector normal al plano.')
else
disp('El punto está en el plano.')
end

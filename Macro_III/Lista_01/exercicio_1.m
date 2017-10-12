%% Ambiente/Parametros
f = @(w, alpha_1, alpha_2) alpha_1 + alpha_2 * w;
u = @(c, gamma) c .^ gamma;

beta = 0.98;
pi = 0.1;
b = 0;
wmin = 0;
wmax = 20;
gamma = 1/2;

%% (i)
alpha_1 = 1/15;
alpha_2 = -1/600;

n = 1000;
w = linspace(0, 20, n)';

V = zeros(n, 1);
G = V;

tol = 10^-5;
itmax = 3000;
iter = 1;
err = 1;

% integracao numerica
x = linspace(wmin, wmax, n);
h = x(2) - x(1);
E = @(w, V, n) V' * ( f(w, alpha_1, alpha_2) ./ sum(f(w, alpha_1, alpha_2)) );

while err > tol && iter < itmax
    N = u(b, gamma) + beta * E(w, V, n);
    N = repmat(N, n, 1);
    A = u(w, gamma) + beta * ( (1-pi) * V + pi * N );
 
    [TV, G] = max([N A], [], 2);

    err = max(abs(TV - V));
    V = TV;
    fprintf('Itera��o: %d, Desvio: %1.7f \n', iter, err)
    iter = iter + 1;
end

G = G - 1;

subplot(2,1,1);
plot(x, V);
title('Funcao valor');
ylabel('v(w)');
xlabel('w');

subplot(2,1,2);
plot(x, G);
title('Funcao politica');
ylabel('g(w)');
xlabel('w');


R = min(x(G == 1));
R

%% (ii)

alpha_1 = 1/30;
alpha_2 = 1/600;

tol = 10^-5;
itmax = 3000;
iter = 1;
err = 1;

% integracao numerica
E = @(w, V, n) V' * ( f(w, alpha_1, alpha_2) ./ sum(f(w, alpha_1, alpha_2)) );

while err > tol && iter < itmax
    N = u(b, gamma) + beta * E(w, V, n);
    N = repmat(N, n, 1);
    A = u(w, gamma) + beta * ( (1-pi) * V + pi * N );
 
    [TV, G] = max([N A], [], 2);

    err = max(abs(TV - V));
    V = TV;
    fprintf('Itera��o: %d, Desvio: %1.7f \n', iter, err)
    iter = iter + 1;
end

G = G - 1;

subplot(2,1,1);
plot(x, V);
title('Funcao valor');
ylabel('v(w)');
xlabel('w');

subplot(2,1,2);
plot(x, G);
title('Funcao politica');
ylabel('g(w)');
xlabel('w');


R = min(x(G == 1));
R

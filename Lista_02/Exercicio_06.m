% EXERC�CIO 06

% Parametros do modelo:
alpha = 0.75;
beta = 0.98;
delta = 0.05;
gamma = 1.2;
A = 2;

% Capital de estado estacion�rio:
kss = ((1/beta + delta - 1) / (alpha * A)) ^ (1/(alpha-1)); 

% A vari�vel de estado � k.
% A regra de bolso sugerida em sala � criar um grid de raio 30% do kss.
grid_size = 2000;
k = linspace(kss * 0.7, kss * 1.3, grid_size)';
k_linha = k';

% Chutes iniciais:
V = linspace(0, 0, grid_size)';
TV = linspace(0, 0, grid_size)';
g = linspace(0, 0, grid_size)';

% Parametros de iteracao:
tol = eps(1e9);
n_iter = 1000;

% Problema
K = repmat(k,1,grid_size);
K_linha = repmat(k_linha, grid_size , 1);
y = f(K,A,alpha);
C = max(y + (1-delta)*K - K_linha, 0);
U = u(C, gamma);

% Define variaveis para iniciar loop
desvio_max = tol+1;
iter = 1;

while desvio_max > tol && iter < n_iter
    H = U + beta * repmat(V', grid_size, 1);
    [TV, I] = max(H, [], 2);
    desvio_max = max(abs(TV - V));
    fprintf('Itera��o: %d, Desvio: %1.7f \n', iter, desvio_max)
    V = TV;
    iter = iter+1;
end

% Fun��o pol�tica
g = k(I);

% Gr�fico das fun��es valor e pol�tica
subplot(2,1,1);
plot(TV);
ylabel('Fun��o valor V(k)');

subplot(2,1,2); hold on;
plot(g);
ylabel('Fun��o pol�tica g(k)');


%% FUN��ES

% Fun��o produ��o
function y = f(k, A, alpha)
    y = A * k .^ alpha;
end

% Fun��o utilidade
function U = u(c, gamma)
    U = (c .^ (1 - gamma) - 1) / (1 - gamma);
end
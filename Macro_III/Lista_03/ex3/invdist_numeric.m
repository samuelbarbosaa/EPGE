% M: matriz quadrada
% P: vetor coluna que representa uma distribui��o invariante da matriz M'
% invdist_numeric obt�m as distribui��es invariantes numericamente,
% partindo de um chute inicial e multiplicando o vetor de cada itera��o por
% M' at� obter uma distribui��o invariante

function P = invdist_numeric(M)

eps = 1e-5; % epsilon que defino como toler�ncia para a solu��o encontrada
max_it = 10000; % numero maximo de iteracoes para evitar ficar preso no while
count = 1; % contador de iteracoes
flag = 0; % flag que indica se o numero maximo de iteracoes foi atingido
n = size(M,1);
P_ant = 1/n*ones(n,1); % chute inicial

P = M'*P_ant;
while sum(abs(P-P_ant)>=eps)>0 && flag==0 % enquanto alguma coordenada for eps afastada
    P_ant = P;
    P = M'*P_ant;
    if count<max_it
        count = count + 1;
    else
        flag = 1;
    end
end

if flag == 1
    error('erro: numero maximo de iteracoes alcancado');
end
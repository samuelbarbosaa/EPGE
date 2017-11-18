% M: matriz quadrada
% P: matriz cujas colunas s�o as distribui��es invariantes associadas �
% matriz M'
% invdist_analytic obt�m as distribui��es invariantes analiticamente, isto
% �, calculando autovetores associados aos autovalores iguais a 1

function P = invdist_analytic(M)

eps = 1e-10; % epsilon que defino como toler�ncia para encontrar o autovalor igual a 1
n = size(M,1);
[V,D] = eig(M'); 
P = [];

for i=1:n % varro a matriz inteira atr�s dos autovalores iguais a 1
    if abs(D(i,i)-1)<eps % se autovalor "�" 1, obtenho o autovetor associado e normalizo de forma que a soma dos componentes do vetar seja 1
        P = [P V(:,i)/sum(V(:,i))]; % concateno o vetor obtido com eventuais vetores obtidos anteriormente
        break
    end
end
clear all
clc

%% Exerc�cio 3 - Lista 1 Macro 3
%% Alunos: Diego Martins; Francisco Luis

%% Par�metros
a=-10;
b=10;

%% Fun��o

f=@(x)((x^3)*exp(-(x^2)));
df=@(x)((x^2)*(exp(-(x^2)))*(3-2*(x^2)));
ddf=@(x)(2*x*exp(-(x^2))*(3-7*(x^2)+2*(x^4)));

%% M�todo da Bisse��o

A=df(a);
B=df(b);
desvio=1;
it=0;

while desvio>0 && it<500
it=it+1;
c=(a+b)/2;
C=df(c);
if C<0
    b=c;
else
    a=c;
end
cprime=(a+b)/2;
erro=abs(cprime-c);
erroprime=abs(df(cprime));
desvio=max(erro,erroprime);
end

%% M�todo Newton-Rapson

alpha=.9;
x=zeros(1,700);
x(1)=alpha;
desviob=1;
itb=0;
i=1;

while desviob>0 && itb<700 
itb=itb+1;
x(i+1)=x(i)-(df(x(i))/ddf(x(i)));
errob=abs(x(i+1)-x(i));
errobprime=abs(df(x(i+1)));
desviob=max(errob,errobprime);
i=i+1;
end


%% Compara��o
%% Dado os intervalos propostos pelo monitor o resultado do item "a" foi
%% dentro do esperado, com um n�mero de itera��es baixo. J� o item "b",
%% precisou de um n�mero de itera��es bem maior e de um chute inicial
%% pr�ximo de um. O segundo modelo apresentou maior volatilidade quanto ao
%% chute inicial. 
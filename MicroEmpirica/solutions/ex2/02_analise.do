* Micro Emp�rica
* Trabalho 02
* Samuel Barbosa

/* Neste exerc�cio vamos estimar a equa��o de sal�rios (Mincer, 1974) com a
corre��o do vi�s de sele��o das informa��es dos sal�rios atrav�s do procedimento
de Heckman (1979). Vamos utilizar os dados da PNAD 2015, considerando somente a
subpopula��o de indiv�duos de 18 a 65 anos de idade. */

* Configura��o do ambiente de trabalho
global root  "E:\Projetos\EPGE_github\MicroEmpirica\" 
global data_raw "${root}\data_raw\pnad"
global data "${root}\data\pnad"
cd "${data_raw}"

clear all

log using "${root}\solutions\ex2\ex2_log.smcl", replace

/* EXERC�CIO EMP�RICO */
use "${data}/pnad2015_ex2.dta", clear

* Define o Desenho Amostral
svyset psu [pw = peso], strata(estrato)

* Identifica os estratos com psu unico 
quietly svydes, gen(single2)
drop if single2==1

* (a) Regress�o OLS - Retornos a educa��o
svy, subpop(pia): reg log_renda anos_estudo i.mulher idade idade2

esttab using "${root}\solutions\ex2\tabela_1.tex", ///
		title("Equa��o de Mincer desconsiderando vi�s de sele��o") ///
		booktabs ///
		replace

* (b) Regress�o OLS - Retornos a educa��o
svy, subpop(pia): probit ind_renda anos_estudo casal##mulher c.n_filhos##mulher
esttab using "${root}\solutions\ex2\tabela_2.tex", ///
		title("Equa��o de sele�ao - Modelo Probit") ///
		booktabs ///
		replace

* (c) Heckman Correction
svy, subpop(pia): heckman log_renda anos_estudo i.mulher idade idade2, select(ind_renda = anos_estudo casal##mulher c.n_filhos##mulher)
esttab using "${root}\solutions\ex2\tabela_3.tex", ///
		title("Equa��o de Mincer (com corre��o de Heckman)") ///
		booktabs ///
		nostar ///
		replace
		
* (d) Two step Correction

log close




	
	
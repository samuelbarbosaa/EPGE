* Micro Emp�rica
* Trabalho 01
* Samuel Barbosa

/* Neste exerc�cio vamos estimar os retornos � educa��o usando a equa��o de 
  Mincer e os dados da PNAD 2015. */

* Configura��o do ambiente de trabalho
global root  "C:\Users\Samue\Desktop\EPGE_github\MicroEmpirica" 
global data_raw "${root}\data_raw\pnad"
global data "${root}\data\pnad"
cd "${data_raw}"

clear all

log using "${root}\solutions\ex1\ex1_log.smcl", replace

* Leitura e tratamento dos dados
infile using "PES2015.dct", using(PES2015.TXT)	
sort uf v0102 v0103
save PES2015.dta, replace	
clear

infile using "DOM2015.dct", using(DOM2015.TXT)	
sort uf v0102 v0103
save DOM2015.dta, replace	
clear

use PES2015.dta, clear
 merge m:1 uf v0102 v0103 using DOM2015.dta
 drop if _merge==2
 drop _merge
save pnad2015.dta, replace	

* Cria, altera e renomeia vari�veis 
rename (v4718 v4803 v8005 v0404 v0302) (renda anos_estudo idade cor_raca mulher)
rename (v0504) (migrou)
rename (v4729 v4617 v4618) (peso estrato psu)

gen idade2 = idade^2
gen log_renda = ln(renda) // renda = 0 � descartado.

recode anos_estudo (17 = .)
recode renda (999999999999 = .)
recode migrou (2=1) (4=0)

replace anos_estudo = anos_estudo - 1

label define sexo_labels 2 "Masc" 4 "Fem"
label define cor_raca_labels 0 "Indigena" 2 "Branca" 4 "Preta" 6 "Amarela" 8 "Parda" 9 "SemDecl"

label value sexo sexo_labels
label value cor_raca cor_raca_labels

* Organiza dados
order v0101 uf sexo idade idade2 sexo cor_raca anos_estudo migrou renda log_renda
keep v0101 uf sexo idade idade2 sexo cor_raca anos_estudo migrou renda log_renda peso estrato psu

keep if renda > 0
drop if renda == .

save "${data}/pnad2015_ex1.dta", replace

/* EXERC�CIO EMP�RICO */
	use "${data}/pnad2015_ex1.dta", clear

	* Define o Desenho Amostral
	svyset psu [pw = peso], strata(estrato) 

	* Identifica os estratos com psu unico 
	svydes, gen(single2)
	drop if single2==1

	* A. Tabela Descritiva  
		svy: mean renda

	* B. Regress�o OLS - Retornos a educa��o

	svy: reg log_renda anos_estudo idade idade2
	svy: reg log_renda anos_estudo idade idade2 i.sexo i.cor_raca
	
	* Exerc�cio com uma subpopula��o
	svy, subpop(migrou): reg log_renda anos_estudo idade idade2	i.sexo i.cor_raca

log close

*********************************************************
*           Guia para o Trabalho 1 - Micro Emp�rica		*
*					La�sa Rachter 						*
*********************************************************

  * Esse do-file l� os Microdados da PNAD 2014, trata algumas vari�veis de interesse e estima equa��o Mineceriana
  * INPUT: Dados Brutos - Microdados PNAD PES.TXT
  * OUTPUT: Dados Tratados - Pnad.dta e tabelas Resultados.xls

	clear all

	 log using "C:\Users\Trabalho1_Nome.smcl", replace // log file: salva todo o output da tela de resultados


	/* Globals */

		global root  "C:\Users\Monitoria" 
		global RawData "${root}\Dados Brutos"
		global TreatedData "${root}\Dados Tratados"
	
		chdir "${RawData}" //Define o Diret�rio
		
		
	/* LEITURA E TRATAMENTO DOS DADOS */

	  * Infile: a partir do dicion�rio de vari�veis, o comando infile faz a leitura dos dados em .txt 

	   * Pessoas

		infile using "pnadpes.dct", using(PES2014.TXT)	
		sort uf v0102 v0103
		save pnadPes.dta, replace	
		clear

	  * Domic�lios

		infile using "pnaddom.dct", using(DOM2014.TXT)	
		 sort uf v0102 v0103
		save pnadDom.dta, replace	
		clear

	/* Merge:

	Combina o banco de dados de pessoas e domic�lios. O "Master Data" usado foi o banco de dados de pessoas e o "Using" o banco de dados de domic�lios 
	merge correto deve ser o "many to 1" - a partir do identificador de domic�lio, que combina uf, n�mero de s�rie e n�mero de controle, estamos identificando pessoas e seus respectivos domic�lios. 
	Quando dropamos _merge==2, estamos eliminando da base de dados as observa��es que apareciam somente no banco de dados "using" (n�o teve match nos dados "master".  
	*/

		use pnadpes.dta, clear
		 merge m:1 uf v0102 v0103 using pnadDom
		 drop if _merge==2
		 drop _merge
		save pesdom, replace	
						

	foreach i in Pes Dom{
	erase pnad`i'_2014.dta					
	}
						
						
	/* TRATAMENTO */ 

	recode v8005 (999=.), g(idade)  //Pnads mais recentes j� vem sem o 999

	gen idade2 = idade^2

	gen female=1 if sexo==0
	replace female=0 if sexo==1
	
	//continuar....
	
	
	* Vari�veis para Definir Amostra Complexa

	rename (v4729 v4617 v4618) (peso estrato psu)
		
   /* KEEPING */

	*Ordeno e mantenho no banco de daos as vari�veis de interesse

	order v0101 uf idade idade2 female etc...
			
	keep v0101 uf v0104 v0105 v0106 idade idade2 sexo female urbana metropol cor anoest trabalhou_semana ///
	horas_trab_sem renda_mensal_din estrato psu peso
		
	  save "${TreatedData}/Pnad.dta", replace


	/* EXERC�CIO EMP�RICO */


  use "${TreatedData}/Pnad.dta", clear

	* Define o Desenho Amostral

    	svyset psu [pw = peso], strata(estrato) 
	
	* Identifica os estratos com psu unico 
		
		svydes, gen(single2)
		drop if single2==1
	
	* A. Tabela Descritiva  
		chdir ${Tables}

		svy: mean Y X Z   //Outras estat�sticas poss�veis: mediana, desvio padr�o, min, max, etc... 

	* B. Regress�o OLS - Retornos a educa��o

	svy: reg Y X 
	outreg2 using "Tabela1", excel nocons  aster(se) dec(3) replace 
	 //para acrescentar informa��es de outras regress�es usar como op��o "append". Lembre que tudo o que vai depois da v�rgula � op��o, voc� pode retirar ou incluir outras  

	* Exerc�cio com uma subpopula��o

	svy, subpop(var): command X 	

close log 

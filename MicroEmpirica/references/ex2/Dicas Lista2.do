
* Dicas para o a Lista Emp�rica 2 - Sele��o de Heckman

 * Criar Identificador de Domic�lios

	egen id_dom = concat(v0101 controle serie)


 * Numero de Filhos

	bysort id_dom: egen n_filhos = total(cond_dom==3 & idade<18)
	replace n_filhos = 0 if cond_dom>2	
	
	


	

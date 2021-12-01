
PROGRAM _INIT
	VstupnyVytah_Statistika.IN.TaskovaTrieda_ms:= 2;
	StoperPredCistenim_Statistika.IN.TaskovaTrieda_ms:= 2;
	StoperPoCisteni_Statistika.IN.TaskovaTrieda_ms:= 2;
	StoperEtiketovania_Statistika.IN.TaskovaTrieda_ms:= 2;
	StoperDopravNG_Statistika.IN.TaskovaTrieda_ms:= 2;
	VystupnyVytah_Statistika.IN.TaskovaTrieda_ms:= 2;
	Linka_Statistika.IN.TaskovaTrieda_ms:= 2; 
END_PROGRAM

PROGRAM _CYCLIC
	
	VstupnyVytah_Statistika();
	StoperPredCistenim_Statistika();
	StoperPoCisteni_Statistika();
	StoperEtiketovania_Statistika();
	StoperDopravNG_Statistika();
	VystupnyVytah_Statistika();
	Linka_Statistika();
	
	
		
	
	//********************************************Meranie taktime vstupnÈho v˝ùahu*****************************************************//
	IF VstupnyVytah_Statistika.IN.ZAPIS_MeraniaCasu AND VstupnyVytah_Statistika.OUT.Stav_ZapisCasu_DONE THEN
		VstupnyVytah_Statistika.IN.ZAPIS_MeraniaCasu:= FALSE;
	END_IF    
	 
	
	//Zobrazenie ötatistik//
	VstupnyVytah_Statistika.OUT.NameranyCas_v_Sekundach;
	
	//Reset priemernÈho Ëasu//
	IF VstupnyVytah_Statistika.IN.RESET_HistorieMeraniCasu AND VstupnyVytah_Statistika.OUT.Stav_RESET_HistorieMerani_DONE THEN
		VstupnyVytah_Statistika.IN.RESET_HistorieMeraniCasu:= FALSE;
	END_IF	
	
	
	
	
	//***********************************************Meranie taktime stopra pred ËistenÌm******************************************************//
	IF StoperPredCistenim_Statistika.IN.ZAPIS_MeraniaCasu AND StoperPredCistenim_Statistika.OUT.Stav_ZapisCasu_DONE THEN
		StoperPredCistenim_Statistika.IN.ZAPIS_MeraniaCasu:= FALSE;
	END_IF    
	 
	//Zobrazenie ötatistik//
	StoperPredCistenim_Statistika.OUT.NameranyCas_v_Sekundach;
	
	
	//Reset priemernÈho Ëasu//
	IF StoperPredCistenim_Statistika.IN.RESET_HistorieMeraniCasu AND StoperPredCistenim_Statistika.OUT.Stav_RESET_HistorieMerani_DONE THEN
		StoperPredCistenim_Statistika.IN.RESET_HistorieMeraniCasu:= FALSE;
	END_IF
	
	
	
	//********************************************Meranie taktime stopra po ËistenÌ***********************************************************//
	IF StoperPoCisteni_Statistika.IN.ZAPIS_MeraniaCasu AND StoperPoCisteni_Statistika.OUT.Stav_ZapisCasu_DONE THEN
		StoperPoCisteni_Statistika.IN.ZAPIS_MeraniaCasu:= FALSE;
	END_IF    
	
	
	//Zobrazenie ötatistik//
	StoperPoCisteni_Statistika.OUT.NameranyCas_v_Sekundach;
	
	
	//Reset priemernÈho Ëasu//
	IF StoperPoCisteni_Statistika.IN.RESET_HistorieMeraniCasu AND StoperPoCisteni_Statistika.OUT.Stav_RESET_HistorieMerani_DONE THEN
		StoperPoCisteni_Statistika.IN.RESET_HistorieMeraniCasu:= FALSE;
	END_IF
	
	
	
	
	
	//********************************************Meranie taktime stopra etiketovania***************************************************************//
	IF StoperEtiketovania_Statistika.IN.ZAPIS_MeraniaCasu AND StoperEtiketovania_Statistika.OUT.Stav_ZapisCasu_DONE THEN
		StoperEtiketovania_Statistika.IN.ZAPIS_MeraniaCasu:= FALSE;
	END_IF    
	
	
	//Zobrazenie ötatistik//
	StoperEtiketovania_Statistika.OUT.NameranyCas_v_Sekundach;
	
	
	//Reset priemernÈho Ëasu//
	IF StoperEtiketovania_Statistika.IN.RESET_HistorieMeraniCasu AND StoperEtiketovania_Statistika.OUT.Stav_RESET_HistorieMerani_DONE THEN
		StoperEtiketovania_Statistika.IN.RESET_HistorieMeraniCasu:= FALSE;
	END_IF
	
	
	
	
	
	//*********************************Meranie taktime stopra dopravnÌka NG*******************************************************************//
	IF StoperDopravNG_Statistika.IN.ZAPIS_MeraniaCasu AND StoperDopravNG_Statistika.OUT.Stav_ZapisCasu_DONE THEN
		StoperDopravNG_Statistika.IN.ZAPIS_MeraniaCasu:= FALSE;
	END_IF    
	
	
	
	//Zobrazenie ötatistik//
	StoperDopravNG_Statistika.OUT.NameranyCas_v_Sekundach;
	
	
	//Reset priemernÈho Ëasu//
	IF StoperDopravNG_Statistika.IN.RESET_HistorieMeraniCasu AND StoperDopravNG_Statistika.OUT.Stav_RESET_HistorieMerani_DONE THEN
		StoperDopravNG_Statistika.IN.RESET_HistorieMeraniCasu:= FALSE;
	END_IF
	
	
	
	
	
	
	//*********************************************Meranie taktime v˝stupnÈho v˝ùahu****************************************************************//
	IF VystupnyVytah_Statistika.IN.ZAPIS_MeraniaCasu AND VystupnyVytah_Statistika.OUT.Stav_ZapisCasu_DONE THEN
		VystupnyVytah_Statistika.IN.ZAPIS_MeraniaCasu:= FALSE;
	END_IF    
	
	
	
	//Zobrazenie ötatistik//
	VystupnyVytah_Statistika.OUT.NameranyCas_v_Sekundach;
	
	//Reset priemernÈho Ëasu//
	IF VystupnyVytah_Statistika.IN.RESET_HistorieMeraniCasu AND VystupnyVytah_Statistika.OUT.Stav_RESET_HistorieMerani_DONE THEN
		VystupnyVytah_Statistika.IN.RESET_HistorieMeraniCasu:= FALSE;
	END_IF
	
	
	
	
	//Reset poËtu kusov OK a NG//
	IF RESET_PoctuVyrobenychKusov THEN
		PocetVyrobenychKusov_OK:= 0;
		PocetVyrobenychKusov_NG:= 0;
		Pomer_OK_kusov_IDR:= 0;
		RESET_PoctuVyrobenychKusov:= FALSE;
	END_IF
   
	
	//Vyr·tanie IDR percentu·lny pomer kusov OK k celkovÈmu poËtu vyroben˝ch kusov//
	IF PocetVyrobenychKusov_OK <> 0 THEN
		Pomer_OK_kusov_IDR:= 100 * (PocetVyrobenychKusov_OK/(PocetVyrobenychKusov_OK + PocetVyrobenychKusov_NG)); 
	END_IF	
	
	
	//Reset celkovÈho poËtu kusov//
	IF RESET_CelkovehoPoctuKusov THEN
		CelkovyPocetVyrobenychKusov:= 0;
		RESET_CelkovehoPoctuKusov:= FALSE;
	END_IF

	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


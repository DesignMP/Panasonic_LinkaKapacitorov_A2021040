
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Meranie motohodin ioniz�tora Tajfun//
	
	Tajfun_Motohodiny.START:= Linka.OUT.IonJednotka_START;
	
	
	//Spustenie merania//
	IF Tajfun_Motohodiny.START THEN
		Tajfun_Motohodiny.Milisekundy:= Tajfun_Motohodiny.Milisekundy + 2;//Ak je v taskovej triede 2ms tak prir�tav�me + 2//
	END_IF		
		
	IF Tajfun_Motohodiny.Milisekundy >= 1000 THEN
		Tajfun_Motohodiny.Sekundy:= Tajfun_Motohodiny.Sekundy + 1;
		Tajfun_Motohodiny.Milisekundy:= 0;
	END_IF
		
	IF Tajfun_Motohodiny.Sekundy >= 60 THEN
		Tajfun_Motohodiny.Minuty:= Tajfun_Motohodiny.Minuty + 1;
		Tajfun_Motohodiny.Sekundy:= 0;
	END_IF	
		
	IF Tajfun_Motohodiny.Minuty >= 60 THEN
		Tajfun_Motohodiny.Hodiny:= Tajfun_Motohodiny.Hodiny + 1;
		Tajfun_Motohodiny.CelkovyPocetHodin:= Tajfun_Motohodiny.CelkovyPocetHodin + 1;
		Tajfun_Motohodiny.Minuty:= 0;
	END_IF
		
	IF Tajfun_Motohodiny.Hodiny >= 24 THEN
		Tajfun_Motohodiny.Dny:= Tajfun_Motohodiny.Dny + 1;
		Tajfun_Motohodiny.Hodiny:= 0;
	END_IF

	
	//Reset merania//
	IF Tajfun_Motohodiny.RESET THEN
		Tajfun_Motohodiny.Milisekundy:= 0;
		Tajfun_Motohodiny.Sekundy:= 0;
		Tajfun_Motohodiny.Minuty:= 0;
		Tajfun_Motohodiny.Hodiny:= 0;
		Tajfun_Motohodiny.CelkovyPocetHodin:= 0;
		Tajfun_Motohodiny.Dny:= 0;
		Tajfun_Motohodiny.RESET:= FALSE;
	END_IF	
        
	
	//Zobrazenie stavov filtrov ioniza�nej jednotky//
	//0 - Stav filtrov ioniza�nej jednotky je OK.
	//1 - Bl�i sa term�n v�meny filtrov ioniza�nej jednotky !!!
	//2 - Nutn� v�mena filtrov ioniza�nej jednotky !!!
	
	//Farby stavov filtrov//
	//0 - Siv�
	//1 - Zelen�
	//2 - Oran�ov�
	//3 - �erven�
	
	
	
	CasKontrolyFiltrov.IN:= Linka.OUT.IonJednotka_START;
	
	IF Safety.STAV.SafetyPLC_Nabehlo THEN
		IF CasKontrolyFiltrov.Q AND (NOT Linka.IN.IonJednotka_Error_Filter1_RJ1 OR NOT Linka.IN.IonJednotka_Error_Filter2_RJ1)THEN
			Linka.STAV.FiltreIonizacnejJednotkyZanesene:= TRUE;
			Vizu.IndexStavuFiltrov:= 2;
			Vizu.IndexFarbyStavuFiltrov:= 3;
		ELSIF Tajfun_Motohodiny.Dny >= RemPremenne.PocetDniDoVymenyFiltra THEN
			Linka.STAV.FiltreIonizacnejJednotkyZanesene:= TRUE;
			Vizu.IndexStavuFiltrov:= 2;
			Vizu.IndexFarbyStavuFiltrov:= 3;
		ELSIF Tajfun_Motohodiny.Dny >= RemPremenne.PocetDniDoVymenyFiltra - 7 THEN	
			Vizu.IndexStavuFiltrov:= 1;
			Vizu.IndexFarbyStavuFiltrov:= 2;
		ELSE	
			Vizu.IndexStavuFiltrov:= 0;
			Vizu.IndexFarbyStavuFiltrov:= 1;
		END_IF
	END_IF
	
	IF Linka.VymenaFiltrovPotvrdena THEN
		Linka.STAV.FiltreIonizacnejJednotkyZanesene:= FALSE;
		Tajfun_Motohodiny.RESET:= TRUE;
		Linka.VymenaFiltrovPotvrdena:= FALSE;
	END_IF	
	
	
	
	CasKontrolyFiltrov.PT:= T#2s;
	CasKontrolyFiltrov();
        
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


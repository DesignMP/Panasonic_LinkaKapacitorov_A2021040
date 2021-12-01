
ACTION OvlSafety: 

	//Podsvietenie tlaèítka Reset CS//
	IF Safety.STAV.CS_OvlPanel_Odblokovany AND Safety.STAV.CS_Robot_Odblokovany AND Safety.STAV.CS_VstupnyVytah_Odblokovany AND Safety.STAV.CS_VystupnyVytah_Odblokovany AND NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.PodsvietenieTlacitka_ResetCS:= Blikac500ms;
	ELSIF Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.PodsvietenieTlacitka_ResetCS:= 2;
	ELSE	
		Vizu.PodsvietenieTlacitka_ResetCS:= 3;
	END_IF	
    
	//Podsvietenie tlaèítok zámkov dverí//
	//Predné dvere//
	IF Linka.IN.PredneDvereZavrete_EZ1 AND NOT Linka.OUT.PredneDvere_Zamkni_EZ1 THEN
		Vizu.FarbaTlacitka_ZamokPredneDvere:= Blikac500ms;
	ELSIF Linka.IN.PredneDvereZavrete_EZ1 AND Linka.OUT.PredneDvere_Zamkni_EZ1 THEN
		Vizu.FarbaTlacitka_ZamokPredneDvere:= 2;	
	ELSE
		Vizu.FarbaTlacitka_ZamokPredneDvere:= 3;
	END_IF	
	
	//Zadné dvere//
	IF Linka.IN.ZadneDvereZavrete_EZ2 AND NOT Linka.OUT.ZadneDvere_Zamkni_EZ2 THEN
		Vizu.FarbaTlacitka_ZamokZadneDvere:= Blikac500ms;
	ELSIF Linka.IN.ZadneDvereZavrete_EZ2 AND Linka.OUT.ZadneDvere_Zamkni_EZ2 THEN
		Vizu.FarbaTlacitka_ZamokZadneDvere:= 2;	
	ELSE
		Vizu.FarbaTlacitka_ZamokZadneDvere:= 3;
	END_IF	
	
	
	
	
	
	
	//******************************************Ovládanie zámkov dverí bunky****************************************//
	//Predné dvere //
	IF Vizu.TL_ZamkniPredneDvere THEN
		IF Linka.IN.PredneDvereZavrete_EZ1 THEN
			IF Linka.OUT.PredneDvere_Zamkni_EZ1 THEN
				Linka.OUT.PredneDvere_Zamkni_EZ1:= FALSE;
			ELSE
				Linka.OUT.PredneDvere_Zamkni_EZ1:= TRUE;
			END_IF
		END_IF
		Vizu.TL_ZamkniPredneDvere:= FALSE;
	END_IF	
		

	//Zadné dvere //
	IF Vizu.TL_ZamkniZadneDvere THEN
		IF Linka.IN.ZadneDvereZavrete_EZ2 THEN
			IF Linka.OUT.ZadneDvere_Zamkni_EZ2 THEN
				Linka.OUT.ZadneDvere_Zamkni_EZ2:= FALSE;
			ELSE
				Linka.OUT.ZadneDvere_Zamkni_EZ2:= TRUE;
			END_IF
		END_IF
		Vizu.TL_ZamkniZadneDvere:= FALSE;
	END_IF	
	
	
	//************************************************Resetovanie zón****************************************************//
	//Reset zóny vstupného výahu//
	CasResetZonyVstupVytahu.IN:= NOT Safety.STAV.ZonaVstupnyVytah_AKTIVNA AND Safety.STAV.ZonaVstupnyVytah_Odblokovana;
	
	IF CasResetZonyVstupVytahu.Q THEN
		Safety.RESET_ZonyVstupnehoVytahu:= TRUE;
	ELSE	
		Safety.RESET_ZonyVstupnehoVytahu:= FALSE;
	END_IF	
		
	CasResetZonyVstupVytahu.PT:= T#1s;
	CasResetZonyVstupVytahu();
	
	//Reset zóny bunky//
	CasResetZonyBunky.IN:= NOT Safety.STAV.ZonaBunky_AKTIVNA AND Safety.STAV.ZonaBunky_Odblokovana;
	
	IF CasResetZonyBunky.Q THEN
		Safety.RESET_ZonyBunky:= TRUE;
	ELSE	
		Safety.RESET_ZonyBunky:= FALSE;
	END_IF	
		
	CasResetZonyBunky.PT:= T#1s;
	CasResetZonyBunky();
	
	
	
	
	//Reset zóny výstupného výahu//
	CasResetZonyVystupVytahu.IN:= NOT Safety.STAV.ZonaVystupnyVytah_AKTIVNA AND Safety.STAV.ZonaVystupnyVytah_Odblokovana;
	
	IF CasResetZonyVystupVytahu.Q THEN
		Safety.RESET_ZonyVystupnehoVytahu:= TRUE;
	ELSE	
		Safety.RESET_ZonyVystupnehoVytahu:= FALSE;
	END_IF	
		
	CasResetZonyVystupVytahu.PT:= T#1s;
	CasResetZonyVystupVytahu();
	
	
	//Reset dedman//
	IF NOT Linka.STAV.Automat AND ZvolenaUroven > 30 AND Safety.STAV.DeadMan_Odblokovany AND NOT Safety.STAV.DeadMan_AKTIVNY THEN
		Safety.RESET_DeadMan:= TRUE;
	ELSE
		Safety.RESET_DeadMan:= FALSE;
	END_IF	
	
	
END_ACTION

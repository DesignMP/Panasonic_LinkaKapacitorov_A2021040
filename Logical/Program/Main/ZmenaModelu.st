
ACTION ZmenaModelu: 

		//***********************************************Zobrazenie stavov zmeny modelu***********************************************//
    //0 - Èakám na zmenu modelu.
    //1 - Nebol naèítaný názov modelu !!!
    //2 - Nebol naèítaný LOT !!!
    //3 - Zmena modelu prebehla OK !!!
	//4 - Zadaný model nieje v databázi linky !!!
	
	//Farba pozadia//
	//0 - sivá
	//1 - modrá
	//2 - zelená
	//3 - èervená
	
	
   	
	IF EDGEPOS(Vizu.CisloAktualnejObrazovky = 4)THEN
		Vizu.StavZmenyModelu_Index:= 0;
		Vizu.StavZmenyModelu_Farba:= 0;
		Vizu.Nacitany_MODEL:= '';
		Vizu.Nacitany_LOT:= '';
	END_IF	
	
	
	
	//Zistenie poètu naèítaných znakov//
	PocetNacitanychZnakov := brsstrlen(ADR(RucCitackaQR.PrecitaneData)); //Zistenie poètu znakov vstupnej spravy
	
	//Zistenie èi sa jedná o Názov modelu alebo èíslo Lotu//
	brsmemcpy(ADR(NacitaneZnaky_POLE),ADR(RucCitackaQR.PrecitaneData),SIZEOF(RucCitackaQR.PrecitaneData)); //Vyplnenie polia znakmy vstupnej správy
	
	
	
	//Zapísanie naèítanej hodnoty do pola Nazov Modelu alebo Cislo Lotu// EZT
	IF RucCitackaQR.PrecitaneData <> '' THEN
		IF NacitaneZnaky_POLE[0] = 69 AND NacitaneZnaky_POLE[1] = 90 AND NacitaneZnaky_POLE[2] = 84 AND PocetNacitanychZnakov = 12 THEN  
			Vizu.Nacitany_MODEL:= RucCitackaQR.PrecitaneData;
		ELSIF NacitaneZnaky_POLE[0] = 66 AND PocetNacitanychZnakov = 11 THEN
			Vizu.Nacitany_LOT:= RucCitackaQR.PrecitaneData;
		END_IF
		RucCitackaQR.PrecitaneData:= '';
	END_IF	
	
	
	

		
	
	
	CASE SC_ZmenaModelu.Step OF
		
		0://Vynulovanie uživatela//
			SC_ZmenaModelu.StepName:= '0 - Nulovanie';
			Linka.ZmenModel:= FALSE;
			i:= 0;
			SC_ZmenaModelu.ResetStep:= TRUE;
			SC_ZmenaModelu.Step:= 1;
			
		1://Rozhodnutie o èinnosti//
			SC_ZmenaModelu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Linka.ZmenModel THEN
				SC_ZmenaModelu.Step:= 10;
			END_IF
					
		
		10://Kontrola zadania modelu//
			SC_ZmenaModelu.StepName:= '10 - Kontrola zadania modelu';
			IF Vizu.Nacitany_MODEL <> '' AND Vizu.Nacitany_LOT <> '' THEN
				SC_ZmenaModelu.ResetStep:= TRUE;
				SC_ZmenaModelu.Step:= 11;
			ELSE
				IF Vizu.Nacitany_MODEL = '' THEN
					Vizu.StavZmenyModelu_Index:= 1;
					Vizu.StavZmenyModelu_Farba:= 3;
				ELSIF Vizu.Nacitany_LOT = '' THEN
					Vizu.StavZmenyModelu_Index:= 2;
					Vizu.StavZmenyModelu_Farba:= 3;
				END_IF
				SC_ZmenaModelu.ResetStep:= TRUE;
				SC_ZmenaModelu.Step:= 0;
			END_IF	
				
		11://Hladanie modelu v recepturach//		
			SC_ZmenaModelu.StepName:= '11 - Hladanie modelu v recepturach';	
			ModelNajdeny:= FALSE;
			FOR i:= 0 TO 150 BY 1 DO
				IF (Receptura[i].NazovModelu = Vizu.Nacitany_MODEL) AND NOT ModelNajdeny THEN
					HistoriaVyroby[IndexHistorie].NazovModelu:= Zvoleny_MODEL;
					HistoriaVyroby[IndexHistorie].NazovLOTU:= Zvoleny_LOT;
					HistoriaVyroby[IndexHistorie].PocetVyrobenychKusov_OK:= PocetVyrobenychKusov_OK;
					HistoriaVyroby[IndexHistorie].PocetVyrobenychKusov_NG:= PocetVyrobenychKusov_NG;
					HistoriaVyroby[IndexHistorie].Pomer_OK_kusov_IDR:= Pomer_OK_kusov_IDR;
					IndexHistorie:= IndexHistorie + 1;
					IF IndexHistorie > 5 THEN
						IndexHistorie:= 0;
					END_IF	
					Linka.PAR.Zvoleny_MODEL:= Vizu.Nacitany_MODEL;
					Zvoleny_MODEL:= Vizu.Nacitany_MODEL;
					Linka.PAR.Zvoleny_LOT:= Vizu.Nacitany_LOT;
					Zvoleny_LOT:= Vizu.Nacitany_LOT;
					Linka.PAR.IndexZvoleneReceptury:= i;
					Vizu.StavZmenyModelu_Index:= 3;
					Vizu.StavZmenyModelu_Farba:= 2;
					RESET_PoctuVyrobenychKusov:= TRUE;
					Linka.Rezim_BezCistenia:= FALSE;
					Linka.Rezim_BezTlaceEtikety:= FALSE;
					Linka.Rezim_Testovania:= FALSE;
					NacitajRecepturu:= TRUE;
					ModelNajdeny:= TRUE;
				END_IF
			END_FOR	
			IF NOT ModelNajdeny THEN
				Vizu.StavZmenyModelu_Index:= 4;
				Vizu.StavZmenyModelu_Farba:= 3;
			END_IF	
			SC_ZmenaModelu.ResetStep:= TRUE;
			SC_ZmenaModelu.Step:= 0;

			
	END_CASE	
	
	
	
END_ACTION

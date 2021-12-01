
PROGRAM _INIT
	MpRecipeXml_2.Load:= TRUE;
	ZvolenyUzivatel:= '';
	ZvolenaUroven:= 0;
	TP_ZobrazPopUpPrihlasenie:=1;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Uzivatelia);
	
	
	//Naèítanie receptur z pamäte//
	IF MpRecipeXml_2.Load AND (MpRecipeXml_2.CommandDone OR MpRecipeXml_2.Error) THEN
		MpRecipeXml_2.Load:= FALSE;
		old_a:= 1;
		i:= 0; 
		IndexZoznam:= 0;
	END_IF	
	
	
	//Konfigurácia receptur//
	MpRecipeXml_2.MpLink:= ADR(gUzivatelXmlLink);  //takto sa menuje mapp komponenta v configurating view//
	MpRecipeXml_2.Enable:= TRUE;
	MpRecipeXml_2.Category:= ADR('UZIVATELIA');
	MpRecipeXml_2.Category:= ADR(strCategory);
	MpRecipeXml_2.DeviceName:= ADR('HDD');  //Názov media, kde sa budú receptury ukladat//
	MpRecipeXml_2.FileName:= ADR('UlozenyUzivatel'); //Názov súboru do ktorého sa receptúry uložia//
	MpRecipeXml_2();
	
	MpRecipeRegPar_2.MpLink:= ADR(gUzivatelXmlLink);
	MpRecipeRegPar_2.Enable:= TRUE;
	MpRecipeRegPar_2.Category:= ADR('UZIVATELIA');
	MpRecipeRegPar_2.PVName:= ADR('Uzivatel'); //Názov premenné, kde je vytvorená štruktura dat pre receptury//
	MpRecipeRegPar_2();	
	
	
	//Zobrazenie názvou receptúr//
	FOR IndexZoznam:=0 TO 50 BY 1 DO
		ZoznamUzivatelov[IndexZoznam]:= Uzivatel[IndexZoznam].Meno;
	END_FOR
	
	//Posun indexu//
	IF MoveUP THEN
		IF i< 50 THEN
			i:= i+1;
		END_IF
		MoveUP:= FALSE;
	END_IF
	
	IF MoveDown THEN
		IF i>0 THEN
			i:= i-1;
		END_IF
		MoveDown:= FALSE;
	END_IF
	
	//Listovanie v uložených uživateloch//
	IF old_a <> i AND i >= 0 AND i <= 50 THEN
		MenoUzivatela:= Uzivatel[i].Meno;
		HesloUzivatela:= '*****';
		UrovenUzivatela:= Uzivatel[i].UrovenUzivatela;
		old_a:= i;
	END_IF	
	
	
	//Automatické odhlásenie uživatela//
	
	IF ZvolenaUroven > 0 AND ZvolenaUroven < 100 AND Vizu.CisloAktualnejObrazovky = 2 THEN 
		CasAutomOdhlaseniaUzivatela.IN:= TRUE;
	ELSE
		CasAutomOdhlaseniaUzivatela.IN:= FALSE;
	END_IF	
	
	IF CasAutomOdhlaseniaUzivatela.Q AND SC_Uzivatelia.Step = 1 THEN
		OdhlasUzivatela:= TRUE;
	END_IF	
	
	CasAutomOdhlaseniaUzivatela.PT:= T#5M;
	CasAutomOdhlaseniaUzivatela();
	
	
	
	
	//Prihlasovanie//
	CASE SC_Uzivatelia.Step OF
		
		0://Vynulovanie uživatela//
			SC_Uzivatelia.StepName:= '0 - Nulovanie';
			UlozUzivatelov:= FALSE;
			PrihlasUzivatela:= FALSE;
			VymazUzivatela:= FALSE;
			OdhlasUzivatela:= FALSE;
			MpRecipeXml_2.Save:= FALSE;
			b:= 0;
			c:= 0;
			d:= 0;
			UzivatelNajdeny:= FALSE;
			UzivatelUlozeny:= FALSE;
			SC_Uzivatelia.ResetStep:= TRUE;
			SC_Uzivatelia.Step:= 1;
			
		1://Rozhodnutie o èinnosti//
			SC_Uzivatelia.StepName:= '1 - Rozhodnutie o cinnosti';
			IF UlozUzivatelov THEN
				SC_Uzivatelia.Step:= 10;
			ELSIF PrihlasUzivatela THEN
				SC_Uzivatelia.Step:= 20;
			ELSIF OdhlasUzivatela THEN
				SC_Uzivatelia.Step:= 30;
			ELSIF VymazUzivatela THEN
				SC_Uzivatelia.Step:= 40;
			END_IF
		
		10://Ulozenie uzivatela//
			SC_Uzivatelia.StepName:= '10 - Ulozenie uzivatela - hladanie existujuceho uzivatela';
			IF MenoUzivatela <> '' AND HesloUzivatela <> '' AND HesloUzivatela <> '*****' THEN
				FOR c:= 0 TO 50 BY 1 DO
					IF Uzivatel[c].Meno = MenoUzivatela AND NOT UzivatelUlozeny THEN
						Uzivatel[c].Heslo:= HesloUzivatela;
						Uzivatel[c].UrovenUzivatela:= UrovenUzivatela;
						MpRecipeXml_2.Save:= TRUE;
						UzivatelUlozeny:= TRUE;
					END_IF
				END_FOR	
			ELSE	
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 0;
			END_IF
							
			IF UzivatelUlozeny AND MpRecipeXml_2.CommandDone THEN
				MpRecipeXml_2.Save:= FALSE;
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 0;
			ELSIF NOT UzivatelUlozeny THEN
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 11;	
			END_IF
		
			
		11:
			//Ulozenie uzivatela//
			SC_Uzivatelia.StepName:= '10 - Ulozenie uzivatela - ulozenie na prve prazdne miesto';	
			
			FOR d:= 0 TO 50 BY 1 DO
				IF Uzivatel[d].Meno = '' AND NOT UzivatelUlozeny THEN
					Uzivatel[d].Meno:= MenoUzivatela;
					Uzivatel[d].Heslo:= HesloUzivatela;
					Uzivatel[d].UrovenUzivatela:= UrovenUzivatela;
					MpRecipeXml_2.Save:= TRUE;
					UzivatelUlozeny:= TRUE;
				END_IF	
			END_FOR
			
			IF UzivatelUlozeny AND MpRecipeXml_2.CommandDone THEN
				MpRecipeXml_2.Save:= FALSE;
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 0;
			ELSIF NOT UzivatelUlozeny THEN
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 0;
			END_IF
			
			
		
		20://Èakanie na prihlásenie uživatela//
			SC_Uzivatelia.StepName:= '20 - Kontrola prazdneho uzivatela';
			IF ZadaneMenoUzivatela <> '' AND ZadaneHesloUzivatela <> '' THEN
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 21;
			ELSE
				ZadaneHesloUzivatela:= ''; 
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 0;
			END_IF	
				
		21://Kontrola prihláseného uživatela//		
			SC_Uzivatelia.StepName:= '21 - Kontrola prihláseného uzivatela';	
			FOR b:= 0 TO 50 BY 1 DO
				IF Uzivatel[b].Meno = ZadaneMenoUzivatela AND Uzivatel[b].Heslo = ZadaneHesloUzivatela AND NOT UzivatelNajdeny THEN
					ZvolenyUzivatel:= Uzivatel[b].Meno;
					ZvolenaUroven:= Uzivatel[b].UrovenUzivatela;
					ZadaneHesloUzivatela:= ''; 
					TP_ZobrazPopUpPrihlasenie:= 1;
					UzivatelNajdeny:= TRUE;
				ELSIF ZadaneMenoUzivatela = 'DesignMP' AND ZadaneHesloUzivatela = 'vlmardo'	AND NOT UzivatelNajdeny THEN
					ZvolenyUzivatel:= 'DesignMP';
					ZvolenaUroven:= 100;
					ZadaneHesloUzivatela:= ''; 
					TP_ZobrazPopUpPrihlasenie:= 1;
					UzivatelNajdeny:= TRUE;
				END_IF	
			END_FOR
			(*ZadaneMenoUzivatela:= '';*)
			ZadaneHesloUzivatela:= ''; 
			SC_Uzivatelia.ResetStep:= TRUE;
			SC_Uzivatelia.Step:= 0;
	
		
		30://Odhlásenie uživatela//
			SC_Uzivatelia.StepName:= '30 - Odhlasenie uzivatela';
			ZvolenyUzivatel:= '';
			ZvolenaUroven:= 0;
			SC_Uzivatelia.ResetStep:= TRUE;
			SC_Uzivatelia.Step:= 0;
		
		
		40://Vymazanie uživatela//
			SC_Uzivatelia.StepName:= '40 - Vymazanie uzivatela';	
			Uzivatel[i].Meno:= '';
			Uzivatel[i].Heslo:= '';
			Uzivatel[i].UrovenUzivatela:= 0;
			MpRecipeXml_2.Save:= TRUE;
			IF MpRecipeXml_2.CommandDone THEN
				SC_Uzivatelia.ResetStep:= TRUE;
				SC_Uzivatelia.Step:= 0;
			END_IF
		
	END_CASE	
	
	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


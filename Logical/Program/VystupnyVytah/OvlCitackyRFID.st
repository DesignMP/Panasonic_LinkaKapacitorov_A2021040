
ACTION OvlCitackyRFID: 

	
		//***********************************************************************Riadenie RFID hlavy 3 - PozÌcia dopravnÌka NG**********************************************************************//
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Hlava_3);
	
	
	//*************************Komunik·cia*******************************//
	//INPUTS//
	RFID_Hlava_3.STAV.PritomnostCipu:= RFID_Hlava_3.IN.BYTE_IN[0].0;
	RFID_Hlava_3.IN.Bit_CP:= RFID_Hlava_3.IN.BYTE_IN[0].0;
	RFID_Hlava_3.IN.Bit_AA:= RFID_Hlava_3.IN.BYTE_IN[0].1;
	RFID_Hlava_3.IN.Bit_AE:= RFID_Hlava_3.IN.BYTE_IN[0].2;
	RFID_Hlava_3.IN.Bit_AF:= RFID_Hlava_3.IN.BYTE_IN[0].3;
	RFID_Hlava_3.IN.Bit_MT:= RFID_Hlava_3.IN.BYTE_IN[0].4;
	RFID_Hlava_3.IN.Bit_TO:= RFID_Hlava_3.IN.BYTE_IN[0].5;
	RFID_Hlava_3.IN.Bit_HF:= RFID_Hlava_3.IN.BYTE_IN[0].6;
	RFID_Hlava_3.IN.Bit_BB:= RFID_Hlava_3.IN.BYTE_IN[0].7;
	
	//OUTPUTS//
	RFID_Hlava_3.OUT.BYTE_OUT[0].0:= RFID_Hlava_3.OUT.Bit_AV;
	RFID_Hlava_3.OUT.BYTE_OUT[31].0:= RFID_Hlava_3.OUT.Bit_AV;
	RFID_Hlava_3.OUT.BYTE_OUT[0].2:= RFID_Hlava_3.OUT.Bit_GR;
	RFID_Hlava_3.OUT.BYTE_OUT[31].2:= RFID_Hlava_3.OUT.Bit_GR;
	RFID_Hlava_3.OUT.BYTE_OUT[0].5:= RFID_Hlava_3.OUT.Bit_KA;
	RFID_Hlava_3.OUT.BYTE_OUT[31].5:= RFID_Hlava_3.OUT.Bit_KA;
	RFID_Hlava_3.OUT.BYTE_OUT[0].6:= RFID_Hlava_3.OUT.Bit_TI;
	RFID_Hlava_3.OUT.BYTE_OUT[31].6:= RFID_Hlava_3.OUT.Bit_TI;
	
	
	//PreËÌtanÈ znaky//
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[0]:= RFID_Hlava_3.IN.BYTE_IN[1];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[1]:= RFID_Hlava_3.IN.BYTE_IN[2];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[2]:= RFID_Hlava_3.IN.BYTE_IN[3];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[3]:= RFID_Hlava_3.IN.BYTE_IN[4];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[4]:= RFID_Hlava_3.IN.BYTE_IN[5];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[5]:= RFID_Hlava_3.IN.BYTE_IN[6];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[6]:= RFID_Hlava_3.IN.BYTE_IN[7];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[7]:= RFID_Hlava_3.IN.BYTE_IN[8];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[8]:= RFID_Hlava_3.IN.BYTE_IN[9];
	RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE[9]:= RFID_Hlava_3.IN.BYTE_IN[10];
	
	brsmemcpy(ADR(RFID_Hlava_3.PAR.Precitane_Cislo_Typ_Paletky),ADR(RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE),SIZEOF(RFID_Hlava_3.PAR.PrecitaneCisloPaletky_POLE));
	
	
		
	//Rozdelenie preËÌtanej spr·vy na ËÌslo paletky a model//
	IF RFID_Hlava_3.STAV.PritomnostCipu THEN
		brsmemset(ADR(VstupnePoleUSINT),0,SIZEOF(VstupnePoleUSINT)); //Vymazanie vstupneho pola
		brsmemset(ADR(VystupnePoleStringov),0,SIZEOF(VystupnePoleStringov)); //Vymazanie v˝stupneho pola znakov
		PocetZnakovUDINT := brsstrlen(ADR(RFID_Hlava_3.PAR.Precitane_Cislo_Typ_Paletky)); //Zistenie poËtu znakov vstupnej spravy
		PocetZnakovUSINT:= UDINT_TO_USINT(PocetZnakovUDINT);
		brsmemcpy(ADR(VstupnePoleUSINT),ADR(RFID_Hlava_3.PAR.Precitane_Cislo_Typ_Paletky),SIZEOF(RFID_Hlava_3.PAR.Precitane_Cislo_Typ_Paletky)); //Vyplnenie polia znakmy vstupnej spr·vy
		h:= 1;
		FOR g:= 1 TO PocetZnakovUSINT BY 1 DO
			IF VstupnePoleUSINT[g] <> 59 THEN //59 je oddelovacÌ znak bodkoËiarka
				AktualNacitanyZnak:= VstupnePoleUSINT[g];
				brsstrcat(ADR(VystupnePoleStringov[h]),ADR(AktualNacitanyZnak));
			ELSE
				h:= h + 1;
			END_IF
		END_FOR
		RFID_Hlava_3.PAR.PrecitaneCisloPaletky:= VystupnePoleStringov[1];
		RFID_Hlava_3.PAR.PrecitanyTypPaletky:= VystupnePoleStringov[2];
	ELSE
		RFID_Hlava_3.PAR.PrecitaneCisloPaletky:= '';
		RFID_Hlava_3.PAR.PrecitanyTypPaletky:= '';
	END_IF		
	
	
	
	
	
	
	CASE SC_Hlava_3.Step OF 
	
		0:
			SC_Hlava_3.StepName:= '0 - Nulovanie';
			RFID_Hlava_3.CMD.CitajDATA:= FALSE;
			RFID_Hlava_3.CMD.ZapisDATA:= FALSE;
			RFID_Hlava_3.CMD.CitaciuHlavu_VYPNI:= FALSE;
			RFID_Hlava_3.OUT.Bit_AV:= FALSE;
			RFID_Hlava_3.OUT.Bit_GR:= FALSE;
			RFID_Hlava_3.OUT.Bit_TI:= FALSE;
			RFID_Hlava_3.OUT.Bit_KA:= FALSE;
			
			IF RFID_Hlava_3.STAV.PritomnostCipu THEN
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 1;
			END_IF	
			
	
	
		1:
			SC_Hlava_3.StepName:= '1 - Rozhodnutie o cinnosti';
			IF NOT RFID_Hlava_3.STAV.PritomnostCipu THEN
				SC_Hlava_3.Step:= 0;
			ELSIF RFID_Hlava_3.CMD.CitajDATA THEN
				RFID_Hlava_3.STAV.CitanieDat_OK:= FALSE;
				RFID_Hlava_3.STAV.CitanieDat_ERROR:= FALSE;
				SC_Hlava_3.Step:= 10;
			ELSIF RFID_Hlava_3.CMD.ZapisDATA THEN
				RFID_Hlava_3.STAV.ZapisDat_OK:= FALSE;
				RFID_Hlava_3.STAV.ZapisDat_ERROR:= FALSE;
				SC_Hlava_3.Step:= 20;
			ELSIF RFID_Hlava_3.CMD.CitaciuHlavu_VYPNI THEN
				SC_Hlava_3.Step:= 30;	
			END_IF
		
		10:
			SC_Hlava_3.StepName:= '10 - Citanie dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#6s;
		
			RFID_Hlava_3.IN.Old_Bit_TO:= RFID_Hlava_3.IN.Bit_TO;
			RFID_Hlava_3.OUT.BYTE_OUT[1]:= 1; //Kommand - 1 - ËÌtanie, 2 - z·pis
			RFID_Hlava_3.OUT.BYTE_OUT[2]:= 0; //ätartovacia adresa ËÌtania (LSB) - na 2 byte zaËÌna zapisovaù naËÌtanÈ znaky
			RFID_Hlava_3.OUT.BYTE_OUT[3]:= 0; //ätartovacia adresa ËÌtania (HSB)
			RFID_Hlava_3.OUT.BYTE_OUT[4]:= 10; //PoËet bajtov ËÌtania (LSB) - 10 znakov  
			RFID_Hlava_3.OUT.BYTE_OUT[5]:= 0; //PoËet bajtov ËÌtania (HSB)
			RFID_Hlava_3.OUT.Bit_AV:= TRUE;
			
			SC_Hlava_3.ResetStep:= TRUE;
			SC_Hlava_3.Step:= 11;
		
		
		11:
			SC_Hlava_3.StepName:= '11 - Citanie dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#2s;
					
			IF RFID_Hlava_3.IN.Bit_AA AND RFID_Hlava_3.IN.Bit_AE AND (RFID_Hlava_3.IN.Old_Bit_TO <> RFID_Hlava_3.IN.Bit_TO) THEN
				RFID_Hlava_3.STAV.CitanieDat_OK:= TRUE;
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 12;
			ELSIF RFID_Hlava_3.IN.Bit_AF THEN
				RFID_Hlava_3.STAV.CitanieDat_ERROR:= TRUE;
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 12;
			END_IF
		
		12:
			SC_Hlava_3.StepName:= '12 - Citanie dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#6s;
		
			RFID_Hlava_3.OUT.Bit_AV:= FALSE;		
		
			IF NOT RFID_Hlava_3.IN.Bit_AA AND NOT RFID_Hlava_3.IN.Bit_AE AND NOT RFID_Hlava_3.IN.Bit_AF THEN
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 0;
			END_IF
		
		
		20:
			SC_Hlava_3.StepName:= '20 - Z·pis dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#6s;
		
			RFID_Hlava_3.IN.Old_Bit_TO:= RFID_Hlava_3.IN.Bit_TO;
			RFID_Hlava_3.OUT.BYTE_OUT[1]:= 2; //Kommand - 1 - ËÌtanie, 2 - z·pis
			RFID_Hlava_3.OUT.BYTE_OUT[2]:= 0; //ätartovacia adresa z·pisu (LSB) - na 2 byte zaËÌna zapisovaù znaky
			RFID_Hlava_3.OUT.BYTE_OUT[3]:= 0; //ätartovacia adresa z·pisu (HSB)
			RFID_Hlava_3.OUT.BYTE_OUT[4]:= 10; //PoËet bajtov z·pisu (LSB) - 10 znakov  
			RFID_Hlava_3.OUT.BYTE_OUT[5]:= 0; //PoËet bajtov z·pisu (HSB)
			RFID_Hlava_3.OUT.Bit_AV:= TRUE;
			
			SC_Hlava_3.ResetStep:= TRUE;
			SC_Hlava_3.Step:= 21;
	
			
			
		21:
			SC_Hlava_3.StepName:= '21 - Z·pis dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#2s;
					
			IF RFID_Hlava_3.IN.Bit_AA AND (RFID_Hlava_3.IN.Old_Bit_TO <> RFID_Hlava_3.IN.Bit_TO) THEN
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 22;
			END_IF	
			
				
			
		22:
			SC_Hlava_3.StepName:= '21 - Z·pis dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#6s;
		
			brsstrcpy(ADR(RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE),ADR(RFID_Hlava_3.PAR.Zadane_Cislo_Typ_Paletky));
			RFID_Hlava_3.OUT.BYTE_OUT[1]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[0];
			RFID_Hlava_3.OUT.BYTE_OUT[2]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[1];
			RFID_Hlava_3.OUT.BYTE_OUT[3]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[2];
			RFID_Hlava_3.OUT.BYTE_OUT[4]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[3];
			RFID_Hlava_3.OUT.BYTE_OUT[5]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[4];
			RFID_Hlava_3.OUT.BYTE_OUT[6]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[5];
			RFID_Hlava_3.OUT.BYTE_OUT[7]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[6];
			RFID_Hlava_3.OUT.BYTE_OUT[8]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[7];
			RFID_Hlava_3.OUT.BYTE_OUT[9]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[8];
			RFID_Hlava_3.OUT.BYTE_OUT[10]:= RFID_Hlava_3.PAR.ZadaneCisloPaletky_POLE[9];
			
			IF RFID_Hlava_3.OUT.Bit_TI THEN
				RFID_Hlava_3.OUT.Bit_TI:= FALSE;
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 23;
			ELSE
				RFID_Hlava_3.OUT.Bit_TI:= TRUE;
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 23;
			END_IF	
		
		
		
		
		23:
			SC_Hlava_3.StepName:= '23 - Z·pis dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#2s;
					
			IF RFID_Hlava_3.IN.Bit_AE THEN
				RFID_Hlava_3.STAV.ZapisDat_OK:= TRUE;
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 24;
			ELSIF RFID_Hlava_3.IN.Bit_AF THEN
				RFID_Hlava_3.STAV.ZapisDat_ERROR:= TRUE;
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 24;
			END_IF
		
		
		24:
			SC_Hlava_3.StepName:= '22 - Z·pis dat';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#6s;
		
			RFID_Hlava_3.OUT.Bit_AV:= FALSE;		
		
			IF NOT RFID_Hlava_3.IN.Bit_AA AND NOT RFID_Hlava_3.IN.Bit_AE AND NOT RFID_Hlava_3.IN.Bit_AF THEN
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 0;
			END_IF
		
		
		
		30:
			SC_Hlava_3.StepName:= '30 - Vypnutie citacej hlavy';
			SC_Hlava_3.IdleTime.PT:= T#3s;
			SC_Hlava_3.AlarmTime.PT:= T#2s;
		
			RFID_Hlava_3.OUT.Bit_KA:= TRUE;
		
			IF NOT RFID_Hlava_3.CMD.CitaciuHlavu_VYPNI THEN
				SC_Hlava_3.ResetStep:= TRUE;
				SC_Hlava_3.Step:= 0;
			END_IF
		
		
		
		
	END_CASE
	
	
	
END_ACTION

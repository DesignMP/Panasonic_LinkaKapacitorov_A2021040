
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_StoperPredCistenim);
	
	//Volanie podprogramov//
	OvlCitackyRFID;
	
	//Reset sekcie //
	IF StoperPredCistenim.Reset THEN
		SC_StoperPredCistenim.Step:= 0;
		StoperPredCistenim.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_StoperPredCistenim.Step:= 0;
	END_IF	
	

	
	CASE SC_StoperPredCistenim.Step OF 
	
		0:
			SC_StoperPredCistenim.StepName:='0 - Nulovanie';
			StoperPredCistenim.Automat:= FALSE;
			StoperPredCistenim.KoniecCyklu:= FALSE;
			StoperPredCistenim.Manual:= FALSE;
			StoperPredCistenim.STAV.PoINIT:= FALSE;
			StoperPredCistenim.OUT.StoperZASUN_YV005:= FALSE;
			StoperPredCistenim.STAV.PrebiehaVyvazaniePaletky:= FALSE;
			Linka.OUT.IonJednotka_START:= FALSE;	
			Linka.STAV.IonizacnaJednotka_BUSY:= FALSE;
			StoperPredCistenim_Statistika.IN.START_MeraniaCasu:= FALSE;
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 1;
			END_IF
	
		1:
			SC_StoperPredCistenim.StepName:='1 - Cakam na spustenie vyroby';
			StoperPredCistenim.KoniecCyklu:= FALSE;
			IF StoperPredCistenim.Automat THEN
				SC_StoperPredCistenim.Step:= 2;
			ELSIF StoperPredCistenim.Manual THEN
				SC_StoperPredCistenim.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
		2:
			SC_StoperPredCistenim.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_StoperPredCistenim.IdleTime.PT:= T#4s;
			SC_StoperPredCistenim.AlarmTime.PT:= T#5s;
			
									
			IF DopravCistenia.STAV.PoINIT THEN
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 3;
			END_IF
		
		3:
			SC_StoperPredCistenim.StepName:='3 - Inicializacia - hladanie paletky';
			SC_StoperPredCistenim.IdleTime.PT:= T#5s;
			SC_StoperPredCistenim.AlarmTime.PT:= T#5s;
			SC_StoperPredCistenim.IdleTime.IN:= TRUE;
	
			IF StoperPredCistenim.IN.PritomnostPaletky_IS4 THEN
				StoperPredCistenim.STAV.PoINIT:= TRUE;
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 101;		
			ELSIF SC_StoperPredCistenim.IdleTime.Q THEN
				StoperPredCistenim.STAV.PoINIT:= TRUE;
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 100;
			END_IF
	
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_StoperPredCistenim.StepName:='100 - Automaticky Rezim - cakam na príchod paletky na stoper';
			SC_StoperPredCistenim.IdleTime.PT:= T#200ms;
			SC_StoperPredCistenim.AlarmTime.PT:= T#30s;
		
			SC_StoperPredCistenim.AlarmTime.IN:= TRUE;
			
			IF SC_StoperPredCistenim.AlarmTime.Q THEN
				Linka.OUT.IonJednotka_START:= FALSE;
				Linka.STAV.IonizacnaJednotka_BUSY:= FALSE;
			END_IF	
			
			DopravCistenia.PAR.ZadanaRychlost:= 50;
		
			SC_StoperPredCistenim.IdleTime.IN:= StoperPredCistenim.IN.PritomnostPaletky_IS4;
			
			IF StoperPredCistenim.KoniecCyklu THEN
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 0;
			ELSIF SC_StoperPredCistenim.IdleTime.Q THEN
				StoperPredCistenim_Statistika.IN.START_MeraniaCasu:= TRUE;
				StoperPredCistenim_Statistika.IN.ZAPIS_MeraniaCasu:= TRUE;
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 101;
			END_IF
	
		
		101:
			SC_StoperPredCistenim.StepName:='101 - Automaticky Rezim - cakam na vyvezenie paletky na stoper za cistenim';
			SC_StoperPredCistenim.IdleTime.PT:= T#200ms;
			SC_StoperPredCistenim.AlarmTime.PT:= T#30s;
			
			SC_StoperPredCistenim.AlarmTime.IN:= TRUE;
			
			IF SC_StoperPredCistenim.AlarmTime.Q THEN
				Linka.OUT.IonJednotka_START:= FALSE;
				Linka.STAV.IonizacnaJednotka_BUSY:= FALSE;
			END_IF	
			
			IF StoperPredCistenim.KoniecCyklu THEN
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 0;
			ELSIF SC_StoperPoCisteni.Step = 100 AND (NOT StoperPoCisteni.IN.PritomnostPaletky_IS6 OR NOT StoperPoCisteni.IN.ZaplnenieBuffera_IS5) AND NOT StoperPoCisteni.STAV.PrebiehaVyvazaniePaletky THEN  
				IF NOT Linka.Rezim_BezCistenia THEN
					SC_StoperPredCistenim.ResetStep:= TRUE;
					SC_StoperPredCistenim.Step:= 103;
				ELSE
					SC_StoperPredCistenim.ResetStep:= TRUE;
					SC_StoperPredCistenim.Step:= 105;
				END_IF	
			ELSIF StoperPoCisteni.STAV.PoINIT AND NOT StoperPoCisteni.IN.ZaplnenieBuffera_IS5 THEN
				IF NOT Linka.Rezim_BezCistenia THEN
					SC_StoperPredCistenim.ResetStep:= TRUE;
					SC_StoperPredCistenim.Step:= 103;
				ELSE
					SC_StoperPredCistenim.ResetStep:= TRUE;
					SC_StoperPredCistenim.Step:= 105;
				END_IF
			END_IF
		
		103:
			SC_StoperPredCistenim.StepName:='103 - Automaticky Rezim - cakam na spustenie cistenia';
			SC_StoperPredCistenim.IdleTime.PT:= T#2s;
			SC_StoperPredCistenim.AlarmTime.PT:= T#10s;
			
			DopravCistenia.PAR.ZadanaRychlost:= Linka.PAR.Zvolena_RychlostDopravPriCisteni;
			
			
			IF NOT SC_StoperPredCistenim.Switch1 THEN
				Linka.OUT.IonJednotka_START:= TRUE;
				SC_StoperPredCistenim.IdleTime.IN:= TRUE;
				SC_StoperPredCistenim.Switch1:= TRUE;
			END_IF	
			
			IF NOT Linka.STAV.PoruchaOtacaniaTrysiek AND SC_StoperPredCistenim.IdleTime.Q THEN
				Linka.STAV.IonizacnaJednotka_BUSY:= TRUE;
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 105;
			ELSIF Linka.STAV.IonizacnaJednotka_BUSY THEN 
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 105;
			ELSIF Linka.STAV.PoruchaOtacaniaTrysiek THEN
				PoruchaCistenia:= TRUE;
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 0;
			END_IF	
			
			
		105:
			SC_StoperPredCistenim.StepName:='105 - Automaticky Rezim - vyvazam paletku na RFID snimac po cisteni, zastavenie cistenia';
			SC_StoperPredCistenim.IdleTime.PT:= T#200ms;
			SC_StoperPredCistenim.AlarmTime.PT:= T#10s;
			
						
			SC_StoperPredCistenim.IdleTime.IN:= NOT StoperPredCistenim.IN.PritomnostPaletky_IS4;
			
			IF NOT SC_StoperPredCistenim.Switch1 THEN
				StoperPredCistenim.OUT.StoperZASUN_YV005:= TRUE;
				SC_StoperPredCistenim.AlarmTime.IN:= TRUE;
				StoperPredCistenim.STAV.PrebiehaVyvazaniePaletky:= TRUE;
				SC_StoperPredCistenim.Switch1:= TRUE;
			END_IF	
			
			IF SC_StoperPredCistenim.IdleTime.Q THEN
				StoperPredCistenim.OUT.StoperZASUN_YV005:= FALSE;
				SC_StoperPredCistenim.AlarmTime.IN:= FALSE;
			END_IF
			
		
			
			IF NOT StoperPredCistenim.OUT.StoperZASUN_YV005 AND RFID_Hlava_4.STAV.PritomnostCipu THEN
				(*Linka.OUT.IonJednotka_START:= FALSE;*)
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 107;
			END_IF	
			
			
		107:
			SC_StoperPredCistenim.StepName:='107 - Automaticky Rezim - precitanie cisla paletky';
			SC_StoperPredCistenim.IdleTime.PT:= T#20ms;
			SC_StoperPredCistenim.AlarmTime.PT:= T#10s;
			
			SC_StoperPredCistenim.AlarmTime.IN:= TRUE;
			
			SC_StoperPredCistenim.IdleTime.IN:= RFID_Hlava_4.STAV.PritomnostCipu;
			
			IF RFID_Hlava_4.PAR.PrecitaneCisloPaletky <> '' THEN
				i:=  STRING_TO_USINT(RFID_Hlava_4.PAR.PrecitaneCisloPaletky);
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 110;
			END_IF
			
			IF SC_StoperPredCistenim.AlarmTime.Q THEN
				Alarmy[70]:= TRUE;
				PoruchaCistenia:= TRUE;
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 0;
			END_IF	
		
			
		110:
			SC_StoperPredCistenim.StepName:='110 - Automaticky Rezim - zapis stavu cistenia na paletku';
			SC_StoperPredCistenim.IdleTime.PT:= T#200ms;
			SC_StoperPredCistenim.AlarmTime.PT:= T#10s;
			
			IF Linka.Rezim_BezCistenia THEN
				Paletka[i].Cistenie_DONE:= TRUE;
				Paletka[i].StavCistenia:= 'OK';
				Paletka[i].StavPaletky:= 'OK';
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 115;
			ELSIF NOT Linka.STAV.PoruchaOtacaniaTrysiek THEN
				Paletka[i].Cistenie_DONE:= TRUE;
				Paletka[i].StavCistenia:= 'OK';
				Paletka[i].StavPaletky:= 'OK';
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 115;
			ELSIF Linka.STAV.PoruchaOtacaniaTrysiek THEN
				Paletka[i].Cistenie_DONE:= TRUE;
				Paletka[i].StavCistenia:= 'NG';
				Paletka[i].StavPaletky:= 'NG';
				SC_StoperPredCistenim.ResetStep:= TRUE;
				SC_StoperPredCistenim.Step:= 115;
			END_IF	
			
			
				
			
		115:
			SC_StoperPredCistenim.StepName:='115 - Automaticky Rezim - vyvazam paletku na stoper po cisteni';
			SC_StoperPredCistenim.IdleTime.PT:= T#4s;
			SC_StoperPredCistenim.AlarmTime.PT:= T#10s;
			
			DopravCistenia.PAR.ZadanaRychlost:= 80;
			
			IF NOT SC_StoperPredCistenim.Switch1 THEN
				DopravCistenia.Dopravnik_RUN:= TRUE;
				SC_StoperPredCistenim.Switch1:= TRUE;
			END_IF	
			
						
			IF StoperPoCisteni.IN.PritomnostPaletky_IS6 THEN
				StoperPredCistenim.STAV.PrebiehaVyvazaniePaletky:= FALSE;
				IF NOT Linka.STAV.PoruchaOtacaniaTrysiek THEN
					SC_StoperPredCistenim.ResetStep:= TRUE;
					SC_StoperPredCistenim.Step:= 100;
				ELSE
					PoruchaCistenia:= TRUE;
					SC_StoperPredCistenim.ResetStep:= TRUE;
					SC_StoperPredCistenim.Step:= 0;
				END_IF	
			END_IF	
			
			
					
			
			
			
			
			
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_StoperPredCistenim.StepName:='700 - Manualny Rezim';
			SC_StoperPredCistenim.IdleTime.PT:= T#8s;
			SC_StoperPredCistenim.AlarmTime.PT:= T#5s;
		
		
		
		
		
		
		
	END_CASE		
			
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


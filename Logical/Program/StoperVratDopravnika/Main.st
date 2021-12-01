
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_StoperVratDopravnika);
	 
	
	
		
	//Reset sekcie //
	IF StoperVratDopravnika.Reset THEN
		SC_StoperVratDopravnika.Step:= 0;
		StoperVratDopravnika.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_StoperVratDopravnika.Step:= 0;
	END_IF	
	

	
	CASE SC_StoperVratDopravnika.Step OF 
	
		0:
			SC_StoperVratDopravnika.StepName:='0 - Nulovanie';
			StoperVratDopravnika.Automat:= FALSE;
			StoperVratDopravnika.KoniecCyklu:= FALSE;
			StoperVratDopravnika.Manual:= FALSE;
			StoperVratDopravnika.STAV.PoINIT:= FALSE;
			StoperVratDopravnika.OUT.StoperZASUN_YV012:= FALSE;
								
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 1;
			END_IF
	
		1:
			SC_StoperVratDopravnika.StepName:='1 - Cakam na spustenie vyroby';
			StoperVratDopravnika.KoniecCyklu:= FALSE;
			IF StoperVratDopravnika.Automat THEN
				SC_StoperVratDopravnika.Step:= 2;
			ELSIF StoperVratDopravnika.Manual THEN
				SC_StoperVratDopravnika.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		2:
			SC_StoperVratDopravnika.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_StoperVratDopravnika.IdleTime.PT:= T#4s;
			SC_StoperVratDopravnika.AlarmTime.PT:= T#5s;
			
									
			IF VratnyDopravnik.STAV.PoINIT THEN
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 3;
			END_IF
		
		3:
			SC_StoperVratDopravnika.StepName:='3 - Inicializacia - hladanie paletky';
			SC_StoperVratDopravnika.IdleTime.PT:= T#5s;
			SC_StoperVratDopravnika.AlarmTime.PT:= T#5s;
			SC_StoperVratDopravnika.IdleTime.IN:= TRUE;
	
			IF StoperVratDopravnika.IN.PritomnostPaletky_IS14 THEN
				StoperVratDopravnika.STAV.PoINIT:= TRUE;
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 101;		
			ELSIF SC_StoperVratDopravnika.IdleTime.Q THEN
				StoperVratDopravnika.STAV.PoINIT:= TRUE;
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 100;
			END_IF
	
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_StoperVratDopravnika.StepName:='100 - Automaticky Rezim - cakam na príchod paletky na stoper';
			SC_StoperVratDopravnika.IdleTime.PT:= T#200ms;
			SC_StoperVratDopravnika.AlarmTime.PT:= T#5s;
		
			SC_StoperVratDopravnika.IdleTime.IN:= StoperVratDopravnika.IN.PritomnostPaletky_IS14;
			
			IF StoperVratDopravnika.KoniecCyklu AND NOT VstupVytah.Automat THEN
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 0;
			ELSIF SC_StoperVratDopravnika.IdleTime.Q THEN
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 101;
			END_IF
	
		
		101:
			SC_StoperVratDopravnika.StepName:='101 - Automaticky Rezim - cakam na vyvezenie paletky na dopravnik vstupneho vytahu';
			SC_StoperVratDopravnika.IdleTime.PT:= T#200ms;
			SC_StoperVratDopravnika.AlarmTime.PT:= T#5s;
			
			IF StoperVratDopravnika.KoniecCyklu AND NOT VstupVytah.Automat THEN
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 0;
			ELSIF SC_VstupVytah.Step = 105 AND NOT VstupVytah.IN.PritomnostPaletky_IS3 THEN  
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 105;
			END_IF
	
	
		105:
			SC_StoperVratDopravnika.StepName:='105 - Automaticky Rezim - vyvazam paletku na dopravnik vstupneho vytahu';
			SC_StoperVratDopravnika.IdleTime.PT:= T#4s;
			SC_StoperVratDopravnika.AlarmTime.PT:= T#10s;
			
			IF NOT SC_StoperVratDopravnika.Switch1 THEN
				StoperVratDopravnika.OUT.StoperZASUN_YV012:= TRUE;
				SC_StoperVratDopravnika.AlarmTime.IN:= TRUE;
				SC_StoperVratDopravnika.Switch1:= TRUE;
			END_IF	
			
			IF NOT StoperVratDopravnika.IN.PritomnostPaletky_IS14 THEN
				StoperVratDopravnika.OUT.StoperZASUN_YV012:= FALSE;
				SC_StoperVratDopravnika.AlarmTime.IN:= FALSE;
			END_IF
						
			
			IF VstupVytah.IN.PritomnostPaletky_IS3 AND NOT StoperVratDopravnika.OUT.StoperZASUN_YV012 THEN
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 100;
			ELSIF SC_StoperVratDopravnika.AlarmTime.Q THEN
				Alarmy[41]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_StoperVratDopravnika.ResetStep:= TRUE;
				SC_StoperVratDopravnika.Step:= 0;
			END_IF
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_StoperVratDopravnika.StepName:='700 - Manualny Rezim';
			SC_StoperVratDopravnika.IdleTime.PT:= T#8s;
			SC_StoperVratDopravnika.AlarmTime.PT:= T#5s;
			
			
	END_CASE		
			
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


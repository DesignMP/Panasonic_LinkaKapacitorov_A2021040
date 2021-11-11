
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
		
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_StoperVystupDopravnika);
	 
		
	//Reset sekcie //
	IF StoperVystupDopravnika.Reset THEN
		SC_StoperVystupDopravnika.Step:= 0;
		StoperVystupDopravnika.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_StoperVystupDopravnika.Step:= 0;
	END_IF	
	

	
	CASE SC_StoperVystupDopravnika.Step OF 
	
		0:
			SC_StoperVystupDopravnika.StepName:='0 - Nulovanie';
			StoperVystupDopravnika.Automat:= FALSE;
			StoperVystupDopravnika.KoniecCyklu:= FALSE;
			StoperVystupDopravnika.Manual:= FALSE;
			StoperVystupDopravnika.STAV.PoINIT:= FALSE;
			StoperVystupDopravnika.OUT.StoperZASUN_YV011:= FALSE;
			StoperVystupDopravnika.STAV.PrebiehaVyvazaniePaletky:= FALSE;
											
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 1;
			END_IF
	
		1:
			SC_StoperVystupDopravnika.StepName:='1 - Cakam na spustenie vyroby';
			StoperVystupDopravnika.KoniecCyklu:= FALSE;
			IF StoperVystupDopravnika.Automat THEN
				SC_StoperVystupDopravnika.Step:= 2;
			ELSIF StoperVystupDopravnika.Manual THEN
				SC_StoperVystupDopravnika.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		2:
			SC_StoperVystupDopravnika.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_StoperVystupDopravnika.IdleTime.PT:= T#4s;
			SC_StoperVystupDopravnika.AlarmTime.PT:= T#5s;
			
									
			IF VystupnyDopravnik.STAV.PoINIT THEN
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 3;
			END_IF
		
		3:
			SC_StoperVystupDopravnika.StepName:='3 - Inicializacia - hladanie paletky';
			SC_StoperVystupDopravnika.IdleTime.PT:= T#5s;
			SC_StoperVystupDopravnika.AlarmTime.PT:= T#5s;
			SC_StoperVystupDopravnika.IdleTime.IN:= TRUE;
	
			IF StoperVystupDopravnika.IN.PritomnostPaletky_IS27 THEN
				StoperVystupDopravnika.STAV.PoINIT:= TRUE;
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 101;		
			ELSIF SC_StoperVystupDopravnika.IdleTime.Q THEN
				StoperVystupDopravnika.STAV.PoINIT:= TRUE;
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 100;
			END_IF
	
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_StoperVystupDopravnika.StepName:='100 - Automaticky Rezim - cakam na príchod paletky na stoper';
			SC_StoperVystupDopravnika.IdleTime.PT:= T#200ms;
			SC_StoperVystupDopravnika.AlarmTime.PT:= T#5s;
		
			SC_StoperVystupDopravnika.IdleTime.IN:= StoperVystupDopravnika.IN.PritomnostPaletky_IS27;
			
			IF StoperVystupDopravnika.KoniecCyklu THEN
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 0;
			ELSIF SC_StoperVystupDopravnika.IdleTime.Q THEN
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 101;
			END_IF
	
		
		101:
			SC_StoperVystupDopravnika.StepName:='101 - Automaticky Rezim - cakam na vyvezenie paletky na dopravnik vystupneho vytahu';
			SC_StoperVystupDopravnika.IdleTime.PT:= T#200ms;
			SC_StoperVystupDopravnika.AlarmTime.PT:= T#5s;
			
			IF StoperVystupDopravnika.KoniecCyklu THEN
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 0;
			ELSIF SC_VystupVytah.Step = 100 AND NOT VystupVytah.IN.PritomnostPaletky_IS26 THEN  
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 105;
			END_IF
	
	
		105:
			SC_StoperVystupDopravnika.StepName:='105 - Automaticky Rezim - vyvazam paletku na dopravnik vystupneho vytahu';
			SC_StoperVystupDopravnika.IdleTime.PT:= T#4s;
			SC_StoperVystupDopravnika.AlarmTime.PT:= T#10s;
			
			IF NOT SC_StoperVystupDopravnika.Switch1 THEN
				StoperVystupDopravnika.OUT.StoperZASUN_YV011:= TRUE;
				StoperVystupDopravnika.STAV.PrebiehaVyvazaniePaletky:= TRUE;
				SC_StoperVystupDopravnika.AlarmTime.IN:= TRUE;
				SC_StoperVystupDopravnika.Switch1:= TRUE;
			END_IF	
			
			IF NOT StoperVystupDopravnika.IN.PritomnostPaletky_IS27 THEN
				StoperVystupDopravnika.OUT.StoperZASUN_YV011:= FALSE;
				SC_StoperVystupDopravnika.AlarmTime.IN:= FALSE;
			END_IF
						
			
			IF VystupVytah.IN.PritomnostPaletky_IS26 AND NOT StoperVystupDopravnika.OUT.StoperZASUN_YV011  THEN
				StoperVystupDopravnika.STAV.PrebiehaVyvazaniePaletky:= FALSE;
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 100;
			ELSIF SC_StoperVystupDopravnika.AlarmTime.Q THEN
				Alarmy[40]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_StoperVystupDopravnika.ResetStep:= TRUE;
				SC_StoperVystupDopravnika.Step:= 0;
			END_IF
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_StoperVystupDopravnika.StepName:='700 - Manualny Rezim';
			SC_StoperVystupDopravnika.IdleTime.PT:= T#8s;
			SC_StoperVystupDopravnika.AlarmTime.PT:= T#5s;
			
			
	END_CASE		
			
	
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


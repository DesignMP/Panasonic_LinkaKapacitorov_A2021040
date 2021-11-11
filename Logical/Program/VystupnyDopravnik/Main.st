
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VystupnyDopravnik);
	
	
		
	//Reset sekcie //
	IF VystupnyDopravnik.Reset THEN
		SC_VystupnyDopravnik.Step:= 0;
		VystupnyDopravnik.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_VystupnyDopravnik.Step:= 0;
	END_IF	
	

	
	CASE SC_VystupnyDopravnik.Step OF 
	
		0:
			SC_VystupnyDopravnik.StepName:='0 - Nulovanie';
			VystupnyDopravnik.Automat:= FALSE;
			VystupnyDopravnik.KoniecCyklu:= FALSE;
			VystupnyDopravnik.Manual:= FALSE;
			VystupnyDopravnik.STAV.PoINIT:= FALSE;
			VystupnyDopravnik.OUT.Dopravnik_ChodVPRED_ELR5:= FALSE;
						
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_VystupnyDopravnik.ResetStep:= TRUE;
				SC_VystupnyDopravnik.Step:= 1;
			END_IF
	
		1:
			SC_VystupnyDopravnik.StepName:='1 - Cakam na spustenie vyroby';
			VystupnyDopravnik.KoniecCyklu:= FALSE;
			IF VystupnyDopravnik.Automat THEN
				SC_VystupnyDopravnik.Step:= 2;
			ELSIF VystupnyDopravnik.Manual THEN
				SC_VystupnyDopravnik.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		
		2:
			SC_VystupnyDopravnik.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_VystupnyDopravnik.IdleTime.PT:= T#500ms;
			SC_VystupnyDopravnik.AlarmTime.PT:= T#5s;
			
			SC_VystupnyDopravnik.IdleTime.IN:= TRUE;
		
						
			IF SC_VystupnyDopravnik.IdleTime.Q THEN
				SC_VystupnyDopravnik.ResetStep:= TRUE;
				SC_VystupnyDopravnik.Step:= 5;
			END_IF	
	
			
					
		5:
			SC_VystupnyDopravnik.StepName:='5 - Inicializacia - spustenie dopravnika a ukoncenie inicializacie';
			SC_VystupnyDopravnik.IdleTime.PT:= T#2s;
			SC_VystupnyDopravnik.AlarmTime.PT:= T#5s;
		
						
			IF NOT SC_VystupnyDopravnik.Switch1 THEN
				VystupnyDopravnik.OUT.Dopravnik_ChodVPRED_ELR5:= TRUE;
				SC_VystupnyDopravnik.IdleTime.IN:= TRUE;
				SC_VystupnyDopravnik.Switch1:= TRUE;
			END_IF	
			
			IF SC_VystupnyDopravnik.IdleTime.Q THEN
				VystupnyDopravnik.STAV.PoINIT:= TRUE;
				SC_VystupnyDopravnik.ResetStep:= TRUE;
				SC_VystupnyDopravnik.Step:= 100;
			END_IF
			
	
			
			//********************************************************Automatický režim****************************************************************************//
			
		100:  
			SC_VystupnyDopravnik.StepName:='100 - Automaticky Rezim - cakam na vypnutie dopravnika';
			SC_VystupnyDopravnik.IdleTime.PT:= T#200ms;
			SC_VystupnyDopravnik.AlarmTime.PT:= T#5s;			
			
			IF VystupnyDopravnik.KoniecCyklu AND NOT StoperVystupDopravnika.Automat AND NOT VystupVytah.Automat THEN
				SC_VystupnyDopravnik.ResetStep:= TRUE;
				SC_VystupnyDopravnik.Step:= 0;
			END_IF
			
			
			
			
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_VystupnyDopravnik.StepName:='700 - Manualny Rezim';
			SC_VystupnyDopravnik.IdleTime.PT:= T#8s;
			SC_VystupnyDopravnik.AlarmTime.PT:= T#5s;
			
			
			
			
	END_CASE	
	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


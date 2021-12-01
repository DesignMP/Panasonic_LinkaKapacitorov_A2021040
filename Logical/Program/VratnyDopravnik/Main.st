
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VratnyDopravnik);
	 
			
	//Reset sekcie //
	IF VratnyDopravnik.Reset THEN
		SC_VratnyDopravnik.Step:= 0;
		VratnyDopravnik.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_VratnyDopravnik.Step:= 0;
	END_IF	
	

	
	CASE SC_VratnyDopravnik.Step OF 
	
		0:
			SC_VratnyDopravnik.StepName:='0 - Nulovanie';
			VratnyDopravnik.Automat:= FALSE;
			VratnyDopravnik.KoniecCyklu:= FALSE;
			VratnyDopravnik.Manual:= FALSE;
			VratnyDopravnik.STAV.PoINIT:= FALSE;
			VratnyDopravnik.OUT.Dopravnik_ChodVPRED_ELR2:= FALSE;
						
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_VratnyDopravnik.ResetStep:= TRUE;
				SC_VratnyDopravnik.Step:= 1;
			END_IF
	
		1:
			SC_VratnyDopravnik.StepName:='1 - Cakam na spustenie vyroby';
			VratnyDopravnik.KoniecCyklu:= FALSE;
			IF VratnyDopravnik.Automat THEN
				SC_VratnyDopravnik.Step:= 2;
			ELSIF VratnyDopravnik.Manual THEN
				SC_VratnyDopravnik.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		
		2:
			SC_VratnyDopravnik.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_VratnyDopravnik.IdleTime.PT:= T#500ms;
			SC_VratnyDopravnik.AlarmTime.PT:= T#5s;
			
			SC_VratnyDopravnik.IdleTime.IN:= TRUE;
		
						
			IF SC_VratnyDopravnik.IdleTime.Q THEN
				SC_VratnyDopravnik.ResetStep:= TRUE;
				SC_VratnyDopravnik.Step:= 5;
			END_IF	
	
			
					
		5:
			SC_VratnyDopravnik.StepName:='5 - Inicializacia - spustenie dopravnika a ukoncenie inicializacie';
			SC_VratnyDopravnik.IdleTime.PT:= T#2s;
			SC_VratnyDopravnik.AlarmTime.PT:= T#5s;
		
						
			IF NOT SC_VratnyDopravnik.Switch1 THEN
				VratnyDopravnik.OUT.Dopravnik_ChodVPRED_ELR2:= TRUE;
				SC_VratnyDopravnik.IdleTime.IN:= TRUE;
				SC_VratnyDopravnik.Switch1:= TRUE;
			END_IF	
			
			IF SC_VratnyDopravnik.IdleTime.Q THEN
				VratnyDopravnik.STAV.PoINIT:= TRUE;
				SC_VratnyDopravnik.ResetStep:= TRUE;
				SC_VratnyDopravnik.Step:= 100;
			END_IF
			
	
			
			//********************************************************Automatický režim****************************************************************************//
			
		100:  
			SC_VratnyDopravnik.StepName:='100 - Automaticky Rezim - cakam na vypnutie dopravnika';
			SC_VratnyDopravnik.IdleTime.PT:= T#200ms;
			SC_VratnyDopravnik.AlarmTime.PT:= T#5s;			
			
			VratnyDopravnik.OUT.Dopravnik_ChodVPRED_ELR2:= NOT Linka.STAV.Dopravniky_PAUZA;
						
			IF VratnyDopravnik.KoniecCyklu AND NOT StoperVratDopravnika.Automat AND NOT VstupVytah.Automat AND NOT VystupVytah.Automat THEN
				SC_VratnyDopravnik.ResetStep:= TRUE;
				SC_VratnyDopravnik.Step:= 0;
			END_IF
			
			
			
			
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_VratnyDopravnik.StepName:='700 - Manualny Rezim';
			SC_VratnyDopravnik.IdleTime.PT:= T#8s;
			SC_VratnyDopravnik.AlarmTime.PT:= T#5s;
			
			
			
			
	END_CASE	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


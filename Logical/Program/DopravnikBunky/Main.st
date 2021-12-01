
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_DopravBunky);
	
	
		
	//Reset sekcie //
	IF DopravBunky.Reset THEN
		SC_DopravBunky.Step:= 0;
		DopravBunky.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_DopravBunky.Step:= 0;
	END_IF	
	

	
	CASE SC_DopravBunky.Step OF 
	
		0:
			SC_DopravBunky.StepName:='0 - Nulovanie';
			DopravBunky.Automat:= FALSE;
			DopravBunky.KoniecCyklu:= FALSE;
			DopravBunky.Manual:= FALSE;
			DopravBunky.STAV.PoINIT:= FALSE;
			DopravBunky.OUT.Dopravnik_ChodVPRED_ELR4:= FALSE;
						
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Safety.STAV.ZonaBunky_AKTIVNA  AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_DopravBunky.ResetStep:= TRUE;
				SC_DopravBunky.Step:= 1;
			END_IF
	
		1:
			SC_DopravBunky.StepName:='1 - Cakam na spustenie vyroby';
			DopravBunky.KoniecCyklu:= FALSE;
			IF DopravBunky.Automat THEN
				SC_DopravBunky.Step:= 2;
			ELSIF DopravBunky.Manual THEN
				SC_DopravBunky.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		
		2:
			SC_DopravBunky.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_DopravBunky.IdleTime.PT:= T#500ms;
			SC_DopravBunky.AlarmTime.PT:= T#5s;
			
			IF Robot.STAV.PoINIT THEN
				SC_DopravBunky.IdleTime.IN:= TRUE;
			END_IF	
						
			IF SC_DopravBunky.IdleTime.Q THEN
				SC_DopravBunky.ResetStep:= TRUE;
				SC_DopravBunky.Step:= 5;
			END_IF	
	
			
					
		5:
			SC_DopravBunky.StepName:='5 - Inicializacia - spustenie dopravnika a ukoncenie inicializacie';
			SC_DopravBunky.IdleTime.PT:= T#2s;
			SC_DopravBunky.AlarmTime.PT:= T#5s;
		
						
			IF NOT SC_DopravBunky.Switch1 THEN
				DopravBunky.OUT.Dopravnik_ChodVPRED_ELR4:= TRUE;
				SC_DopravBunky.IdleTime.IN:= TRUE;
				SC_DopravBunky.Switch1:= TRUE;
			END_IF	
			
			IF SC_DopravBunky.IdleTime.Q THEN
				DopravBunky.STAV.PoINIT:= TRUE;
				SC_DopravBunky.ResetStep:= TRUE;
				SC_DopravBunky.Step:= 100;
			END_IF
			
	
			
			//********************************************************Automatický režim****************************************************************************//
			
		100:  
			SC_DopravCistenia.StepName:='100 - Automaticky Rezim - cakam na vypnutie dopravnika';
			SC_DopravCistenia.IdleTime.PT:= T#5s;
			SC_DopravCistenia.AlarmTime.PT:= T#5s;			
			
			SC_DopravCistenia.IdleTime.IN:= NOT StoperEtiketovania.Automat AND NOT StoperDopravNG.Automat AND NOT StoperPoCisteni.Automat;
			
			DopravBunky.OUT.Dopravnik_ChodVPRED_ELR4:= NOT Linka.STAV.Dopravniky_PAUZA;
			
			IF DopravBunky.KoniecCyklu AND SC_DopravCistenia.IdleTime.Q THEN
				SC_DopravBunky.ResetStep:= TRUE;
				SC_DopravBunky.Step:= 0;
			END_IF
			
			
			
			
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_DopravBunky.StepName:='700 - Manualny Rezim';
			SC_DopravBunky.IdleTime.PT:= T#8s;
			SC_DopravBunky.AlarmTime.PT:= T#5s;
			
			
			
			
	END_CASE	
	
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


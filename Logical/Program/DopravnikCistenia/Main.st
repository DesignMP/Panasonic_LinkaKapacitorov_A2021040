
PROGRAM _INIT
	DopravCistenia.PAR.ZadanaJoggRychlost:= 10;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvlMenica;

		
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_DopravCistenia);
	
	
		
	//Reset sekcie //
	IF DopravCistenia.Reset THEN
		SC_DopravCistenia.Step:= 0;
		DopravCistenia.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_DopravCistenia.Step:= 0;
	END_IF	
	

	
	CASE SC_DopravCistenia.Step OF 
	
		0:
			SC_DopravCistenia.StepName:='0 - Nulovanie';
			DopravCistenia.Automat:= FALSE;
			DopravCistenia.KoniecCyklu:= FALSE;
			DopravCistenia.Manual:= FALSE;
			DopravCistenia.STAV.PoINIT:= FALSE;
			SC_OvlMenica.Step:= 0;
						
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_DopravCistenia.ResetStep:= TRUE;
				SC_DopravCistenia.Step:= 1;
			END_IF
	
		1:
			SC_DopravCistenia.StepName:='1 - Cakam na spustenie vyroby';
			DopravCistenia.KoniecCyklu:= FALSE;
			IF DopravCistenia.Automat THEN
				SC_DopravCistenia.Step:= 2;
			ELSIF DopravCistenia.Manual THEN
				SC_DopravCistenia.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		
		2:
			SC_DopravCistenia.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_DopravCistenia.IdleTime.PT:= T#500ms;
			SC_DopravCistenia.AlarmTime.PT:= T#5s;
			
			SC_DopravCistenia.IdleTime.IN:= TRUE;
						
			IF SC_DopravCistenia.IdleTime.Q THEN
				SC_DopravCistenia.ResetStep:= TRUE;
				SC_DopravCistenia.Step:= 5;
			END_IF	
	
			
					
		5:
			SC_DopravCistenia.StepName:='5 - Inicializacia - spustenie dopravnika a ukoncenie inicializacie';
			SC_DopravCistenia.IdleTime.PT:= T#2s;
			SC_DopravCistenia.AlarmTime.PT:= T#5s;
		
			DopravCistenia.PAR.ZadanaRychlost:= 50;
			
			IF NOT SC_DopravCistenia.Switch1 AND SC_OvlMenica.Step = 1 THEN
				DopravCistenia.Dopravnik_RUN:= TRUE;
				SC_DopravCistenia.IdleTime.IN:= TRUE;
				SC_DopravCistenia.Switch1:= TRUE;
			END_IF	
			
			IF SC_DopravCistenia.IdleTime.Q THEN
				DopravCistenia.STAV.PoINIT:= TRUE;
				SC_DopravCistenia.ResetStep:= TRUE;
				SC_DopravCistenia.Step:= 100;
			END_IF
			
	
			
			//********************************************************Automatický režim****************************************************************************//
			
		100:  
			SC_DopravCistenia.StepName:='100 - Automaticky Rezim - cakam na vypnutie dopravnika';
			SC_DopravCistenia.IdleTime.PT:= T#200ms;
			SC_DopravCistenia.AlarmTime.PT:= T#5s;			
			
			DopravCistenia.Dopravnik_RUN:= NOT Linka.STAV.Dopravniky_PAUZA;
			
			
			IF DopravCistenia.KoniecCyklu AND NOT StoperPredCistenim.Automat AND NOT StoperPoCisteni.Automat AND NOT VstupVytah.Automat THEN
				SC_DopravCistenia.ResetStep:= TRUE;
				SC_DopravCistenia.Step:= 0;
			END_IF
			
			
			
			
			
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_DopravCistenia.StepName:='700 - Manualny Rezim';
			SC_DopravCistenia.IdleTime.PT:= T#8s;
			SC_DopravCistenia.AlarmTime.PT:= T#5s;
			
			
			
			
	END_CASE	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


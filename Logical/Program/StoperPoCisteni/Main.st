
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_StoperPoCisteni);
	
	
	//Reset sekcie //
	IF StoperPoCisteni.Reset THEN
		SC_StoperPoCisteni.Step:= 0;
		StoperPoCisteni.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_StoperPoCisteni.Step:= 0;
	END_IF	
	

	
	CASE SC_StoperPoCisteni.Step OF 
	
		0:
			SC_StoperPoCisteni.StepName:='0 - Nulovanie';
			StoperPoCisteni.Automat:= FALSE;
			StoperPoCisteni.KoniecCyklu:= FALSE;
			StoperPoCisteni.Manual:= FALSE;
			StoperPoCisteni.STAV.PoINIT:= FALSE;
			StoperPoCisteni.OUT.StoperZASUN_YV006:= FALSE;
			StoperPoCisteni.STAV.PrebiehaVyvazaniePaletky:= FALSE;	
			StoperPoCisteni_Statistika.IN.START_MeraniaCasu:= FALSE;
									
			IF Safety.STAV.ZonaCS_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 1;
			END_IF
	
		1:
			SC_StoperPoCisteni.StepName:='1 - Cakam na spustenie vyroby';
			StoperPoCisteni.KoniecCyklu:= FALSE;
			IF StoperPoCisteni.Automat THEN
				SC_StoperPoCisteni.Step:= 2;
			ELSIF StoperPoCisteni.Manual THEN
				SC_StoperPoCisteni.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		2:
			SC_StoperPoCisteni.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_StoperPoCisteni.IdleTime.PT:= T#4s;
			SC_StoperPoCisteni.AlarmTime.PT:= T#5s;
			
									
			IF DopravCistenia.STAV.PoINIT THEN
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 3;
			END_IF
		
		3:
			SC_StoperPoCisteni.StepName:='3 - Inicializacia - hladanie paletky';
			SC_StoperPoCisteni.IdleTime.PT:= T#5s;
			SC_StoperPoCisteni.AlarmTime.PT:= T#5s;
			SC_StoperPoCisteni.IdleTime.IN:= TRUE;
	
			IF StoperPoCisteni.IN.PritomnostPaletky_IS6 THEN
				StoperPoCisteni.STAV.PoINIT:= TRUE;
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 101;		
			ELSIF SC_StoperPoCisteni.IdleTime.Q THEN
				StoperPoCisteni.STAV.PoINIT:= TRUE;
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 100;
			END_IF
	
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_StoperPoCisteni.StepName:='100 - Automaticky Rezim - cakam na príchod paletky na stoper';
			SC_StoperPoCisteni.IdleTime.PT:= T#200ms;
			SC_StoperPoCisteni.AlarmTime.PT:= T#5s;
		
			SC_StoperPoCisteni.IdleTime.IN:= StoperPoCisteni.IN.PritomnostPaletky_IS6;
			
			IF StoperPoCisteni.KoniecCyklu THEN
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 0;
			ELSIF SC_StoperPoCisteni.IdleTime.Q THEN
				StoperPoCisteni_Statistika.IN.START_MeraniaCasu:= TRUE;
				StoperPoCisteni_Statistika.IN.ZAPIS_MeraniaCasu:= TRUE;
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 101;
			END_IF
	
		
		101:
			SC_StoperPoCisteni.StepName:='101 - Automaticky Rezim - cakam na vyvezenie paletky na stoper etiketovania';
			SC_StoperPoCisteni.IdleTime.PT:= T#200ms;
			SC_StoperPoCisteni.AlarmTime.PT:= T#5s;
			
			IF StoperPoCisteni.KoniecCyklu THEN
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 0;
			ELSIF SC_StoperEtiketovania.Step = 100 AND NOT StoperEtiketovania.IN.PritomnostPaletky_IS16 THEN  
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 105;
			END_IF
	
	
		105:
			SC_StoperPoCisteni.StepName:='105 - Automaticky Rezim - vyvazam paletku na stoper etiketovania';
			SC_StoperPoCisteni.IdleTime.PT:= T#4s;
			SC_StoperPoCisteni.AlarmTime.PT:= T#20s;
			
			IF NOT SC_StoperPoCisteni.Switch1 THEN
				StoperPoCisteni.OUT.StoperZASUN_YV006:= TRUE;
				StoperPoCisteni.STAV.PrebiehaVyvazaniePaletky:= TRUE;
				SC_StoperPoCisteni.AlarmTime.IN:= TRUE;
				SC_StoperPoCisteni.Switch1:= TRUE;
			END_IF	
			
			IF NOT StoperPoCisteni.IN.PritomnostPaletky_IS6 THEN
				StoperPoCisteni.OUT.StoperZASUN_YV006:= FALSE;
				SC_StoperPoCisteni.AlarmTime.IN:= FALSE;
			END_IF
						
			
			IF StoperEtiketovania.IN.PritomnostPaletky_IS16 AND NOT StoperPoCisteni.OUT.StoperZASUN_YV006 THEN
				StoperPoCisteni.STAV.PrebiehaVyvazaniePaletky:= FALSE;
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 100;
			ELSIF SC_StoperPoCisteni.AlarmTime.Q THEN
				Alarmy[39]:= TRUE;
				PoruchaCistenia:= TRUE;
				SC_StoperPoCisteni.ResetStep:= TRUE;
				SC_StoperPoCisteni.Step:= 0;
			END_IF
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_StoperPoCisteni.StepName:='700 - Manualny Rezim';
			SC_StoperPoCisteni.IdleTime.PT:= T#8s;
			SC_StoperPoCisteni.AlarmTime.PT:= T#5s;
			
			
	END_CASE		
			
			
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


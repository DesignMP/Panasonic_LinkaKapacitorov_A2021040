
ACTION OvlMenica: 

	//CANopen adresa menièa - 32//
	
	//Volanie funkèného bloku//
	DopravCistenia.MenicDopravnika_FM1();
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlMenica);
	
	//Prepnutie menièa do stavu READY//
	IF EDGEPOS(Safety.STAV.SafetyPLC_Nabehlo)THEN
		IF NOT DopravCistenia.MenicDopravnika_FM1.STAV.READY THEN
			DopravCistenia.MenicDopravnika_FM1.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF
	END_IF
	
	
		
		
	//Parametre menièa//
	DopravCistenia.MenicDopravnika_FM1.PAR.TypKomunikacieProfinet:= 0;
	DopravCistenia.STAV.AktualnaRychlost:= DopravCistenia.MenicDopravnika_FM1.PAR.AktualnaFrekvencia_Hz;
	DopravCistenia.STAV.BUSY:= DopravCistenia.MenicDopravnika_FM1.STAV.RUN;
	
	
	CASE SC_OvlMenica.Step OF
		
		0:
			SC_OvlMenica.StepName:= '0 - Nulovanie';
			Chod_VPRED:= FALSE;
			Chod_VZAD:= FALSE;
			DopravCistenia.Dopravnik_RUN:= FALSE;
			DopravCistenia.MenicDopravnika_FM1.CMD.HOME:= FALSE;
			DopravCistenia.MenicDopravnika_FM1.CMD.Chod_VPRED:= FALSE;
			DopravCistenia.MenicDopravnika_FM1.CMD.Chod_VZAD:= FALSE;
			
											
			IF SC_DopravCistenia.Step <> 0 AND DopravCistenia.MenicDopravnika_FM1.STAV.READY AND NOT DopravCistenia.MenicDopravnika_FM1.STAV.PORUCHA THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlMenica.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Chod_VPRED THEN
				SC_OvlMenica.Step:= 10;
			ELSIF Chod_VZAD THEN
				SC_OvlMenica.Step:= 20;
			ELSIF DopravCistenia.Dopravnik_RUN THEN
				SC_OvlMenica.Step:= 30;
			END_IF
	
		
		
		10:
			SC_OvlMenica.StepName:= '10 - Chod VPRED';
			SC_OvlMenica.IdleTime.PT:= T#3s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			IF DopravCistenia.Automat THEN
				DopravCistenia.MenicDopravnika_FM1.PAR.ZadanaFrekvencia_Hz:= DopravCistenia.PAR.ZadanaRychlost;
			ELSE
				DopravCistenia.MenicDopravnika_FM1.PAR.ZadanaFrekvencia_Hz:= DopravCistenia.PAR.ZadanaJoggRychlost;
			END_IF	
						
			IF NOT SC_OvlMenica.Switch1 THEN
				DopravCistenia.MenicDopravnika_FM1.CMD.Chod_VPRED:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT Chod_VPRED THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		20:
			SC_OvlMenica.StepName:= '20 - Chod VZAD';
			SC_OvlMenica.IdleTime.PT:= T#3s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			IF DopravCistenia.Automat THEN
				DopravCistenia.MenicDopravnika_FM1.PAR.ZadanaFrekvencia_Hz:= DopravCistenia.PAR.ZadanaRychlost;
			ELSE
				DopravCistenia.MenicDopravnika_FM1.PAR.ZadanaFrekvencia_Hz:= DopravCistenia.PAR.ZadanaJoggRychlost;
			END_IF	
						
			IF NOT SC_OvlMenica.Switch1 THEN
				DopravCistenia.MenicDopravnika_FM1.CMD.Chod_VZAD:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT Chod_VZAD THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		30:
			SC_OvlMenica.StepName:= '30 - Chod VPRED v automate';
			SC_OvlMenica.IdleTime.PT:= T#3s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			IF DopravCistenia.Automat THEN
				DopravCistenia.MenicDopravnika_FM1.PAR.ZadanaFrekvencia_Hz:= DopravCistenia.PAR.ZadanaRychlost;
			ELSE
				DopravCistenia.MenicDopravnika_FM1.PAR.ZadanaFrekvencia_Hz:= DopravCistenia.PAR.ZadanaJoggRychlost;
			END_IF	
						
			IF NOT SC_OvlMenica.Switch1 THEN
				DopravCistenia.MenicDopravnika_FM1.CMD.Chod_VPRED:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT DopravCistenia.Dopravnik_RUN THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		
		
		
	END_CASE
	
	
	
	
	
END_ACTION

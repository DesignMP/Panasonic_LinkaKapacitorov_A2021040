
ACTION OvlMenica: 

	//Otáèka motora = zdvih 10 mm//
	
	//CANopen adresa menièa - 34//
	
	//Volanie funkèného bloku//
	VstupVytah.MenicZdvihu_FM2();
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlMenica);
	
	//Prepnutie menièa do stavu READY//
	IF EDGEPOS(Safety.STAV.SafetyPLC_Nabehlo)THEN
		IF NOT VstupVytah.MenicZdvihu_FM2.STAV.READY THEN
			VstupVytah.MenicZdvihu_FM2.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF
	ELSIF EDGEPOS(Safety.STAV.ZonaVstupnyVytah_AKTIVNA)THEN
		IF NOT VstupVytah.MenicZdvihu_FM2.STAV.READY THEN
			VstupVytah.MenicZdvihu_FM2.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF
	END_IF
	
	
	//Parametre menièa//
	VstupVytah.MenicZdvihu_FM2.PAR.TypKomunikacieProfinet:= 0;
	VstupVytah.MenicZdvihu_FM2.PAR.ZadanaPozicia_MM:= (VstupVytah.PAR.Zdvih_ZadanaPozicia * 100);
	VstupVytah.STAV.Zdvih_AktualnaPozicia:= (VstupVytah.MenicZdvihu_FM2.PAR.AktualnaPozicia_MM/100);
	VstupVytah.STAV.Zdvih_AktualnaRychlost:= VstupVytah.MenicZdvihu_FM2.PAR.AktualnaFrekvencia_Hz;
	VstupVytah.STAV.Zdvih_HomingOK:= VstupVytah.MenicZdvihu_FM2.STAV.Homing_OK;
	VstupVytah.STAV.Zdvih_PoziciaDosiahnuta:= VstupVytah.MenicZdvihu_FM2.STAV.Pozicia_DOSIAHNUTA;
	VstupVytah.STAV.Zdvih_BUSY:= VstupVytah.MenicZdvihu_FM2.STAV.RUN;
	
	//Preposielanie IO menièa cez komunikáciu//
	VstupVytah.IN.ReferencnySnimacZdvihu:= VstupVytah.MenicZdvihu_FM2.PAR.BUS_OUT_Bit_0;
	VstupVytah.IN.HornyLimitZdvihu:= VstupVytah.MenicZdvihu_FM2.PAR.BUS_OUT_Bit_1;
	VstupVytah.MenicZdvihu_FM2.PAR.BUS_IN_Bit_0:= VstupVytah.IN.SpodnyLimitZdvihu;
	
	IF Zdvih_HOME THEN
		VstupVytah.IN.SpodnyLimitZdvihu:= TRUE;
	ELSE
		VstupVytah.IN.SpodnyLimitZdvihu:= NOT VstupVytah.IN.ReferencnySnimacZdvihu;
	END_IF	
	
	IF NOT Safety.STAV.ZonaVstupnyVytah_AKTIVNA THEN
		SC_OvlMenica.Step:= 0;
	END_IF	
	
	CASE SC_OvlMenica.Step OF
		
		0:
			SC_OvlMenica.StepName:= '0 - Nulovanie';
			Zdvih_JoggHORE:= FALSE;
			Zdvih_JoggDOLE:= FALSE;
			Zdvih_POLOHUJ:= FALSE;
			Zdvih_HOME:= FALSE;
			VstupVytah.MenicZdvihu_FM2.CMD.HOME:= FALSE;
			VstupVytah.MenicZdvihu_FM2.CMD.Chod_VPRED:= FALSE;
			VstupVytah.MenicZdvihu_FM2.CMD.Chod_VZAD:= FALSE;
			VstupVytah.MenicZdvihu_FM2.CMD.Polohuj:= FALSE;
			VstupVytah.STAV.Homing_BUSY:= FALSE;
											
			IF SC_VstupVytah.Step <> 0 AND VstupVytah.MenicZdvihu_FM2.STAV.READY AND NOT VstupVytah.MenicZdvihu_FM2.STAV.PORUCHA AND Safety.STAV.ZonaVstupnyVytah_AKTIVNA THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlMenica.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Zdvih_JoggHORE THEN
				SC_OvlMenica.Step:= 10;
			ELSIF Zdvih_JoggDOLE THEN
				SC_OvlMenica.Step:= 20;
			ELSIF Zdvih_HOME THEN
				SC_OvlMenica.Step:= 30;
			ELSIF Zdvih_POLOHUJ THEN
				SC_OvlMenica.Step:= 40;
			END_IF
	
		
		
		10:
			SC_OvlMenica.StepName:= '10 - Jogg HORE';
			SC_OvlMenica.IdleTime.PT:= T#3s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			VstupVytah.MenicZdvihu_FM2.PAR.ZadanaFrekvencia_Hz:= VstupVytah.PAR.Zdvih_ZadanaJoggRychlost;
						
			IF NOT SC_OvlMenica.Switch1 AND VstupVytah.IN.HornyLimitZdvihu THEN
				VstupVytah.MenicZdvihu_FM2.CMD.Chod_VPRED:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT Zdvih_JoggHORE THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT VstupVytah.IN.HornyLimitZdvihu THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		20:
			SC_OvlMenica.StepName:= '20 - Jogg DOLE';
			SC_OvlMenica.IdleTime.PT:= T#3s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			VstupVytah.MenicZdvihu_FM2.PAR.ZadanaFrekvencia_Hz:= VstupVytah.PAR.Zdvih_ZadanaJoggRychlost;
						
			IF NOT SC_OvlMenica.Switch1 AND VstupVytah.IN.SpodnyLimitZdvihu THEN
				VstupVytah.MenicZdvihu_FM2.CMD.Chod_VZAD:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT Zdvih_JoggDOLE THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT VstupVytah.IN.SpodnyLimitZdvihu THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		30:	
			SC_OvlMenica.StepName:= '30 - Homing - kontrola referencneho snimaca';
			SC_OvlMenica.IdleTime.PT:= T#500ms;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
			
			
			
			VstupVytah.STAV.Homing_BUSY:= TRUE;
			
			IF VstupVytah.IN.ReferencnySnimacZdvihu THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 31;
			ELSE
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 32;
			END_IF
			
			
		31:
			SC_OvlMenica.StepName:= '31 - Homing - presun vytahu nad referencny snimac';
			SC_OvlMenica.IdleTime.PT:= T#1s;
			SC_OvlMenica.AlarmTime.PT:= T#2s;
			
			SC_OvlMenica.IdleTime.IN:= NOT VstupVytah.IN.ReferencnySnimacZdvihu;
			
			IF NOT SC_OvlMenica.Switch1 THEN
				VstupVytah.MenicZdvihu_FM2.CMD.Chod_VPRED:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF SC_OvlMenica.IdleTime.Q THEN
				VstupVytah.MenicZdvihu_FM2.CMD.Chod_VPRED:= FALSE;
				SC_OvlMenica.AlarmTime.IN:= TRUE;
			END_IF
			
			IF SC_OvlMenica.AlarmTime.Q THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 32;
			END_IF	
			
			
		32:
			SC_OvlMenica.StepName:= '32 - Homing - spustenie homingu';
			SC_OvlMenica.IdleTime.PT:= T#500ms;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			
			            
			IF NOT SC_OvlMenica.Switch1 THEN
				VstupVytah.MenicZdvihu_FM2.CMD.HOME:= TRUE;
				SC_OvlMenica.IdleTime.IN:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
		
			IF VstupVytah.STAV.Zdvih_HomingOK AND SC_OvlMenica.IdleTime.Q THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT Zdvih_HOME THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		40:
			SC_OvlMenica.StepName:= '40 - Polohovanie';
			SC_OvlMenica.IdleTime.PT:= T#1s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			VstupVytah.MenicZdvihu_FM2.PAR.ZadanaFrekvencia_Hz:= VstupVytah.PAR.Zdvih_ZadanaRychlost;
					
			IF NOT SC_OvlMenica.Switch1 THEN
				VstupVytah.MenicZdvihu_FM2.CMD.Polohuj:= TRUE;
				SC_OvlMenica.IdleTime.IN:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF (*(VstupVytah.STAV.Zdvih_AktualnaPozicia = VstupVytah.PAR.Zdvih_ZadanaPozicia) AND*) SC_OvlMenica.IdleTime.Q AND VstupVytah.STAV.Zdvih_PoziciaDosiahnuta THEN
				VstupVytah.STAV.VytahNapolohovany:= TRUE;
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT Zdvih_POLOHUJ THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		
		
		
	END_CASE
	
	
END_ACTION


ACTION OvlMenica: 

	//Otáèka motora = zdvih 10 mm//
	
	//CANopen adresa menièa - 36//
	
	//Volanie funkèného bloku//
	VystupVytah.MenicZdvihu_FM3();
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlMenica);
	
	//Prepnutie menièa do stavu READY//
	IF EDGEPOS(Safety.STAV.SafetyPLC_Nabehlo)THEN
		IF NOT VystupVytah.MenicZdvihu_FM3.STAV.READY THEN
			VystupVytah.MenicZdvihu_FM3.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF
	ELSIF EDGEPOS(Safety.STAV.ZonaVystupnyVytah_AKTIVNA)THEN
		IF NOT VystupVytah.MenicZdvihu_FM3.STAV.READY THEN
			VystupVytah.MenicZdvihu_FM3.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF
	END_IF
	
	
		
	//Parametre menièa//
	VystupVytah.MenicZdvihu_FM3.PAR.TypKomunikacieProfinet:= 0;
	VystupVytah.MenicZdvihu_FM3.PAR.ZadanaPozicia_MM:= (VystupVytah.PAR.Zdvih_ZadanaPozicia * 100);
	VystupVytah.STAV.Zdvih_AktualnaPozicia:= (VystupVytah.MenicZdvihu_FM3.PAR.AktualnaPozicia_MM/100);
	VystupVytah.STAV.Zdvih_AktualnaRychlost:= VystupVytah.MenicZdvihu_FM3.PAR.AktualnaFrekvencia_Hz;
	VystupVytah.STAV.Zdvih_HomingOK:= VystupVytah.MenicZdvihu_FM3.STAV.Homing_OK;
	VystupVytah.STAV.Zdvih_PoziciaDosiahnuta:= VystupVytah.MenicZdvihu_FM3.STAV.Pozicia_DOSIAHNUTA;
	VystupVytah.STAV.Zdvih_BUSY:= VystupVytah.MenicZdvihu_FM3.STAV.RUN;
	
	//Preposielanie IO menièa cez komunikáciu//
	VystupVytah.IN.ReferencnySnimacZdvihu:= VystupVytah.MenicZdvihu_FM3.PAR.BUS_OUT_Bit_0;
	VystupVytah.IN.HornyLimitZdvihu:= VystupVytah.MenicZdvihu_FM3.PAR.BUS_OUT_Bit_1;
	VystupVytah.MenicZdvihu_FM3.PAR.BUS_IN_Bit_0:= VystupVytah.IN.SpodnyLimitZdvihu;
	
	IF Zdvih_HOME THEN
		VystupVytah.IN.SpodnyLimitZdvihu:= TRUE;
	ELSE
		VystupVytah.IN.SpodnyLimitZdvihu:= NOT VystupVytah.IN.ReferencnySnimacZdvihu;
	END_IF	
	
	IF NOT Safety.STAV.ZonaVystupnyVytah_AKTIVNA THEN
		SC_OvlMenica.Step:= 0;
	END_IF	
	
	
	
	
	CASE SC_OvlMenica.Step OF
		
		0:
			SC_OvlMenica.StepName:= '0 - Nulovanie';
			Zdvih_JoggHORE:= FALSE;
			Zdvih_JoggDOLE:= FALSE;
			Zdvih_POLOHUJ:= FALSE;
			Zdvih_HOME:= FALSE;
			VystupVytah.MenicZdvihu_FM3.CMD.HOME:= FALSE;
			VystupVytah.MenicZdvihu_FM3.CMD.Chod_VPRED:= FALSE;
			VystupVytah.MenicZdvihu_FM3.CMD.Chod_VZAD:= FALSE;
			VystupVytah.MenicZdvihu_FM3.CMD.Polohuj:= FALSE;
			VystupVytah.STAV.Homing_BUSY:= FALSE;
											
			IF SC_VystupVytah.Step <> 0 AND VystupVytah.MenicZdvihu_FM3.STAV.READY AND NOT VystupVytah.MenicZdvihu_FM3.STAV.PORUCHA AND Safety.STAV.ZonaVystupnyVytah_AKTIVNA THEN
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
		
			VystupVytah.MenicZdvihu_FM3.PAR.ZadanaFrekvencia_Hz:= VystupVytah.PAR.Zdvih_ZadanaJoggRychlost;
						
			IF NOT SC_OvlMenica.Switch1 AND VystupVytah.IN.HornyLimitZdvihu THEN
				VystupVytah.MenicZdvihu_FM3.CMD.Chod_VPRED:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT Zdvih_JoggHORE THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT VystupVytah.IN.HornyLimitZdvihu THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
		
		
		20:
			SC_OvlMenica.StepName:= '20 - Jogg DOLE';
			SC_OvlMenica.IdleTime.PT:= T#3s;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
		
			VystupVytah.MenicZdvihu_FM3.PAR.ZadanaFrekvencia_Hz:= VystupVytah.PAR.Zdvih_ZadanaJoggRychlost;
						
			IF NOT SC_OvlMenica.Switch1 AND VystupVytah.IN.SpodnyLimitZdvihu THEN
				VystupVytah.MenicZdvihu_FM3.CMD.Chod_VZAD:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF NOT Zdvih_JoggDOLE THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT VystupVytah.IN.SpodnyLimitZdvihu THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;	
			END_IF	
		
		30:	
			SC_OvlMenica.StepName:= '30 - Homing - kontrola referencneho snimaca';
			SC_OvlMenica.IdleTime.PT:= T#500ms;
			SC_OvlMenica.AlarmTime.PT:= T#3s;
			
			VystupVytah.STAV.Homing_BUSY:= TRUE;
			
			IF VystupVytah.IN.ReferencnySnimacZdvihu THEN
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
			
			SC_OvlMenica.IdleTime.IN:= NOT VystupVytah.IN.ReferencnySnimacZdvihu;
			
			IF NOT SC_OvlMenica.Switch1 THEN
				VystupVytah.MenicZdvihu_FM3.CMD.Chod_VPRED:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF SC_OvlMenica.IdleTime.Q THEN
				VystupVytah.MenicZdvihu_FM3.CMD.Chod_VPRED:= FALSE;
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
				VystupVytah.MenicZdvihu_FM3.CMD.HOME:= TRUE;
				SC_OvlMenica.IdleTime.IN:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
		
			IF VystupVytah.STAV.Zdvih_HomingOK AND SC_OvlMenica.IdleTime.Q THEN
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
		
			VystupVytah.MenicZdvihu_FM3.PAR.ZadanaFrekvencia_Hz:= VystupVytah.PAR.Zdvih_ZadanaRychlost;
					
			IF NOT SC_OvlMenica.Switch1 THEN
				VystupVytah.MenicZdvihu_FM3.CMD.Polohuj:= TRUE;
				SC_OvlMenica.IdleTime.IN:= TRUE;
				SC_OvlMenica.Switch1:= TRUE;
			END_IF
			
			IF (*(VystupVytah.STAV.Zdvih_AktualnaPozicia = VystupVytah.PAR.Zdvih_ZadanaPozicia) AND*) SC_OvlMenica.IdleTime.Q AND VystupVytah.STAV.Zdvih_PoziciaDosiahnuta THEN
				VystupVytah.STAV.VytahNapolohovany:= TRUE;
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			ELSIF NOT Zdvih_POLOHUJ THEN
				SC_OvlMenica.ResetStep:= TRUE;
				SC_OvlMenica.Step:= 0;
			END_IF	
				
		
	END_CASE
	
	
	
	
END_ACTION

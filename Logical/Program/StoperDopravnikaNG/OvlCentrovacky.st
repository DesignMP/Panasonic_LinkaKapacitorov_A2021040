
ACTION OvlCentrovacky: 

	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlCentrovacky);
	
	
	CASE SC_OvlCentrovacky.Step OF
		
		0:
			SC_OvlCentrovacky.StepName:= '0 - Nulovanie';
			Centrovacku_VYSUN:= FALSE;
			Centrovacku_ZASUN:= FALSE;
			Centrovacku_VYSTRED:= FALSE;
			//			StoperDopravNG.OUT.Centrovanie_VYSUN_YV009:= FALSE;
			//			StoperDopravNG.OUT.Centrovanie_ZASUN_YV010:= FALSE;
								
			IF SC_StoperDopravNG.Step <> 0 THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlCentrovacky.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Centrovacku_VYSUN THEN
				SC_OvlCentrovacky.Step:= 10;
			ELSIF Centrovacku_ZASUN THEN
				SC_OvlCentrovacky.Step:= 20;
			ELSIF Centrovacku_VYSTRED THEN
				SC_OvlCentrovacky.Step:= 30;
			END_IF
	
		
		10:
			SC_OvlCentrovacky.StepName:= '10 - Vysunutie centrovacky hore';
			SC_OvlCentrovacky.IdleTime.PT:= T#3s;
			SC_OvlCentrovacky.AlarmTime.PT:= T#6s;
						
			IF StoperDopravNG.Automat THEN
				SC_OvlCentrovacky.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlCentrovacky.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlCentrovacky.Switch1 THEN
				StoperDopravNG.OUT.Centrovanie_ZASUN_YV010:= FALSE;
				StoperDopravNG.OUT.Centrovanie_VYSUN_YV009:= TRUE;
				SC_OvlCentrovacky.Switch1:= TRUE;
			END_IF	
			
			IF StoperDopravNG.IN.Centrovanie_HornaPoloha_IS19 OR SC_OvlCentrovacky.IdleTime.Q THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			ELSIF SC_OvlCentrovacky.AlarmTime.Q THEN
				Alarmy[57]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlCentrovacky.StepName:= '20 - Zasunutie centrovacky dole';
			SC_OvlCentrovacky.IdleTime.PT:= T#3s;
			SC_OvlCentrovacky.AlarmTime.PT:= T#6s;
						
			IF StoperDopravNG.Automat THEN
				SC_OvlCentrovacky.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlCentrovacky.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlCentrovacky.Switch1 THEN
				StoperDopravNG.OUT.Centrovanie_VYSUN_YV009:= FALSE;
				StoperDopravNG.OUT.Centrovanie_ZASUN_YV010:= TRUE;
				SC_OvlCentrovacky.Switch1:= TRUE;
			END_IF	
			
			IF StoperDopravNG.IN.Centrovanie_SpodnaPoloha_IS21 OR SC_OvlCentrovacky.IdleTime.Q THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			ELSIF SC_OvlCentrovacky.AlarmTime.Q THEN
				Alarmy[58]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			END_IF
		
		30:
			SC_OvlCentrovacky.StepName:= '30 - Presun centrovacky do strednej polohy';
			SC_OvlCentrovacky.IdleTime.PT:= T#3s;
			SC_OvlCentrovacky.AlarmTime.PT:= T#6s;
						
			IF StoperDopravNG.Automat THEN
				SC_OvlCentrovacky.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlCentrovacky.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlCentrovacky.Switch1 THEN
				StoperDopravNG.OUT.Centrovanie_VYSUN_YV009:= FALSE;
				StoperDopravNG.OUT.Centrovanie_ZASUN_YV010:= FALSE;
				SC_OvlCentrovacky.Switch1:= TRUE;
			END_IF	
			
			IF StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 OR SC_OvlCentrovacky.IdleTime.Q THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			ELSIF SC_OvlCentrovacky.AlarmTime.Q THEN
				Alarmy[59]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			END_IF
		
		
	END_CASE
	
END_ACTION

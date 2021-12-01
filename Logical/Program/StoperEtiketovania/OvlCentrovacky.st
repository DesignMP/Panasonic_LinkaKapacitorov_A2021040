
ACTION OvlCentrovacky: 

	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlCentrovacky);
	
	
	CASE SC_OvlCentrovacky.Step OF
		
		0:
			SC_OvlCentrovacky.StepName:= '0 - Nulovanie';
			Centrovacku_VYSUN:= FALSE;
			Centrovacku_ZASUN:= FALSE;
			StoperEtiketovania.RR_OdcentrujPaletku:= FALSE;
			StoperEtiketovania.RR_ZacentrujPaletku:= FALSE;
			//StoperEtiketovania.OUT.Centrovanie_VYSUN_YV003:= FALSE;
			//StoperEtiketovania.OUT.Centrovanie_ZASUN_YV004:= FALSE;
								
			IF SC_StoperEtiketovania.Step <> 0 THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlCentrovacky.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Centrovacku_VYSUN THEN
				SC_OvlCentrovacky.Step:= 10;
			ELSIF Centrovacku_ZASUN THEN
				SC_OvlCentrovacky.Step:= 20;
			ELSIF StoperEtiketovania.RR_ZacentrujPaletku THEN
				SC_OvlCentrovacky.Step:= 10;
			ELSIF StoperEtiketovania.RR_OdcentrujPaletku THEN
				SC_OvlCentrovacky.Step:= 20;
			END_IF
	
		
		10:
			SC_OvlCentrovacky.StepName:= '10 - Vysunutie centrovacky';
			SC_OvlCentrovacky.IdleTime.PT:= T#3s;
			SC_OvlCentrovacky.AlarmTime.PT:= T#6s;
						
			IF StoperEtiketovania.Automat THEN
				SC_OvlCentrovacky.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlCentrovacky.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlCentrovacky.Switch1 THEN
				StoperEtiketovania.OUT.Centrovanie_ZASUN_YV004:= FALSE;
				StoperEtiketovania.OUT.Centrovanie_VYSUN_YV003:= TRUE;
				SC_OvlCentrovacky.Switch1:= TRUE;
			END_IF	
			
			IF StoperEtiketovania.IN.Centrovanie_HornaPoloha_IS18 OR SC_OvlCentrovacky.IdleTime.Q THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			ELSIF SC_OvlCentrovacky.AlarmTime.Q THEN
				Alarmy[53]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlCentrovacky.StepName:= '20 - Zasunutie centrovacky';
			SC_OvlCentrovacky.IdleTime.PT:= T#3s;
			SC_OvlCentrovacky.AlarmTime.PT:= T#6s;
						
			IF StoperEtiketovania.Automat THEN
				SC_OvlCentrovacky.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlCentrovacky.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlCentrovacky.Switch1 THEN
				StoperEtiketovania.OUT.Centrovanie_VYSUN_YV003:= FALSE;
				StoperEtiketovania.OUT.Centrovanie_ZASUN_YV004:= TRUE;
				SC_OvlCentrovacky.Switch1:= TRUE;
			END_IF	
			
			IF StoperEtiketovania.IN.Centrovanie_SpodnaPoloha_IS17 OR SC_OvlCentrovacky.IdleTime.Q THEN
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			ELSIF SC_OvlCentrovacky.AlarmTime.Q THEN
				Alarmy[54]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_OvlCentrovacky.ResetStep:= TRUE;
				SC_OvlCentrovacky.Step:= 0;
			END_IF
		
		
		
		
	END_CASE
	
END_ACTION

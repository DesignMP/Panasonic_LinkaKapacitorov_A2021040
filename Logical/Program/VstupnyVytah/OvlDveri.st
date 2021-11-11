
ACTION OvlDveri: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlDveri);
	
	
	CASE SC_OvlDveri.Step OF
		
		0:
			SC_OvlDveri.StepName:= '0 - Nulovanie';
			Dvere_OTVOR:= FALSE;
			Dvere_ZATVOR:= FALSE;
//			VstupVytah.OUT.DvereVytahu_OTVOR_YV002:= FALSE;
//			VstupVytah.OUT.DvereVytahu_ZATVOR_YV001:= FALSE;
								
			IF SC_VstupVytah.Step <> 0 THEN
				SC_OvlDveri.ResetStep:= TRUE;
				SC_OvlDveri.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlDveri.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Dvere_OTVOR THEN
				SC_OvlDveri.Step:= 10;
			ELSIF Dvere_ZATVOR THEN
				SC_OvlDveri.Step:= 20;
			END_IF
	
		
		10:
			SC_OvlDveri.StepName:= '10 - Otvorenie dveri';
			SC_OvlDveri.IdleTime.PT:= T#3s;
			SC_OvlDveri.AlarmTime.PT:= T#6s;
						
			IF VstupVytah.Automat THEN
				SC_OvlDveri.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlDveri.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlDveri.Switch1 THEN
				VstupVytah.OUT.DvereVytahu_ZATVOR_YV001:= FALSE;
				VstupVytah.OUT.DvereVytahu_OTVOR_YV002:= TRUE;
				SC_OvlDveri.Switch1:= TRUE;
			END_IF	
			
			IF VstupVytah.IN.DvereVytahuOtvorene_MS1 OR SC_OvlDveri.IdleTime.Q THEN
				SC_OvlDveri.ResetStep:= TRUE;
				SC_OvlDveri.Step:= 0;
			ELSIF SC_OvlDveri.AlarmTime.Q THEN
				Alarmy[42]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_OvlDveri.ResetStep:= TRUE;
				SC_OvlDveri.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlDveri.StepName:= '20 - Zatvorenie dveri';
			SC_OvlDveri.IdleTime.PT:= T#3s;
			SC_OvlDveri.AlarmTime.PT:= T#6s;
						
			IF VstupVytah.Automat THEN
				SC_OvlDveri.AlarmTime.IN:= TRUE;
			ELSE
				SC_OvlDveri.IdleTime.IN:= TRUE;
			END_IF	
			
			IF NOT SC_OvlDveri.Switch1 THEN
				VstupVytah.OUT.DvereVytahu_OTVOR_YV002:= FALSE;
				VstupVytah.OUT.DvereVytahu_ZATVOR_YV001:= TRUE;
				SC_OvlDveri.Switch1:= TRUE;
			END_IF	
			
			IF VstupVytah.IN.DvereVytahuZatvorene_MS2 OR SC_OvlDveri.IdleTime.Q THEN
				SC_OvlDveri.ResetStep:= TRUE;
				SC_OvlDveri.Step:= 0;
			ELSIF SC_OvlDveri.AlarmTime.Q THEN
				Alarmy[43]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_OvlDveri.ResetStep:= TRUE;
				SC_OvlDveri.Step:= 0;
			END_IF
		
		
		
		
	END_CASE
	
	
	
END_ACTION

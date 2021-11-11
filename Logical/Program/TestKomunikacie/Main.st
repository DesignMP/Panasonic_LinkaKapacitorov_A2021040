
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC

	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Step);
	
	
	CASE SC_Step.Step OF 
	
		0:
			SC_Step.StepName:='0 - Nulovanie';
			Cistenie_OK:= FALSE;
			Cistenie_NG:= FALSE;
			VytlacEtiketu:= FALSE;
			NalepenieEtikety_OK:= FALSE;
			NalepenieEikety_NG:= FALSE;
			KontrolaDMkodu_OK:= FALSE;
			KontrolaDMkodu_NG:= FALSE;
			KontrolaTextu_OK:= FALSE;
			KontrolaTextu_NG:= FALSE;
			KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
			KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
			KOM_Panasonic.Server_IN.CommandNumber:= 0;
			SC_Step.ResetStep:= TRUE;
			SC_Step.Step:= 1;
	
	
		1:
			IF Cistenie_OK THEN
				ZakaznickeCislo:= '';
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 10;
			ELSIF Cistenie_NG THEN
				ZakaznickeCislo:= '';
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 20;
			ELSIF VytlacEtiketu THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 30;
			ELSIF NalepenieEtikety_OK THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 40;
			ELSIF NalepenieEikety_NG THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 50;
			ELSIF KontrolaDMkodu_OK THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 60;
			ELSIF KontrolaDMkodu_NG THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 70;
			ELSIF KontrolaTextu_OK THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 80;
			ELSIF KontrolaTextu_NG THEN
				ReturnProcessName:= '';
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 90;
			END_IF	
		
		
		10:
			SC_Step.StepName:='10 - Odoslanie - Stav cistenie OK';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 10;
				KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 13;
			END_IF	
				
			
		13:
			SC_Step.StepName:='13 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 10 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ZakaznickeCislo:= KOM_Panasonic.Server_OUT.SerialNumber_ZakaznickaEtiketa;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
					
	
			
			
			
			
			
		
		20:
			SC_Step.StepName:='20 - Odoslanie - Stav cistenie NG';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 10;
				KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 23;
			END_IF	
				
			
		
		
		23:
			SC_Step.StepName:='23 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 10 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ZakaznickeCislo:= KOM_Panasonic.Server_OUT.SerialNumber_ZakaznickaEtiketa;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		
		
		30:
			SC_Step.StepName:='30 - Odoslanie - Vytlac etiketu';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 20;
				KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 33;
			END_IF	
				
			
		33:
			SC_Step.StepName:='33 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 20 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		
		40:
			SC_Step.StepName:='40 - Odoslanie - Stav nalepenie etikety OK';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 30;
				KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 43;
			END_IF	
				
			
		43:
			SC_Step.StepName:='43 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 30 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		50:
			SC_Step.StepName:='50 - Odoslanie - Stav nalepenie etikety NG';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 30;
				KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 53;
			END_IF	
				
			
		53:
			SC_Step.StepName:='53 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 30 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		60:
			SC_Step.StepName:='60 - Odoslanie - Stav citania DM kodu zakaznickej etikety OK';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 40;
				KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 63;
			END_IF	
				
			
		63:
			SC_Step.StepName:='63 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 40 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		70:
			SC_Step.StepName:='70 - Odoslanie - Stav citania DM kodu zakaznickej etikety NG';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 40;
				KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 73;
			END_IF	
				
			
		73:
			SC_Step.StepName:='73 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 40 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		80:
			SC_Step.StepName:='80 - Odoslanie - Stav citania znakov zakaznickej etikety OK';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 50;
				KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 83;
			END_IF	
				
			
		83:
			SC_Step.StepName:='83 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 50 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		90:
			SC_Step.StepName:='90 - Odoslanie - Stav citania znakov zakaznickej etikety NG';
			SC_Step.IdleTime.PT:= T#4s;
			SC_Step.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= '10_CP1';
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= 'BD10020070300046ZZZZZZZB10BD1';
			KOM_Panasonic.Server_IN.Cislo_LOTU:= 'BS217210002';
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				KOM_Panasonic.Server_IN.CommandNumber:= 50;
				KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_Step.ResetStep:= TRUE;
				SC_Step.Step:= 93;
			END_IF	
				
			
		93:
			SC_Step.StepName:='93 - Odpoved servera';
			SC_Step.IdleTime.PT:= T#100ms;
			SC_Step.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 50 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					ReturnProcessName:= 'OK';
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_Step.ResetStep:= TRUE;
					SC_Step.Step:= 0;
				END_IF
			END_IF	
		
		
		
			
	END_CASE		
	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


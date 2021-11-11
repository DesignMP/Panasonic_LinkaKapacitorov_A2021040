
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlCistenia);
	
	
	
	
	
	CASE SC_OvlCistenia.Step OF 
	
		0:
			SC_OvlCistenia.StepName:='0 - Nulovanie';
			CasOtacaniaHornejTrisky_1.IN:= FALSE;
			CasOtacaniaHornejTrisky_2.IN:= FALSE;
			CasOtacaniaHornejTrisky_3.IN:= FALSE;
			CasOtacaniaHornejTrisky_4.IN:= FALSE;
			CasOtacaniaSpodnejTrisky_1.IN:= FALSE;
			CasOtacaniaSpodnejTrisky_2.IN:= FALSE;
			CasOtacaniaSpodnejTrisky_3.IN:= FALSE;
			Linka.OUT.IonJednotka_START:= FALSE;
			Linka.OUT.IonJednotka_AIR:= FALSE;
			SC_OvlCistenia.ResetStep:= TRUE;
			SC_OvlCistenia.Step:= 1;
		
	
		1:
			SC_OvlCistenia.StepName:='1 - Cakam na spustenie cistenia';
			
			IF Linka.OUT.IonJednotka_START THEN
				SC_OvlCistenia.Step:= 10;
			END_IF
	
		10:
			SC_OvlCistenia.StepName:='10 - spustenie kontroly otacania trisiek';
			SC_OvlCistenia.IdleTime.PT:= T#2s;
			SC_OvlCistenia.AlarmTime.PT:= T#1s;
		
			Linka.OUT.IonJednotka_AIR:= TRUE;
			
			SC_OvlCistenia.IdleTime.IN:= TRUE;
			
								
			IF EDGE(Linka.IN.SnimacRotacieHornTrysiek_1_IS7) THEN
				CasOtacaniaHornejTrisky_1.IN:= FALSE;
			ELSE	
				CasOtacaniaHornejTrisky_1.IN:= TRUE;
			END_IF	
				
			IF EDGE(Linka.IN.SnimacRotacieHornTrysiek_2_IS8) THEN
				CasOtacaniaHornejTrisky_2.IN:= FALSE;
			ELSE	
				CasOtacaniaHornejTrisky_2.IN:= TRUE;
			END_IF	
			
			IF EDGE(Linka.IN.SnimacRotacieHornTrysiek_3_IS9) THEN
				CasOtacaniaHornejTrisky_3.IN:= FALSE;
			ELSE	
				CasOtacaniaHornejTrisky_3.IN:= TRUE;
			END_IF	
			
			IF EDGE(Linka.IN.SnimacRotacieHornTrysiek_4_IS10) THEN
				CasOtacaniaHornejTrisky_4.IN:= FALSE;
			ELSE	
				CasOtacaniaHornejTrisky_4.IN:= TRUE;
			END_IF	
			
			IF EDGE(Linka.IN.SnimacRotacieSpodTrysiek_1_IS11) THEN
				CasOtacaniaSpodnejTrisky_1.IN:= FALSE;
			ELSE	
				CasOtacaniaSpodnejTrisky_1.IN:= TRUE;
			END_IF	
						
			IF EDGE(Linka.IN.SnimacRotacieSpodTrysiek_2_IS12) THEN
				CasOtacaniaSpodnejTrisky_2.IN:= FALSE;
			ELSE	
				CasOtacaniaSpodnejTrisky_2.IN:= TRUE;
			END_IF	
						
			IF EDGE(Linka.IN.SnimacRotacieSpodTrysiek_3_IS13) THEN
				CasOtacaniaSpodnejTrisky_3.IN:= FALSE;
			ELSE	
				CasOtacaniaSpodnejTrisky_3.IN:= TRUE;
			END_IF	
			
						
			IF NOT Linka.OUT.IonJednotka_START THEN
				SC_OvlCistenia.ResetStep:= TRUE;
				SC_OvlCistenia.Step:= 0;
			END_IF
			
			IF SC_OvlCistenia.IdleTime.Q THEN
				IF CasOtacaniaHornejTrisky_1.Q THEN
					Alarmy[37]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				ELSIF CasOtacaniaHornejTrisky_2.Q THEN
					Alarmy[37]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				ELSIF CasOtacaniaHornejTrisky_3.Q THEN
					Alarmy[37]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				ELSIF CasOtacaniaHornejTrisky_4.Q THEN
					Alarmy[37]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				ELSIF CasOtacaniaSpodnejTrisky_1.Q THEN
					Alarmy[38]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				ELSIF CasOtacaniaSpodnejTrisky_2.Q THEN
					Alarmy[38]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				ELSIF CasOtacaniaSpodnejTrisky_3.Q THEN
					Alarmy[38]:= TRUE;
					Linka.STAV.PoruchaOtacaniaTrysiek:= TRUE;
					SC_OvlCistenia.ResetStep:= TRUE;
					SC_OvlCistenia.Step:= 0;
				END_IF
			END_IF
			
		
		
		
		
		
		
		
	
	END_CASE
	
	CasOtacaniaHornejTrisky_1.PT:= T#300ms;
	CasOtacaniaHornejTrisky_1();
	CasOtacaniaHornejTrisky_2.PT:= T#300ms;
	CasOtacaniaHornejTrisky_2();
	CasOtacaniaHornejTrisky_3.PT:= T#300ms;
	CasOtacaniaHornejTrisky_3();
	CasOtacaniaHornejTrisky_4.PT:= T#300ms;
	CasOtacaniaHornejTrisky_4();
	CasOtacaniaSpodnejTrisky_1.PT:= T#500ms;
	CasOtacaniaSpodnejTrisky_1();
	CasOtacaniaSpodnejTrisky_2.PT:= T#500ms;
	CasOtacaniaSpodnejTrisky_2();
	CasOtacaniaSpodnejTrisky_3.PT:= T#500ms;
	CasOtacaniaSpodnejTrisky_3();
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


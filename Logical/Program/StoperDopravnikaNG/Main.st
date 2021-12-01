
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvlCentrovacky;
	
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_StoperDopravNG);
	
	
	//Príznak obsluha potvrdila paletku NG na dopravníku NG//
	IF StoperDopravNG.Automat AND StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG AND Vizu.TL_NavratPaletkyNG THEN
		StoperDopravNG.STAV.ObsluhaPotvrdilaPaletkuNG:= TRUE;
		Vizu.TL_NavratPaletkyNG:= FALSE;
	END_IF	
	IF NOT StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 THEN
		StoperDopravNG.STAV.ObsluhaPotvrdilaPaletkuNG:= FALSE;
	END_IF	
	
	//Zmena farby tlaèítka potvrdenie návratu paletky NG//
	IF StoperDopravNG.STAV.ObsluhaPotvrdilaPaletkuNG THEN
		Vizu.FarbaTlacitka_PotvrdPaletkuNG:= Blikac500ms;
	ELSE
		Vizu.FarbaTlacitka_PotvrdPaletkuNG:= TRUE;
	END_IF	
		
	
	
	//Zobrazenie hlásenia potvrd paletku NG//
	IF StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG AND NOT StoperDopravNG.STAV.DopravnikNG_BUSY AND StoperDopravNG.STAV.PoINIT THEN
		Vizu.ZobrazHlasenie_PotvrdPaletkyNG:= 0;
	ELSE
		Vizu.ZobrazHlasenie_PotvrdPaletkyNG:= 1;
	END_IF	
	
	//Príznak paletka NG na konci dopravníka//
	IF StoperDopravNG.Automat AND StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 THEN
		StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG:= TRUE;
	END_IF
	
	
	
	//Zamknutie tlaèítka potvrdenie paletky NG//
	IF StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG AND StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 THEN
		Vizu.TL_PotvrdeniePaletky_NG_DISABLE:= FALSE;
	ELSE
		Vizu.TL_PotvrdeniePaletky_NG_DISABLE:= TRUE;
	END_IF	
	
	//Zamknutie tlaèítka zrušenie paletky NG//
	IF StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG AND NOT StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 THEN
		Vizu.TL_ZruseniePaletky_NG_DISABLE:= FALSE;
	ELSE
		Vizu.TL_ZruseniePaletky_NG_DISABLE:= TRUE;
	END_IF	
	
	
	//Zrušenie paletky NG//
	IF StoperDopravNG.STAV.ObsluhaPotvrdilaZrusPaletkyNG THEN
		StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG:= FALSE;
		StoperDopravNG.STAV.ObsluhaPotvrdilaZrusPaletkyNG:= FALSE;
	END_IF	
	
	 
	//Reset sekcie //
	IF StoperDopravNG.Reset THEN
		SC_StoperDopravNG.Step:= 0;
		StoperDopravNG.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_StoperDopravNG.Step:= 0;
	END_IF	
	

	
	CASE SC_StoperDopravNG.Step OF 
	
		0:
			SC_StoperDopravNG.StepName:='0 - Nulovanie';
			StoperDopravNG.Automat:= FALSE;
			StoperDopravNG.KoniecCyklu:= FALSE;
			StoperDopravNG.Manual:= FALSE;
			StoperDopravNG.STAV.PoINIT:= FALSE;
			StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;
			StoperDopravNG.OUT.Dopravnik_ChodVZAD_ELR3:= FALSE;
			SC_OvlCentrovacky.Step:= 0;
			StoperDopravNG.STAV.ObsluhaPotvrdilaPaletkuNG:= FALSE;
			StoperDopravNG.RR_Dopravnik_VPRED:= FALSE;
			StoperDopravNG.RR_Dopravnik_VZAD:= FALSE;
			Vizu.ZobrazHlasenie_PotvrdPaletkyNG:= 1;
			StoperDopravNG.STAV.PrebiehaVyvazaniePaletky:= FALSE;
			StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG:= FALSE;
			StoperDopravNG.STAV.DopravnikNG_BUSY:= FALSE;
			StoperDopravNG_Statistika.IN.START_MeraniaCasu:= FALSE;
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Safety.STAV.ZonaBunky_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 1;
			END_IF
	
		1:
			SC_StoperDopravNG.StepName:='1 - Cakam na spustenie vyroby';
			StoperDopravNG.KoniecCyklu:= FALSE;
			IF StoperDopravNG.Automat THEN
				SC_StoperDopravNG.Step:= 2;
			ELSIF StoperDopravNG.Manual THEN
				SC_StoperDopravNG.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		2:
			SC_StoperDopravNG.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_StoperDopravNG.IdleTime.PT:= T#4s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
			
									
			IF DopravBunky.STAV.PoINIT AND Robot.STAV.PoINIT THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 5;
			END_IF
		
			
		5:
			SC_StoperDopravNG.StepName:='5 - Inicializacia - hladanie paletky na dopravniku NG';
			SC_StoperDopravNG.IdleTime.PT:= T#5s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_StoperDopravNG.Switch1 AND Safety.STAV.MutingRobota_AKTIVNY THEN
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= TRUE;
				StoperDopravNG.STAV.DopravnikNG_BUSY:= TRUE;
				SC_StoperDopravNG.IdleTime.IN:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
			
			
			IF StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 THEN
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;
				StoperDopravNG.STAV.DopravnikNG_BUSY:= FALSE;
				Vizu.ZobrazHlasenie_PotvrdPaletkyNG:= 0;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 10;
			ELSIF SC_StoperDopravNG.IdleTime.Q THEN
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;
				StoperDopravNG.STAV.DopravnikNG_BUSY:= FALSE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 10;
			END_IF	
			
			
			
		10:
			SC_StoperDopravNG.StepName:='10 - Inicializacia - presun centrovacky do sterdnej polohy';
			SC_StoperDopravNG.IdleTime.PT:= T#4s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
			
			IF NOT SC_StoperDopravNG.Switch1 THEN
				Centrovacku_VYSTRED:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 13;
			END_IF	
		
		13:
			SC_StoperDopravNG.StepName:='13 - Inicializacia - hladanie paletky';
			SC_StoperDopravNG.IdleTime.PT:= T#3s;
			SC_StoperDopravNG.AlarmTime.PT:= T#7s;
			
			SC_StoperDopravNG.IdleTime.IN:= StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15;
			SC_StoperDopravNG.AlarmTime.IN:= TRUE;
			
			
			
			IF SC_StoperDopravNG.IdleTime.Q THEN
				StoperDopravNG.STAV.PoINIT:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 100;		
			ELSIF SC_StoperDopravNG.AlarmTime.Q AND NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 THEN
				StoperDopravNG.STAV.PoINIT:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 100;
			END_IF
		
		
			//********************************************************Automatický režim****************************************************************************//	
		
		100:
			SC_StoperDopravNG.StepName:='100 - Automaticky Rezim - cakam na príchod paletky na stoper';
			SC_StoperDopravNG.IdleTime.PT:= T#3s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
		
			SC_StoperDopravNG.IdleTime.IN:= StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15;
						
			IF StoperDopravNG.KoniecCyklu THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 0;
			ELSIF SC_StoperDopravNG.IdleTime.Q THEN
				StoperDopravNG_Statistika.IN.START_MeraniaCasu:= TRUE;
				StoperDopravNG_Statistika.IN.ZAPIS_MeraniaCasu:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 110; 
			ELSIF NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 AND StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 AND NOT StoperEtiketovania.STAV.PrebiehaVyvazaniePaletky AND StoperDopravNG.STAV.ObsluhaPotvrdilaPaletkuNG AND NOT StoperEtiketovania.STAV.Etiketovanie_BUSY AND NOT StoperVystupDopravnika.IN.ZaplnenieBuffera_IS28 THEN
				StoperDopravNG.STAV.DopravnikNG_BUSY:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 150;
			END_IF
				
			
			
		
		110:
			SC_StoperDopravNG.StepName:='110 - Automaticky Rezim - kontrola stavu paletky';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
		
		
			IF StoperEtiketovania.STAV.VyvazamPaletkuNG THEN
				StoperDopravNG.STAV.DopravnikNG_BUSY:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 120;
			ELSE
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 170;	
			END_IF	
		
			//Vyvezenie na dopravník NG//	
		120:
			SC_StoperDopravNG.StepName:='120 - Automaticky Rezim - kontrola muting pozicie robota';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
			
			IF Safety.STAV.MutingRobota_AKTIVNY AND Robot.STAV.PoINIT THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 128;	
			ELSIF NOT Safety.STAV.MutingRobota_AKTIVNY AND Robot.STAV.PoINIT THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 123;
			END_IF	
			
		123:
			SC_StoperDopravNG.StepName:='123 - Automaticky Rezim - cakam na ukoncenie cinnosti robota';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 125;
			END_IF	
			
		125:
			SC_StoperDopravNG.StepName:='125 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena AND Safety.STAV.MutingRobota_AKTIVNY THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 128; 
			END_IF 
			
			
			
		128:
			SC_StoperDopravNG.StepName:='128 - Automaticky Rezim - zdvih centrovacky pre vyvezenie paletky na dopravnik NG';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
				
			
			IF NOT SC_StoperDopravNG.Switch1 THEN
				Centrovacku_VYSUN:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF StoperDopravNG.IN.Centrovanie_HornaPoloha_IS19 THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 130;
			END_IF	
		
		130:
			SC_StoperDopravNG.StepName:='130 - Automaticky Rezim - spustenie dopravnika NG vpred';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
		
			SC_StoperDopravNG.IdleTime.IN:= StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4;
			
			IF NOT SC_StoperDopravNG.Switch1 AND Safety.STAV.MutingRobota_AKTIVNY THEN
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= TRUE;
				SC_StoperDopravNG.AlarmTime.IN:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF SC_StoperDopravNG.IdleTime.Q THEN
				(*StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;*)
				StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG:= TRUE;
				StoperDopravNG.STAV.DopravnikNG_BUSY:= FALSE;
				Vizu.ZobrazHlasenie_PotvrdPaletkyNG:= 0;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 133;
			ELSIF SC_StoperDopravNG.AlarmTime.Q THEN
				Alarmy[63]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 0;	
			END_IF	
		
					
		
		133:
			SC_StoperDopravNG.StepName:='133 - Automaticky Rezim - presun centrovacky do strednej polohy';
			SC_StoperDopravNG.IdleTime.PT:= T#4s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
			
			IF NOT SC_StoperDopravNG.Switch1 THEN
				Centrovacku_VYSTRED:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 100;
			END_IF
		
			//Navezenie z dopravníka NG//		
		150:
			SC_StoperDopravNG.StepName:='150 - Automaticky Rezim - kontrola muting pozicie robota';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
			
			IF Safety.STAV.MutingRobota_AKTIVNY THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 158;	
			ELSIF NOT Safety.STAV.MutingRobota_AKTIVNY AND Robot.Automat THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 153;
			END_IF	
			
		153:
			SC_StoperDopravNG.StepName:='153 - Automaticky Rezim - cakam na ukoncenie cinnosti robota';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 155;
			END_IF	
			
		155:
			SC_StoperDopravNG.StepName:='155 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena AND Safety.STAV.MutingRobota_AKTIVNY THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 158; 
			END_IF 
			
			
			
		158:
			SC_StoperDopravNG.StepName:='150 - Automaticky Rezim - zdvih centrovacky pre navezenie paletky z dopravnika NG';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
		
			IF NOT SC_StoperDopravNG.Switch1 THEN
				Centrovacku_VYSUN:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF StoperDopravNG.IN.Centrovanie_HornaPoloha_IS19 THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 160;
			END_IF
		
		160:
			SC_StoperDopravNG.StepName:='160 - Automaticky Rezim - spustenie dopravnika NG vzad';
			SC_StoperDopravNG.IdleTime.PT:= T#200ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
		
			SC_StoperDopravNG.IdleTime.IN:= StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15;
			
			IF NOT SC_StoperDopravNG.Switch1 AND Safety.STAV.MutingRobota_AKTIVNY THEN
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVZAD_ELR3:= TRUE;
				SC_StoperDopravNG.AlarmTime.IN:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF SC_StoperDopravNG.IdleTime.Q THEN
				StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVZAD_ELR3:= FALSE;
				StoperDopravNG.STAV.DopravnikNG_BUSY:= FALSE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 163;
			ELSIF SC_StoperDopravNG.AlarmTime.Q THEN
				Alarmy[64]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 0;	
			END_IF	
		
				
			
		163:
			SC_StoperDopravNG.StepName:='163 - Automaticky Rezim - presun centrovacky do strednej polohy';
			SC_StoperDopravNG.IdleTime.PT:= T#4s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
			
			IF NOT SC_StoperDopravNG.Switch1 THEN
				Centrovacku_VYSTRED:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF
		
			IF StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 170;
			END_IF
			
			
			//Vyvezenie paletky na výstupný dopravník//		
		170:
			SC_StoperDopravNG.StepName:='170 - Automaticky Rezim - cakam na vyvezenie na stoper vystupneho dopravnika';
			SC_StoperDopravNG.IdleTime.PT:= T#4s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
		
		
			IF StoperDopravNG.KoniecCyklu THEN
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 0;
			ELSIF NOT StoperVystupDopravnika.IN.ZaplnenieBuffera_IS28 AND VystupnyDopravnik.STAV.PoINIT THEN	
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 173;
			END_IF
		
		173:
			SC_StoperDopravNG.StepName:='173 - Automaticky Rezim - vyvazam paletku na stoper vystupneho dopravnika';
			SC_StoperDopravNG.IdleTime.PT:= T#500ms;
			SC_StoperDopravNG.AlarmTime.PT:= T#10s;
			
			SC_StoperDopravNG.IdleTime.IN:= NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15;
			
			IF NOT SC_StoperDopravNG.Switch1 THEN
				Centrovacku_ZASUN:= TRUE;
				StoperDopravNG.STAV.PrebiehaVyvazaniePaletky:= TRUE;
				SC_StoperDopravNG.AlarmTime.IN:= TRUE;
				SC_StoperDopravNG.Switch1:= TRUE;
			END_IF	
			
			IF NOT SC_StoperDopravNG.Switch2 AND SC_StoperDopravNG.IdleTime.Q AND SC_OvlCentrovacky.Step = 1 THEN
				Centrovacku_VYSTRED:= TRUE;
				SC_StoperDopravNG.AlarmTime.IN:= FALSE;
				SC_StoperDopravNG.Switch2:= TRUE;
			END_IF
						
			
			IF NOT Linka.Rezim_Priechodny AND StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 AND NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 THEN
				StoperDopravNG.STAV.PrebiehaVyvazaniePaletky:= FALSE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 100;
			ELSIF Linka.Rezim_Priechodny AND StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 AND NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 AND StoperVystupDopravnika.IN.ZaplnenieBuffera_IS28 THEN	
				StoperDopravNG.STAV.PrebiehaVyvazaniePaletky:= FALSE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 100;
			ELSIF SC_StoperDopravNG.AlarmTime.Q THEN
				Alarmy[65]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperDopravNG.ResetStep:= TRUE;
				SC_StoperDopravNG.Step:= 0;
			END_IF
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_StoperDopravNG.StepName:='700 - Manualny Rezim';
			SC_StoperDopravNG.IdleTime.PT:= T#8s;
			SC_StoperDopravNG.AlarmTime.PT:= T#5s;
			
			//Ovládanie dopravníka//
			IF StoperDopravNG.RR_Dopravnik_VPRED THEN
				StoperDopravNG.RR_Dopravnik_VZAD:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVZAD_ELR3:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= TRUE;
			ELSIF StoperDopravNG.RR_Dopravnik_VZAD THEN	
				StoperDopravNG.RR_Dopravnik_VPRED:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVZAD_ELR3:= TRUE;
			ELSE
				StoperDopravNG.OUT.Dopravnik_ChodVPRED_ELR3:= FALSE;
				StoperDopravNG.OUT.Dopravnik_ChodVZAD_ELR3:= FALSE;
			END_IF	
		
			
	END_CASE		
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


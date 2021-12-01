
PROGRAM _INIT
	
	VystupVytah.PAR.Zdvih_ZadanaJoggRychlost:= 10;
	
	
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvlMenica;
	OvlCitackyRFID;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VystupVytah);
	 
	
	//Reset sekcie //
	IF VystupVytah.Reset THEN
		SC_VystupVytah.Step:= 0;
		VystupVytah.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_VystupVytah.Step:= 0;
	END_IF	
	

	
	CASE SC_VystupVytah.Step OF 
	
		0:
			SC_VystupVytah.StepName:='0 - Nulovanie';
			VystupVytah.Automat:= FALSE;
			VystupVytah.KoniecCyklu:= FALSE;
			VystupVytah.Manual:= FALSE;
			VystupVytah.STAV.PoINIT:= FALSE;
			SC_OvlMenica.Step:= 0;
			VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
			VystupVytah.OUT.Dopravnik_ChodVZAD_ELR6:= FALSE;
			VystupVytah.RR_Dopravnik_VPRED:= FALSE;
			VystupVytah.RR_Dopravnik_VZAD:= FALSE;
			VystupVytah.STAV.PrebiehaVyvazaniePaletky:= FALSE;
			IF PoruchaVystupnehoVytahu THEN
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= Blikac200ms;
			ELSE
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
			END_IF	
			VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
			VystupVytah.STAV.VytahNapolohovany:= FALSE;
			VystupnyVytah_Statistika.IN.START_MeraniaCasu:= FALSE;
						
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Safety.STAV.ZonaVystupnyVytah_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 1;
			END_IF
	
		1:
			SC_VystupVytah.StepName:='1 - Cakam na spustenie vyroby';
			VystupVytah.KoniecCyklu:= FALSE;
			IF VystupVytah.Automat THEN
				SC_VystupVytah.Step:= 2;
			ELSIF VystupVytah.Manual THEN
				SC_VystupVytah.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
	
		2:
			SC_VystupVytah.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_VystupVytah.IdleTime.PT:= T#500ms;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
			
			SC_VystupVytah.IdleTime.IN:= TRUE;
									
			IF SC_VystupVytah.IdleTime.Q THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 5;
			END_IF
		
		5:
			SC_VystupVytah.StepName:='5 - Inicializacia - spustam dopravnik vytahu pre navezenie paletky';
			SC_VystupVytah.IdleTime.PT:= T#500ms;
			SC_VystupVytah.AlarmTime.PT:= T#7s;
			
			SC_VystupVytah.IdleTime.IN:= VystupVytah.IN.PritomnostPaletky_IS26;
			
			IF NOT SC_VystupVytah.Switch1 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= TRUE;
				SC_VystupVytah.AlarmTime.IN:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF	
			
			IF SC_VystupVytah.IdleTime.Q AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 15;
			ELSIF SC_VystupVytah.AlarmTime.Q AND NOT VystupVytah.IN.PritomnostPaletky_IS26 AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN	
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 15;
			ELSIF SC_VystupVytah.AlarmTime.Q AND VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN		
				Alarmy[49]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			END_IF	
		
					
			
				
		15:
			SC_VystupVytah.StepName:='15 - Inicializacia - kontrola homingu zdvihu vytahu';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
		
			IF VystupVytah.STAV.Zdvih_HomingOK THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 35;
			ELSE
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 18;
			END_IF
		
		18:
			SC_VystupVytah.StepName:='18 - Inicializacia - cakam na spustenie homingu zdvihu vytahu';
			SC_VystupVytah.IdleTime.PT:= T#1s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
			
			SC_VystupVytah.IdleTime.IN:= Safety.STAV.BarieraVystupVytahu_AKTIVNA AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6;
			           
			            
			IF SC_VystupVytah.IdleTime.Q THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 20;
			END_IF		
			
			
			
			
		20:
			SC_VystupVytah.StepName:='20 - Inicializacia - spustam homing zdvihu vytahu';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
		
			VystupVytah.OUT.Banner_CervenaLED_IOS2:= TRUE;
					
			
			IF NOT SC_VystupVytah.Switch1 THEN
				Zdvih_HOME:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
		
			IF VystupVytah.STAV.Zdvih_HomingOK THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 35;
			ELSIF NOT Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				Alarmy[50]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			ELSIF VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				Alarmy[51]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			END_IF	
	
		
	
		
		35:
			SC_VystupVytah.StepName:='35 - Inicializacia - cakam na spustenie presunu vytahu do hornej pozicie navazania';
			SC_VystupVytah.IdleTime.PT:= T#1s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
			
			SC_VystupVytah.IdleTime.IN:= Safety.STAV.BarieraVystupVytahu_AKTIVNA AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6;
			           
			            
			IF SC_VystupVytah.IdleTime.Q THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 38;
			END_IF		
		
		
		38:
			SC_VystupVytah.StepName:='38 - Inicializacia - presuvam vytah do hornej pozicie navazania';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
		
			VystupVytah.OUT.Banner_CervenaLED_IOS2:= TRUE;
			VystupVytah.PAR.Zdvih_ZadanaRychlost:= 50;
			VystupVytah.PAR.Zdvih_ZadanaPozicia:= RemPremenne.VystupVytah_PozNavazania;			
			
			
			
			IF NOT SC_VystupVytah.Switch1 AND SC_OvlMenica.Step = 1 THEN
				Zdvih_POLOHUJ:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
		
			IF VystupVytah.STAV.VytahNapolohovany THEN
				VystupVytah.STAV.VytahNapolohovany:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 40;
			ELSIF NOT Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				Alarmy[50]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			ELSIF VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				Alarmy[51]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;	
			END_IF		
		
		
		40:
			SC_VystupVytah.StepName:='40 - Inicializacia - kontrola pritomnosti paletky na dopravniku vytahu';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
		
			IF VystupVytah.IN.PritomnostPaletky_IS26 THEN
				VystupVytah.STAV.PoINIT := TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 100;
			ELSE	
				VystupVytah.STAV.PoINIT := TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 100;
			END_IF	
		
		
			//********************************************************Automatický režim****************************************************************************//
		
		100:
			SC_VystupVytah.StepName:='100 - Automaticky Rezim - cakam na navezenie paletky na vytah zo stopra vystupneho dopravnika';
			SC_VystupVytah.IdleTime.PT:= T#500ms;
			SC_VystupVytah.AlarmTime.PT:= T#5s;	
		
		
			IF VystupVytah.KoniecCyklu THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			ELSIF SC_StoperVystupDopravnika.Step = 105 AND NOT VystupVytah.IN.PritomnostPaletky_IS26 AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 105;
			ELSIF VystupVytah.IN.PritomnostPaletky_IS26 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 108;
			END_IF		
		
			
			
		105:
			SC_VystupVytah.StepName:='105 - Automaticky Rezim - navazam paletku na dopravnik vytahu';
			SC_VystupVytah.IdleTime.PT:= T#200ms;
			SC_VystupVytah.AlarmTime.PT:= T#20s;
		
			SC_VystupVytah.IdleTime.IN:= VystupVytah.IN.PritomnostPaletky_IS26;
			
			IF NOT SC_VystupVytah.Switch1 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= TRUE;
				SC_VystupVytah.AlarmTime.IN:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF	
			
			
            
            
			IF SC_VystupVytah.IdleTime.Q AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 108;
			ELSIF SC_VystupVytah.AlarmTime.Q THEN
				Alarmy[52]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			END_IF		
			
			
			
			
		
		108:
			SC_VystupVytah.StepName:='108 - Automaticky Rezim - citam cislo paletky';
			SC_VystupVytah.IdleTime.PT:= T#200ms;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
					
			SC_VystupVytah.IdleTime.IN:= RFID_Hlava_3.STAV.PritomnostCipu;
			
			IF SC_VystupVytah.IdleTime.Q THEN
				IF RFID_Hlava_3.PAR.PrecitaneCisloPaletky <> '' THEN
					i:=  STRING_TO_USINT(RFID_Hlava_3.PAR.PrecitaneCisloPaletky);
					SC_VystupVytah.ResetStep:= TRUE;
					SC_VystupVytah.Step:= 110;
				ELSE
					Alarmy[62]:= TRUE;
					PoruchaVystupnehoVytahu:= TRUE;
					SC_VystupVytah.ResetStep:= TRUE;
					SC_VystupVytah.Step:= 0;
				END_IF	
			END_IF	
			
			
			
		
		110:
			SC_VystupVytah.StepName:='110 - Automaticky Rezim - kontrola stavu paletky';
			SC_VystupVytah.IdleTime.PT:= T#200ms;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
		
		
			IF Paletka[i].StavPaletky = 'OK' THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 120;	
			ELSIF Paletka[i].StavPaletky = 'NG' THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 125;
			ELSIF Paletka[i].StavPaletky = 'PR' THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 125;	
			ELSE
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 125;
			END_IF	
			
		
	
			
						
		120:
			SC_VystupVytah.StepName:='120 - Automaticky Rezim - cakam na odobratie OK kusu a potvrdenie bannerom alebo aktivnou barierou';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
		
			SC_VystupVytah.IdleTime.IN:= VystupVytah.IN.PritomnostPaletky_IS26 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA;
			
			VystupVytah.OUT.Banner_ZelenaLED_IOS2:= TRUE;
			VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
			
			IF VystupVytah.KoniecCyklu THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			ELSIF VystupVytah.IN.PritomnostPaletky_IS26 AND (NOT VystupVytah.IN.PritomnostProduktu_OS5 OR (Linka.Rezim_Testovania AND SC_VystupVytah.IdleTime.Q)) AND Safety.STAV.BarieraVystupVytahu_AKTIVNA AND VystupVytah.IN.BannerPotvrdeny_IOS2 AND VratnyDopravnik.STAV.PoINIT THEN
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 130;
			ELSIF VystupVytah.IN.PritomnostPaletky_IS26 AND (NOT VystupVytah.IN.PritomnostProduktu_OS5 OR (Linka.Rezim_Testovania AND SC_VystupVytah.IdleTime.Q)) AND SC_VystupVytah.IdleTime.Q AND NOT VystupVytah_Banner_AKTIVNY AND VratnyDopravnik.STAV.PoINIT THEN 	
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 130;
			ELSIF NOT VystupVytah.IN.PritomnostPaletky_IS26 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 121;
			END_IF	
	
			
		121:
			SC_VystupVytah.StepName:='121 - Automaticky Rezim - kontrola pritomnosti paletky na dopravniku vytahu';
			SC_VystupVytah.IdleTime.PT:= T#5s;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
			
			
			
			IF NOT SC_VystupVytah.Switch1 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= TRUE;
				SC_VystupVytah.IdleTime.IN:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
			
			IF VystupVytah.IN.PritomnostPaletky_IS26 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 120;
			ELSIF SC_VystupVytah.IdleTime.Q THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 100;
			END_IF		
			
			
			
		125:
			SC_VystupVytah.StepName:='125 - Automaticky Rezim - cakam na potvrdenie NG kusu bannerom alebo aktivnou barierou';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
		
			IF VystupVytah.IN.PritomnostProduktu_OS5 THEN
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= TRUE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= TRUE;
			ELSE
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= TRUE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
			END_IF	
				
			
			SC_VystupVytah.IdleTime.IN:= VystupVytah.IN.PritomnostPaletky_IS26 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA AND NOT VystupVytah_BannerNG_AKTIVNY AND VratnyDopravnik.STAV.PoINIT;
			
			
			IF VystupVytah.KoniecCyklu THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			ELSIF VystupVytah.IN.PritomnostPaletky_IS26 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA AND VystupVytah.IN.BannerPotvrdeny_IOS2 AND VratnyDopravnik.STAV.PoINIT THEN
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 130;
			ELSIF SC_VystupVytah.IdleTime.Q THEN 	
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 130;
			ELSIF NOT VystupVytah.IN.PritomnostPaletky_IS26 AND Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				VystupVytah.OUT.Banner_ZelenaLED_IOS2:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 128;
			END_IF		
			
		
		128:
			SC_VystupVytah.StepName:='128 - Automaticky Rezim - kontrola pritomnosti paletky na dopravniku vytahu';
			SC_VystupVytah.IdleTime.PT:= T#2s;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
			
			
			
			IF NOT SC_VystupVytah.Switch1 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= TRUE;
				SC_VystupVytah.IdleTime.IN:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
			
			IF VystupVytah.IN.PritomnostPaletky_IS26 THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 125;
			ELSIF SC_VystupVytah.IdleTime.Q THEN
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 100;
			END_IF			
			
			
			
			
		
		
		130:
			SC_VystupVytah.StepName:='130 - Automaticky Rezim - presuvam vytah do spodnej pozicie vyvazania';
			SC_VystupVytah.IdleTime.PT:= T#3s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
		
			VystupVytah.OUT.Banner_CervenaLED_IOS2:= TRUE;		
			VystupVytah.PAR.Zdvih_ZadanaRychlost:= 50;
			VystupVytah.PAR.Zdvih_ZadanaPozicia:= RemPremenne.VystupVytah_PozVyvazania;
			
			
			
			IF NOT SC_VystupVytah.Switch1 AND SC_OvlMenica.Step = 1 THEN
				Zdvih_POLOHUJ:= TRUE;
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= TRUE;
				VystupnyVytah_Statistika.IN.START_MeraniaCasu:= TRUE;
				VystupnyVytah_Statistika.IN.ZAPIS_MeraniaCasu:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
		
			IF VystupVytah.STAV.VytahNapolohovany THEN
				VystupVytah.STAV.VytahNapolohovany:= FALSE;
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 135;
			ELSIF NOT Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				Alarmy[50]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;	
			ELSIF VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				Alarmy[51]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;
			END_IF	
		
		
				
		
		135:
			SC_VystupVytah.StepName:='135 - Automaticky Rezim - vyvezenie paletky na vratny dopravnik';
			SC_VystupVytah.IdleTime.PT:= T#200ms;
			SC_VystupVytah.AlarmTime.PT:= T#2s;
		
					
			IF NOT SC_VystupVytah.Switch1 THEN
				VystupVytah.OUT.Dopravnik_ChodVZAD_ELR6:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
		
			IF EDGENEG(VystupVytah.IN.PrechodDopravnikaVytahu_OS6) THEN
				SC_VystupVytah.IdleTime.IN:= TRUE;
			END_IF
			
			IF SC_VystupVytah.IdleTime.Q AND NOT VystupVytah.IN.PritomnostPaletky_IS26 AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				VystupVytah.OUT.Dopravnik_ChodVZAD_ELR6:= FALSE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 140;
			END_IF	
		
		140:
			SC_VystupVytah.StepName:='140 - Automaticky Rezim - cakam na presun vytahu do hornej pozicie navazania';
			SC_VystupVytah.IdleTime.PT:= T#1s;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
		
			SC_VystupVytah.IdleTime.IN:= Safety.STAV.BarieraVystupVytahu_AKTIVNA AND NOT VystupVytah.IN.PrechodDopravnikaVytahu_OS6;
            
			IF SC_VystupVytah.IdleTime.Q THEN
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 143;
			END_IF	
		
		143:
			SC_VystupVytah.StepName:='143 - Automaticky Rezim - presuvam vytah do hornej pozicie navazania';
			SC_VystupVytah.IdleTime.PT:= T#500ms;
			SC_VystupVytah.AlarmTime.PT:= T#10s;
		
			VystupVytah.OUT.Banner_CervenaLED_IOS2:= TRUE;	
			VystupVytah.PAR.Zdvih_ZadanaRychlost:= 50;
			VystupVytah.PAR.Zdvih_ZadanaPozicia:= RemPremenne.VystupVytah_PozNavazania;
						
			
			IF NOT SC_VystupVytah.Switch1 AND SC_OvlMenica.Step = 1 THEN
				Zdvih_POLOHUJ:= TRUE;
				SC_VystupVytah.Switch1:= TRUE;
			END_IF
		
			IF VystupVytah.STAV.VytahNapolohovany THEN
				VystupVytah.STAV.VytahNapolohovany:= FALSE;
				VystupVytah.OUT.Banner_CervenaLED_IOS2:= FALSE;	
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 100;
			ELSIF NOT Safety.STAV.BarieraVystupVytahu_AKTIVNA THEN
				Alarmy[50]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;	
			ELSIF VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
				Alarmy[51]:= TRUE;
				PoruchaVystupnehoVytahu:= TRUE;
				SC_VystupVytah.ResetStep:= TRUE;
				SC_VystupVytah.Step:= 0;	
			END_IF	
		
	
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_VystupVytah.StepName:='700 - Manualny Rezim';
			SC_VystupVytah.IdleTime.PT:= T#8s;
			SC_VystupVytah.AlarmTime.PT:= T#5s;
		
		
		
			//Ovládanie dopravníka//
			IF VystupVytah.RR_Dopravnik_VPRED THEN
				VystupVytah.OUT.Dopravnik_ChodVZAD_ELR6:= FALSE;
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= TRUE;
			ELSIF VystupVytah.RR_Dopravnik_VZAD THEN	
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				VystupVytah.OUT.Dopravnik_ChodVZAD_ELR6:= TRUE;
			ELSE
				VystupVytah.OUT.Dopravnik_ChodVPRED_ELR6:= FALSE;
				VystupVytah.OUT.Dopravnik_ChodVZAD_ELR6:= FALSE;
			END_IF	
		
		
		
		
		
		
		
		
	END_CASE
	
	
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


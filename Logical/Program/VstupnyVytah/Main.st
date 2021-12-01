
PROGRAM _INIT
	VstupVytah.PAR.Zdvih_ZadanaJoggRychlost:= 10;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie podprogramov//
	OvlMenica;
	OvlDveri;
	OvlCitackyRFID;
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VstupVytah);
	
	
	//Reset sekcie //
	IF VstupVytah.Reset THEN
		SC_VstupVytah.Step:= 0;
		VstupVytah.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_VstupVytah.Step:= 0;
	END_IF	
	

	
	CASE SC_VstupVytah.Step OF 
	
		0:
			SC_VstupVytah.StepName:='0 - Nulovanie';
			VstupVytah.Automat:= FALSE;
			VstupVytah.KoniecCyklu:= FALSE;
			VstupVytah.Manual:= FALSE;
			VstupVytah.STAV.PoINIT:= FALSE;
			SC_OvlMenica.Step:= 0;
			SC_OvlDveri.Step:= 0;
			VstupVytah.OUT.Dopravnik_ChodVPRED_ELR1:= FALSE;
			VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
			VstupVytah.RR_Dopravnik_VPRED:= FALSE;
			VstupVytah.RR_Dopravnik_VZAD:= FALSE;
			IF PoruchaVstupnehoVytahu THEN
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= Blikac200ms;
			ELSE
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
			END_IF	
			VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
			VstupVytah.STAV.PrebiehaVyvazaniePaletky:= FALSE;
			VstupVytah.STAV.VytahNapolohovany:= FALSE;
			Vizu.ZobrazHlasenie_NespravTypPaletky:= 1;
			VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
			VstupnyVytah_Statistika.IN.START_MeraniaCasu:= FALSE;
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Safety.STAV.ZonaVstupnyVytah_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 1;
			END_IF
	
		1:
			SC_VstupVytah.StepName:='1 - Cakam na spustenie vyroby';
			VstupVytah.KoniecCyklu:= FALSE;
			IF VstupVytah.Automat THEN
				SC_VstupVytah.Step:= 2;
			ELSIF VstupVytah.Manual THEN
				SC_VstupVytah.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
	
		2:
			SC_VstupVytah.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
			
			SC_VstupVytah.IdleTime.IN:= TRUE;
									
			IF SC_VstupVytah.IdleTime.Q THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 5;
			END_IF
		
		5:
			SC_VstupVytah.StepName:='5 - Inicializacia - spustam dopravnik vytahu pre navezenie paletky';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#7s;
			
			SC_VstupVytah.IdleTime.IN:= VstupVytah.IN.PritomnostPaletky_IS3;
			
			IF NOT SC_VstupVytah.Switch1 THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= TRUE;
				SC_VstupVytah.AlarmTime.IN:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF	
			
			IF SC_VstupVytah.IdleTime.Q AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 10;
			ELSIF SC_VstupVytah.AlarmTime.Q AND NOT VstupVytah.IN.PritomnostPaletky_IS3 AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN	
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 10;
			ELSIF SC_VstupVytah.AlarmTime.Q AND VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN		
				Alarmy[44]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			END_IF	
		
		10:
			SC_VstupVytah.StepName:='10 - Inicializacia - kontrola zatvorenia dveri vytahu';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#7s;	
			
			
			IF VstupVytah.IN.DvereVytahuZatvorene_MS2 THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 15;
			ELSE
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 13;
			END_IF
		
		
						
				
				
		13:
			SC_VstupVytah.StepName:='10 - Inicializacia - zatvorenie dveri vytahu';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#7s;
			
			
			IF NOT SC_VstupVytah.Switch1 THEN
				Dvere_ZATVOR:= TRUE;	
				SC_VstupVytah.Switch1:= TRUE;
			END_IF	
				
			IF VstupVytah.IN.DvereVytahuZatvorene_MS2 THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 15;
			END_IF
			
			
			
				
		15:
			SC_VstupVytah.StepName:='15 - Inicializacia - kontrola homingu zdvihu vytahu';
			SC_VstupVytah.IdleTime.PT:= T#2s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
		
			IF VstupVytah.STAV.Zdvih_HomingOK THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 35;
			ELSE
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 18;
			END_IF
		
		18:
			SC_VstupVytah.StepName:='18 - Inicializacia - cakam na spustenie homingu zdvihu vytahu';
			SC_VstupVytah.IdleTime.PT:= T#1s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
			
			SC_VstupVytah.IdleTime.IN:= Safety.STAV.BarieraVstupVytahu_AKTIVNA AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1;
			           
			            
			IF SC_VstupVytah.IdleTime.Q THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 20;
			END_IF		
			
			
			
			
		20:
			SC_VstupVytah.StepName:='20 - Inicializacia - spustam homing zdvihu vytahu';
			SC_VstupVytah.IdleTime.PT:= T#2s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
		
			VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
					
			
			IF NOT SC_VstupVytah.Switch1 THEN
				Zdvih_HOME:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
		
			IF VstupVytah.STAV.Zdvih_HomingOK THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 35;
			ELSIF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			ELSIF VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
				Alarmy[47]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			END_IF	
	
		

		35:
			SC_VstupVytah.StepName:='35 - Inicializacia - cakam na spustenie presunu vytahu do hornej pozicie vyvazania';
			SC_VstupVytah.IdleTime.PT:= T#1s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
			
			SC_VstupVytah.IdleTime.IN:= Safety.STAV.BarieraVstupVytahu_AKTIVNA AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1;
			           
			            
			IF SC_VstupVytah.IdleTime.Q THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 38;
			END_IF		
		
		
		38:
			SC_VstupVytah.StepName:='38 - Inicializacia - presuvam vytah do hornej pozicie vyvazania';
			SC_VstupVytah.IdleTime.PT:= T#1s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
		
			VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
			VstupVytah.PAR.Zdvih_ZadanaRychlost:= 50;
			VstupVytah.PAR.Zdvih_ZadanaPozicia:= RemPremenne.VstupVytah_PozVyvazania;
						
			
			IF NOT SC_VstupVytah.Switch1 AND SC_OvlMenica.Step = 1 THEN
				Zdvih_POLOHUJ:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
		
			IF VstupVytah.STAV.VytahNapolohovany THEN
				VstupVytah.STAV.VytahNapolohovany:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 40;
			ELSIF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;	
			ELSIF VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
				Alarmy[47]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;	
			END_IF		
		
		
		40:
			SC_VstupVytah.StepName:='40 - Inicializacia - kontrola pritomnosti paletky na dopravniku vytahu';
			SC_VstupVytah.IdleTime.PT:= T#2s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
		
			IF VstupVytah.IN.PritomnostPaletky_IS3 THEN
				VstupVytah.STAV.PoINIT := TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 100;
			ELSE	
				VstupVytah.STAV.PoINIT := TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 100;
			END_IF	
		
		
			//********************************************************Automatický režim****************************************************************************//
		
		100:
			SC_VstupVytah.StepName:='100 - Automaticky Rezim - cakam na navezenie paletky na vytah zo spodneho vratneho dopravnika';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#5s;	
		
		
			IF VstupVytah.KoniecCyklu THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			ELSIF SC_StoperVratDopravnika.Step = 101 AND NOT VstupVytah.IN.PritomnostPaletky_IS3 AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA AND VstupVytah.IN.DvereVytahuZatvorene_MS2 THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 103;
			ELSIF VstupVytah.IN.PritomnostPaletky_IS3 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 111;
			END_IF		
		
		
		103:
			SC_VstupVytah.StepName:='103 - Automaticky Rezim - presuvam vytah do spodnej pozicie navazania';
			SC_VstupVytah.IdleTime.PT:= T#1s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
		
			
			VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;		
			VstupVytah.PAR.Zdvih_ZadanaRychlost:= 50;
			VstupVytah.PAR.Zdvih_ZadanaPozicia:= RemPremenne.VstupVytah_PozNavazania;
						
			
			IF NOT SC_VstupVytah.Switch1 AND SC_OvlMenica.Step = 1 THEN
				Zdvih_POLOHUJ:= TRUE;
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
		
			IF VstupVytah.STAV.VytahNapolohovany THEN
				VstupVytah.STAV.VytahNapolohovany:= FALSE;
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 105;
			ELSIF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;	
			ELSIF VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
				Alarmy[47]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			END_IF	
	
		
		105:
			SC_VstupVytah.StepName:='105 - Automaticky Rezim - navazam paletku na dopravnik vytahu';
			SC_VstupVytah.IdleTime.PT:= T#200ms;
			SC_VstupVytah.AlarmTime.PT:= T#20s;
		
			SC_VstupVytah.IdleTime.IN:= VstupVytah.IN.PritomnostPaletky_IS3;
			
			IF NOT SC_VstupVytah.Switch1 THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= TRUE;
				SC_VstupVytah.AlarmTime.IN:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF	
			
			
            
            
			IF SC_VstupVytah.IdleTime.Q AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 108;
			ELSIF SC_VstupVytah.AlarmTime.Q THEN
				Alarmy[45]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			END_IF	
		
		
		108:
			SC_VstupVytah.StepName:='108 - Automaticky Rezim - cakam na presun vytahu do hornej pozicie vyvazania';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
		
			SC_VstupVytah.IdleTime.IN:= Safety.STAV.BarieraVstupVytahu_AKTIVNA AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1 AND VstupVytah.IN.DvereVytahuZatvorene_MS2;
            
			IF SC_VstupVytah.IdleTime.Q THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 110;
			END_IF	
		
		110:
			SC_VstupVytah.StepName:='110 - Automaticky Rezim - presuvam vytah do hornej pozicie vyvazania';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
		
			VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
			VstupVytah.PAR.Zdvih_ZadanaRychlost:= 50;
			VstupVytah.PAR.Zdvih_ZadanaPozicia:= RemPremenne.VstupVytah_PozVyvazania;
						
			
			IF NOT SC_VstupVytah.Switch1 AND SC_OvlMenica.Step = 1 THEN
				Zdvih_POLOHUJ:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
		
			IF VstupVytah.STAV.VytahNapolohovany THEN
				VstupVytah.STAV.VytahNapolohovany:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 111;
			ELSIF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;	
			ELSIF VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
				Alarmy[47]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;	
			END_IF	
		
			
		111:
			SC_VstupVytah.StepName:='111 - Automaticky Rezim - kontrola pritomnosti paletky';
			SC_VstupVytah.IdleTime.PT:= T#200ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
			
			IF VstupVytah.IN.PritomnostPaletky_IS3 THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 113;
			ELSE
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 112;
			END_IF	
					
			
		112:
			SC_VstupVytah.StepName:='112 - Automaticky Rezim - hladanie paletky na dopravniku vytahu';
			SC_VstupVytah.IdleTime.PT:= T#5s;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
			
			
			
			IF NOT SC_VstupVytah.Switch1 THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= TRUE;
				SC_VstupVytah.IdleTime.IN:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
			
			IF VstupVytah.IN.PritomnostPaletky_IS3 THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 111;
			ELSIF SC_VstupVytah.IdleTime.Q THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 100;
			END_IF	
			
			
			
			
			
		113:
			SC_VstupVytah.StepName:='113 - Automaticky Rezim - citam cislo paletky a priradujem index paletky';
			SC_VstupVytah.IdleTime.PT:= T#20ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
			
			SC_VstupVytah.IdleTime.IN:= RFID_Hlava_1.STAV.PritomnostCipu;
			
			IF SC_VstupVytah.IdleTime.Q THEN
				IF RFID_Hlava_1.PAR.PrecitaneCisloPaletky <> '' AND RFID_Hlava_1.PAR.PrecitanyTypPaletky <> '' THEN
					i:=  STRING_TO_USINT(RFID_Hlava_1.PAR.PrecitaneCisloPaletky);
					SC_VstupVytah.ResetStep:= TRUE;
					SC_VstupVytah.Step:= 115;
				ELSE
					Alarmy[60]:= TRUE;
					PoruchaVstupnehoVytahu:= TRUE;
					SC_VstupVytah.ResetStep:= TRUE;
					SC_VstupVytah.Step:= 0;	
				END_IF	
			END_IF	
		
			
			
			
		115:
			SC_VstupVytah.StepName:='115 - Automaticky Rezim - kontrolujem paletku a zvoleny typ paletky pre aktualny model,vyplnam udaje paletky';
			SC_VstupVytah.IdleTime.PT:= T#200ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
			
			IF Linka.PAR.Zvoleny_TypPaletky = RFID_Hlava_1.PAR.PrecitanyTypPaletky THEN
				Paletka[i].CisloPaletky:= RFID_Hlava_1.PAR.PrecitaneCisloPaletky;
				Paletka[i].TypPaletky:= Linka.PAR.Zvoleny_TypPaletky;		
				Paletka[i].NazovModelu:= Linka.PAR.Zvoleny_MODEL;		
				Paletka[i].CisloLOT:= Linka.PAR.Zvoleny_LOT;
				Paletka[i].Robot_CisloProgramu:= Linka.PAR.Zvolene_CisloProgramuRobota;
				Paletka[i].Kamera_CisloProgramu_QRkod:= Linka.PAR.Zvolene_KamCisloProg_QRkod;
				Paletka[i].Kamera_CisloProgramu_DMkod:= Linka.PAR.Zvolene_KamCisloProg_DMkod;
				Paletka[i].NazovPaletky:= '';
				brsstrcat(ADR(Paletka[i].NazovPaletky),ADR(Paletka[i].CisloPaletky));
				brsstrcat(ADR(Paletka[i].NazovPaletky),ADR('_'));
				brsstrcat(ADR(Paletka[i].NazovPaletky),ADR(Paletka[i].TypPaletky));
				Paletka[i].ReturnProcessName:= '';
				Paletka[i].TypVyroby:= '';
				Paletka[i].StavPaletky:= 'OK';
				Paletka[i].Cistenie_DONE:= FALSE;
				Paletka[i].StavCistenia:= '';
				Paletka[i].NalepenieEtikety_DONE:= FALSE;
				Paletka[i].StavNalepeniaEtikety:= '';
				Paletka[i].InternySerialNumber:= '';
				Paletka[i].ZakaznickeCislo:= '';
				Paletka[i].PrecitaneZnakyZakaznickehoDMkodu:= '';
				Paletka[i].StavCitania_InternehoQRkodu:= '';
				Paletka[i].StavCitania_ZakaznickehoDMkodu:= '';
				Paletka[i].StavCitania_KontrolaZnakov:= '';
				Paletka[i].StavKontrolyBielehoPaternu:= '';
				Paletka[i].StavPorovnaniaDMkoduZoServerom:= '';
				Paletka[i].StavKomunikacie_DONE:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 120;
			ELSIF Linka.Rezim_Priechodny THEN
				Paletka[i].StavPaletky:= 'PR';
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 120;
			ELSE
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 118;
			END_IF	
			
				
		118:
			SC_VstupVytah.StepName:='118 - Automaticky Rezim - cakam na vymenu zlej paletky a potvrdenie bannerom';
			SC_VstupVytah.IdleTime.PT:= T#2s;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
			
			Vizu.ZobrazHlasenie_NespravTypPaletky:= 0;
			
			IF NOT Blikac500ms THEN
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= TRUE;
			ELSE	
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
			END_IF	
			
			IF VstupVytah.KoniecCyklu THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			ELSIF Safety.STAV.BarieraVstupVytahu_AKTIVNA AND VstupVytah.IN.BannerPotvrdeny_IOS1 THEN
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				Vizu.ZobrazHlasenie_NespravTypPaletky:= 1;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 100;
			ELSIF Safety.STAV.BarieraVstupVytahu_AKTIVNA AND NOT VstupVytah.IN.PritomnostPaletky_IS3 THEN
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				Vizu.ZobrazHlasenie_NespravTypPaletky:= 1;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 100;
			END_IF	
		
				
			
		120:
			SC_VstupVytah.StepName:='120 - Automaticky Rezim - cakam na vlozenie kusu a potvrdenie banerom alebo aktivnu barieru vstupneho vytahu a vyvezenie na stoper pred cistenim';
			SC_VstupVytah.IdleTime.PT:= T#2s;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
			
			SC_VstupVytah.IdleTime.IN:= VstupVytah.IN.PritomnostPaletky_IS3 AND (VstupVytah.IN.PritomnostProduktu_OS2 OR Linka.Rezim_Priechodny) AND Safety.STAV.BarieraVstupVytahu_AKTIVNA;
		
			IF VstupVytah.IN.BannerPotvrdeny_IOS1 AND NOT Linka.Rezim_Priechodny AND VstupVytah.IN.PritomnostProduktu_OS2 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= TRUE;
			ELSIF VstupVytah.IN.BannerPotvrdeny_IOS1 AND Linka.Rezim_Priechodny AND NOT VstupVytah.IN.PritomnostProduktu_OS2 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= TRUE;	
			END_IF	
			
			IF VstupVytah.STAV.ObsluhaPotvrdilaBanner THEN
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
			ELSE
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= TRUE;
			END_IF	
		
			IF VstupVytah.KoniecCyklu THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			ELSIF Linka.Rezim_Priechodny AND VstupVytah.IN.PritomnostPaletky_IS3 AND NOT VstupVytah.IN.PritomnostProduktu_OS2 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA AND VstupVytah.STAV.ObsluhaPotvrdilaBanner AND StoperPredCistenim.STAV.PoINIT AND NOT StoperPredCistenim.IN.PritomnostPaletky_IS4 AND NOT StoperPredCistenim.OUT.StoperZASUN_YV005 THEN
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 130;
			ELSIF Linka.Rezim_Priechodny AND VstupVytah.IN.PritomnostPaletky_IS3 AND NOT VstupVytah.IN.PritomnostProduktu_OS2 AND NOT VstupVytah_Banner_AKTIVNY AND SC_VstupVytah.IdleTime.Q AND StoperPredCistenim.STAV.PoINIT AND NOT StoperPredCistenim.IN.PritomnostPaletky_IS4 AND NOT StoperPredCistenim.OUT.StoperZASUN_YV005 THEN
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 130;	
			ELSIF NOT Linka.Rezim_Priechodny AND VstupVytah.IN.PritomnostPaletky_IS3 AND VstupVytah.IN.PritomnostProduktu_OS2 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA AND VstupVytah.STAV.ObsluhaPotvrdilaBanner AND StoperPredCistenim.STAV.PoINIT AND NOT StoperPredCistenim.IN.PritomnostPaletky_IS4 AND NOT StoperPredCistenim.OUT.StoperZASUN_YV005 THEN
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 130;
			ELSIF NOT Linka.Rezim_Priechodny AND VstupVytah.IN.PritomnostPaletky_IS3 AND VstupVytah.IN.PritomnostProduktu_OS2 AND NOT VstupVytah_Banner_AKTIVNY AND SC_VstupVytah.IdleTime.Q AND StoperPredCistenim.STAV.PoINIT AND NOT StoperPredCistenim.IN.PritomnostPaletky_IS4 AND NOT StoperPredCistenim.OUT.StoperZASUN_YV005 THEN
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= TRUE;
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 130;
			ELSIF NOT VstupVytah.IN.PritomnostPaletky_IS3 AND Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 112;
			END_IF	
		
	
		
		
		130:
			SC_VstupVytah.StepName:='130 - Automaticky Rezim - otvorenie dveri vytahu';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#1s;
		
			SC_VstupVytah.AlarmTime.IN:= NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA;
			
			IF NOT SC_VstupVytah.Switch1 THEN
				Dvere_OTVOR:= TRUE;	
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
			
			IF VstupVytah.IN.DvereVytahuOtvorene_MS1 THEN
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 138;
			ELSIF SC_VstupVytah.AlarmTime.Q THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;		
			END_IF	
		
		
		138:
			SC_VstupVytah.StepName:='125 - Automaticky Rezim - vyvezenie paletky na stoper pred cistenim';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
		
			IF NOT SC_VstupVytah.Switch1 THEN
				VstupVytah.OUT.Dopravnik_ChodVPRED_ELR1:= TRUE;
				SC_VstupVytah.AlarmTime.IN:= TRUE;
				VstupVytah.STAV.PrebiehaVyvazaniePaletky:= TRUE;
				VstupnyVytah_Statistika.IN.START_MeraniaCasu:= TRUE;
				VstupnyVytah_Statistika.IN.ZAPIS_MeraniaCasu:= TRUE;
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
		
			IF NOT VstupVytah.IN.PritomnostPaletky_IS3 AND NOT VstupVytah.IN.PrechodDopravnikaVytahu_OS1 AND StoperPredCistenim.IN.PritomnostPaletky_IS4 THEN
				VstupVytah.OUT.Dopravnik_ChodVPRED_ELR1:= FALSE;
				VstupVytah.STAV.PrebiehaVyvazaniePaletky:= FALSE;
				VstupVytah.OUT.Banner_CervenaLED_IOS1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 140;
			ELSIF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			ELSIF SC_VstupVytah.AlarmTime.Q THEN
				Alarmy[48]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;
			END_IF	
		
		140:
			SC_VstupVytah.StepName:='140 - Automaticky Rezim - zatvorenie dveri vytahu';
			SC_VstupVytah.IdleTime.PT:= T#500ms;
			SC_VstupVytah.AlarmTime.PT:= T#10s;
		
			IF NOT SC_VstupVytah.Switch1 THEN
				Dvere_ZATVOR:= TRUE;	
				SC_VstupVytah.Switch1:= TRUE;
			END_IF
			
			IF VstupVytah.IN.DvereVytahuZatvorene_MS2 THEN
				VstupVytah.STAV.ObsluhaPotvrdilaBanner:= FALSE;
				VstupVytah.OUT.Banner_ZelenaLED_IOS1:= FALSE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 100;
			ELSIF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
				Alarmy[46]:= TRUE;
				PoruchaVstupnehoVytahu:= TRUE;
				SC_VstupVytah.ResetStep:= TRUE;
				SC_VstupVytah.Step:= 0;		
			END_IF
		
	
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_VstupVytah.StepName:='700 - Manualny Rezim';
			SC_VstupVytah.IdleTime.PT:= T#8s;
			SC_VstupVytah.AlarmTime.PT:= T#5s;
		
			//Ovládanie dopravníka//
			IF VstupVytah.RR_Dopravnik_VPRED THEN
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
				VstupVytah.OUT.Dopravnik_ChodVPRED_ELR1:= TRUE;
			ELSIF VstupVytah.RR_Dopravnik_VZAD THEN	
				VstupVytah.OUT.Dopravnik_ChodVPRED_ELR1:= FALSE;
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= TRUE;
			ELSE
				VstupVytah.OUT.Dopravnik_ChodVPRED_ELR1:= FALSE;
				VstupVytah.OUT.Dopravnik_ChodVZAD_ELR1:= FALSE;
			END_IF	
		
			
		
		
	END_CASE
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM


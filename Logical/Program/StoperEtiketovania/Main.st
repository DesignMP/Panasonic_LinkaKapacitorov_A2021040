
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie podprogramov//
	OvlCentrovacky;
	OvlCitackyRFID;
	OvlTlaciarne;
		
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_StoperEtiketovania);
	
	//Volanie funkèného bloku komunikácie Panasonic//
	KOM_Panasonic();
	
	
	//Reset sekcie //
	IF StoperEtiketovania.Reset THEN
		SC_StoperEtiketovania.Step:= 0;
		StoperEtiketovania.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		SC_StoperEtiketovania.Step:= 0;
	END_IF	
	

	//Status Tlaèiareò zaaretovaná//
	StoperEtiketovania.STAV.TlaciarenZaaretovana:= StoperEtiketovania.IN.SuflikTlaciarne_LS_IS23 AND StoperEtiketovania.IN.SuflikTlaciarne_PS_IS22;
	
	//Zrušenie príznaku prebieha vyvezenie paletky//
	IF StoperEtiketovania.STAV.PrebiehaVyvazaniePaletky AND StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 THEN
		StoperEtiketovania.STAV.PrebiehaVyvazaniePaletky:= FALSE;
	END_IF	
	
	CASE SC_StoperEtiketovania.Step OF 
	
		0:
			SC_StoperEtiketovania.StepName:='0 - Nulovanie';
			StoperEtiketovania.Automat:= FALSE;
			StoperEtiketovania.KoniecCyklu:= FALSE;
			StoperEtiketovania.Manual:= FALSE;
			StoperEtiketovania.STAV.PoINIT:= FALSE;
			StoperEtiketovania.OUT.StoperZASUN_YV007:= FALSE;
			SC_OvlCentrovacky.Step:= 0;
			Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety:= FALSE;
			Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
			Robot.KOM_OUT.PresunDoPoziceKontrolyEtikety:= FALSE;
			Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo:= FALSE;
			Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku:= FALSE;
			Robot.KOM_OUT.NalepEtiketu:= FALSE;
			Robot.KOM_OUT.CitanieStitkuUkoncene:= FALSE;
			StoperEtiketovania.OUT.Tlaciaren_VytlacEtiketu:= FALSE;
			StoperEtiketovania.OUT.Tlaciaren_VytlacZnovaEtiketu:= FALSE;
			Kamera.STAV.Results_READY:= FALSE;
			Kamera.CMD.Triger:= FALSE;
			IF Kamera.STAV.AktualneCisloProgramu <> 50 THEN
				Kamera.PAR.ZadaneCisloProgramu:= 50;
			END_IF	
			StoperEtiketovania.STAV.PrebiehaVyvazaniePaletky:= FALSE;
			StoperEtiketovania.RR_VytlacEtiketu:= FALSE;
			Vizu.ZobrazHlasenie_ZaaretujTlaciaren:= 1;
			Vizu.ZobrazHlas_ZatvorSerDvereTlac:= 1;
			Vizu.ZobrazHlasenie_TlaciarenOffline:= 1;
			StoperDopravNG.OUT.NatlakujTlmicPaletky_YV008:= FALSE;
			NacitanieKorekcii_DONE:= FALSE;
			StoperEtiketovania.STAV.Etiketovanie_BUSY:= FALSE;
			StoperEtiketovania_Statistika.IN.START_MeraniaCasu:= FALSE;
			KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
			KOM_Panasonic.Server_IN.VytlacEtiketu_RucnyRezim:= FALSE;
			KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
			KOM_Panasonic.Server_IN.Blowing_Error:= FALSE;
			KOM_Panasonic.Server_IN.DMcode_Reading_Error:= FALSE;
			KOM_Panasonic.Server_IN.QRcode_Reading_Error:= FALSE;
			KOM_Panasonic.Server_IN.RFID_Reading_Error:= FALSE;
			KOM_Panasonic.Server_IN.Text_Reading_Error:= FALSE;
			KOM_Panasonic.Server_IN.CommandNumber:= 0;
			KOM_Panasonic.Server_IN.RezimBezTlaceEtikety:= FALSE;
						
			IF Safety.STAV.ZonaCS_AKTIVNA AND Safety.STAV.ZonaBunky_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND Linka.STAV.Hardware_OK THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 1;
			END_IF
	
		1:
			SC_StoperEtiketovania.StepName:='1 - Cakam na spustenie vyroby';
			StoperEtiketovania.KoniecCyklu:= FALSE;
			IF StoperEtiketovania.Automat THEN
				SC_StoperEtiketovania.Step:= 2;
			ELSIF StoperEtiketovania.Manual THEN
				SC_StoperEtiketovania.Step:= 700;
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
			
		2:
			SC_StoperEtiketovania.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_StoperEtiketovania.IdleTime.PT:= T#4s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
									
			IF DopravBunky.STAV.PoINIT AND Robot.STAV.PoINIT THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 10;
			END_IF
		
		10:
			SC_StoperEtiketovania.StepName:='10 - Inicializacia - zasunutie centrovacky';
			SC_StoperEtiketovania.IdleTime.PT:= T#4s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Centrovacku_ZASUN:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
		
			IF StoperEtiketovania.IN.Centrovanie_SpodnaPoloha_IS17 THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 13;
			END_IF	
		
		13:
			SC_StoperEtiketovania.StepName:='13 - Inicializacia - hladanie paletky';
			SC_StoperEtiketovania.IdleTime.PT:= T#5s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			SC_StoperEtiketovania.IdleTime.IN:= TRUE;
	
			IF StoperEtiketovania.IN.PritomnostPaletky_IS16 THEN
				StoperEtiketovania.STAV.PoINIT:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 100;		
			ELSIF SC_StoperEtiketovania.IdleTime.Q THEN
				StoperEtiketovania.STAV.PoINIT:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 100;
			END_IF
		
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_StoperEtiketovania.StepName:='100 - Automaticky Rezim - cakam na príchod paletky na stoper';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			IF Linka.Rezim_BezTlaceEtikety THEN
				KOM_Panasonic.Server_IN.RezimBezTlaceEtikety:= TRUE;
			ELSE	
				KOM_Panasonic.Server_IN.RezimBezTlaceEtikety:= FALSE;
			END_IF	
			
			
			
			SC_StoperEtiketovania.IdleTime.IN:= StoperEtiketovania.IN.PritomnostPaletky_IS16;
			
			IF StoperEtiketovania.KoniecCyklu THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			ELSIF SC_StoperEtiketovania.IdleTime.Q THEN
				StoperEtiketovania_Statistika.IN.START_MeraniaCasu:= TRUE;
				StoperEtiketovania_Statistika.IN.ZAPIS_MeraniaCasu:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 103;
			END_IF
		
		103:
			SC_StoperEtiketovania.StepName:='103 - Automaticky Rezim - citam cislo paletky';
			SC_StoperEtiketovania.IdleTime.PT:= T#0ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#10s;
			
				
			
			SC_StoperEtiketovania.IdleTime.IN:= RFID_Hlava_2.STAV.PritomnostCipu;
			
			IF SC_StoperEtiketovania.IdleTime.Q THEN
				IF RFID_Hlava_2.PAR.PrecitaneCisloPaletky <> '' THEN
					i:=  STRING_TO_USINT(RFID_Hlava_2.PAR.PrecitaneCisloPaletky);
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 105;
				ELSE
					Alarmy[61]:= TRUE;
					PoruchaBunky:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 0;
				END_IF	
			END_IF	
			
			
			
		105:
			SC_StoperEtiketovania.StepName:='108 - Automaticky Rezim - nacitanie offsetov pozicie lepenia zakaznickej etikety a cisla programu pre robot';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#10s;
			
			OffsetRobota_NazovModelu:= Paletka[i].NazovModelu;
			Robot.KOM_OUT.CisloProduktu:= Paletka[i].Robot_CisloProgramu;
			Kamera.PAR.ZadaneCisloProgramu:= Paletka[i].Kamera_CisloProgramu_QRkod;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				NacitajKorekcieRobota:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
						
			IF NacitanieKorekcii_DONE THEN
				NacitanieKorekcii_DONE:= FALSE;
				IF Linka.PAR.Zvolena_PozLepenia_OffsetX <> 0 THEN
					IF Linka.PAR.Zvolena_PozLepenia_OffsetX > 0 THEN
						Robot.KOM_OUT.LepenieStitku_OffsetX:= REAL_TO_USINT(Linka.PAR.Zvolena_PozLepenia_OffsetX * 10);
						Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetX:= FALSE;
					ELSIF Linka.PAR.Zvolena_PozLepenia_OffsetX < 0 THEN
						Robot.KOM_OUT.LepenieStitku_OffsetX:= REAL_TO_USINT(ABS(Linka.PAR.Zvolena_PozLepenia_OffsetX) * 10);
						Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetX:= TRUE;
					END_IF	
				ELSE
					Robot.KOM_OUT.LepenieStitku_OffsetX:= 0;
					Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetX:= FALSE;
				END_IF
				IF Linka.PAR.Zvolena_PozLepenia_OffsetY <> 0 THEN
					IF Linka.PAR.Zvolena_PozLepenia_OffsetY > 0 THEN
						Robot.KOM_OUT.LepenieStitku_OffsetY:= REAL_TO_USINT(Linka.PAR.Zvolena_PozLepenia_OffsetY * 10);
						Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetY:= FALSE;
					ELSIF Linka.PAR.Zvolena_PozLepenia_OffsetY < 0 THEN
						Robot.KOM_OUT.LepenieStitku_OffsetY:= REAL_TO_USINT(ABS(Linka.PAR.Zvolena_PozLepenia_OffsetY) * 10);
						Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetY:= TRUE;
					END_IF
				ELSE
					Robot.KOM_OUT.LepenieStitku_OffsetY:= 0;
					Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetY:= FALSE;
				END_IF	
				IF Linka.PAR.Zvolena_PozLepenia_OffsetZ <> 0 THEN
					IF Linka.PAR.Zvolena_PozLepenia_OffsetZ > 0 THEN
						Robot.KOM_OUT.LepenieStitku_OffsetZ:= REAL_TO_USINT(Linka.PAR.Zvolena_PozLepenia_OffsetZ * 10);
						Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetZ:= FALSE;
					ELSIF Linka.PAR.Zvolena_PozLepenia_OffsetZ < 0 THEN
						Robot.KOM_OUT.LepenieStitku_OffsetZ:= REAL_TO_USINT(ABS(Linka.PAR.Zvolena_PozLepenia_OffsetZ) * 10);
						Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetZ:= TRUE;
					END_IF
				ELSE
					Robot.KOM_OUT.LepenieStitku_OffsetZ:= 0;
					Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetZ:= FALSE;
				END_IF
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 110;	
			END_IF	
			
			
			
			
		110:
			SC_StoperEtiketovania.StepName:='110 - Automaticky Rezim - zacentrovanie paletky';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Centrovacku_VYSUN:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
		
			IF StoperEtiketovania.IN.Centrovanie_HornaPoloha_IS18 THEN
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 115;
				ELSE	
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 113;
				END_IF	
			END_IF	
		
			
		113:
			SC_StoperEtiketovania.StepName:='113 - Automaticky Rezim - kontrola stavu komunikacie a paletky';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			IF Paletka[i].StavKomunikacie_DONE THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 240;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 0 AND Paletka[i].StavPaletky = 'NG' THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 240;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 0 THEN  //Zaèiatok 
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 115;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 10 THEN //Naèítanie internej etikety
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 140;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 20 THEN //Vytlaèenie štítku z tlaèiarne
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 140;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 30 THEN //Nalepenie štítku
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 180;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 40 THEN //Naèítanie zákaznickej etikety
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 180;
			ELSIF KOM_Panasonic.Server_OUT.LastCommandNumber = 50 THEN //Komunikacia zo serverom ukonèená
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 240;
			END_IF	
			
				
		115:
			SC_StoperEtiketovania.StepName:='115 - Automaticky Rezim - presun robota na poziciu precitania interneho stitku';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;	
			
			IF NOT StoperDopravNG.STAV.DopravnikNG_BUSY AND NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.CisloProduktu:= Paletka[i].Robot_CisloProgramu;
				StoperEtiketovania.STAV.Etiketovanie_BUSY:= TRUE;
				Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 118;
			END_IF		
			
			
				
		
		118:
			SC_StoperEtiketovania.StepName:='118 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
                
			Kamera.STAV.Results_READY:= FALSE;
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena AND (Kamera.PAR.ZadaneCisloProgramu = Kamera.STAV.AktualneCisloProgramu) AND NOT Kamera.STAV.Results_READY THEN
				Kamera.STAV.Old_Hodnota_RUN_Counter:= Kamera.STAV.RUN_Counter;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 120;  
			END_IF 
		
			
				
		120:
			SC_StoperEtiketovania.StepName:='120 - Automaticky Rezim - nacitanie interného stitku';
			SC_StoperEtiketovania.IdleTime.PT:= T#5s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			
					
			IF NOT SC_StoperEtiketovania.Switch1 AND NOT Kamera.STAV.Results_READY AND Kamera.STAV.READY THEN
				Kamera.CMD.Triger:= TRUE;
				SC_StoperEtiketovania.IdleTime.IN:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
		
			IF NOT Kamera.STAV.READY THEN
				Alarmy[75]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			ELSIF NOT Kamera.CMD.Triger AND Kamera.STAV.Results_READY THEN
				Kamera.STAV.Results_READY:= FALSE;
			ELSIF Kamera.CMD.Triger AND Kamera.STAV.Results_READY AND (Kamera.STAV.Old_Hodnota_RUN_Counter <> Kamera.STAV.RUN_Counter) THEN
				PocetOpatovnychTrigrov:= 0;
				Kamera.STAV.Results_READY:= FALSE;
				Kamera.CMD.Triger:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 122;
			ELSIF SC_StoperEtiketovania.IdleTime.Q AND NOT Kamera.STAV.Results_READY THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 121;
			END_IF
		
		
		121:
			SC_StoperEtiketovania.StepName:='121 - Automaticky Rezim - cakam na opatovny triger kamery';
			SC_StoperEtiketovania.IdleTime.PT:= T#2s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;	
			
			Kamera.STAV.Results_READY:= FALSE;
			Kamera.CMD.Triger:= FALSE;
			Kamera.STAV.Old_Hodnota_RUN_Counter:= Kamera.STAV.RUN_Counter;
			SC_StoperEtiketovania.IdleTime.IN:= TRUE;
			
			IF SC_StoperEtiketovania.IdleTime.Q AND PocetOpatovnychTrigrov <= 3 THEN
				PocetOpatovnychTrigrov:= PocetOpatovnychTrigrov + 1;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 120;
			ELSIF SC_StoperEtiketovania.IdleTime.Q AND PocetOpatovnychTrigrov > 3 THEN
				Alarmy[75]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			END_IF	
			
			
			
			
		122:
			SC_StoperEtiketovania.StepName:='122 - Automaticky Rezim - odsunutie robota po precitani interneho stitku';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 123;
			END_IF
			
			
		123:	
			SC_StoperEtiketovania.StepName:='123 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 125;  
			END_IF 	
			
			
			
			
			
		125:
			SC_StoperEtiketovania.StepName:='125 - Automaticky Rezim - kontrola kamerovych vysledkov citania interneho QR kodu';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;	
			
			IF Kamera.RESULT.InternaEtiketa_QRkod_OK AND Kamera.RESULT.InternaEtiketa_ZnakyQRkodu <> 'Error' THEN
				Paletka[i].StavCitania_InternehoQRkodu:= 'OK';
				Paletka[i].InternySerialNumber:= Kamera.RESULT.InternaEtiketa_ZnakyQRkodu;
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 145;
				ELSE	
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 133;
				END_IF	
			ELSIF NOT Kamera.RESULT.InternaEtiketa_QRkod_OK THEN
				Paletka[i].StavCitania_InternehoQRkodu:= 'NG';
				Paletka[i].StavPaletky:= 'NG';
				Paletka[i].ReturnProcessName:= 'Neprecitany interny QR kod';
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 230; 
			END_IF	
				
				
			
		
		133:
			SC_StoperEtiketovania.StepName:='133 - Automaticky Rezim - odoslanie serioveho cisla internej etikety, cisla paletky a stavu cistenia na server Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#100ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;			
				
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= Paletka[i].NazovPaletky;
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= Paletka[i].InternySerialNumber;
			KOM_Panasonic.Server_IN.Cislo_LOTU:= Paletka[i].CisloLOT;
			
			Kamera.PAR.ZadaneCisloProgramu:= Paletka[i].Kamera_CisloProgramu_DMkod;
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY THEN
				IF Paletka[i].StavCistenia = 'OK' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 10;
					KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 135;
				ELSIF Paletka[i].StavCistenia = 'NG' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 10;
					KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 135;
				END_IF	
			END_IF	
				
			
		
		
		135:
			SC_StoperEtiketovania.StepName:='135 - Automaticky Rezim - cakam na odpoved servera Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#100ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;	
			
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 10 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					Paletka[i].ZakaznickeCislo:= KOM_Panasonic.Server_OUT.SerialNumber_ZakaznickaEtiketa;
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					IF Linka.Rezim_BezTlaceEtikety THEN
						SC_StoperEtiketovania.ResetStep:= TRUE;
						SC_StoperEtiketovania.Step:= 190; 
					ELSE
						SC_StoperEtiketovania.ResetStep:= TRUE;
						SC_StoperEtiketovania.Step:= 140;  
					END_IF	
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					Paletka[i].ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					Paletka[i].StavPaletky:= 'NG';
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				END_IF
			END_IF	
					
		
					
		
		
		
		140:
			SC_StoperEtiketovania.StepName:='140 - Automaticky Rezim - odoslanie poziadavky na vytlacenie etikety na server Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= Paletka[i].NazovPaletky;
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= Paletka[i].InternySerialNumber;
			KOM_Panasonic.Server_IN.Cislo_LOTU:= Paletka[i].CisloLOT;
			
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY (*AND STEP*) THEN
				STEP:= FALSE;
				KOM_Panasonic.Server_IN.CommandNumber:= 20;
				KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
				KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 145; 
			END_IF	
		
		
			
		145:
			SC_StoperEtiketovania.StepName:='145 - Automaticky Rezim - presun robota na poziciu odobratia etikety z tlaciarne';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			Kamera.PAR.ZadaneCisloProgramu:= Paletka[i].Kamera_CisloProgramu_DMkod;
			
			IF StoperEtiketovania.STAV.TlaciarenZaaretovana AND NOT StoperEtiketovania.IN.Tlaciaren_Offline AND NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety:= TRUE;
				IF Linka.Rezim_BezKomunikacie THEN
					StoperEtiketovania.OUT.Tlaciaren_VytlacEtiketu:= TRUE;
				END_IF	
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF	
				
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 148;
			END_IF	
		
	
		
		148:
			SC_StoperEtiketovania.StepName:='148 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 155;
				ELSE	
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 150; 
				END_IF	
			END_IF 	
			
				
			
			
		150:
			SC_StoperEtiketovania.StepName:='150 - Automaticky Rezim - cakam na odpoved servera Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
				
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 20 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 155;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					Paletka[i].ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					Paletka[i].StavPaletky:= 'NG';
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				END_IF
			END_IF		
			
					
			
		155:
			SC_StoperEtiketovania.StepName:='150 - Automaticky Rezim - kontrola vytlacenia etikety';
			SC_StoperEtiketovania.IdleTime.PT:= T#500ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#20s;
			
			SC_StoperEtiketovania.AlarmTime.IN:= TRUE;
			SC_StoperEtiketovania.IdleTime.IN:= Robot.IN.PrisatieEtikety_OK_S1;
			
			IF SC_StoperEtiketovania.IdleTime.Q THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 160;
			ELSIF SC_StoperEtiketovania.AlarmTime.Q THEN
				Paletka[i].StavNalepeniaEtikety:= 'NG';
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				ELSE	
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 170;
				END_IF	
			END_IF	
		
			
			
			
		160:
			SC_StoperEtiketovania.StepName:='160 - Automaticky Rezim - nalepenie etikety na produkt';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.NalepEtiketu:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF	
				
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.NalepEtiketu:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 165;
			END_IF	
				
		
				
		
		165:
			SC_StoperEtiketovania.StepName:='165 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Paletka[i].StavNalepeniaEtikety:= 'OK';
				Paletka[i].NalepenieEtikety_DONE:= TRUE;
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 190; 
				ELSE
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 170;
				END_IF	
			END_IF 
		
			
		170:
			SC_StoperEtiketovania.StepName:='170 - Automaticky Rezim - odoslanie stavu nalepenia etikety na server Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= Paletka[i].NazovPaletky;
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= Paletka[i].InternySerialNumber;
			KOM_Panasonic.Server_IN.Cislo_LOTU:= Paletka[i].CisloLOT;
			
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY (*AND STEP*) THEN
				STEP:= FALSE;
				IF Paletka[i].StavNalepeniaEtikety = 'OK' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 30;
					KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 173; 
				ELSIF Paletka[i].StavNalepeniaEtikety = 'NG' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 30;
					KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 173;
				END_IF	
			END_IF	
			
			
		173:
			SC_StoperEtiketovania.StepName:='173 - Automaticky Rezim - cakam na odpoved servera Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
				
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 30 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					Paletka[i].NalepenieEtikety_DONE:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 190;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					Paletka[i].ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					Paletka[i].StavPaletky:= 'NG';
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				END_IF
			END_IF		
			
		
		180:
			SC_StoperEtiketovania.StepName:='180 - Automaticky Rezim - presun robota na poziciu kamerovej kontroly zakaznickej etikety s pozicie mutingu';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			Kamera.PAR.ZadaneCisloProgramu:= Paletka[i].Kamera_CisloProgramu_DMkod;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 195;
			END_IF		
			
			
		
			
			
		
		190:
			SC_StoperEtiketovania.StepName:='190 - Automaticky Rezim - presun robota na poziciu kamerovej kontroly zakaznickej etikety';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			Kamera.PAR.ZadaneCisloProgramu:= Paletka[i].Kamera_CisloProgramu_DMkod;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.PresunDoPoziceKontrolyEtikety:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPoziceKontrolyEtikety:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 195;
			END_IF		
		
	
			
		
		195:
			SC_StoperEtiketovania.StepName:='195 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
              
			Kamera.STAV.Results_READY:= FALSE;
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena AND (Kamera.PAR.ZadaneCisloProgramu = Kamera.STAV.AktualneCisloProgramu) AND NOT Kamera.STAV.Results_READY THEN
				Kamera.STAV.Old_Hodnota_RUN_Counter:= Kamera.STAV.RUN_Counter;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 200;
			END_IF 
		
		
		200:
			SC_StoperEtiketovania.StepName:='200 - Automaticky Rezim - kamerova kontrola zakaznickej etikety';
			SC_StoperEtiketovania.IdleTime.PT:= T#5s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
					
			
			IF NOT SC_StoperEtiketovania.Switch1 AND NOT Kamera.STAV.Results_READY AND Kamera.STAV.READY THEN
				Kamera.CMD.Triger:= TRUE;
				SC_StoperEtiketovania.IdleTime.IN:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
		
			IF NOT Kamera.STAV.READY THEN
				Alarmy[75]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			ELSIF NOT Kamera.CMD.Triger AND Kamera.STAV.Results_READY THEN
				Kamera.STAV.Results_READY:= FALSE;
			ELSIF Kamera.CMD.Triger AND Kamera.STAV.Results_READY AND (Kamera.STAV.Old_Hodnota_RUN_Counter <> Kamera.STAV.RUN_Counter) THEN
				Kamera.STAV.Results_READY:= FALSE;
				Kamera.CMD.Triger:= FALSE;
				PocetOpatovnychTrigrov:= 0;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 205;
			ELSIF SC_StoperEtiketovania.IdleTime.Q AND NOT Kamera.STAV.Results_READY THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 201;
			END_IF
			
	
		201:
			SC_StoperEtiketovania.StepName:='201 - Automaticky Rezim - cakam na opatovny triger kamery';
			SC_StoperEtiketovania.IdleTime.PT:= T#2s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;	
			
			Kamera.STAV.Results_READY:= FALSE;
			Kamera.CMD.Triger:= FALSE;
			Kamera.STAV.Old_Hodnota_RUN_Counter:= Kamera.STAV.RUN_Counter;
			SC_StoperEtiketovania.IdleTime.IN:= TRUE;
			
			IF SC_StoperEtiketovania.IdleTime.Q AND PocetOpatovnychTrigrov <= 3 THEN
				PocetOpatovnychTrigrov:= PocetOpatovnychTrigrov + 1;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 200;
			ELSIF SC_StoperEtiketovania.IdleTime.Q AND PocetOpatovnychTrigrov > 3 THEN
				Alarmy[75]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			END_IF		
			
			
			
			
			
		205:
			SC_StoperEtiketovania.StepName:='205 - Automaticky Rezim - odsunutie robota po precitani zakaznickej etikety';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 208;
			END_IF
			
			
			
		208:	
			SC_StoperEtiketovania.StepName:='208 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Centrovacku_ZASUN:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 210;
			END_IF 		
			
	
			
				
			
			
		210:
			SC_StoperEtiketovania.StepName:='210 - Automaticky Rezim - kontrola precitania zakaznickeho DM kodu';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			IF Kamera.RESULT.ZakazEtiketa_DMkod_OK AND Kamera.RESULT.ZakazEtiketa_ZnakyDMkodu <> 'Error' THEN
				Paletka[i].PrecitaneZnakyZakaznickehoDMkodu:= Kamera.RESULT.ZakazEtiketa_ZnakyDMkodu;
				IF Paletka[i].ZakaznickeCislo = Paletka[i].PrecitaneZnakyZakaznickehoDMkodu THEN
					Paletka[i].StavCitania_ZakaznickehoDMkodu:= 'OK';
				ELSE
					Paletka[i].StavCitania_ZakaznickehoDMkodu:= 'NG';
					Paletka[i].StavPaletky:= 'NG';
				END_IF	
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 215;
			ELSIF NOT Kamera.RESULT.ZakazEtiketa_DMkod_OK THEN
				Paletka[i].StavCitania_ZakaznickehoDMkodu:= 'NG';
				Paletka[i].StavPaletky:= 'NG';
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 215;
			END_IF	
		
			
		215:
			SC_StoperEtiketovania.StepName:='215 - Automaticky Rezim - kontrola pritomnosti znakov na zakaznickej etikete';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			IF Kamera.RESULT.ZakazEtiketa_PritomnZnakov_OK THEN
				Paletka[i].StavCitania_KontrolaZnakov:= 'OK';
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 240;
				ELSE
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 220;
				END_IF
			ELSIF NOT Kamera.RESULT.ZakazEtiketa_PritomnZnakov_OK THEN
				Paletka[i].StavCitania_KontrolaZnakov:= 'NG';
				Paletka[i].StavPaletky:= 'NG';
				IF Linka.Rezim_BezKomunikacie THEN
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				ELSE
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 220;
				END_IF
			END_IF	
			
			
		
			
		220:
			SC_StoperEtiketovania.StepName:='220 - Automaticky Rezim - odoslanie stavu citania DM kodu zakaznickej etikety na server Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= Paletka[i].NazovPaletky;
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= Paletka[i].InternySerialNumber;
			KOM_Panasonic.Server_IN.Cislo_LOTU:= Paletka[i].CisloLOT;
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY (*AND STEP*) THEN
				STEP:= FALSE;
				IF Paletka[i].StavCitania_ZakaznickehoDMkodu = 'OK' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 40;
					KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 223; 
				ELSIF Paletka[i].StavCitania_ZakaznickehoDMkodu = 'NG' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 40;
					KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 223;
				END_IF	
			END_IF	
			
			
		223:
			SC_StoperEtiketovania.StepName:='223 - Automaticky Rezim - cakam na odpoved servera Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
				
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 40 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 225;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					Paletka[i].ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					Paletka[i].StavPaletky:= 'NG';
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				END_IF
			END_IF		
			
			
			
		225:
			SC_StoperEtiketovania.StepName:='225 - Automaticky Rezim - odoslanie stavu citania znakov zakaznickej etikety na server Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			KOM_Panasonic.Server_IN.NazovPaletky_RFID:= Paletka[i].NazovPaletky;
			KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= Paletka[i].InternySerialNumber;
			KOM_Panasonic.Server_IN.Cislo_LOTU:= Paletka[i].CisloLOT;
			
			IF NOT KOM_Panasonic.Server_OUT.DataForPLC_READY (*AND STEP*) THEN
				STEP:= FALSE;
				IF Paletka[i].StavCitania_KontrolaZnakov = 'OK' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 50;
					KOM_Panasonic.Server_IN.ProcessResult:= TRUE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 228; 
				ELSIF Paletka[i].StavCitania_KontrolaZnakov = 'NG' THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 50;
					KOM_Panasonic.Server_IN.ProcessResult:= FALSE;
					KOM_Panasonic.Server_IN.DataForServer_READY:= TRUE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 228;
				END_IF	
			END_IF	
			
			
		228:
			SC_StoperEtiketovania.StepName:='228 - Automaticky Rezim - cakam na odpoved servera Panasonic';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
				
			IF KOM_Panasonic.Server_OUT.DataForPLC_READY AND KOM_Panasonic.Server_OUT.LastCommandNumber = 50 THEN
				IF KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 240;
				ELSIF NOT KOM_Panasonic.Server_OUT.ContinueToNextProcess THEN
					Paletka[i].ReturnProcessName:= KOM_Panasonic.Server_OUT.ReturnProcessName;
					Paletka[i].StavPaletky:= 'NG';
					KOM_Panasonic.Server_IN.CommandNumber:= 0;
					KOM_Panasonic.Server_IN.DataForServer_READY:= FALSE;
					SC_StoperEtiketovania.ResetStep:= TRUE;
					SC_StoperEtiketovania.Step:= 230;
				END_IF
			END_IF	
			
		
			
			
		230:
			SC_StoperEtiketovania.StepName:='230 - Automaticky Rezim - presun robota do pozicie mutingu';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
			Paletka[i].StavKomunikacie_DONE:= TRUE;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 235;
			END_IF
			
			
		235:	
			SC_StoperEtiketovania.StepName:='235 - Automaticky Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
                
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena AND Safety.STAV.MutingRobota_AKTIVNY THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 240;  
			END_IF 			
			
			
			
			
				
			
		240:
			SC_StoperEtiketovania.StepName:='240 - Automaticky Rezim - odcentrovanie paletky';
			SC_StoperEtiketovania.IdleTime.PT:= T#200ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
			Kamera.PAR.ZadaneCisloProgramu:= Paletka[i].Kamera_CisloProgramu_QRkod;
			StoperEtiketovania.STAV.Etiketovanie_BUSY:= FALSE;
			Paletka[i].StavKomunikacie_DONE:= TRUE;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				Centrovacku_ZASUN:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF
		
			IF StoperEtiketovania.IN.Centrovanie_SpodnaPoloha_IS17 THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 250;
			END_IF
	
			
				
			
			
		
		250:
			SC_StoperEtiketovania.StepName:='250 - Automaticky Rezim - cakam na vyvezenie paletky na stoper dopravnika NG';
			SC_StoperEtiketovania.IdleTime.PT:= T#500ms;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
		
						
			IF StoperEtiketovania.KoniecCyklu THEN
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			ELSIF Paletka[i].StavPaletky = 'OK' AND SC_StoperDopravNG.Step = 100 AND StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 AND NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 AND NOT StoperDopravNG.STAV.ObsluhaPotvrdilaPaletkuNG AND NOT StoperDopravNG.STAV.DopravnikNG_BUSY THEN
				StoperEtiketovania.STAV.VyvazamPaletkuNG:= FALSE;
				PocetVyrobenychKusov_OK:= PocetVyrobenychKusov_OK + 1;
				CelkovyPocetVyrobenychKusov:= CelkovyPocetVyrobenychKusov + 1;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 255;
			ELSIF Paletka[i].StavPaletky = 'NG' AND SC_StoperDopravNG.Step = 100 AND StoperDopravNG.IN.Centrovanie_StrednaPoloha_IS20 AND NOT StoperDopravNG.IN.Stoper_PritomnostPaletky_IS15 AND (NOT StoperDopravNG.IN.Dopravnik_PritomnostPaletky_OS4 AND NOT StoperDopravNG.STAV.PaletkaNaKonciDopravnika_NG) AND NOT StoperDopravNG.STAV.DopravnikNG_BUSY THEN	
				StoperEtiketovania.STAV.VyvazamPaletkuNG:= TRUE;
				StoperEtiketovania.STAV.AlarmTextPaletkyNG:= Paletka[i].ReturnProcessName;
				PocetVyrobenychKusov_NG:= PocetVyrobenychKusov_NG + 1;
				CelkovyPocetVyrobenychKusov:= CelkovyPocetVyrobenychKusov + 1;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 255;
			END_IF	
		
		255:
			SC_StoperEtiketovania.StepName:='255 - Automaticky Rezim - vyvazam paletku na stoper dopravnika NG';
			SC_StoperEtiketovania.IdleTime.PT:= T#4s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#10s;
			
			IF NOT SC_StoperEtiketovania.Switch1 THEN
				StoperEtiketovania.OUT.StoperZASUN_YV007:= TRUE;
				StoperDopravNG.OUT.NatlakujTlmicPaletky_YV008:= TRUE;
				StoperEtiketovania.STAV.PrebiehaVyvazaniePaletky:= TRUE;
				SC_StoperEtiketovania.AlarmTime.IN:= TRUE;
				SC_StoperEtiketovania.Switch1:= TRUE;
			END_IF	
			
			IF NOT StoperEtiketovania.IN.PritomnostPaletky_IS16 THEN
				StoperEtiketovania.OUT.StoperZASUN_YV007:= FALSE;
				StoperDopravNG.OUT.NatlakujTlmicPaletky_YV008:= FALSE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 100;
			END_IF
			
			IF SC_StoperEtiketovania.AlarmTime.Q THEN
				Alarmy[56]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_StoperEtiketovania.ResetStep:= TRUE;
				SC_StoperEtiketovania.Step:= 0;
			END_IF
		
			//*******************************************************Manuálny režim*******************************************************************************//
		700:
			SC_StoperEtiketovania.StepName:='700 - Manualny Rezim';
			SC_StoperEtiketovania.IdleTime.PT:= T#8s;
			SC_StoperEtiketovania.AlarmTime.PT:= T#5s;
			
		
			//Vytlaèenie etikety//
			IF StoperEtiketovania.RR_VytlacEtiketu THEN
				IF NOT StoperEtiketovania.IN.Tlaciaren_Offline THEN
					CasVytlaceniaEtikety.IN:= TRUE;
					KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa:= '';
					strcat(ADR(KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa),ADR(StoperEtiketovania.PAR.TypPaletky_RucneVytlacEtikety));
					strcat(ADR(KOM_Panasonic.Server_IN.SerialNumber_InternaEtiketa),ADR('00000000000000000000000000'));
					KOM_Panasonic.Server_IN.VytlacEtiketu_RucnyRezim:= TRUE;
				END_IF
				StoperEtiketovania.RR_VytlacEtiketu:= FALSE;
			END_IF
			
			IF CasVytlaceniaEtikety.Q THEN
				KOM_Panasonic.Server_IN.VytlacEtiketu_RucnyRezim:= FALSE;
				CasVytlaceniaEtikety.IN:= FALSE;
			END_IF	
		
		
		
			CasVytlaceniaEtikety.PT:= T#1s;
			CasVytlaceniaEtikety();
					
					
			
		
	END_CASE	
			
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


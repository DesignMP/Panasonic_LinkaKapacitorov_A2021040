
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	KOM_Robot;
	KOM_Kamera;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Robot);
	
	
	
	//Reset sekcie //
	IF Robot.Reset THEN
		SC_Robot.Step:= 0;
		Robot.Reset:= FALSE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA  THEN
		SC_Robot.Step:= 0;
	ELSIF Robot.Automat AND (NOT Safety.STAV.BarieraDopravnikaNG_AKTIVNA AND NOT Safety.STAV.MutingRobota_AKTIVNY) THEN
		Alarmy[72]:= TRUE;
		SC_Robot.Step:= 0;
		SC_StoperEtiketovania.Step:= 0;
		PoruchaBunky:= TRUE;
	ELSIF Robot.Automat AND NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Alarmy[71]:= TRUE;
		SC_Robot.Step:= 0;
		SC_StoperEtiketovania.Step:= 0;
		PoruchaBunky:= TRUE;
	END_IF	
	

	
	CASE SC_Robot.Step OF 
	
		0:
			SC_Robot.StepName:='0 - Nulovanie';
			Robot.Automat:= FALSE;
			Robot.KoniecCyklu:= FALSE;
			Robot.Manual:= FALSE;
			Robot.STAV.PoINIT:= FALSE;
			Robot.KOM_OUT.OdparkujRobota:= FALSE;
			Robot.KOM_OUT.PP_na_Main:= FALSE;
			Robot.KOM_OUT.Reset_CS:= FALSE;
			Robot.KOM_OUT.StartProgramu:= FALSE;
			Robot.KOM_OUT.StartProgramuMain:= FALSE;
			Robot.KOM_OUT.VypniMotory:= FALSE;
			Robot.KOM_OUT.ZapniMotory:= FALSE;
			Robot.Odparkovanie:= FALSE;
			Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety:= FALSE;
			Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
			Robot.KOM_OUT.PresunDoPoziceKontrolyEtikety:= FALSE;
			Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo:= FALSE;
			Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku:= FALSE;
			Robot.KOM_OUT.NalepEtiketu:= FALSE;
			Robot.KOM_OUT.CitanieStitkuUkoncene:= FALSE;
			Robot.RR_PresunPoziciaCitaniaDMkodu:= FALSE;
			Robot.RR_PresunPoziciaCitaniaQRkodu:= FALSE;
			Robot.RR_PresunPoziciaNalepeniaEtikety:= FALSE;
			Robot.RR_PresunPoziciaOdobratiaEtikety:= FALSE;
			
			IF Robot.KOM_IN.Stav_RezimAUTOMAT AND Robot.KOM_IN.Stav_ProgramRUN THEN
				Robot.KOM_OUT.StopProgramu:= TRUE;
			ELSE	
				Robot.KOM_OUT.StopProgramu:= FALSE;
			END_IF	
			IF Safety.STAV.ZonaCS_AKTIVNA AND Safety.STAV.ZonaBunky_AKTIVNA AND Linka.IN.TlakVzduchu_OK_S2 AND NOT NastalaPorucha AND NOT Robot.KOM_IN.Stav_ProgramRUN AND Linka.STAV.Hardware_OK THEN
				Robot.KOM_OUT.StopProgramu:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 1;
			END_IF
	
		1:
			SC_Robot.StepName:='1 - Cakam na spustenie vyroby';
			Robot.KoniecCyklu:= FALSE;
			IF Robot.Automat THEN
				SC_Robot.Step:= 2;
			ELSIF Robot.Odparkovanie THEN
				SC_Robot.Step:= 2;
			ELSIF Robot.RR_PresunPoziciaCitaniaQRkodu THEN
				Robot.Manual:= TRUE;
				SC_Robot.Step:= 2;
			ELSIF Robot.RR_PresunPoziciaCitaniaDMkodu THEN
				Robot.Manual:= TRUE;
				SC_Robot.Step:= 2;
			ELSIF Robot.RR_PresunPoziciaOdobratiaEtikety THEN
				Robot.Manual:= TRUE;
				SC_Robot.Step:= 2;	
			END_IF
			
		
			//********************************************************Inicializácia****************************************************************************//	
	
		2:
			SC_Robot.StepName:='2 - Inicializacia - cakam na spustenie inicializacie';
			SC_Robot.IdleTime.PT:= T#500ms;
			SC_Robot.AlarmTime.PT:= T#5s;
			
			SC_Robot.IdleTime.IN:= TRUE;
									
			IF SC_Robot.IdleTime.Q THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 3;
			END_IF
			
		3:
			SC_Robot.StepName:='2 - Inicializacia - kontrolujem central stop robota';
			SC_Robot.IdleTime.PT:= T#500ms;
			SC_Robot.AlarmTime.PT:= T#5s;
	
			IF Robot.KOM_IN.Stav_RobotCS THEN
				Robot.KOM_OUT.Reset_CS:= TRUE;
			END_IF
		
			IF NOT Robot.KOM_IN.Stav_RobotCS THEN
				Robot.KOM_OUT.Reset_CS:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 4;
			END_IF
		
		
		4:
			SC_Robot.StepName:='4 - Inicializacia - zapinam motory robota';
			SC_Robot.IdleTime.PT:= T#500ms;
			SC_Robot.AlarmTime.PT:= T#5s;
			
			IF NOT Robot.KOM_IN.Stav_MotoryON THEN
				Robot.KOM_OUT.ZapniMotory:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_MotoryON THEN
				Robot.KOM_OUT.ZapniMotory:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 6;
			END_IF
			
			
		6:
			SC_Robot.StepName:='6 - Inicializacia - spustam program robota od zaciatku';
			SC_Robot.IdleTime.PT:= T#500ms;
			SC_Robot.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Robot.Switch1 THEN
				Robot.KOM_OUT.StartProgramuMain:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_ProgramRUN AND Robot.KOM_IN.Stav_VystupyZresetovane THEN
				Robot.KOM_OUT.StartProgramuMain:= FALSE;
				IF Robot.RR_PresunPoziciaCitaniaQRkodu THEN
					SC_Robot.Step:= 700;
				ELSIF Robot.RR_PresunPoziciaCitaniaDMkodu THEN
					SC_Robot.Step:= 720;
				ELSIF Robot.RR_PresunPoziciaOdobratiaEtikety THEN
					SC_Robot.Step:= 740;	
				ELSIF Robot.Odparkovanie AND Safety.STAV.MutingRobota_AKTIVNY THEN
					SC_Robot.ResetStep:= TRUE;
					SC_Robot.Step:= 0;	
				ELSIF NOT Robot.Odparkovanie THEN
					Robot.STAV.PoINIT:= TRUE;
					SC_Robot.ResetStep:= TRUE;
					SC_Robot.Step:= 100;
				END_IF	
			END_IF	
			
			
		
			//********************************************************Automatický režim****************************************************************************//
				
		100:  
			SC_Robot.StepName:='100 - Automaticky Rezim - cakam na ukoncenie programu robota';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;		
			
						
			IF NOT Robot.KOM_IN.Stav_ProgramRUN THEN
				Alarmy[73]:= TRUE;
				PoruchaBunky:= TRUE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;
			ELSIF Robot.KoniecCyklu AND NOT StoperEtiketovania.Automat AND NOT StoperDopravNG.Automat THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;	
			END_IF	
			
			

		
		
		
			//*******************************************************Manuálny režim*******************************************************************************//	
			
		700:
			SC_Robot.StepName:='700 - Manualny Rezim - citania QR kodu internej etikety,precitanie typu paletky,zvolenie cisla programu pre robot a cisla programu kamery';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
		
						
			SC_Robot.IdleTime.IN:= RFID_Hlava_2.STAV.PritomnostCipu;
			
			IF NOT StoperEtiketovania.IN.Centrovanie_HornaPoloha_IS18 THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;
			ELSIF NOT RFID_Hlava_2.STAV.PritomnostCipu THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;	
			ELSIF SC_Robot.IdleTime.Q THEN
				IF RFID_Hlava_2.PAR.PrecitaneCisloPaletky <> '' AND Linka.PAR.Zvoleny_MODEL <> '' THEN
					IF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BF1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKB24380HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 1;
						Kamera.PAR.ZadaneCisloProgramu:= 1;
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BV1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKE26150HC' THEN
						Robot.KOM_OUT.CisloProduktu:= 2;
						Kamera.PAR.ZadaneCisloProgramu:= 3;
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BW1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKE27070WA' THEN
						Robot.KOM_OUT.CisloProduktu:= 3;
						Kamera.PAR.ZadaneCisloProgramu:= 5;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'CN1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKE28730WA' THEN
						Robot.KOM_OUT.CisloProduktu:= 4;
						Kamera.PAR.ZadaneCisloProgramu:= 7;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'CP1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKN27101HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 5;
						Kamera.PAR.ZadaneCisloProgramu:= 9;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BE1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKR21681HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 6;
						Kamera.PAR.ZadaneCisloProgramu:= 11;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BD1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKR25060HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 7;
						Kamera.PAR.ZadaneCisloProgramu:= 13;
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BF1' AND Linka.PAR.Zvoleny_MODEL = 'EZTYB21670HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 8;
						Kamera.PAR.ZadaneCisloProgramu:= 15;	
					END_IF	
					SC_Robot.ResetStep:= TRUE;
					SC_Robot.Step:= 702;
				ELSE	
					SC_Robot.ResetStep:= TRUE;
					SC_Robot.Step:= 0;
				END_IF
			END_IF	
		
			
				
			
			
		702:
			SC_Robot.StepName:='702 - Manualny Rezim - citania QR kodu internej etikety,presun robota do pozicie citania internej etikety';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Robot.Switch1 THEN
				Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 705;
			END_IF	
		
			
		705:
			SC_Robot.StepName:='705 - Manualny Rezim - citania QR kodu internej etikety,cakam na zrusenie signalu cinnost robota ukoncena';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
           
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 708;  
			END_IF 
	
		
		708:
			SC_Robot.StepName:='708 - Manualny Rezim - citania QR kodu internej etikety,cakam na ukoncenie citania internej etikety';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
		
			
			IF NOT SC_Robot.Switch1 AND NOT Robot.RR_PresunPoziciaCitaniaQRkodu THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 710;
			END_IF
		
		
		710:
			SC_Robot.StepName:='710 - Manualny Rezim - citania QR kodu internej etikety,cakam na zrusenie signalu cinnost robota ukoncena';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
           
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 713;  
			END_IF 
		
		713:
			SC_Robot.StepName:='713 - Manualny Rezim - citania QR kodu internej etikety,presun robota do muting pozicie';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Robot.Switch1 THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena AND Safety.STAV.MutingRobota_AKTIVNY THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;
			END_IF	
		
		
			
			
			
			
			
			
			
		
		
		720:
			SC_Robot.StepName:='720 - Manualny Rezim - citania DM kodu zakaznickej etikety,precitanie typu paletky,zvolenie cisla programu pre robot a cisla programu kamery';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
		
			
			
			
						
			SC_Robot.IdleTime.IN:= RFID_Hlava_2.STAV.PritomnostCipu;
			
			IF NOT StoperEtiketovania.IN.Centrovanie_HornaPoloha_IS18 THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;
			ELSIF NOT RFID_Hlava_2.STAV.PritomnostCipu THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;	
			ELSIF SC_Robot.IdleTime.Q THEN
				IF RFID_Hlava_2.PAR.PrecitaneCisloPaletky <> '' AND Linka.PAR.Zvoleny_MODEL <> '' THEN
					IF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BF1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKB24380HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 1;
						Kamera.PAR.ZadaneCisloProgramu:= 2;
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BV1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKE26150HC' THEN
						Robot.KOM_OUT.CisloProduktu:= 2;
						Kamera.PAR.ZadaneCisloProgramu:= 4;
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BW1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKE27070WA' THEN
						Robot.KOM_OUT.CisloProduktu:= 3;
						Kamera.PAR.ZadaneCisloProgramu:= 6;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'CN1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKE28730WA' THEN
						Robot.KOM_OUT.CisloProduktu:= 4;
						Kamera.PAR.ZadaneCisloProgramu:= 8;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'CP1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKN27101HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 5;
						Kamera.PAR.ZadaneCisloProgramu:= 10;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BE1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKR21681HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 6;
						Kamera.PAR.ZadaneCisloProgramu:= 12;	
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BD1' AND Linka.PAR.Zvoleny_MODEL = 'EZTKR25060HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 7;
						Kamera.PAR.ZadaneCisloProgramu:= 14;
					ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BF1' AND Linka.PAR.Zvoleny_MODEL = 'EZTYB21670HA' THEN
						Robot.KOM_OUT.CisloProduktu:= 8;
						Kamera.PAR.ZadaneCisloProgramu:= 16;	
					END_IF	
					SC_Robot.ResetStep:= TRUE;
					SC_Robot.Step:= 722;
				ELSE	
					SC_Robot.ResetStep:= TRUE;
					SC_Robot.Step:= 0;
				END_IF
			END_IF	
		
		722:
			SC_Robot.StepName:='722 - Manualny Rezim - citania DM kodu zakaznickej etikety,presun robota do pozicie citania zakaznickej etikety';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Robot.Switch1 THEN
				Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 725;
			END_IF	
		
			
		725:
			SC_Robot.StepName:='725 - Manualny Rezim - citania DM kodu zakaznickej etikety,cakam na zrusenie signalu cinnost robota ukoncena';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
           
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 728;  
			END_IF 
	
		
		728:
			SC_Robot.StepName:='728 - Manualny Rezim - citania DM kodu zakaznickej etikety,cakam na ukoncenie citania zakaznickej etikety';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
		
			
			IF NOT SC_Robot.Switch1 AND NOT Robot.RR_PresunPoziciaCitaniaDMkodu THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.CitanieStitkuUkoncene:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 730;
			END_IF
		
		
		730:
			SC_Robot.StepName:='730 - Manualny Rezim - citania DM kodu zakaznickej etikety,cakam na zrusenie signalu cinnost robota ukoncena';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
           
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 733;  
			END_IF 
		
		733:
			SC_Robot.StepName:='733 - Manualny Rezim - citania DM kodu zakaznickej etikety,presun robota do muting pozicie';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Robot.Switch1 THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena AND Safety.STAV.MutingRobota_AKTIVNY THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;
			END_IF	
		
		
		
		
		
		740:
			SC_Robot.StepName:='740 - Manualny Rezim - presun robota do pozicie odobratia etikety z tlaciarne';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Robot.Switch1 THEN
				Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 745;
			END_IF	
		
			
		745:
			SC_Robot.StepName:='745 - Manualny Rezim - cakam na zrusenie signalu cinnost robota ukoncena';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;
           
			
			IF NOT Robot.KOM_IN.Stav_RobotCinnostUkoncena THEN
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 748;  
			END_IF 
		
		
		
		748:
			SC_Robot.StepName:='748 - Manualny Rezim - cakam na ukoncenie presunu odobratia etikety z tlaciarne';
			SC_Robot.IdleTime.PT:= T#200ms;
			SC_Robot.AlarmTime.PT:= T#5s;	
		
			
			IF NOT SC_Robot.Switch1 AND NOT Robot.RR_PresunPoziciaOdobratiaEtikety THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= TRUE;
				SC_Robot.Switch1:= TRUE;
			END_IF
			
					
			
			IF Robot.KOM_IN.Stav_RobotCinnostUkoncena AND Safety.STAV.MutingRobota_AKTIVNY THEN
				Robot.KOM_OUT.PresunDoMutingPozicie:= FALSE;
				SC_Robot.ResetStep:= TRUE;
				SC_Robot.Step:= 0;
			END_IF	
		
		
		
		
		
	
	
	END_CASE
	
	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM



PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
    //Alarmy pracoviska (0 - 100)//
	//A0 - Porucha prepatovej ochrany !!!
	//A1 - Porucha tlaku vzduchu !!!
    //A2 - Porucha komunikacie s robotom !!!
	//A3 - Porucha komunikacie so smart kamerou !!!
	//A4 - Porucha komunikacie s modulom citaciek RFID !!!
	//A5 - Porucha komunikacie s ventilovym terminalom !!!
	//A6 - Porucha komunikacie s frekvencnymi menicmi !!!
    //A7 - Porucha PLC karty AB2 - Profinet master !!!
    //A8 - Porucha PLC karty AB3 - Safety master !!!
	//A9 - Porucha PLC karty AB4 - Safety vstupy !!!
    //A10 - Porucha PLC karty AB5 - Digitalne vstupy !!!
    //A11 - Porucha PLC karty AB6 - Digitalne vstupy !!!
    //A12 - Porucha PLC karty AB7 - Digitalne vstupy !!!
	//A13 - Porucha PLC karty AB8 - Digitalne vystupy !!!
	//A14 - Porucha PLC karty AB9 - Digitalne vystupy !!!
	//A15 - Porucha PLC karty AB10 - X2X master !!!
	//A16 - Porucha modulu DI1 - Digitalne vstupy !!!
	//A17 - Porucha modulu DI2 - Digitalne vstupy !!!
	//A18 - Porucha modulu DI3 - Digitalne vstupy !!!
	//A19 - Porucha modulu SI1 - Safety vstupy !!!
	//A20 - Porucha modulu SI2 - Safety vstupy !!!
	//A21 - 
	//A22 -
	//A23 - 
	//A24 - 
	//A25 - 
	//A26 - 
	//A27 - 
	//A28 - 
	//A29 - 
	//A30 - 
    //A31 - Bolo stlacene tlacitko CS robota !!!
    //A32 - Bolo stlacene tlacitko CS ovladacieho panela !!!
	//A33 - Bolo stlacene tlacitko CS vstupneho vytahu !!!
	//A34 - Bolo stlacene tlacitko CS vystupneho vytahu !!!
	//A35 - Porucha vyvezenia paletky zo stopra pred cistenim !!!
	//A36 - Porucha spustenia cistenia !!!
	//A37 - Porucha otacania hornej trisky cistenia !!!
	//A38 - Porucha otacania spodnej trisky cistenia !!!
	//A39 - Porucha vyvezenia paletky zo stopra po cisteni !!!
    //A40 - Porucha vyvezenia paletky zo stopra vystupneho dopravnika !!!
	//A41 - Porucha vyvezenia paletky zo stopra vratneho dopravnika !!!
	//A42 - Porucha otvorenia dveri vstupneho vytahu !!!
	//A43 - Porucha zatvorenia dveri vstupneho vytahu !!!
	//A44 - Pritomnost paletky na prechode medzi vstupnym vytahom a dopravnikom !!!
	//A45 - Porucha navazania paletky na dopravnik vstupneho vytahu !!!
	//A46 - Narusenie optickej bariery vstupneho vytahu !!!
	//A47 - Paletka v koliznej pozicii vstupneho vytahu !!!
	//A48 - Porucha vyvezenia paletky z dopravnika vstupneho vytahu !!!
	//A49 - Pritomnost paletky na prechode medzi vystupnym vytahom a dopravnikom !!!
	//A50 - Narusenie optickej bariery vystupneho vytahu !!!
	//A51 - Paletka v koliznej pozicii vystupneho vytahu !!!
	//A52 - Porucha navazania paletky na dopravnik vystupneho vytahu !!!
	//A53 - Porucha zdvihu centrovania paletky na pozicii etiketovania !!!
	//A54 - Porucha zasunutia centrovania paletky na pozicii etiketovania !!!
	//A55 - Porucha vytlacenia etikety !!!
	//A56 - Porucha vyvezenia paletky zo stopra etiketovania !!!
	//A57 - Porucha zdvihu centrovania paletky na pozicii stopra dopravnika NG !!!
	//A58 - Porucha zasunutia centrovania paletky na pozicii stopra dopravnika NG !!!
	//A59 - Porucha presunu centrovania paletky do strednej polohy na pozicii stopra dopravnika NG !!!
	//A60 - Porucha precitania cisla paletky na pozicii vstupneho vytahu !!!
	//A61 - Porucha precitania cisla paletky na pozicii stopra etiketovania !!!
	//A62 - Porucha precitania cisla paletky na pozicii vystupneho vytahu !!!
	//A63 - Porucha vyvezenia paletky na dopravnik NG !!!
	//A64 - Porucha navezenia paletky z dopravnika NG !!!
	//A65 - Porucha vyvezenia paletky zo stopra dopravnika NG !!!
	//A66 - Porucha precitania QR kodu interneho stitku na pozicii stopra etiketovania !!!
	//A67 - Porucha menica zdvihu vstupneho vytahu !!!
	//A68 - Porucha menica pohonu dopravnika cistenia !!!
	//A69 - Porucha menica zdvihu vystupneho vytahu !!!
	//A70 - Porucha precitania cisla paletky na pozicii dopravnika cistenia !!!
	//A71 - Porucha, nepovolene otvorenie servisnych dveri tlaciarne !!! 
	//A72 - Narusenie optickej bariery dopravnika NG !!!
	//A73 - Bol zastaveny program robota !!!
	//A74 - Porucha komunik·cie so serverom Panasonic !!!
	//A75 - Kamera robota nieje READY !!!

	 
     //***********************************Hladanie poruchy*****************************************//
   	
	FOR a:=0 TO 100 BY 1 DO
		Alarmy[a];
		IF Alarmy[a] = TRUE THEN
			NastalaPorucha:= TRUE;
		END_IF	
	END_FOR
    
	//********************************Zobrazenie symbolu alarmu*****************************************************//
	
	IF NastalaPorucha THEN
		Vizu.ZobrazSymbolAlarmu:= Blikac500ms;
	ELSE
		Vizu.ZobrazSymbolAlarmu:= FALSE;
	END_IF	
   
    

    
	
	
	
	
	
    
	//*************************************Potvrdenie alarmov*********************************************************//
	IF PotvrdenieAlarmov THEN
		brsmemset(ADR(Alarmy),0,SIZEOF(Alarmy));
		NastalaPorucha:= FALSE;
		PoruchaBunky:= FALSE;
		PoruchaCistenia:= FALSE;
		PoruchaLinky:= FALSE;
		PoruchaVstupnehoVytahu:= FALSE;
		PoruchaVystupnehoVytahu:= FALSE;
		Linka.STAV.PoruchaOtacaniaTrysiek:= FALSE;
		Linka.Majak_HukackaON:= FALSE;
		IF VstupVytah.MenicZdvihu_FM2.STAV.PORUCHA THEN
			VstupVytah.MenicZdvihu_FM2.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF 
		IF VystupVytah.MenicZdvihu_FM3.STAV.PORUCHA THEN
			VystupVytah.MenicZdvihu_FM3.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF 
		IF DopravCistenia.MenicDopravnika_FM1.STAV.PORUCHA THEN
			DopravCistenia.MenicDopravnika_FM1.CMD.Potvrd_PORUCHU:= TRUE;
		END_IF 
		PotvrdenieAlarmov:= FALSE;
	END_IF	
	
	    
	//*******************************Porucha prepatovej ochrany*********************************************************//
	IF Safety.STAV.ZonaCS_AKTIVNA AND NOT Linka.IN.PrepatovaOchrana_OK THEN
		Alarmy[0]:= TRUE;
	END_IF 
   
	//*******************************Porucha tlaku vzduchu**************************************************************//
	CasKontrolyTlakuVzduchu.IN:= Safety.STAV.ZonaCS_AKTIVNA AND NOT Linka.IN.TlakVzduchu_OK_S2;
	
	IF CasKontrolyTlakuVzduchu.Q THEN
		Alarmy[1]:= TRUE;
		PoruchaLinky:= TRUE;
	END_IF	
	
	CasKontrolyTlakuVzduchu.PT:= T#2s;
	CasKontrolyTlakuVzduchu();
    
	//********************************Porucha komunik·cie s robotom******************************************************//
	CasKontroly_KOM_Robota.IN:= Safety.STAV.ZonaCS_AKTIVNA AND NOT StavHardware.Komunikacia_Robot_OK;
	IF CasKontroly_KOM_Robota.Q THEN
		Alarmy[2]:= TRUE;
		PoruchaBunky:= TRUE;
	END_IF
    
    
	CasKontroly_KOM_Robota.PT:= T#2s;
	CasKontroly_KOM_Robota();
    
	//********************************Porucha komunik·cie s kamerou******************************************************//
	CasKontroly_KOM_Kamery.IN:= Safety.STAV.ZonaCS_AKTIVNA AND NOT StavHardware.Komunikacia_Kamera_OK;
	IF CasKontroly_KOM_Kamery.Q THEN
		Alarmy[3]:= TRUE;
		PoruchaBunky:= TRUE;
	END_IF
    
    
	CasKontroly_KOM_Kamery.PT:= T#2s;
	CasKontroly_KOM_Kamery();
	
	
	//********************************Porucha komunik·cie s modulom RFID ËitaËiek******************************************************//
	CasKontroly_KOM_IOlinkModulu.IN:= Safety.STAV.ZonaCS_AKTIVNA AND NOT StavHardware.Komunikacia_RFIDModul_OK;
	IF CasKontroly_KOM_RFIDModulu.Q THEN
		Alarmy[4]:= TRUE;
		PoruchaLinky:= TRUE;
	END_IF
    
    
	CasKontroly_KOM_RFIDModulu.PT:= T#2s;
	CasKontroly_KOM_IOlinkModulu();
	
	
	//********************************Porucha komunik·cie s ventilov˝m termin·lom******************************************************//
	CasKontroly_KOM_VentTerminalu.IN:= Safety.STAV.ZonaCS_AKTIVNA AND NOT StavHardware.Komunikacia_VentTerminal_OK;
	//	IF CasKontroly_KOM_VentTerminalu.Q THEN
	//		Alarmy[5]:= TRUE;
	//		PoruchaLinky:= TRUE;
	//	END_IF
    
    
	CasKontroly_KOM_VentTerminalu.PT:= T#2s;
	CasKontroly_KOM_VentTerminalu();
	
	
	//********************************Porucha komunik·cie s frekvenËn˝mi meniËmy******************************************************//
	CasKontroly_KOM_MenicovFM.IN:= Safety.STAV.ZonaCS_AKTIVNA AND NOT StavHardware.Komunikacia_MeniceFM_OK;
	IF CasKontroly_KOM_MenicovFM.Q THEN
		Alarmy[6]:= TRUE;
		PoruchaLinky:= TRUE;
	END_IF
    
    
	CasKontroly_KOM_MenicovFM.PT:= T#2s;
	CasKontroly_KOM_MenicovFM();
	
	
	
	//**********************************Porucha - karty PLC niesu online**************************************************//
	IF CasKontroly_KarietPLC.Q THEN
		IF NOT StavHardware.KartaAB2_ProfinetMaster_OK THEN
			Alarmy[7]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB3_SafetyMaster_OK THEN
			Alarmy[8]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB4_SafetyDI_OK THEN
			Alarmy[9]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB5_16DI_OK THEN
			Alarmy[10]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB6_16DI_OK THEN
			Alarmy[11]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB7_16DI_OK THEN
			Alarmy[12]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB8_16DO_OK THEN
			Alarmy[13]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB9_16DO_OK THEN
			Alarmy[14]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.KartaAB10_X2X_OK THEN
			Alarmy[15]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.ModulDI1_16DI_OK THEN
			Alarmy[16]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.ModulDI2_16DI_OK THEN
			Alarmy[17]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.ModulDI3_8DI_OK THEN
			Alarmy[18]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.ModulSI1_4SI_OK THEN
			Alarmy[19]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.ModulSI2_4SI_OK THEN
			Alarmy[20]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF
		IF NOT StavHardware.Komunikacia_Panasonic_OK THEN
			Alarmy[74]:= TRUE;
			PoruchaLinky:= TRUE;
		END_IF	
	END_IF    
        
	IF Safety.STAV.ZonaCS_AKTIVNA AND NOT Linka.STAV.Hardware_OK THEN
		CasKontroly_KarietPLC.IN:= TRUE;
	ELSE
		CasKontroly_KarietPLC.IN:= FALSE;
	END_IF    
        
	CasKontroly_KarietPLC.PT:= T#2s;
	CasKontroly_KarietPLC();
    
	    
    
	//**********************************Porucha bolo stlacene tlaËÌtko CS robota***************************************//
	IF EDGENEG(Safety.STAV.CS_Robot_Odblokovany) THEN
		Alarmy[31]:= TRUE;
		PoruchaLinky;
	END_IF    
    
   
	//**********************************Porucha bolo stlacene tlaËÌtko CS ovl·dacieho panela***************************************//
	IF EDGENEG(Safety.STAV.CS_OvlPanel_Odblokovany) THEN
		Alarmy[32]:= TRUE;
		PoruchaLinky;
	END_IF  
	
	
	
	//**********************************Porucha bolo stlacene tlaËÌtko CS vstupnÈho v˝ùahu***************************************//
	IF EDGENEG(Safety.STAV.CS_VstupnyVytah_Odblokovany) THEN
		Alarmy[33]:= TRUE;
		PoruchaLinky;
	END_IF 
    
	
	//**********************************Porucha bolo stlacene tlaËÌtko CS v˝stupnÈho v˝ùahu***************************************//
	IF EDGENEG(Safety.STAV.CS_VystupnyVytah_Odblokovany) THEN
		Alarmy[34]:= TRUE;
		PoruchaLinky;
	END_IF 
	
	//************************************Porucha meniËa zdvihu vstupnÈho v˝ùahu***************************************************//
	IF VstupVytah.Automat AND VstupVytah.MenicZdvihu_FM2.STAV.PORUCHA THEN
		Alarmy[67]:= TRUE;
		PoruchaVstupnehoVytahu:= TRUE;
	END_IF	
	
	//************************************Porucha meniËa pohonu dopravnÌka Ëistenia***************************************************//
	IF DopravCistenia.Automat AND DopravCistenia.MenicDopravnika_FM1.STAV.PORUCHA THEN
		Alarmy[68]:= TRUE;
		PoruchaCistenia:= TRUE;
	END_IF
	
	//************************************Porucha meniËa zdvihu v˝stupnÈho v˝ùahu***************************************************//
	IF VystupVytah.Automat AND VystupVytah.MenicZdvihu_FM3.STAV.PORUCHA THEN	
		Alarmy[69]:= TRUE;
		PoruchaVystupnehoVytahu:= TRUE;
	END_IF
	
	
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM



PROGRAM _INIT

	Linka.CitackaQRkodu_AKTIVNA:= TRUE;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	
	
	
	//Zapnutie osvetlenia bunky//
	IF NOT Linka.IN.PredneDvereZavrete_EZ1 OR NOT Linka.IN.ZadneDvereZavrete_EZ2 THEN
		Linka.OUT.OsvetlenieBunky_Zapni:= TRUE;
	ELSE	
		Linka.OUT.OsvetlenieBunky_Zapni:= FALSE;
	END_IF	
	
	//Ovládanie vzduchotechniky//
	IF Linka.OUT.IonJednotka_START THEN
		Linka.OUT.Vzduchotechnika_START:= TRUE;
	ELSIF CasVypnutiaVzduchotechniky.Q THEN	
		Linka.OUT.Vzduchotechnika_START:= FALSE;
	END_IF

	
	CasVypnutiaVzduchotechniky.IN:= Linka.OUT.Vzduchotechnika_START AND NOT Linka.OUT.IonJednotka_START;
	CasVypnutiaVzduchotechniky.PT:= T#30M;
	CasVypnutiaVzduchotechniky();
	
	//Volanie podprogramov//
	OvlSafety;
	KOM_VentilovyTerminal;
	ZmenaModelu;
	OvlRucnejCitackyQR;
	
	//****************************************Príznak hardware pracoviska OK***********************************//
    
	IF StavHardware.KartaAB2_ProfinetMaster_OK AND
		StavHardware.KartaAB3_SafetyMaster_OK AND
		StavHardware.KartaAB4_SafetyDI_OK AND
		StavHardware.KartaAB5_16DI_OK AND
		StavHardware.KartaAB6_16DI_OK AND
		StavHardware.KartaAB7_16DI_OK AND
		StavHardware.KartaAB8_16DO_OK AND
		StavHardware.KartaAB9_16DO_OK AND
		StavHardware.KartaAB10_X2X_OK AND
		StavHardware.ModulDI1_16DI_OK AND
		StavHardware.ModulDI2_16DI_OK AND
		StavHardware.ModulDI3_8DI_OK AND
		StavHardware.ModulSI1_4SI_OK AND
		StavHardware.ModulSI2_4SI_OK AND
		StavHardware.Komunikacia_RFIDModul_OK AND
		StavHardware.Komunikacia_Kamera_OK AND
		StavHardware.Komunikacia_MeniceFM_OK AND
		StavHardware.Komunikacia_Robot_OK AND
		StavHardware.Komunikacia_Panasonic_OK AND
		NOT StavHardware.Komunikacia_VentTerminal_OK THEN
		Linka.STAV.Hardware_OK:= TRUE; 
	ELSE
		Linka.STAV.Hardware_OK:= FALSE;
	END_IF
	
	
	//***************************************Ovládanie majáka**************************************************//
	//Zelene svetlo//
	IF Linka.STAV.Automat THEN
		Linka.OUT.Majak_ZeleneSvetlo:= TRUE;
	ELSIF Linka.STAV.Manual THEN
		Linka.OUT.Majak_ZeleneSvetlo:= Blikac500ms;
	ELSE
		Linka.OUT.Majak_ZeleneSvetlo:= FALSE;
	END_IF    
    
	//Žlté svetlo//
	IF Linka.STAV.Automat AND NOT Linka.STAV.PoINIT THEN
		Linka.OUT.Majak_ZlteSvetlo:= Blikac500ms;
	ELSE
		Linka.OUT.Majak_ZlteSvetlo:= FALSE;
	END_IF    
    
	//Èervené svetlo//
	IF NastalaPorucha THEN
		Linka.OUT.Majak_CerveneSvetlo:= TRUE; 
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Linka.OUT.Majak_CerveneSvetlo:= TRUE;
	ELSE
		Linka.OUT.Majak_CerveneSvetlo:= FALSE;
	END_IF   
    
	//Húkaèka//
	IF EDGEPOS(NastalaPorucha) THEN
		IF CasAktivacieHukacky.Q THEN
			Linka.Majak_HukackaON:= TRUE;
		END_IF	
	END_IF
    
	IF Linka.Majak_HukackaON THEN
		Linka.OUT.Majak_Hukacka:= Blikac500ms;
	ELSE
		Linka.OUT.Majak_Hukacka:= FALSE;
	END_IF   
	
	CasAktivacieHukacky.IN:= NOT Linka.Majak_HukackaON;
	CasAktivacieHukacky.PT:= T#500ms;
	CasAktivacieHukacky();
	
	//**************************************Ukonèenie pracovného cyklu na pracovisku**********************************************//
	//Normálne//
	IF Linka.KoniecCyklu THEN
		VstupVytah.KoniecCyklu:= TRUE;
		StoperPredCistenim.KoniecCyklu:= TRUE;
		StoperPoCisteni.KoniecCyklu:= TRUE;
		DopravCistenia.KoniecCyklu:= TRUE;
		StoperEtiketovania.KoniecCyklu:= TRUE;
		Robot.KoniecCyklu:= TRUE;
		StoperDopravNG.KoniecCyklu:= TRUE;
		DopravBunky.KoniecCyklu:= TRUE;
		StoperVystupDopravnika.KoniecCyklu:= TRUE;
		VystupnyDopravnik.KoniecCyklu:= TRUE;
		VystupVytah.KoniecCyklu:= TRUE;
		StoperVratDopravnika.KoniecCyklu:= TRUE;
		VratnyDopravnik.KoniecCyklu:= TRUE;
		Linka.KoniecCyklu:= FALSE;
	END_IF   
    
	//Pri poruche//
	IF EDGEPOS(PoruchaVstupnehoVytahu) THEN
		VstupVytah.KoniecCyklu:= TRUE;
	END_IF	
	
	IF EDGEPOS(PoruchaCistenia) THEN
		StoperPredCistenim.KoniecCyklu:= TRUE;
		StoperPoCisteni.KoniecCyklu:= TRUE;
		DopravCistenia.KoniecCyklu:= TRUE;
	END_IF	
	
	IF EDGEPOS(PoruchaBunky) THEN
		StoperEtiketovania.Reset:= TRUE;
		Robot.KoniecCyklu:= TRUE;
		StoperDopravNG.Reset:= TRUE;
		DopravBunky.KoniecCyklu:= TRUE;
	END_IF	
	
	IF EDGEPOS(PoruchaVystupnehoVytahu) THEN
		VystupVytah.KoniecCyklu:= TRUE;
	END_IF	
	
	IF EDGEPOS(PoruchaLinky) THEN
		Linka.KoniecCyklu:= TRUE; 
	END_IF	
	
	//Keï dôjde páska v tlaèiarni//
	IF Robot.Automat AND StoperEtiketovania.IN.Tlaciaren_KoniecEtikiet THEN
		Vizu.ZobrazHlasenie_DochadzaPaska:= 0;
		Vizu.IndexStavuPasky:= 0;
		StoperEtiketovania.KoniecCyklu:= TRUE;
		Robot.KoniecCyklu:= TRUE;
		StoperDopravNG.KoniecCyklu:= TRUE;
		DopravBunky.KoniecCyklu:= TRUE;
	ELSIF Robot.Automat AND StoperEtiketovania.IN.Tlaciaren_KoniecPasky THEN
		Vizu.ZobrazHlasenie_DochadzaPaska:= 0;	
		Vizu.IndexStavuPasky:= 1;
		StoperEtiketovania.KoniecCyklu:= TRUE;
		Robot.KoniecCyklu:= TRUE;
		StoperDopravNG.KoniecCyklu:= TRUE;
		DopravBunky.KoniecCyklu:= TRUE;
	END_IF	
	
	
	

	
	
	
    
	//Status prebieha ukonèenie cyklu//
	IF VstupVytah.KoniecCyklu OR
		StoperPredCistenim.KoniecCyklu OR
		StoperPoCisteni.KoniecCyklu OR
		DopravCistenia.KoniecCyklu OR
		StoperEtiketovania.KoniecCyklu OR
		Robot.KoniecCyklu OR
		StoperDopravNG.KoniecCyklu OR
		DopravBunky.KoniecCyklu OR
		StoperVystupDopravnika.KoniecCyklu OR
		VystupnyDopravnik.KoniecCyklu OR
		VystupVytah.KoniecCyklu OR
		StoperVratDopravnika.KoniecCyklu OR
		VratnyDopravnik.KoniecCyklu THEN
		Linka.STAV.UkoncenieCyklu_BUSY:= TRUE;
	ELSE
		Linka.STAV.UkoncenieCyklu_BUSY:= FALSE;
	END_IF    
	
	
	//****************************************Resetovanie linky****************************************************************//
	//Normálne//
	IF Linka.Reset THEN
		VstupVytah.Reset:= TRUE;
		StoperPredCistenim.Reset:= TRUE;
		StoperPoCisteni.Reset:= TRUE;
		DopravCistenia.Reset:= TRUE;
		StoperEtiketovania.Reset:= TRUE;
		Robot.Reset:= TRUE;
		StoperDopravNG.Reset:= TRUE;
		DopravBunky.Reset:= TRUE;
		StoperVystupDopravnika.Reset:= TRUE;
		VystupnyDopravnik.Reset:= TRUE;
		VystupVytah.Reset:= TRUE;
		StoperVratDopravnika.Reset:= TRUE;
		VratnyDopravnik.Reset:= TRUE;
		Linka.Reset:= FALSE;
	END_IF
    
        
	//Pri stlaèení tlaèítka Automat//
	IF Vizu.TL_RezimAutomat THEN
		IF Linka.STAV.Manual THEN
			Linka.Reset:= TRUE;
		END_IF
		Vizu.TL_RezimAutomat:= FALSE;
	END_IF
	
	
	//**************************************Manuálny režim linky*************************************************************//
	IF Linka.Manual THEN
		VstupVytah.Manual:= TRUE;
		StoperPredCistenim.Manual:= TRUE;
		StoperPoCisteni.Manual:= TRUE;
		DopravCistenia.Manual:= TRUE;
		StoperEtiketovania.Manual:= TRUE;
		Robot.Manual:= TRUE;
		StoperDopravNG.Manual:= TRUE;
		DopravBunky.Manual:= TRUE;
		StoperVystupDopravnika.Manual:= TRUE;
		VystupnyDopravnik.Manual:= TRUE;
		VystupVytah.Manual:= TRUE;
		StoperVratDopravnika.Manual:= TRUE;
		VratnyDopravnik.Manual:= TRUE;
		Linka.Manual:= FALSE;
	END_IF
    
    
	//Príznak je zvolený režim Manuál//
	IF VstupVytah.Manual OR
		StoperPredCistenim.Manual OR
		StoperPoCisteni.Manual OR
		DopravCistenia.Manual OR
		StoperEtiketovania.Manual OR
		Robot.Manual OR
		StoperDopravNG.Manual OR
		DopravBunky.Manual OR
		StoperVystupDopravnika.Manual OR
		VystupnyDopravnik.Manual OR
		VystupVytah.Manual OR
		StoperVratDopravnika.Manual OR
		VratnyDopravnik.Manual THEN
		Linka.STAV.Manual:= TRUE;
	ELSE
		Linka.STAV.Manual:= FALSE;
	END_IF    
	
	//***************************************Automatický režim pracoviska**********************************************************//
	IF Linka.Automat THEN
		VstupVytah.Automat:= TRUE;
		StoperPredCistenim.Automat:= TRUE;
		StoperPoCisteni.Automat:= TRUE;
		DopravCistenia.Automat:= TRUE;
		StoperEtiketovania.Automat:= TRUE;
		Robot.Automat:= TRUE;
		StoperDopravNG.Automat:= TRUE;
		DopravBunky.Automat:= TRUE;
		StoperVystupDopravnika.Automat:= TRUE;
		VystupnyDopravnik.Automat:= TRUE;
		VystupVytah.Automat:= TRUE;
		StoperVratDopravnika.Automat:= TRUE;
		VratnyDopravnik.Automat:= TRUE;
		Linka.Automat:= FALSE;
	END_IF
    
    
	//Príznak je zvolený režim Automat//
	IF VstupVytah.Automat OR
		StoperPredCistenim.Automat OR
		StoperPoCisteni.Automat OR
		DopravCistenia.Automat OR
		StoperEtiketovania.Automat OR
		Robot.Automat OR
		StoperDopravNG.Automat OR
		DopravBunky.Automat OR
		StoperVystupDopravnika.Automat OR
		VystupnyDopravnik.Automat OR
		VystupVytah.Automat OR
		StoperVratDopravnika.Automat OR
		VratnyDopravnik.Automat THEN
		Linka.STAV.Automat:= TRUE;
	ELSE
		Linka.STAV.Automat:= FALSE;
	END_IF   
    
	//Príznak Zariadenie je po inicializácii//
	IF VstupVytah.STAV.PoINIT AND
		StoperPredCistenim.STAV.PoINIT AND
		StoperPoCisteni.STAV.PoINIT AND
		DopravCistenia.STAV.PoINIT AND
		StoperEtiketovania.STAV.PoINIT AND
		Robot.STAV.PoINIT AND
		StoperDopravNG.STAV.PoINIT AND
		DopravBunky.STAV.PoINIT AND
		StoperVystupDopravnika.STAV.PoINIT AND
		VystupnyDopravnik.STAV.PoINIT AND
		VystupVytah.STAV.PoINIT AND
		StoperVratDopravnika.STAV.PoINIT AND
		VratnyDopravnik.STAV.PoINIT THEN
		Linka.STAV.PoINIT:= TRUE;
	ELSE    
		Linka.STAV.PoINIT:= FALSE;
	END_IF
	
	
	//****************************************Príznak Zariadenie pripravené na spustenie********************************************//
	IF SC_VstupVytah.Step = 1 AND
		SC_StoperPredCistenim.Step = 1 AND
		SC_StoperPoCisteni.Step = 1 AND
		SC_DopravCistenia.Step = 1 AND
		SC_StoperEtiketovania.Step = 1 AND
		SC_Robot.Step = 1 AND
		SC_StoperDopravNG.Step = 1 AND
		SC_DopravBunky.Step = 1 AND
		SC_StoperVystupDopravnika.Step = 1 AND
		SC_VystupnyDopravnik.Step = 1 AND
		SC_VystupVytah.Step = 1 AND
		SC_StoperVratDopravnika.Step = 1 AND
		SC_VratnyDopravnik.Step = 1 THEN
		Linka.STAV.READY_TO_START:= TRUE;
	ELSE    
		Linka.STAV.READY_TO_START:= FALSE;
	END_IF  
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


(********************************************************************
 * COPYRIGHT -- Microsoft
 ********************************************************************
 * File: Global.typ
 * Author: Martin
 * Created: February 11, 2016
 ********************************************************************
 * Global data types of project Zamazat_1
 ********************************************************************)
(**************Ovládanie tlaèiarne**********************)

TYPE
	Client_typ : 	STRUCT  (*TCP Client Variables*)
		sStep : UINT; (*TCP Client Step Variable*)
		TcpOpen_0 : TcpOpen; (*AsTCP.TcpOpen FUB*)
		TcpClient_0 : TcpClient; (*AsTCP.TcpClient FUB*)
		TcpRecv_0 : TcpRecv; (*AsTCP.TcpRecv FUB*)
		TcpSend_0 : TcpSend; (*AsTCP.TcpSend FUB*)
		TcpIoctl_0 : TcpIoctl; (*AsTCP.TcpIoctl FUB*)
		TcpClose_0 : TcpClose; (*AsTCP.TcpClose FUB*)
		linger_opt : tcpLINGER_typ; (*AsTCP.tcpLINGER_typ*)
		recv_timeout : UDINT; (*receive timeout*)
		TcpOpen_timeout : UDINT;
		TcpClient_timeout : UDINT;
	END_STRUCT;
	Tlaciaren_typ : 	STRUCT 
		Commands : TlaciarenCommands_typ;
		Status : TlaciarenStatus_typ;
		Data : TlaciarenData_typ;
	END_STRUCT;
	TlaciarenCommands_typ : 	STRUCT 
		PosliSpravu : BOOL;
	END_STRUCT;
	TlaciarenStatus_typ : 	STRUCT 
		PoruchaOtvoreniaKomunikacie : BOOL;
		PoruchaOdoslaniaDat : BOOL;
		PoruchaZatvoreniaKomunikacie : BOOL;
		PoruchaSpojenia_s_Tlaciarnou : BOOL;
		PoruchaPrijatiaDat : BOOL;
		PrislaSprava_s_Tlaciarne : BOOL;
	END_STRUCT;
	TlaciarenData_typ : 	STRUCT  (*Datatyp for global Variables*)
		Sprava_pre_Tlaciaren : STRING[4000]; (*Obsahuje posielane data pre tlaèiareò v textovej podobe*)
		Odpoved_s_Tlaciarne : STRING[400]; (*Obsahuje odpoveï s tlaèiarne*)
	END_STRUCT;
	EtiketaPanasonic_typ : 	STRUCT 
		IdentificationNumber : STRING[10];
		ModelType : STRING[8];
		SupplierNumber : STRING[9];
		Country : STRING[2];
		Date : STRING[8];
		Counter : STRING[5];
		DataMetrix : STRING[31];
	END_STRUCT;
END_TYPE

(**********************RFID Èitaèky*********************************************)

TYPE
	RFID_typ : 	STRUCT 
		IN : RFID_IN_typ;
		OUT : RFID_OUT_typ;
		CMD : RFID_CMD_typ;
		STAV : RFID_STAV_typ;
		PAR : RFID_PAR_typ;
	END_STRUCT;
	RFID_IN_typ : 	STRUCT 
		BYTE_IN : ARRAY[0..31]OF USINT;
		Bit_CP : BOOL;
		Bit_AA : BOOL;
		Bit_AE : BOOL;
		Bit_AF : BOOL;
		Bit_MT : BOOL;
		Bit_TO : BOOL;
		Old_Bit_TO : BOOL;
		Bit_HF : BOOL;
		Bit_BB : BOOL;
	END_STRUCT;
	RFID_OUT_typ : 	STRUCT 
		BYTE_OUT : ARRAY[0..31]OF USINT;
		Bit_AV : BOOL;
		Bit_GR : BOOL;
		Bit_KA : BOOL;
		Bit_TI : BOOL;
	END_STRUCT;
	RFID_CMD_typ : 	STRUCT 
		CitajDATA : BOOL;
		ZapisDATA : BOOL;
		CitaciuHlavu_VYPNI : BOOL;
	END_STRUCT;
	RFID_STAV_typ : 	STRUCT 
		CitanieDat_OK : BOOL;
		CitanieDat_ERROR : BOOL;
		ZapisDat_OK : BOOL;
		ZapisDat_ERROR : BOOL;
		PritomnostCipu : BOOL;
	END_STRUCT;
	RFID_PAR_typ : 	STRUCT 
		PrecitaneCisloPaletky : STRING[10];
		PrecitanyTypPaletky : STRING[10];
		Zadane_Cislo_Typ_Paletky : STRING[10]; (*Oddelovací znak "bodkoèiarka"*)
		Precitane_Cislo_Typ_Paletky : STRING[10];
		PrecitaneCisloPaletky_POLE : ARRAY[0..9]OF USINT;
		ZadaneCisloPaletky_POLE : ARRAY[0..9]OF USINT;
	END_STRUCT;
END_TYPE

(**************************Ruèná èitaèka QR kódu******************************)

TYPE
	RS232_typ : 	STRUCT 
		Command : RS232_Command_typ;
		Status : RS232_Status_typ;
		Step : USINT;
		FRM_xopen_0 : FRM_xopen;
		xopenConfig : XOPENCONFIG;
		FRM_read_0 : FRM_read;
		FRM_write_0 : FRM_write;
		FRM_rbuf_0 : FRM_rbuf;
		FRM_gbuf_0 : FRM_gbuf;
		FRM_robuf_0 : FRM_robuf;
		FRM_close_0 : FRM_close;
		PrecitaneData : STRING[80];
	END_STRUCT;
	RS232_Command_typ : 	STRUCT 
		PosielajData : BOOL;
		PrimajData : BOOL;
		ZatvorKomunikaciu : BOOL;
		PotvrdeniePoruchy : BOOL;
	END_STRUCT;
	RS232_Status_typ : 	STRUCT 
		PoruchaOtvoreniaKomunikacie : BOOL;
		PoruchaPriradeniaSEND_Buffera : BOOL;
		PoruchaUvolneniaSEND_Buffera : BOOL;
		PoruchaZatvoreniaKomunikacie : BOOL;
		PoruchaCitaniaDat : BOOL;
		PoruchaUvolneniaRECEIVE_Buffera : BOOL;
		PrimanieDat_OK : BOOL;
		PosielanieDat_OK : BOOL;
	END_STRUCT;
END_TYPE

(**************************Remanentne premenné********************************)

TYPE
	RemPremenne_typ : 	STRUCT 
		VstupVytah_PozNavazania : UDINT;
		VstupVytah_PozVyvazania : UDINT;
		VystupVytah_PozNavazania : UDINT;
		VystupVytah_PozVyvazania : UDINT;
		PocetDniDoVymenyFiltra : UDINT;
	END_STRUCT;
END_TYPE

(***************Uzivatelia****************************)

TYPE
	ParametreUzivatelovTyp : 	STRUCT 
		Meno : STRING[50];
		Heslo : STRING[50];
		UrovenUzivatela : UINT;
	END_STRUCT;
END_TYPE

(************Receptury*************************)

TYPE
	ParametreRecepturTyp : 	STRUCT 
		NazovModelu : STRING[18];
		TypPaletky : STRING[4];
		Robot_CisloProgramu : USINT;
		Kamera_CisloProgramuQRkod : USINT;
		Kamera_CisloProgramuDMkod : USINT;
		Robot_PozLepenia_OffsetX : REAL;
		Robot_PozLepenia_OffsetY : REAL;
		Robot_PozLepenia_OffsetZ : REAL;
		RychlostDopravnikaPriCisteni : REAL;
	END_STRUCT;
END_TYPE

(**************************Safety***************************************************)

TYPE
	Safety_typ : 	STRUCT 
		IN : Safety_IN_typ;
		OUT : Safety_OUT_typ;
		PAR : Safety_PAR_typ;
		STAV : Safety_STAV_typ;
		RESET_ZonyBunky : BOOL;
		RESET_ZonyCS : BOOL;
		RESET_ZonyVstupnehoVytahu : BOOL;
		RESET_ZonyVystupnehoVytahu : BOOL;
		SpatnaVazba_ZonaBunky : BOOL;
		SpatnaVazba_ZonaCS : BOOL;
	END_STRUCT;
	Safety_IN_typ : 	STRUCT 
		Robot_CS_CH1 : BOOL;
		Robot_CS_CH2 : BOOL;
		VyblokovanieSafety_CH1 : BOOL;
		VyblokovanieSafety_CH2 : BOOL;
		OvladaciPanel_CS_CH1 : BOOL;
		OvladaciPanel_CS_CH2 : BOOL;
		DopravnikNG_Bariera_CH1 : BOOL;
		DopravnikNG_Bariera_CH2 : BOOL;
		Snimac_ServisneDvere_CH1 : BOOL;
		Snimac_ServisneDvere_CH2 : BOOL;
		ZamkyBunky_CH1 : BOOL;
		ZamkyBunky_CH2 : BOOL;
		MutingRobota_CH1 : BOOL;
		MutingRobota_CH2 : BOOL;
		DeadMan_CH1 : BOOL;
		DeadMan_CH2 : BOOL;
		VstupnyVytah_MutingSnimac_CH1 : BOOL;
		VstupnyVytah_MutingSnimac_CH2 : BOOL;
		VstupnyVytah_Bariera_CH1 : BOOL;
		VstupnyVytah_Bariera_CH2 : BOOL;
		VstupnyVytah_CS_CH1 : BOOL;
		VstupnyVytah_CS_CH2 : BOOL;
		VystupnyVytah_MutingSnimac_CH1 : BOOL;
		VystupnyVytah_MutingSnimac_CH2 : BOOL;
		VystupnyVytah_Bariera_CH1 : BOOL;
		VystupnyVytah_Bariera_CH2 : BOOL;
		VystupnyVytah_CS_CH1 : BOOL;
		VystupnyVytah_CS_CH2 : BOOL;
	END_STRUCT;
	Safety_OUT_typ : 	STRUCT 
		Zona_CS : BOOL;
		Zona_Bunky : BOOL;
		Zona_VstupnyVytah : BOOL;
		Zona_VystupnyVytah : BOOL;
	END_STRUCT;
	Safety_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	Safety_STAV_typ : 	STRUCT 
		SafetyPLC_Nabehlo : BOOL;
		ZonaCS_AKTIVNA : BOOL;
		ZonaBunky_Odblokovana : BOOL;
		ZamkyBunky_AKTIVNE : BOOL;
		ZonaBunky_AKTIVNA : BOOL;
		ZonaVstupnyVytah_Odblokovana : BOOL;
		ZonaVstupnyVytah_AKTIVNA : BOOL;
		ZonaVystupnyVytah_Odblokovana : BOOL;
		ZonaVystupnyVytah_AKTIVNA : BOOL;
		BarieraDopravnikaNG_AKTIVNA : BOOL;
		MutingRobota_AKTIVNY : BOOL;
		MutingBarieryVstupVytah_AKTIVNY : BOOL;
		MutingBarieryVystupVytah_AKTIVNY : BOOL;
		BarieraVstupVytahu_AKTIVNA : BOOL;
		BarieraVystupVytahu_AKTIVNA : BOOL;
		ServisneDvereTlaciarne_AKTIVNE : BOOL;
		CS_Robot_Odblokovany : BOOL;
		CS_OvlPanel_Odblokovany : BOOL;
		CS_VstupnyVytah_Odblokovany : BOOL;
		CS_VystupnyVytah_Odblokovany : BOOL;
		VyblokovanieSafety_AKTIVNE : BOOL;
	END_STRUCT;
END_TYPE

(**************************Vizualizacia**********************************************)

TYPE
	Vizu_typ : 	STRUCT 
		Language_Index : USINT;
		CisloAktualnejObrazovky : USINT;
		CisloZadanejObrazovky : USINT;
		TL_RezimAutomat : BOOL;
		TL_NavratPaletkyNG : BOOL;
		TL_ZamkniPredneDvere : BOOL;
		TL_ZamkniZadneDvere : BOOL;
		StavPracoviskaVstupVytah_Index : USINT;
		StavPracoviskaStopPredCist_Index : USINT;
		StavPracoviskaStopPoCist_Index : USINT;
		StavPracoviskaDoprCistenia_Index : USINT;
		StavPracoviskaStopEtiketov_Index : USINT;
		StavPracoviskaRobota_Index : USINT;
		StavPracoviskaDoprBunky_Index : USINT;
		StavPracoviskaStopDopNG_Index : USINT;
		StavPracoviskaStopVystDopr_Index : USINT;
		StavPracoviskaDoprVystup_Index : USINT;
		StavPracoviskaVystupVytah_Index : USINT;
		StavPracoviskaStopVratDopr_Index : USINT;
		StavPracoviskaDoprVrat_Index : USINT;
		StavZariadenia_Farba : USINT;
		StavZariadenia_Index : USINT;
		StavNGpaletky_Index : USINT;
		StavZmenyModelu_Index : USINT;
		StavZmenyModelu_Farba : USINT;
		TL_ZamokPredneDvere_DISABLE : BOOL;
		TL_ZamokZadneDvere_DISABLE : BOOL;
		TL_RezimManual_DISABLE : BOOL; (*0 - odomknuté, 1 - zamknuté*)
		TL_StartAutomat_DISABLE : BOOL;
		TL_UkoncenieCyklu_DISABLE : BOOL;
		TL_Reset_DISABLE : BOOL;
		TL_ZmenModel_DISABLE : BOOL;
		TL_PotvrdeniePaletky_NG_DISABLE : BOOL;
		TL_ZruseniePaletky_NG_DISABLE : BOOL;
		TL_OdparkujRobota_DISABLE : BOOL;
		ZmenaParametrov_DISABLE : BOOL;
		TL_BunkyRR_DISABLE : BOOL;
		TL_Ovl_Ionizatora_DISABLE : BOOL;
		TL_Ovl_DveriVstupVytahu_DISABLE : BOOL;
		Slider : USINT;
		FarbaTlacitkaAlarm_Index : BOOL;
		FarbaTlacitka_PotvrdPaletkuNG : BOOL;
		FarbaTlacitka_ZamokPredneDvere : USINT;
		FarbaTlacitka_ZamokZadneDvere : USINT;
		ZobrazSymbolAlarmu : BOOL;
		ZobrazHlasenie_ResetZariadenia : USINT;
		ZobrazHlasenie_PotvrdPaletkyNG : USINT;
		ZobrazHlasenie_NespravTypPaletky : USINT;
		ZobrazHlasenie_ZaaretujTlaciaren : USINT;
		ZobrazHlas_ZatvorSerDvereTlac : USINT;
		ZobrazHlasenie_TlaciarenOffline : USINT;
		ZobrazHlasenie_DochadzaPaska : USINT;
		PodsvietenieTlacitka_ResetCS : USINT;
		Nacitany_MODEL : STRING[18];
		Nacitany_LOT : STRING[11];
		NacitanieMODELU_DISABLE : BOOL;
		NacitanieLOTU_DISABLE : BOOL;
		NacitanieMODELU_IndexFarby : USINT;
		NacitanieLOTU_IndexFarby : USINT;
		OverNacitany_MODEL : BOOL;
		OverNacitany_LOT : BOOL;
		TL_VstupVytah_Homing_DISABLE : BOOL;
		TL_VstupVytah_Zdvih_DISABLE : BOOL;
		TL_VstupVytah_Doprav_DISABLE : BOOL;
		TL_VystupVytah_Homing_DISABLE : BOOL;
		TL_VystupVytah_Zdvih_DISABLE : BOOL;
		TL_VystupVytah_Doprav_DISABLE : BOOL;
		TL_Robot_CitanieQRkodu_DISABLE : BOOL;
		TL_Robot_CitanieDMkodu_DISABLE : BOOL;
		TL_Robot_OdoberEtiketu_DISABLE : BOOL;
		ZadavanieKorekciiRobota_DISABLE : BOOL;
		RezimBezTlaceEtikety_DISABLE : BOOL;
		RezimBezCistenia_DISABLE : BOOL;
		IndexSuradnicovehoSystemuPaletky : USINT;
		IndexFarbyStavuFiltrov : USINT;
		IndexStavuFiltrov : USINT;
		IndexStavuPasky : USINT;
		IndexStavuLadenieKamery : USINT;
		IndexStavuLadenieKamery_Farba : USINT;
		ZobrazSymbolCS_VstupVytah : USINT;
		ZobrazSymbolCS_VystupVytah : USINT;
		ZobrazSymbolCS_Panel : USINT;
		ZobrazSymbolCS_Robot : USINT;
	END_STRUCT;
END_TYPE

(**************************Linka************************************************)

TYPE
	Linka_typ : 	STRUCT 
		IN : Linka_IN_typ;
		OUT : Linka_OUT_typ;
		PAR : Linka_PAR_typ;
		STAV : Linka_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		Majak_HukackaON : BOOL;
		CitackaQRkodu_AKTIVNA : BOOL;
		ZmenModel : BOOL;
		VymenaFiltrovPotvrdena : BOOL;
		Rezim_BezTlaceEtikety : BOOL;
		Rezim_BezKomunikacie : BOOL;
		Rezim_BezCistenia : BOOL;
	END_STRUCT;
	Linka_IN_typ : 	STRUCT 
		PrepatovaOchrana_OK : BOOL; (*1 - OK*)
		PoruchaNapajaniaMenicov : BOOL; (*1 - OK*)
		SpatnaVazba_ZonaCS : BOOL; (*1 - OK*)
		SpatnaVazba_ZonaVstupVytah : BOOL; (*1 - OK*)
		SpatnaVazba_ZonaVystupVytah : BOOL; (*1 - OK*)
		SpatnaVazba_ZonaBunky : BOOL; (*1 - OK*)
		SpatnaVazba_VentilTerminal_SQ1 : BOOL;
		SpatnaVazba_VentilTerminal_SQ2 : BOOL;
		PredneDvereZavrete_EZ1 : BOOL;
		ZadneDvereZavrete_EZ2 : BOOL;
		SmartKamera_IN0_CAM1 : BOOL;
		SmartKamera_IN1_CAM1 : BOOL;
		TlakVzduchu_OK_S2 : BOOL;
		IonJednotka_MachineON_RJ1 : BOOL;
		IonJednotka_Error_Sumary_RJ1 : BOOL;
		IonJednotka_Error_Filter1_RJ1 : BOOL;
		IonJednotka_Error_Filter2_RJ1 : BOOL;
		IonJednotka_Error_Motor_RJ1 : BOOL;
		IonJednotka_Error_Network_RJ1 : BOOL;
		IonJednotka_Error_HighVolt_RJ1 : BOOL;
		IonJednotka_Error_ComAirTC1_RJ1 : BOOL;
		IonJednotka_Error_ComAirTC2_RJ1 : BOOL;
		IonJednotka_Error_VolumeFlow_RJ1 : BOOL;
		IonJednotka_Error_TCcontrol_RJ1 : BOOL;
		IonJednotka_Error_Inverter_RJ1 : BOOL;
		IonJednotka_PoruchaNapajania : BOOL;
		SnimacRotacieHornTrysiek_1_IS7 : BOOL;
		SnimacRotacieHornTrysiek_2_IS8 : BOOL;
		SnimacRotacieHornTrysiek_3_IS9 : BOOL;
		SnimacRotacieHornTrysiek_4_IS10 : BOOL;
		SnimacRotacieSpodTrysiek_1_IS11 : BOOL;
		SnimacRotacieSpodTrysiek_2_IS12 : BOOL;
		SnimacRotacieSpodTrysiek_3_IS13 : BOOL;
	END_STRUCT;
	Linka_OUT_typ : 	STRUCT 
		Majak_ZeleneSvetlo : BOOL;
		Majak_ZlteSvetlo : BOOL;
		Majak_CerveneSvetlo : BOOL;
		Majak_Hukacka : BOOL;
		PredneDvere_Zamkni_EZ1 : BOOL;
		ZadneDvere_Zamkni_EZ2 : BOOL;
		OsvetlenieBunky_Zapni : BOOL;
		SmartKamera_OUT0_CAM1 : BOOL;
		SmartKamera_OUT1_CAM1 : BOOL;
		VT1_PowerlinkOUTPUTS : ARRAY[0..3]OF USINT;
		IonJednotka_START : BOOL;
		IonJednotka_RESET : BOOL;
		IonJednotka_AIR : BOOL;
		Vzduchotechnika_START : BOOL;
	END_STRUCT;
	Linka_PAR_typ : 	STRUCT 
		Zvoleny_MODEL : STRING[18];
		Zvoleny_LOT : STRING[11];
		Zvoleny_TypPaletky : STRING[10];
		IndexZvoleneReceptury : USINT;
		Zvolene_CisloProgramuRobota : USINT;
		Zvolene_KamCisloProg_QRkod : USINT;
		Zvolene_KamCisloProg_DMkod : USINT;
		Zvolena_PozLepenia_OffsetX : REAL;
		Zvolena_PozLepenia_OffsetY : REAL;
		Zvolena_PozLepenia_OffsetZ : REAL;
		Zvolena_RychlostDopravPriCisteni : REAL;
	END_STRUCT;
	Linka_STAV_typ : 	STRUCT 
		Automat : BOOL;
		Manual : BOOL;
		PoINIT : BOOL;
		READY_TO_START : BOOL;
		UkoncenieCyklu_BUSY : BOOL;
		Hardware_OK : BOOL;
		PrebiehaZmenaModelu : BOOL;
		PoruchaOtacaniaTrysiek : BOOL;
		FiltreIonizacnejJednotkyZanesene : BOOL;
		IonizacnaJednotka_BUSY : BOOL;
	END_STRUCT;
END_TYPE

(**************Stav hardware*****************************)

TYPE
	Hardware_STAV_typ : 	STRUCT 
		KartaAB2_ProfinetMaster_OK : BOOL;
		KartaAB3_SafetyMaster_OK : BOOL;
		KartaAB4_SafetyDI_OK : BOOL;
		KartaAB5_16DI_OK : BOOL;
		KartaAB6_16DI_OK : BOOL;
		KartaAB7_16DI_OK : BOOL;
		KartaAB8_16DO_OK : BOOL;
		KartaAB9_16DO_OK : BOOL;
		KartaAB10_X2X_OK : BOOL;
		ModulDI1_16DI_OK : BOOL;
		ModulDI2_16DI_OK : BOOL;
		ModulDI3_8DI_OK : BOOL;
		ModulSI1_4SI_OK : BOOL;
		ModulSI2_4SI_OK : BOOL;
		Komunikacia_Robot_OK : BOOL;
		Komunikacia_Kamera_OK : BOOL;
		Komunikacia_RFIDModul_OK : BOOL;
		Komunikacia_VentTerminal_OK : BOOL;
		Komunikacia_MeniceFM_OK : BOOL;
		Komunikacia_Panasonic_OK : BOOL;
	END_STRUCT;
END_TYPE

(***************VstupnyVytah*************************************)

TYPE
	VstupnyVytah_typ : 	STRUCT 
		IN : VstupnyVytah_IN_typ;
		OUT : VstupnyVytah_OUT_typ;
		PAR : VstupnyVytah_PAR_typ;
		STAV : VstupnyVytah_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		MenicZdvihu_FM2 : RiadenieFM;
		RR_Dopravnik_VPRED : BOOL;
		RR_Dopravnik_VZAD : BOOL;
	END_STRUCT;
	VstupnyVytah_IN_typ : 	STRUCT 
		RiadenieDopravnika_OK_ELR1 : BOOL;
		TeplotaMotora_OK_M1 : BOOL; (*1 - OK*)
		StavMenicaZdvihu_OK_FM2 : BOOL; (*1 - OK*)
		BannerPotvrdeny_IOS1 : BOOL;
		DvereVytahuOtvorene_MS1 : BOOL;
		DvereVytahuZatvorene_MS2 : BOOL;
		PrechodDopravnikaVytahu_OS1 : BOOL;
		PritomnostPaletky_IS3 : BOOL;
		PritomnostProduktu_OS2 : BOOL;
		ReferencnySnimacZdvihu : BOOL; (*Preposielané z FM cez komunikáciu*)
		SpodnyLimitZdvihu : BOOL; (*Preposielané z FM cez komunikáciu*)
		HornyLimitZdvihu : BOOL; (*Preposielané z FM cez komunikáciu*)
	END_STRUCT;
	VstupnyVytah_OUT_typ : 	STRUCT 
		Dopravnik_ChodVPRED_ELR1 : BOOL;
		Dopravnik_ChodVZAD_ELR1 : BOOL;
		Banner_ZelenaLED_IOS1 : BOOL;
		Banner_CervenaLED_IOS1 : BOOL;
		DvereVytahu_OTVOR_YV002 : BOOL;
		DvereVytahu_ZATVOR_YV001 : BOOL;
	END_STRUCT;
	VstupnyVytah_PAR_typ : 	STRUCT 
		Zdvih_ZadanaPozicia : UDINT;
		Zdvih_ZadanaRychlost : REAL;
		Zdvih_ZadanaJoggRychlost : REAL;
		PotvrdenieBannerom_AKTIVNE : BOOL;
	END_STRUCT;
	VstupnyVytah_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		Zdvih_AktualnaPozicia : UDINT;
		Zdvih_AktualnaRychlost : REAL;
		Zdvih_HomingOK : BOOL;
		Zdvih_BUSY : BOOL;
		Homing_BUSY : BOOL;
		Zdvih_PoziciaDosiahnuta : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
		VytahNapolohovany : BOOL;
		ObsluhaPotvrdilaBanner : BOOL;
	END_STRUCT;
END_TYPE

(***************StoperPredCistenim*************************************)

TYPE
	StoperPredCistenim_typ : 	STRUCT 
		IN : StoperPredCistenim_IN_typ;
		OUT : StoperPredCistenim_OUT_typ;
		PAR : StoperPredCistenim_PAR_typ;
		STAV : StoperPredCistenim_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	StoperPredCistenim_IN_typ : 	STRUCT 
		PritomnostPaletky_IS4 : BOOL;
	END_STRUCT;
	StoperPredCistenim_OUT_typ : 	STRUCT 
		StoperZASUN_YV005 : BOOL;
	END_STRUCT;
	StoperPredCistenim_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	StoperPredCistenim_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
	END_STRUCT;
END_TYPE

(***************StoperPoCisteni*************************************)

TYPE
	StoperPoCisteni_typ : 	STRUCT 
		IN : StoperPoCisteni_IN_typ;
		OUT : StoperPoCisteni_OUT_typ;
		PAR : StoperPoCisteni_PAR_typ;
		STAV : StoperPoCisteni_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	StoperPoCisteni_IN_typ : 	STRUCT 
		PritomnostPaletky_IS6 : BOOL;
		ZaplnenieBuffera_IS5 : BOOL;
	END_STRUCT;
	StoperPoCisteni_OUT_typ : 	STRUCT 
		StoperZASUN_YV006 : BOOL;
	END_STRUCT;
	StoperPoCisteni_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	StoperPoCisteni_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
	END_STRUCT;
END_TYPE

(***************DopravnikCistenia*************************************)

TYPE
	DopravCistenia_typ : 	STRUCT 
		IN : DopravCistenia_IN_typ;
		OUT : DopravCistenia_OUT_typ;
		PAR : DopravCistenia_PAR_typ;
		STAV : DopravCistenia_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		MenicDopravnika_FM1 : RiadenieFM;
		RR_Chod_VPRED : BOOL;
		RR_Chod_VZAD : BOOL;
		Dopravnik_RUN : BOOL;
	END_STRUCT;
	DopravCistenia_IN_typ : 	STRUCT 
		StavMenica_OK_FM1 : BOOL; (*1 - OK*)
	END_STRUCT;
	DopravCistenia_OUT_typ : 	STRUCT 
		New_Member : USINT;
	END_STRUCT;
	DopravCistenia_PAR_typ : 	STRUCT 
		ZadanaRychlost : REAL;
		ZadanaJoggRychlost : REAL;
	END_STRUCT;
	DopravCistenia_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		AktualnaRychlost : REAL;
		BUSY : BOOL;
	END_STRUCT;
END_TYPE

(***************DopravnikBunky*************************************)

TYPE
	DopravBunky_typ : 	STRUCT 
		IN : DopravBunky_IN_typ;
		OUT : DopravBunky_OUT_typ;
		PAR : DopravBunky_PAR_typ;
		STAV : DopravBunky_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	DopravBunky_IN_typ : 	STRUCT 
		RiadenieDopravnika_OK_ELR4 : BOOL;
		TeplotaMotora_OK_M4 : BOOL; (*1 - OK*)
	END_STRUCT;
	DopravBunky_OUT_typ : 	STRUCT 
		Dopravnik_ChodVPRED_ELR4 : BOOL;
	END_STRUCT;
	DopravBunky_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	DopravBunky_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
	END_STRUCT;
END_TYPE

(***************StoperEtiketovania*************************************)

TYPE
	StoperEtiketovania_typ : 	STRUCT 
		IN : StoperEtiketovania_IN_typ;
		OUT : StoperEtiketovania_OUT_typ;
		PAR : StoperEtiketovania_PAR_typ;
		STAV : StoperEtiketovania_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		RR_VytlacEtiketu : BOOL;
		OdosliDataDoPanasonicu : BOOL;
	END_STRUCT;
	StoperEtiketovania_IN_typ : 	STRUCT 
		Tlaciaren_KoniecEtikiet : BOOL;
		Tlaciaren_KoniecPasky : BOOL;
		Tlaciaren_Porucha : BOOL;
		Tlaciaren_KoniecTlace : BOOL;
		Tlaciaren_Offline : BOOL;
		Tlaciaren_Dispending : BOOL;
		PritomnostPaletky_IS16 : BOOL;
		Centrovanie_HornaPoloha_IS18 : BOOL;
		Centrovanie_SpodnaPoloha_IS17 : BOOL;
		SuflikTlaciarne_LS_IS23 : BOOL;
		SuflikTlaciarne_PS_IS22 : BOOL;
	END_STRUCT;
	StoperEtiketovania_OUT_typ : 	STRUCT 
		Tlaciaren_VytlacEtiketu : BOOL;
		Tlaciaren_VytlacZnovaEtiketu : BOOL;
		Centrovanie_VYSUN_YV003 : BOOL;
		Centrovanie_ZASUN_YV004 : BOOL;
		StoperZASUN_YV007 : BOOL;
	END_STRUCT;
	StoperEtiketovania_PAR_typ : 	STRUCT 
		TypPaletky_RucneVytlacEtikety : STRING[3];
	END_STRUCT;
	StoperEtiketovania_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
		TlaciarenZaaretovana : BOOL;
		Etiketovanie_BUSY : BOOL;
		VyvazamPaletkuNG : BOOL;
		AlarmTextPaletkyNG : STRING[30];
	END_STRUCT;
END_TYPE

(***************Robot************************************)

TYPE
	Robot_typ : 	STRUCT 
		IN : Robot_IN_typ;
		OUT : Robot_OUT_typ;
		KOM_IN : RobotKOM_IN_typ;
		KOM_OUT : RobotKOM_OUT_typ;
		PAR : Robot_PAR_typ;
		STAV : Robot_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		PrisavanieEtikety_ZAPNI : BOOL;
		Odparkovanie : BOOL;
		RR_PresunPoziciaCitaniaQRkodu : BOOL;
		RR_PresunPoziciaCitaniaDMkodu : BOOL;
		RR_PresunPoziciaOdobratiaEtikety : BOOL;
		RR_PresunPoziciaNalepeniaEtikety : BOOL;
	END_STRUCT;
	Robot_IN_typ : 	STRUCT 
		PrisatieEtikety_OK_S1 : BOOL;
	END_STRUCT;
	Robot_OUT_typ : 	STRUCT 
		PrisavanieEtikety_ZAPNI_YV013 : BOOL;
		PrisavanieEtikety_VYPNI_YV014 : BOOL;
	END_STRUCT;
	Robot_PAR_typ : 	STRUCT 
		New_Member : USINT;
	END_STRUCT;
	Robot_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
	END_STRUCT;
	RobotKOM_IN_typ : 	STRUCT 
		Stav_RobotOdparkovany : BOOL;
		Stav_RobotDrziEtiketu : BOOL;
		Stav_RobotCinnostUkoncena : BOOL;
		Stav_MotoryON : BOOL;
		Stav_MotoryOFF : BOOL;
		Stav_ProgramRUN : BOOL;
		Stav_RezimAUTOMAT : BOOL;
		Stav_RobotCS : BOOL;
		Stav_VystupyZresetovane : BOOL;
		Stav_ZonaNavratuRobota_OK : BOOL;
		Stav_ZonaNavratuRobota_NG : BOOL;
		Stav_PoruchaRobota : BOOL;
		Profinet_PLC_INPUTS : ARRAY[0..63]OF USINT;
	END_STRUCT;
	RobotKOM_OUT_typ : 	STRUCT 
		ZapniMotory : BOOL;
		VypniMotory : BOOL;
		PP_na_Main : BOOL;
		Reset_CS : BOOL;
		StartProgramu : BOOL;
		StartProgramuMain : BOOL;
		StopProgramu : BOOL;
		OdparkujRobota : BOOL;
		ServisnaPozicia : BOOL;
		ZahodEtiketu : BOOL;
		NalepEtiketu : BOOL;
		PresunDoVychodiskovejPozicie : BOOL;
		PresunDoMutingPozicie : BOOL;
		PresunDoPozicieOdobratiaEtikety : BOOL;
		PresunDoPoziceKontrolyEtikety : BOOL;
		PresunDoPoziceKontrEtiketyPriamo : BOOL;
		PresunDoPozicieKontrolyIntStitku : BOOL;
		CitanieStitkuUkoncene : BOOL;
		UkoncenieCykluRobota : BOOL;
		CisloProduktu : USINT;
		LepenieStitku_OffsetX : USINT;
		LepenieStitku_OffsetY : USINT;
		LepenieStitku_OffsetZ : USINT;
		LepenieStitku_ZnamienkoOffsetX : BOOL;
		LepenieStitku_ZnamienkoOffsetY : BOOL;
		LepenieStitku_ZnamienkoOffsetZ : BOOL;
		Profinet_PLC_OUTPUTS : ARRAY[0..63]OF USINT;
	END_STRUCT;
END_TYPE

(***************StoperDopravnikaNG*************************************)

TYPE
	StoperDopravnikaNG_typ : 	STRUCT 
		IN : StoperDopravnikaNG_IN_typ;
		OUT : StoperDopravnikaNG_OUT_typ;
		PAR : StoperDopravnikaNG_PAR_typ;
		STAV : StoperDopravnikaNG_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		RR_Dopravnik_VPRED : BOOL;
		RR_Dopravnik_VZAD : BOOL;
	END_STRUCT;
	StoperDopravnikaNG_IN_typ : 	STRUCT 
		Stoper_PritomnostPaletky_IS15 : BOOL;
		Dopravnik_PritomnostPaletky_OS4 : BOOL;
		Dopravnik_PritomnostProduktu_OS3 : BOOL;
		Centrovanie_HornaPoloha_IS19 : BOOL;
		Centrovanie_StrednaPoloha_IS20 : BOOL;
		Centrovanie_SpodnaPoloha_IS21 : BOOL;
		RiadenieDopravnika_OK_ELR3 : BOOL;
		TeplotaMotora_OK_M3 : BOOL; (*1 - OK*)
	END_STRUCT;
	StoperDopravnikaNG_OUT_typ : 	STRUCT 
		NatlakujTlmicPaletky_YV008 : BOOL;
		Centrovanie_VYSUN_YV009 : BOOL; (*Transport na NG dopravník*)
		Centrovanie_ZASUN_YV010 : BOOL; (*Transport na výstupný dopravník*)
		Dopravnik_ChodVPRED_ELR3 : BOOL;
		Dopravnik_ChodVZAD_ELR3 : BOOL;
	END_STRUCT;
	StoperDopravnikaNG_PAR_typ : 	STRUCT 
		New_Member : USINT;
	END_STRUCT;
	StoperDopravnikaNG_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		ObsluhaPotvrdilaPaletkuNG : BOOL;
		ObsluhaPotvrdilaZrusPaletkyNG : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
		PaletkaNaKonciDopravnika_NG : BOOL;
		DopravnikNG_BUSY : BOOL;
	END_STRUCT;
END_TYPE

(***************VystupnyDopravnik*************************************)

TYPE
	VystupnyDopravnik_typ : 	STRUCT 
		IN : VystupnyDopravnik_IN_typ;
		OUT : VystupnyDopravnik_OUT_typ;
		PAR : VystupnyDopravnik_PAR_typ;
		STAV : VystupnyDopravnik_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	VystupnyDopravnik_IN_typ : 	STRUCT 
		RiadenieDopravnika_OK_ELR5 : BOOL;
		TeplotaMotora_OK_M5 : BOOL;
	END_STRUCT;
	VystupnyDopravnik_OUT_typ : 	STRUCT 
		Dopravnik_ChodVPRED_ELR5 : BOOL;
	END_STRUCT;
	VystupnyDopravnik_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	VystupnyDopravnik_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
	END_STRUCT;
END_TYPE

(***************StoperVystupDopravnika*************************************)

TYPE
	StoperVystupDopravnika_typ : 	STRUCT 
		IN : StoperVystupDopravnika_IN_typ;
		OUT : StoperVystupDopravnika_OUT_typ;
		PAR : StoperVystupDopravnika_PAR_typ;
		STAV : StoperVystupDopravnika_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	StoperVystupDopravnika_IN_typ : 	STRUCT 
		PritomnostPaletky_IS27 : BOOL;
		ZaplnenieBuffera_IS28 : BOOL;
	END_STRUCT;
	StoperVystupDopravnika_OUT_typ : 	STRUCT 
		StoperZASUN_YV011 : BOOL;
	END_STRUCT;
	StoperVystupDopravnika_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	StoperVystupDopravnika_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
	END_STRUCT;
END_TYPE

(***************VystupnyVytah*************************************)

TYPE
	VystupnyVytah_typ : 	STRUCT 
		IN : VystupnyVytah_IN_typ;
		OUT : VystupnyVytah_OUT_typ;
		PAR : VystupnyVytah_PAR_typ;
		STAV : VystupnyVytah_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
		MenicZdvihu_FM3 : RiadenieFM;
		RR_Dopravnik_VPRED : BOOL;
		RR_Dopravnik_VZAD : BOOL;
	END_STRUCT;
	VystupnyVytah_IN_typ : 	STRUCT 
		RiadenieDopravnika_OK_ELR6 : BOOL;
		TeplotaMotora_OK_M6 : BOOL; (*1 - OK*)
		StavMenicaZdvihu_OK_FM3 : BOOL; (*1 - OK*)
		BannerPotvrdeny_IOS2 : BOOL;
		PritomnostPaletky_IS26 : BOOL;
		PritomnostProduktu_OS5 : BOOL;
		PrechodDopravnikaVytahu_OS6 : BOOL;
		ReferencnySnimacZdvihu : BOOL; (*Preposielané z FM cez komunikáciu*)
		SpodnyLimitZdvihu : BOOL; (*Preposielané z FM cez komunikáciu*)
		HornyLimitZdvihu : BOOL; (*Preposielané z FM cez komunikáciu*)
		SpodnySpomalovaciSnimac : BOOL;
		HornySpomalovaciSnimac : BOOL;
	END_STRUCT;
	VystupnyVytah_OUT_typ : 	STRUCT 
		Dopravnik_ChodVPRED_ELR6 : BOOL;
		Dopravnik_ChodVZAD_ELR6 : BOOL;
		Banner_ZelenaLED_IOS2 : BOOL;
		Banner_CervenaLED_IOS2 : BOOL;
	END_STRUCT;
	VystupnyVytah_PAR_typ : 	STRUCT 
		Zdvih_ZadanaPozicia : UDINT;
		Zdvih_ZadanaRychlost : REAL;
		Zdvih_ZadanaJoggRychlost : REAL;
		PotvrdenieBannerom_AKTIVNE : BOOL;
		PotvrdenieNGkusuBannerom_AKTIVNE : BOOL;
	END_STRUCT;
	VystupnyVytah_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		Zdvih_AktualnaPozicia : UDINT;
		Zdvih_AktualnaRychlost : REAL;
		Zdvih_HomingOK : BOOL;
		Zdvih_BUSY : BOOL;
		Homing_BUSY : BOOL;
		Zdvih_PoziciaDosiahnuta : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
		VytahNapolohovany : BOOL;
	END_STRUCT;
END_TYPE

(***************VratnyDopravnik*************************************)

TYPE
	VratnyDopravnik_typ : 	STRUCT 
		IN : VratnyDopravnik_IN_typ;
		OUT : VratnyDopravnik_OUT_typ;
		PAR : VratnyDopravnik_PAR_typ;
		STAV : VratnyDopravnik_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	VratnyDopravnik_IN_typ : 	STRUCT 
		RiadenieDopravnika_OK_ELR2 : BOOL;
		TeplotaMotora_OK_M2 : BOOL;
	END_STRUCT;
	VratnyDopravnik_OUT_typ : 	STRUCT 
		Dopravnik_ChodVPRED_ELR2 : BOOL;
	END_STRUCT;
	VratnyDopravnik_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	VratnyDopravnik_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
	END_STRUCT;
END_TYPE

(***************StoperVratnehoDopravnika*************************************)

TYPE
	StoperVratDopravnika_typ : 	STRUCT 
		IN : StoperVratDopravnika_IN_typ;
		OUT : StoperVratDopravnika_OUT_typ;
		PAR : StoperVratDopravnika_PAR_typ;
		STAV : StoperVratDopravnika_STAV_typ;
		Automat : BOOL;
		Manual : BOOL;
		Reset : BOOL;
		KoniecCyklu : BOOL;
	END_STRUCT;
	StoperVratDopravnika_IN_typ : 	STRUCT 
		PritomnostPaletky_IS14 : BOOL;
	END_STRUCT;
	StoperVratDopravnika_OUT_typ : 	STRUCT 
		StoperZASUN_YV012 : BOOL;
	END_STRUCT;
	StoperVratDopravnika_PAR_typ : 	STRUCT 
		PAR_0 : USINT;
	END_STRUCT;
	StoperVratDopravnika_STAV_typ : 	STRUCT 
		PoINIT : BOOL;
		PrebiehaVyvazaniePaletky : BOOL;
	END_STRUCT;
END_TYPE

(*****************Kamera*****************************************)

TYPE
	CAM_typ : 	STRUCT 
		CMD : CAM_CMD_typ;
		PAR : CAM_PAR_typ;
		STAV : CAM_STAV_typ;
		RESULT : CAM_RESULTS_typ;
		Profinet_InterEtiketaQRznaky : ARRAY[0..63]OF USINT;
		Profinet_ZakazEtiketaDMznaky : ARRAY[0..63]OF USINT;
		Profinet_PLC_INPUTS : ARRAY[0..10]OF USINT;
		Profinet_PLC_OUTPUTS : USINT;
	END_STRUCT;
	CAM_CMD_typ : 	STRUCT 
		Triger : BOOL;
	END_STRUCT;
	CAM_PAR_typ : 	STRUCT 
		ZadaneCisloProgramu : USINT;
	END_STRUCT;
	CAM_STAV_typ : 	STRUCT 
		BUSY : BOOL;
		SWITCH : BOOL;
		READY : BOOL;
		Results_READY : BOOL;
		AktualneCisloProgramu : USINT;
		RUN_Counter : USINT;
		Old_Hodnota_RUN_Counter : USINT;
	END_STRUCT;
	CAM_RESULTS_typ : 	STRUCT 
		ZakazEtiketa_DMkod_OK : BOOL;
		InternaEtiketa_QRkod_OK : BOOL;
		ZakazEtiketa_PritomnZnakov_OK : BOOL;
		BielyPatern_OK : BOOL;
		InternaEtiketa_ZnakyQRkodu : STRING[64];
		ZakazEtiketa_ZnakyDMkodu : STRING[64];
	END_STRUCT;
END_TYPE

(*************Parametre paletky*********************)

TYPE
	Paletka_typ : 	STRUCT 
		StavPaletky : STRING[2]; (*OK alebo NG*)
		CisloPaletky : STRING[4]; (*Preèítané èitaèkou RFID*)
		TypPaletky : STRING[4]; (*Preèítané èitaèkou RFID*)
		NazovPaletky : STRING[10]; (*Vyskladaný z èísla paletky a typu paletky*)
		NazovModelu : STRING[18]; (*Naèítaný z èitaèky*)
		CisloLOT : STRING[20]; (*Naèítaný z èitaèky*)
		Robot_CisloProgramu : USINT;
		Kamera_CisloProgramu_QRkod : USINT;
		Kamera_CisloProgramu_DMkod : USINT;
		TypVyroby : STRING[1]; (*Vždy druhý znak z Lotu  0 - Regular, S - Sample, P - Preproduct, E - Early evaluation *)
		InternySerialNumber : STRING[48]; (*Preèítaný z kapacitora*)
		ZakaznickeCislo : STRING[49]; (*Prijaté zo servera*)
		PrecitaneZnakyZakaznickehoDMkodu : STRING[49]; (*Preèítané zo zákaznickej etikety*)
		ReturnProcessName : STRING[30];
		Cistenie_DONE : BOOL;
		StavCistenia : STRING[2]; (*OK alebo NG*)
		NalepenieEtikety_DONE : BOOL;
		StavNalepeniaEtikety : STRING[2]; (*OK alebo NG*)
		StavCitania_InternehoQRkodu : STRING[2]; (*OK alebo NG*)
		StavCitania_ZakaznickehoDMkodu : STRING[2]; (*OK alebo NG*)
		StavCitania_KontrolaZnakov : STRING[2]; (*OK alebo NG*)
		StavPorovnaniaDMkoduZoServerom : STRING[2]; (*OK alebo NG*)
		StavKontrolyBielehoPaternu : STRING[2]; (*OK alebo NG*)
		StavKomunikacie_DONE : BOOL;
	END_STRUCT;
END_TYPE

(*************Historia výroby************************)

TYPE
	HystoriaVyroby_typ : 	STRUCT 
		NazovModelu : STRING[18];
		NazovLOTU : STRING[11];
		PocetVyrobenychKusov_OK : UDINT;
		PocetVyrobenychKusov_NG : UDINT;
	END_STRUCT;
END_TYPE

(*************Motohodiny****************************)

TYPE
	Motohodiny_typ : 	STRUCT 
		Milisekundy : UINT;
		Sekundy : USINT;
		Minuty : USINT;
		Hodiny : USINT;
		Dny : UDINT;
		CelkovyPocetHodin : UDINT;
		START : BOOL;
		RESET : BOOL;
	END_STRUCT;
END_TYPE


TYPE
	MenicSTAV_typ : 	STRUCT 
		PORUCHA : BOOL;
		Pozicia_DOSIAHNUTA : BOOL;
		RUN : BOOL;
		READY : BOOL;
		Homing_OK : BOOL;
		ParamSada_BIT0_ENABLE : BOOL;
		ParamSada_BIT1_ENABLE : BOOL;
		QuickStop_Aktivny : BOOL;
		Komunikacia_OK : BOOL;
	END_STRUCT;
	MenicCMD_typ : 	STRUCT 
		Chod_VPRED : BOOL;
		Chod_VZAD : BOOL;
		QuickSTOP : BOOL;
		Polohuj : BOOL;
		Potvrd_PORUCHU : BOOL;
		HOME : BOOL;
		Pozicia_RESET : BOOL;
	END_STRUCT;
	MenicPAR_typ : 	STRUCT 
		ZadanaFrekvencia_Hz : REAL;
		AktualnaFrekvencia_Hz : REAL;
		AktualnyMoment_Nm : REAL;
		ZadanaPozicia_MM : UDINT;
		AktualnaPozicia_MM : UDINT;
		TypKomunikacieProfinet : BOOL; (*0 - Powerlink, 1- Profinet*)
		SwapovanieKomunikacie : BOOL; (*0 - NIE, 1 - ANO*)
		BUS_IN_Bit_0 : BOOL;
		BUS_IN_Bit_1 : BOOL;
		BUS_IN_Bit_2 : BOOL;
		BUS_IN_Bit_3 : BOOL;
		BUS_IN_Bit_4 : BOOL;
		BUS_IN_Bit_5 : BOOL;
		BUS_IN_Bit_6 : BOOL;
		BUS_OUT_Bit_0 : BOOL;
		BUS_OUT_Bit_1 : BOOL;
		BUS_OUT_Bit_2 : BOOL;
		BUS_OUT_Bit_3 : BOOL;
		BUS_OUT_Bit_4 : BOOL;
		BUS_OUT_Bit_5 : BOOL;
		BUS_OUT_Bit_6 : BOOL;
	END_STRUCT;
	PowerlinkKOM_IN_typ : 	STRUCT 
		StavoveSlovo : UINT;
		StavovaHodnota_1 : INT;
		StavovaHodnota_2 : INT;
		StavovaHodnota_3 : INT;
		StavovaHodnota_4 : INT;
		StavovaHodnota_5 : INT;
	END_STRUCT;
	PowerlinkKOM_OUT_typ : 	STRUCT 
		RiadiaceSlovo : UINT;
		ZadanaHodnota_1 : INT;
		ZadanaHodnota_2 : INT;
		ZadanaHodnota_3 : INT;
		ZadanaHodnota_4 : INT;
		ZadanaHodnota_5 : INT;
	END_STRUCT;
	ProfinetKOM_IN_typ : 	STRUCT 
		StavoveSlovo : UINT;
		StavovaHodnota_1 : UINT;
		StavovaHodnota_2 : UINT;
		StavovaHodnota_3 : UINT;
		StavovaHodnota_4 : UINT;
		StavovaHodnota_5 : UINT;
	END_STRUCT;
	ProfinetKOM_OUT_typ : 	STRUCT 
		RiadiaceSlovo : UINT;
		ZadanaHodnota_1 : UINT;
		ZadanaHodnota_2 : UINT;
		ZadanaHodnota_3 : UINT;
		ZadanaHodnota_4 : UINT;
		ZadanaHodnota_5 : UINT;
	END_STRUCT;
END_TYPE

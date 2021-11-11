
TYPE
	Inputs_typ : 	STRUCT 
		ProcessResult : BOOL;
		RFID_Reading_Error : BOOL;
		Blowing_Error : BOOL;
		QRcode_Reading_Error : BOOL;
		DMcode_Reading_Error : BOOL;
		Text_Reading_Error : BOOL;
		VytlacEtiketu_RucnyRezim : BOOL;
		RezimBezTlaceEtikety : BOOL;
		CommandNumber : UDINT;
		SerialNumber_InternaEtiketa : STRING[48];
		NazovPaletky_RFID : STRING[10];
		Cislo_LOTU : STRING[20];
		DataForServer_READY : BOOL;
	END_STRUCT;
	Outputs_typ : 	STRUCT 
		ContinueToNextProcess : BOOL;
		SerialNumber_ZakaznickaEtiketa : STRING[49];
		ReturnProcessName : STRING[30];
		DataForPLC_READY : BOOL;
		LastCommandNumber : UDINT;
	END_STRUCT;
END_TYPE

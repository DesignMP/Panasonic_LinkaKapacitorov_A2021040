
ACTION KOM_Kamera: 

	//Reset napájania kamery//
	IF Linka.ResetNapajaniaKamery THEN
		Linka.OUT.Rele_ResetNapajaniaKamery:= TRUE;
		Linka.ResetNapajaniaKamery:= FALSE;
	END_IF
	
	CasResetovaniaKamery.IN:= Linka.OUT.Rele_ResetNapajaniaKamery;
	IF CasResetovaniaKamery.Q THEN
		Linka.OUT.Rele_ResetNapajaniaKamery:= FALSE;
	END_IF	
	
	
	CasResetovaniaKamery.PT:= T#2s;
	CasResetovaniaKamery();
	
	
	//Triger kamery//
	Kamera.Profinet_PLC_OUTPUTS.0:= Kamera.CMD.Triger;
	
	//Stav kamera READY//
	Kamera.STAV.READY:= StavHardware.Komunikacia_Kamera_OK;
	
	
	//Toogle bit kamery//
	Kamera.STAV.SWITCH:= Kamera.Profinet_PLC_INPUTS[4].0;
	
	//Stav - výsledky READY//
	IF EDGE(Kamera.STAV.SWITCH)THEN
		Kamera.STAV.Results_READY:= TRUE;
	END_IF

	
	//Stav - èítanie QR kódu alebi DM kódu OK//
	Kamera.RESULT.InternaEtiketa_QRkod_OK:= Kamera.Profinet_PLC_INPUTS[5].0;
	Kamera.RESULT.ZakazEtiketa_DMkod_OK:= Kamera.Profinet_PLC_INPUTS[5].1;
	Kamera.RESULT.ZakazEtiketa_PritomnZnakov_OK:= Kamera.Profinet_PLC_INPUTS[5].2;
	Kamera.RESULT.BielyPatern_OK:= Kamera.Profinet_PLC_INPUTS[5].3;
	
	//Vnútorné  poèítadlo kamery//
	Kamera.STAV.RUN_Counter;

	//Zadané èíslo programu kamery//
	Kamera.PAR.ZadaneCisloProgramu;
	
	//Èíslo aktuálneho programu kamery//
	Kamera.STAV.AktualneCisloProgramu;
	
	
	//Zistenie poètu znakov Interného QR kódu//
	PocetNacitZnakovQRkodu := brsstrlen(ADR(Kamera.Profinet_InterEtiketaQRznaky));
	
	//Zistenie poètu znakov Zákaznického DM kódu//
	PocetNacitZnakovDMkodu := brsstrlen(ADR(Kamera.Profinet_ZakazEtiketaDMznaky));
	
	
	//Spájanie znakov Interného QR kódu z Pola USINT do výsledného stringu//
	brsmemcpy(ADR(Kamera.RESULT.InternaEtiketa_ZnakyQRkodu),ADR(Kamera.Profinet_InterEtiketaQRznaky),SIZEOF(Kamera.Profinet_InterEtiketaQRznaky));
	
	//Spájanie znakov Zákaznického DM kódu z Pola USINT do výsledného stringu//
	brsmemcpy(ADR(Kamera.RESULT.ZakazEtiketa_ZnakyDMkodu),ADR(Kamera.Profinet_ZakazEtiketaDMznaky),SIZEOF(Kamera.Profinet_ZakazEtiketaDMznaky));
	
	

	
	
	
	
	
END_ACTION

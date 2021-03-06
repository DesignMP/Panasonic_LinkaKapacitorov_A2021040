
ACTION KOM_Kamera: 

	//Reset nap�jania kamery//
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
	
	//Stav - v�sledky READY//
	IF EDGE(Kamera.STAV.SWITCH)THEN
		Kamera.STAV.Results_READY:= TRUE;
	END_IF

	
	//Stav - ��tanie QR k�du alebi DM k�du OK//
	Kamera.RESULT.InternaEtiketa_QRkod_OK:= Kamera.Profinet_PLC_INPUTS[5].0;
	Kamera.RESULT.ZakazEtiketa_DMkod_OK:= Kamera.Profinet_PLC_INPUTS[5].1;
	Kamera.RESULT.ZakazEtiketa_PritomnZnakov_OK:= Kamera.Profinet_PLC_INPUTS[5].2;
	Kamera.RESULT.BielyPatern_OK:= Kamera.Profinet_PLC_INPUTS[5].3;
	
	//Vn�torn�  po��tadlo kamery//
	Kamera.STAV.RUN_Counter;

	//Zadan� ��slo programu kamery//
	Kamera.PAR.ZadaneCisloProgramu;
	
	//��slo aktu�lneho programu kamery//
	Kamera.STAV.AktualneCisloProgramu;
	
	
	//Zistenie po�tu znakov Intern�ho QR k�du//
	PocetNacitZnakovQRkodu := brsstrlen(ADR(Kamera.Profinet_InterEtiketaQRznaky));
	
	//Zistenie po�tu znakov Z�kaznick�ho DM k�du//
	PocetNacitZnakovDMkodu := brsstrlen(ADR(Kamera.Profinet_ZakazEtiketaDMznaky));
	
	
	//Sp�janie znakov Intern�ho QR k�du z Pola USINT do v�sledn�ho stringu//
	brsmemcpy(ADR(Kamera.RESULT.InternaEtiketa_ZnakyQRkodu),ADR(Kamera.Profinet_InterEtiketaQRznaky),SIZEOF(Kamera.Profinet_InterEtiketaQRznaky));
	
	//Sp�janie znakov Z�kaznick�ho DM k�du z Pola USINT do v�sledn�ho stringu//
	brsmemcpy(ADR(Kamera.RESULT.ZakazEtiketa_ZnakyDMkodu),ADR(Kamera.Profinet_ZakazEtiketaDMznaky),SIZEOF(Kamera.Profinet_ZakazEtiketaDMznaky));
	
	

	
	
	
	
	
END_ACTION

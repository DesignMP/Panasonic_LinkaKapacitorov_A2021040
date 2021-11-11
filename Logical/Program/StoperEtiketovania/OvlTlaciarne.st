
ACTION OvlTlaciarne: 

	
	//SATO parametre komunikácie//
	//IP: 192.168.1.6
	//255.255.255.0
	//Port è.:9100
	
	
	
	PrvyRiadok:= 'A5E30093844AACO';
	DruhyRiadok:= 'A5E30093844AACO@210722B0106';
	TretiRiadok:= '07/2021';
	DataMetrix:= DruhyRiadok;
	
	
		//**************************************Textové polia etikety**************************************//
		

	//Správa pre tlaèiareò SATO HR224R//
	Tlaciaren.Data.Sprava_pre_Tlaciaren:= 'A';//Zaèiatok správy
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('%0')); //rotácia textu 0 - 0°, 1 - 90°, 2 - 180°, 3 - 270°
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('A103600840')); //rozmer etikety výška 0360/24 = 15mm, šírka 0840/24 = 35mm
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0012')); //posunutie textu vertikálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0055')); //posunutie textu horizontálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('P2')); //velkost medzery medzi pismenami
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('L0710')); //násobok velkosti písma
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('U'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(PrvyRiadok));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0098')); //posunutie textu vertikálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0055')); //posunutie textu horizontálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('P2')); //velkost medzery medzi pismenami
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('L0406')); //násobok velkosti písma
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('U'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(DruhyRiadok));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0216')); //posunutie textu vertikálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0312')); //posunutie textu horizontálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('P2')); //velkost medzery medzi pismenami
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('L0609')); //násobok velkosti písma
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('U'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(TretiRiadok));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0168')); //posunutie textu vertikálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0055')); //posunutie textu horizontálne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('BX01201010000000001')); //Definícia Datametrixu
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('DC'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(DataMetrix));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('Q1')); //Poèet výtlaèkov etikety
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('Z'));//Koniec správy
	
	
	
	//Hodnotu vydelíme 24 aby sme dostali vzdialenost v mm//  
	
	
END_ACTION

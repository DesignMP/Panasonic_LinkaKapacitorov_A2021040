
ACTION OvlTlaciarne: 

	
	//SATO parametre komunik�cie//
	//IP: 192.168.1.6
	//255.255.255.0
	//Port �.:9100
	
	
	
	PrvyRiadok:= 'A5E30093844AACO';
	DruhyRiadok:= 'A5E30093844AACO@210722B0106';
	TretiRiadok:= '07/2021';
	DataMetrix:= DruhyRiadok;
	
	
		//**************************************Textov� polia etikety**************************************//
		

	//Spr�va pre tla�iare� SATO HR224R//
	Tlaciaren.Data.Sprava_pre_Tlaciaren:= 'A';//Za�iatok spr�vy
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('%0')); //rot�cia textu 0 - 0�, 1 - 90�, 2 - 180�, 3 - 270�
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('A103600840')); //rozmer etikety v��ka 0360/24 = 15mm, ��rka 0840/24 = 35mm
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0012')); //posunutie textu vertik�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0055')); //posunutie textu horizont�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('P2')); //velkost medzery medzi pismenami
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('L0710')); //n�sobok velkosti p�sma
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('U'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(PrvyRiadok));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0098')); //posunutie textu vertik�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0055')); //posunutie textu horizont�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('P2')); //velkost medzery medzi pismenami
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('L0406')); //n�sobok velkosti p�sma
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('U'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(DruhyRiadok));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0216')); //posunutie textu vertik�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0312')); //posunutie textu horizont�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('P2')); //velkost medzery medzi pismenami
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('L0609')); //n�sobok velkosti p�sma
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('U'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(TretiRiadok));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('V0168')); //posunutie textu vertik�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('H0055')); //posunutie textu horizont�lne
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('BX01201010000000001')); //Defin�cia Datametrixu
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('DC'));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR(DataMetrix));
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('Q1')); //Po�et v�tla�kov etikety
	strcat(ADR(Tlaciaren.Data.Sprava_pre_Tlaciaren),ADR('Z'));//Koniec spr�vy
	
	
	
	//Hodnotu vydel�me 24 aby sme dostali vzdialenost v mm//  
	
	
END_ACTION

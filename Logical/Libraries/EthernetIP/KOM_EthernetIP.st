
(* Komunikacia z Panasonic *)
FUNCTION_BLOCK KOM_EthernetIP
	
	//**********************************Výstupy z PLC do Panasonic*******************************************************//
	//Výsledok procesu//
	Mapping_OUT[0].0:= Server_IN.ProcessResult;
	
	//Chyba èítania èipu paletky//
	Mapping_OUT[0].1:= Server_IN.RFID_Reading_Error;
	
	//Chyba v procese èistenia//
	Mapping_OUT[0].2:= Server_IN.Blowing_Error;
	
	
	//Chyba preèítania QR kódu interného štítku//
	Mapping_OUT[0].3:= Server_IN.QRcode_Reading_Error;
	
	//Chyba preèítania DM kódu zákaznickej etikety//
	Mapping_OUT[0].4:= Server_IN.DMcode_Reading_Error;
	
	//Chyba preèítania textu na zákaznickej etikete//
	Mapping_OUT[0].5:= Server_IN.Text_Reading_Error;
	
	//Vytlaèenie etikety v ruènom režime//
	Mapping_OUT[0].6:= Server_IN.VytlacEtiketu_RucnyRezim;
	
	//Režim bez tlaèe etikety//
	Mapping_OUT[0].7:= Server_IN.RezimBezTlaceEtikety;
	
	//Èíslo výrobného procesu//
	Mapping_OUT[1]:= Server_IN.CommandNumber;
	
	
		
	
	
	
	
	//Sériové èíslo internej etikety//
	brsstrcpy(ADR(SerNumber_InterEtiketa_PoleUSINT),ADR(Server_IN.SerialNumber_InternaEtiketa));
	
	FOR a:= 0 TO 47 BY 1 DO
		SerNumber_InterEtiketa_PoleUDINT[a]:= SerNumber_InterEtiketa_PoleUSINT[a];
	END_FOR	
	
	brsmemcpy(ADR(Mapping_OUT[2]),ADR(SerNumber_InterEtiketa_PoleUDINT),SIZEOF(SerNumber_InterEtiketa_PoleUDINT));
	
	
	//Názov paletky//
	brsstrcpy(ADR(NazovPaletky_RFID_PoleUSINT),ADR(Server_IN.NazovPaletky_RFID));
	
	FOR b:= 0 TO 9 BY 1 DO
		NazovPaletky_RFID_PoleUDINT[b]:= NazovPaletky_RFID_PoleUSINT[b];
	END_FOR	
	
	brsmemcpy(ADR(Mapping_OUT[50]),ADR(NazovPaletky_RFID_PoleUDINT),SIZEOF(NazovPaletky_RFID_PoleUDINT));
	
	
	
	//Èíslo LOTU//
	brsstrcpy(ADR(Cislo_LOTU_PoleUSINT),ADR(Server_IN.Cislo_LOTU));
	
	FOR c:= 0 TO 19 BY 1 DO
		Cislo_LOTU_PoleUDINT[c]:= Cislo_LOTU_PoleUSINT[c];
	END_FOR	
	
	brsmemcpy(ADR(Mapping_OUT[60]),ADR(Cislo_LOTU_PoleUDINT),SIZEOF(Cislo_LOTU_PoleUDINT));
	
	//Potvrdenie dáta pre Panasonic pripravené//
	Mapping_OUT[80].0:= Server_IN.DataForServer_READY;
	
	
	
	//*********************************Vstupy z Panasonic do PLC*********************************************************//
	//Pokraèovanie na další proces//
	Server_OUT.ContinueToNextProcess:= Mapping_IN[0].0;
	
	
	//Sériové èíslo zákaznickej etikety//
	brsmemcpy(ADR(SerNumber_ZakazEtiketa_PoleUDINT),ADR(Mapping_IN[1]),196);
	
	FOR d:= 0 TO 48 BY 1 DO
		SerNumber_ZakazEtiketa_PoleUSINT[d]:= UDINT_TO_USINT(SerNumber_ZakazEtiketa_PoleUDINT[d]);
	END_FOR	
	
	brsstrcpy(ADR(Server_OUT.SerialNumber_ZakaznickaEtiketa),ADR(SerNumber_ZakazEtiketa_PoleUSINT));
	
	
	
	
	//Return process name//
	brsmemcpy(ADR(ReturnProcessName_PoleUDINT),ADR(Mapping_IN[50]),120);
	
	FOR e:= 0 TO 29 BY 1 DO
		ReturnProcessName_PoleUSINT[e]:= UDINT_TO_USINT(ReturnProcessName_PoleUDINT[e]);
	END_FOR	
	
	brsstrcpy(ADR(Server_OUT.ReturnProcessName),ADR(ReturnProcessName_PoleUSINT));
	
	
	
	//Potvrdenie dáta pre PLC pripravené//
	Server_OUT.DataForPLC_READY:= Mapping_IN[80].0;
	
	
	//Posledné prijaté èíslo procesu//
	Server_OUT.LastCommandNumber:= Mapping_IN[81];
	
	
END_FUNCTION_BLOCK

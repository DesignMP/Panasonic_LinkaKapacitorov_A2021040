
(* Komunikacia z Panasonic *)
FUNCTION_BLOCK KOM_EthernetIP
	
	//**********************************V�stupy z PLC do Panasonic*******************************************************//
	//V�sledok procesu//
	Mapping_OUT[0].0:= Server_IN.ProcessResult;
	
	//Chyba ��tania �ipu paletky//
	Mapping_OUT[0].1:= Server_IN.RFID_Reading_Error;
	
	//Chyba v procese �istenia//
	Mapping_OUT[0].2:= Server_IN.Blowing_Error;
	
	
	//Chyba pre��tania QR k�du intern�ho �t�tku//
	Mapping_OUT[0].3:= Server_IN.QRcode_Reading_Error;
	
	//Chyba pre��tania DM k�du z�kaznickej etikety//
	Mapping_OUT[0].4:= Server_IN.DMcode_Reading_Error;
	
	//Chyba pre��tania textu na z�kaznickej etikete//
	Mapping_OUT[0].5:= Server_IN.Text_Reading_Error;
	
	//Vytla�enie etikety v ru�nom re�ime//
	Mapping_OUT[0].6:= Server_IN.VytlacEtiketu_RucnyRezim;
	
	//Re�im bez tla�e etikety//
	Mapping_OUT[0].7:= Server_IN.RezimBezTlaceEtikety;
	
	//��slo v�robn�ho procesu//
	Mapping_OUT[1]:= Server_IN.CommandNumber;
	
	
		
	
	
	
	
	//S�riov� ��slo internej etikety//
	brsstrcpy(ADR(SerNumber_InterEtiketa_PoleUSINT),ADR(Server_IN.SerialNumber_InternaEtiketa));
	
	FOR a:= 0 TO 47 BY 1 DO
		SerNumber_InterEtiketa_PoleUDINT[a]:= SerNumber_InterEtiketa_PoleUSINT[a];
	END_FOR	
	
	brsmemcpy(ADR(Mapping_OUT[2]),ADR(SerNumber_InterEtiketa_PoleUDINT),SIZEOF(SerNumber_InterEtiketa_PoleUDINT));
	
	
	//N�zov paletky//
	brsstrcpy(ADR(NazovPaletky_RFID_PoleUSINT),ADR(Server_IN.NazovPaletky_RFID));
	
	FOR b:= 0 TO 9 BY 1 DO
		NazovPaletky_RFID_PoleUDINT[b]:= NazovPaletky_RFID_PoleUSINT[b];
	END_FOR	
	
	brsmemcpy(ADR(Mapping_OUT[50]),ADR(NazovPaletky_RFID_PoleUDINT),SIZEOF(NazovPaletky_RFID_PoleUDINT));
	
	
	
	//��slo LOTU//
	brsstrcpy(ADR(Cislo_LOTU_PoleUSINT),ADR(Server_IN.Cislo_LOTU));
	
	FOR c:= 0 TO 19 BY 1 DO
		Cislo_LOTU_PoleUDINT[c]:= Cislo_LOTU_PoleUSINT[c];
	END_FOR	
	
	brsmemcpy(ADR(Mapping_OUT[60]),ADR(Cislo_LOTU_PoleUDINT),SIZEOF(Cislo_LOTU_PoleUDINT));
	
	//Potvrdenie d�ta pre Panasonic pripraven�//
	Mapping_OUT[80].0:= Server_IN.DataForServer_READY;
	
	
	
	//*********************************Vstupy z Panasonic do PLC*********************************************************//
	//Pokra�ovanie na dal�� proces//
	Server_OUT.ContinueToNextProcess:= Mapping_IN[0].0;
	
	
	//S�riov� ��slo z�kaznickej etikety//
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
	
	
	
	//Potvrdenie d�ta pre PLC pripraven�//
	Server_OUT.DataForPLC_READY:= Mapping_IN[80].0;
	
	
	//Posledn� prijat� ��slo procesu//
	Server_OUT.LastCommandNumber:= Mapping_IN[81];
	
	
END_FUNCTION_BLOCK


ACTION OvlRucnejCitackyQR: 

	//"$L"  LF - linefeed - skok na druhý riadok
	
	
	
	
	CASE RucCitackaQR.Step OF
		
		
		0://Nulovanie//
			RucCitackaQR.Command.PrimajData:= FALSE;
			RucCitackaQR.Command.ZatvorKomunikaciu:= FALSE;
			RucCitackaQR.Command.PotvrdeniePoruchy:= FALSE;
			RucCitackaQR.Status.PoruchaOtvoreniaKomunikacie:= FALSE;
			RucCitackaQR.Status.PoruchaZatvoreniaKomunikacie:= FALSE;
			RucCitackaQR.Status.PoruchaCitaniaDat:= FALSE;
			RucCitackaQR.Status.PoruchaUvolneniaRECEIVE_Buffera:= FALSE;
			RucCitackaQR.Step:= 1;
		
		1://Rozhodnutie o èinnosti//
			IF RucCitackaQR.Command.PrimajData THEN
				RucCitackaQR.Step:= 10;
			ELSIF Linka.CitackaQRkodu_AKTIVNA THEN
				RucCitackaQR.Step:= 10;
			END_IF
		
		
		
			
			
		10://Prímanie dát - otvorenie seriovej komunikácie//
			RucCitackaQR.FRM_xopen_0.enable:= TRUE;
			RucCitackaQR.FRM_xopen_0.device:=  ADR('IF1');
			RucCitackaQR.FRM_xopen_0.mode:= ADR('/PHY=RS232 /BD=115200 /DB=8 /PA=N /SB=1'); 
			RucCitackaQR.FRM_xopen_0.config:= ADR(RucCitackaQR.xopenConfig);
			
			RucCitackaQR.xopenConfig.idle:= 100;
			RucCitackaQR.xopenConfig.delimc:= 0;
			RucCitackaQR.xopenConfig.delim[0]:= 0;
			RucCitackaQR.xopenConfig.delim[1]:= 0;
			RucCitackaQR.xopenConfig.tx_cnt:= 3;
			RucCitackaQR.xopenConfig.rx_cnt:= 3;
			RucCitackaQR.xopenConfig.tx_len:= 256;
			RucCitackaQR.xopenConfig.rx_len:= 256;
			RucCitackaQR.xopenConfig.argc:= 0;
			RucCitackaQR.xopenConfig.argv:= 0;
		
			RucCitackaQR.FRM_xopen_0();
		
			IF RucCitackaQR.FRM_xopen_0.status = 0 THEN   //Otvorenie komunikácie prebehlo OK
				RucCitackaQR.Step:= 11;
			ELSIF RucCitackaQR.FRM_xopen_0.status = 65535 THEN  //Prebieha otvorenie komunikácie - stav BUSY
				RucCitackaQR.Step:= 10;
			ELSE	
				RucCitackaQR.Status.PoruchaOtvoreniaKomunikacie:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha otvorenia komunikácie
			END_IF	
			
			
		11://Prímanie dát - èítanie dát z komunikácie//
			RucCitackaQR.FRM_read_0.enable:= TRUE;
			RucCitackaQR.FRM_read_0.ident:= RucCitackaQR.FRM_xopen_0.ident;
			RucCitackaQR.FRM_read_0();
			
			IF RucCitackaQR.FRM_read_0.status = 0 THEN //Èítanie dát z komunikácie prebehlo OK
				RucCitackaQR.Step:= 12;
			ELSIF RucCitackaQR.Command.ZatvorKomunikaciu THEN
				RucCitackaQR.Step:= 0;
			ELSIF NOT Linka.CitackaQRkodu_AKTIVNA THEN
				RucCitackaQR.Step:= 0;
			ELSIF RucCitackaQR.FRM_read_0.status = 60 THEN //Prebieha èítanie dát z komunikácie - stav žiadne dáta
				RucCitackaQR.Step:= 11;
			ELSIF RucCitackaQR.FRM_read_0.status = 8079 THEN //Prišli zlé alebo neúplné dáta
				RucCitackaQR.Step:= 18;
			ELSE
				RucCitackaQR.Status.PoruchaCitaniaDat:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha èítania dát z komunikácie
			END_IF
			
		12://Prímanie dát - kopírovanie dát do RECEIVE buffera//
			brsmemset(ADR(RucCitackaQR.PrecitaneData),0,SIZEOF(RucCitackaQR.PrecitaneData)); //Vynulovanie preèítanej správy
			brsmemcpy(ADR(RucCitackaQR.PrecitaneData),RucCitackaQR.FRM_read_0.buffer,RucCitackaQR.FRM_read_0.buflng); //Zkopírovanie dát z RECEIVE buffera do preèítanej správy
			RucCitackaQR.Step:= 18;
			
		
		18://Prímanie dát - uvolnenie RECEIVE buffera//
			RucCitackaQR.FRM_rbuf_0.enable:= TRUE;
			RucCitackaQR.FRM_rbuf_0.buffer:= RucCitackaQR.FRM_read_0.buffer;  
			RucCitackaQR.FRM_rbuf_0.buflng:= RucCitackaQR.FRM_read_0.buflng;
			RucCitackaQR.FRM_rbuf_0.ident:= RucCitackaQR.FRM_xopen_0.ident;
			RucCitackaQR.FRM_rbuf_0();
			
			IF RucCitackaQR.FRM_rbuf_0.status = 0 THEN //Uvolnenie RECEIVE buffera prebehlo OK
				IF RucCitackaQR.Command.ZatvorKomunikaciu THEN
					RucCitackaQR.Step:= 20;
				ELSE
					RucCitackaQR.Step:= 11;
				END_IF
			ELSIF RucCitackaQR.FRM_rbuf_0.status = 65535 THEN //Prebieha uvolnenie RECEIVE buffera - stav BUSY
				RucCitackaQR.Step:= 18;
			ELSIF RucCitackaQR.FRM_rbuf_0.status = 8072 THEN //Buffer je poškodený - op)tovné èítanie
				RucCitackaQR.Step:= 11;	
			ELSE
				RucCitackaQR.Status.PoruchaUvolneniaRECEIVE_Buffera:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha uvolnenia RECEIVE buffera
			END_IF
			
		20://Prímanie dát - zatvorenie komunikácie//	
			RucCitackaQR.FRM_close_0.enable:= TRUE;
			RucCitackaQR.FRM_close_0.ident:= RucCitackaQR.FRM_xopen_0.ident;
			RucCitackaQR.FRM_close_0();
			
			IF RucCitackaQR.FRM_close_0.status = 0 THEN //Zatvorenie komunikácie prebehlo OK
				RucCitackaQR.Step:= 0;
			ELSIF RucCitackaQR.FRM_close_0.status = 65535 THEN //Prebieha zatvorenie komunikácie - stav BUSY
				RucCitackaQR.Step:= 20;
			ELSE
				RucCitackaQR.Status.PoruchaZatvoreniaKomunikacie:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha zatvorenia komunikácie
			END_IF
						
						
						
						
		
		100://Porucha komunikácie//
			IF RucCitackaQR.Command.PotvrdeniePoruchy THEN
				RucCitackaQR.Step:= 0;
			END_IF	
		
		
	END_CASE	
	
	
	
	
	
	
	
	
END_ACTION

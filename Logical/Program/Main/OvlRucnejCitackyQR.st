
ACTION OvlRucnejCitackyQR: 

	//"$L"  LF - linefeed - skok na druh� riadok
	
	
	
	
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
		
		1://Rozhodnutie o �innosti//
			IF RucCitackaQR.Command.PrimajData THEN
				RucCitackaQR.Step:= 10;
			ELSIF Linka.CitackaQRkodu_AKTIVNA THEN
				RucCitackaQR.Step:= 10;
			END_IF
		
		
		
			
			
		10://Pr�manie d�t - otvorenie seriovej komunik�cie//
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
		
			IF RucCitackaQR.FRM_xopen_0.status = 0 THEN   //Otvorenie komunik�cie prebehlo OK
				RucCitackaQR.Step:= 11;
			ELSIF RucCitackaQR.FRM_xopen_0.status = 65535 THEN  //Prebieha otvorenie komunik�cie - stav BUSY
				RucCitackaQR.Step:= 10;
			ELSE	
				RucCitackaQR.Status.PoruchaOtvoreniaKomunikacie:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha otvorenia komunik�cie
			END_IF	
			
			
		11://Pr�manie d�t - ��tanie d�t z komunik�cie//
			RucCitackaQR.FRM_read_0.enable:= TRUE;
			RucCitackaQR.FRM_read_0.ident:= RucCitackaQR.FRM_xopen_0.ident;
			RucCitackaQR.FRM_read_0();
			
			IF RucCitackaQR.FRM_read_0.status = 0 THEN //��tanie d�t z komunik�cie prebehlo OK
				RucCitackaQR.Step:= 12;
			ELSIF RucCitackaQR.Command.ZatvorKomunikaciu THEN
				RucCitackaQR.Step:= 0;
			ELSIF NOT Linka.CitackaQRkodu_AKTIVNA THEN
				RucCitackaQR.Step:= 0;
			ELSIF RucCitackaQR.FRM_read_0.status = 60 THEN //Prebieha ��tanie d�t z komunik�cie - stav �iadne d�ta
				RucCitackaQR.Step:= 11;
			ELSIF RucCitackaQR.FRM_read_0.status = 8079 THEN //Pri�li zl� alebo ne�pln� d�ta
				RucCitackaQR.Step:= 18;
			ELSE
				RucCitackaQR.Status.PoruchaCitaniaDat:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha ��tania d�t z komunik�cie
			END_IF
			
		12://Pr�manie d�t - kop�rovanie d�t do RECEIVE buffera//
			brsmemset(ADR(RucCitackaQR.PrecitaneData),0,SIZEOF(RucCitackaQR.PrecitaneData)); //Vynulovanie pre��tanej spr�vy
			brsmemcpy(ADR(RucCitackaQR.PrecitaneData),RucCitackaQR.FRM_read_0.buffer,RucCitackaQR.FRM_read_0.buflng); //Zkop�rovanie d�t z RECEIVE buffera do pre��tanej spr�vy
			RucCitackaQR.Step:= 18;
			
		
		18://Pr�manie d�t - uvolnenie RECEIVE buffera//
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
			ELSIF RucCitackaQR.FRM_rbuf_0.status = 8072 THEN //Buffer je po�koden� - op)tovn� ��tanie
				RucCitackaQR.Step:= 11;	
			ELSE
				RucCitackaQR.Status.PoruchaUvolneniaRECEIVE_Buffera:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha uvolnenia RECEIVE buffera
			END_IF
			
		20://Pr�manie d�t - zatvorenie komunik�cie//	
			RucCitackaQR.FRM_close_0.enable:= TRUE;
			RucCitackaQR.FRM_close_0.ident:= RucCitackaQR.FRM_xopen_0.ident;
			RucCitackaQR.FRM_close_0();
			
			IF RucCitackaQR.FRM_close_0.status = 0 THEN //Zatvorenie komunik�cie prebehlo OK
				RucCitackaQR.Step:= 0;
			ELSIF RucCitackaQR.FRM_close_0.status = 65535 THEN //Prebieha zatvorenie komunik�cie - stav BUSY
				RucCitackaQR.Step:= 20;
			ELSE
				RucCitackaQR.Status.PoruchaZatvoreniaKomunikacie:= TRUE;
				RucCitackaQR.Step:= 100;  //Porucha zatvorenia komunik�cie
			END_IF
						
						
						
						
		
		100://Porucha komunik�cie//
			IF RucCitackaQR.Command.PotvrdeniePoruchy THEN
				RucCitackaQR.Step:= 0;
			END_IF	
		
		
	END_CASE	
	
	
	
	
	
	
	
	
END_ACTION

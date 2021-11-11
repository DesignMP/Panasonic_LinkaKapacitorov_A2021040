
(* Blok pre riadenie frekvencneho menica na Powerlinku *)
FUNCTION_BLOCK RiadenieFM
	
		//***********************************Control word************************************//
 	//Bit_0 - RUN
	//Bit_1 - Disable Voltage
	//Bit_2 - Quick Stop
	//Bit_3 - Enable Operation
	//Bit_4 - Pulse Enabled
	//Bit_5 - Enable Ramp
	//Bit_6 - Setpoint Enabled
	//Bit_7 - Potvrdenie poruchy
	//Bit_8 - »innosù zadana v parametry maniËa P480_11 /Homing ätart//
	//Bit_9 - »innosù zadana v parametry meniËa P480_12 /Reset pozÌcie alebo referenËn˝ bod/
	//Bit_10 - Zapnutie riadenie meniËa cez komunik·ciu
	//Bit_11 - Smer ot·Ëania vpravo
	//Bit_12 - Smer ot·Ëania væavo
	//Bit_13 - Reserve
	//Bit_14 - Prepnutie parametrovej sady - bit 0
	//Bit_15 - Prepnutie parametrovej sady - bit 1
	
	//*************************************Status word*************************************//
	//Bit_0 - Stav READY
	//Bit_1 - READY for operation
	//Bit_2 - Stav motor beûÌ
	//Bit_3 - Porucha
	//Bit_4 - Voltage Enabled
	//Bit_5 - Stav Quick Stop /0 - Quick stop aktÌvny, 1 - Quick stop neaktÌvny/
	//Bit_6 - No starting lockout
	//Bit_7 - Warning
	//Bit_8 - PozÌcia dosiahnut·
	//Bit_9 - Bus control active
	//Bit_10 - Stav zadan˝ v parametri meniËa P481_11 aktivny /Homing OK/
	//Bit_11 - Stav motor beûÌ vpravo
	//Bit_12 - Stav motor beûÌ væavo
	//Bit_13 - Stav zadan˝ v parametri meniËa P481_12 aktÌvny
	//Bit_14 - Stav prepnutia parametrovej sady - bit 0
	//Bit_15 - Stav prepnutia parametrovej sady - bit 1
	
	
	//***************************Prehodenie bitov komunik·cie**********************************************//
	IF PAR.TypKomunikacieProfinet = 0 THEN //Powerlink//
		StavoveSlovo:= Powerlink_KOM_IN.StavoveSlovo;
		StavovaHodnota_1:= Powerlink_KOM_IN.StavovaHodnota_1;
		StavovaHodnota_2:= Powerlink_KOM_IN.StavovaHodnota_2;
		StavovaHodnota_3:= Powerlink_KOM_IN.StavovaHodnota_3;
		StavovaHodnota_4:= Powerlink_KOM_IN.StavovaHodnota_4;
		StavovaHodnota_5:= Powerlink_KOM_IN.StavovaHodnota_5;
		
		Powerlink_KOM_OUT.RiadiaceSlovo:= RiadiaceSlovo;
		Powerlink_KOM_OUT.ZadanaHodnota_1:= ZadanaHodnota_1;
		Powerlink_KOM_OUT.ZadanaHodnota_2:= ZadanaHodnota_2;
		Powerlink_KOM_OUT.ZadanaHodnota_3:= ZadanaHodnota_3;
		Powerlink_KOM_OUT.ZadanaHodnota_4:= ZadanaHodnota_4;
		Powerlink_KOM_OUT.ZadanaHodnota_5:= ZadanaHodnota_5;
		
		
	ELSIF PAR.TypKomunikacieProfinet = 1 THEN  //Profinet//
		IF PAR.SwapovanieKomunikacie = 0 THEN
			StavoveSlovo:= Profinet_KOM_IN.StavoveSlovo;
			StavovaHodnota_1:= Profinet_KOM_IN.StavovaHodnota_1;
			StavovaHodnota_2:= Profinet_KOM_IN.StavovaHodnota_2;
			StavovaHodnota_3:= Profinet_KOM_IN.StavovaHodnota_3;
			StavovaHodnota_4:= Profinet_KOM_IN.StavovaHodnota_4;
			StavovaHodnota_5:= Profinet_KOM_IN.StavovaHodnota_5;
	
			Profinet_KOM_OUT.RiadiaceSlovo:= RiadiaceSlovo;
			Profinet_KOM_OUT.ZadanaHodnota_1:= ZadanaHodnota_1;
			Profinet_KOM_OUT.ZadanaHodnota_2:= ZadanaHodnota_2;
			Profinet_KOM_OUT.ZadanaHodnota_3:= ZadanaHodnota_3;
			Profinet_KOM_OUT.ZadanaHodnota_4:= ZadanaHodnota_4;
			Profinet_KOM_OUT.ZadanaHodnota_5:= ZadanaHodnota_5;
		
		ELSIF PAR.SwapovanieKomunikacie = 1 THEN
			StavoveSlovo:= swapUINT(Profinet_KOM_IN.StavoveSlovo);
			StavovaHodnota_1:= swapUINT(Profinet_KOM_IN.StavovaHodnota_1);
			StavovaHodnota_2:= swapUINT(Profinet_KOM_IN.StavovaHodnota_2);
			StavovaHodnota_3:= swapUINT(Profinet_KOM_IN.StavovaHodnota_3);
			StavovaHodnota_4:= swapUINT(Profinet_KOM_IN.StavovaHodnota_4);
			StavovaHodnota_5:= swapUINT(Profinet_KOM_IN.StavovaHodnota_5);
	
			Profinet_KOM_OUT.RiadiaceSlovo:= swapUINT(RiadiaceSlovo);
			Profinet_KOM_OUT.ZadanaHodnota_1:= swapUINT(ZadanaHodnota_1);
			Profinet_KOM_OUT.ZadanaHodnota_2:= swapUINT(ZadanaHodnota_2);
			Profinet_KOM_OUT.ZadanaHodnota_3:= swapUINT(ZadanaHodnota_3);
			Profinet_KOM_OUT.ZadanaHodnota_4:= swapUINT(ZadanaHodnota_4);
			Profinet_KOM_OUT.ZadanaHodnota_5:= swapUINT(ZadanaHodnota_5);
			
		END_IF
	END_IF
	
	
	
	
	//***************************Preposielanie IO bitov**********************************************//
	//Vstupy pre meniË//
	ZadanaHodnota_4.0:= PAR.BUS_IN_Bit_0;
	ZadanaHodnota_4.1:= PAR.BUS_IN_Bit_1;
	ZadanaHodnota_4.2:= PAR.BUS_IN_Bit_2;
	ZadanaHodnota_4.3:= PAR.BUS_IN_Bit_3;
	ZadanaHodnota_4.4:= PAR.BUS_IN_Bit_4;
	ZadanaHodnota_4.5:= PAR.BUS_IN_Bit_5;
	ZadanaHodnota_4.6:= PAR.BUS_IN_Bit_6;
	
	
	//V˝stupy z meniËa//
	PAR.BUS_OUT_Bit_0:= StavovaHodnota_4.0;
	PAR.BUS_OUT_Bit_1:= StavovaHodnota_4.1;
	PAR.BUS_OUT_Bit_2:= StavovaHodnota_4.2;
	PAR.BUS_OUT_Bit_3:= StavovaHodnota_4.3;
	PAR.BUS_OUT_Bit_4:= StavovaHodnota_4.4;
	PAR.BUS_OUT_Bit_5:= StavovaHodnota_4.5;
	PAR.BUS_OUT_Bit_6:= StavovaHodnota_4.6;
	
	
	
	
	//Zadan· frekvencia//
	ZadanaHodnota_1:= ZadanaFrekvencia_preFM;
		
	//Aktu·lna frekvencia//
	AktualnaFrekvencia_zFM:= StavovaHodnota_1;
	//Zadan· pozÌcia// 
	ZadanaHodnota_2:= ZadanaPozicia_LW_preFM;
	ZadanaHodnota_3:= ZadanaPozicia_HW_preFM;
	//Aktu·lna pozÌcia//
	AktualnaPozicia_LW_zFM:= StavovaHodnota_2;
	AktualnaPozicia_HW_zFM:= StavovaHodnota_3;
		
	
	//***********************************************Stavy meniËa******************************************************//
	STAV.PORUCHA:= StavoveSlovo.3;
	STAV.QuickStop_Aktivny:= NOT StavoveSlovo.5;
	STAV.READY:= StavoveSlovo.0;
	STAV.RUN:= StavoveSlovo.2;
	STAV.Pozicia_DOSIAHNUTA:= StavoveSlovo.8;
	STAV.Homing_OK:= StavoveSlovo.10;
	STAV.ParamSada_BIT0_ENABLE:= StavoveSlovo.14;
	STAV.ParamSada_BIT1_ENABLE:= StavoveSlovo.15;
	
	
	
	//äk·lovanie zadanej frekvencie - Parameter meniËa 105 = 50Hz//
	SCAL_ZadanejFrekvencie(x:= PAR.ZadanaFrekvencia_Hz, x1:= 0.0, y1:= 0.0, x2:= 50.0, y2:= 16384.0);
	ZadanaFrekvencia_preFM:= REAL_TO_INT(SCAL_ZadanejFrekvencie.y);

	//äk·lovanie aktualnej frekvencie - Parameter meniËa 105 = 50Hz//
	AktualnaFrekvencia_zFM_REAL:= INT_TO_REAL(AktualnaFrekvencia_zFM);
	SCAL_AktualnejFrekvencie(x:= AktualnaFrekvencia_zFM_REAL, x1:= 0.0, y1:= 0.0, x2:= 16384.0, y2:= 50.0);
	PAR.AktualnaFrekvencia_Hz:= SCAL_AktualnejFrekvencie.y;
	
	//äk·lovanie aktu·lneho momentu//
	AktualnyMoment_zFM_REAL:= INT_TO_REAL(AktualnyMoment_zFM);
	SCAL_AktualnehoMomentu(x:= AktualnyMoment_zFM_REAL, x1:= 0.0, y1:= 0.0, x2:= 16384.0, y2:= 100.0);
	PAR.AktualnyMoment_Nm:= SCAL_AktualnehoMomentu.y;
	
	
	//Rozloûenie 32 bitovej hodnoty UDINT na dve 16 bitove hodnoty UINT pri zad·vanie pozicie//
	CONV_ZadPoz_UDINT_to_UINT.InputUDINT:= PAR.ZadanaPozicia_MM;
	ZadanaPozicia_LW_preFM:= CONV_ZadPoz_UDINT_to_UINT.OutputArrayUINT[0];
	ZadanaPozicia_HW_preFM:= CONV_ZadPoz_UDINT_to_UINT.OutputArrayUINT[1];
	CONV_ZadPoz_UDINT_to_UINT();
	
		
	//Spojenie dvoch 16 bitov˝ch hodnot UINT do jednej 32 bitovej hodnoty UDINT pre ËÌtanie pozicie//
	CONV_AktPoz_UINT_to_UDINT.InputArrayUINT[0]:= AktualnaPozicia_LW_zFM;
	CONV_AktPoz_UINT_to_UDINT.InputArrayUINT[1]:= AktualnaPozicia_HW_zFM;
	PAR.AktualnaPozicia_MM:= CONV_AktPoz_UINT_to_UDINT.OutputUDINT;
	CONV_AktPoz_UINT_to_UDINT();
	
	
	
	//Potvrdenie poruchy//
	IF CMD.Potvrd_PORUCHU THEN
		RiadiaceSlovo:= 16#4FE;
		IF NOT STAV.PORUCHA THEN
			RiadiaceSlovo:= 16#47E;
			CMD.Potvrd_PORUCHU:= FALSE;
		END_IF
	END_IF	
	
	//Quick stop//
	IF CMD.QuickSTOP THEN
		Step:= 0;
		RiadiaceSlovo:= 16#47A;
		IF STAV.QuickStop_Aktivny THEN
			RiadiaceSlovo:= 16#47E;
			CMD.QuickSTOP:= FALSE;
		END_IF
	END_IF	
	
	//Reset polohy meniËa//
	IF CMD.Pozicia_RESET THEN
		RiadiaceSlovo:= 16#67E;
		IF PAR.AktualnaPozicia_MM = 0 THEN
			RiadiaceSlovo:= 16#47E;
			CMD.Pozicia_RESET:= FALSE;
		END_IF
	END_IF	
	
	
	//ParametrovÈ sady//
	//Bit_0 = 0,Bit_1 = 0 - Parametrova sada 1 
	//Bit_0 = 1,Bit_1 = 0 - Parametrova sada 2 (Polohovanie)  
	//Bit_0 = 0,Bit_1 = 1 - Parametrova sada 3
	//Bit_0 = 1,Bit_1 = 1 - Parametrova sada 4
	
	
	//Riadenie meniËa//
	
	
	CASE Step OF
		
		0: //Nulovanie//
			CMD.HOME:= FALSE;
			CMD.Chod_VPRED:= FALSE;
			CMD.Chod_VZAD:= FALSE;
			CMD.Polohuj:= FALSE;
			CasHomingu.IN:= FALSE;
			CasPolohovania.IN:= FALSE;
			IF STAV.READY AND NOT STAV.PORUCHA AND NOT CMD.QuickSTOP THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 1;
			END_IF	
			
		1: //Rozhodnutie o Ëinnosti//
			IF CMD.HOME THEN
				Step:= 10;
			ELSIF CMD.Chod_VPRED THEN
				Step:= 20;
			ELSIF CMD.Chod_VZAD THEN
				Step:= 30;
			ELSIF CMD.Polohuj THEN
				Step:= 40;
			END_IF	
		
		10: //ätart homingu//
			IF PAR.ZadanaFrekvencia_Hz = 0.0 THEN
				PAR.ZadanaFrekvencia_Hz:= 5;
			END_IF
		
			RiadiaceSlovo:= 16#557F;
			CasHomingu.IN:= TRUE;
			Step:= 11;
		
		11: //UkonËenie homingu//
			IF STAV.Homing_OK AND CasHomingu.Q THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 0;
			ELSIF NOT CMD.HOME THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 0;
			END_IF	

				
		20: //Chod VPRED//
			IF PAR.ZadanaFrekvencia_Hz = 0.0 THEN
				PAR.ZadanaFrekvencia_Hz:= 10;
			END_IF	
						
			RiadiaceSlovo:= 16#C7F;
						
			IF NOT CMD.Chod_VPRED THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 0;
			END_IF	
		
			
			
		30: //Chod VZAD//
			IF PAR.ZadanaFrekvencia_Hz = 0.0 THEN
				PAR.ZadanaFrekvencia_Hz:= 10;
			END_IF	
			
			RiadiaceSlovo:= 16#147F;
							
			IF NOT CMD.Chod_VZAD THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 0;
			END_IF	
		
		
		40: //ätart polohovania//
			IF PAR.ZadanaFrekvencia_Hz = 0.0 THEN
				PAR.ZadanaFrekvencia_Hz:= 10;
			END_IF
			
			IF PAR.AktualnaPozicia_MM <> PAR.ZadanaPozicia_MM THEN
				RiadiaceSlovo:= 16#447F;
				CasPolohovania.IN:= TRUE;
				Step:= 41;
			ELSE	
				Step:= 0;
			END_IF
				
				
		41:	//UkonËenie polohovanie//
			
			IF STAV.Pozicia_DOSIAHNUTA AND CasPolohovania.Q THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 0;
			ELSIF NOT CMD.Polohuj THEN
				RiadiaceSlovo:= 16#47E;
				Step:= 0;
			END_IF	
		
		
	END_CASE		
	
	
	CasHomingu.PT:= T#500ms;
	CasHomingu();
	
	CasPolohovania.PT:= T#500ms;
	CasPolohovania();			
				
	
END_FUNCTION_BLOCK


PROGRAM _INIT
	Vizu.NacitanieLOTU_DISABLE:= TRUE;
	Vizu.ZobrazHlasenie_PotvrdPaletkyNG:= 1;
	Vizu.ZobrazHlasenie_NespravTypPaletky:= 1;
	Vizu.ZobrazHlasenie_ZaaretujTlaciaren:= 1;
	Vizu.ZobrazHlas_ZatvorSerDvereTlac:= 1;
	Vizu.ZobrazHlasenie_TlaciarenOffline:= 1;
	Vizu.ZobrazHlasenie_DochadzaPaska:= 1;
END_PROGRAM

PROGRAM _CYCLIC
	
	//Prepnutie na hlavnu obrazovku pri stla�en� tla��tka CS//
	IF EDGENEG(Safety.STAV.ZonaCS_AKTIVNA)THEN
		Vizu.CisloZadanejObrazovky:= 2;
	END_IF	
	
	
	//Zmena jazyka vizualiz�cie//
	Vizu.Language_Index;
	
	//**********************************************Urovne u�ivatelov***********************************************************//
	//10 - Zora�ova�
	//20 - Zvl�tna urove�
	//30 - Technol�g
	//40 - Admin Technol�g
	
	
	
	
	
	
	
	//***********************************************Zobrazenie stavov zariadenia***********************************************//
    //0 - Linka je vypnut�.
    //1 - Prebieha inicializacia linky.
    //2 - Linka be�� v automatickom re�ime.
    //3 - Robot nieje prepnut� do automatick�ho re�imu !!!
	//4 - Prebieha ukoncenie cyklu. 
    //5 - Nieje zvolen� model alebo LOT !!!
	//6 - Tla�iare� nieje Online !!!
	//7 - Tla�iare� nieje zaisten� !!!
	//8 - Servisn� dvere tla�iarne niesu zatvoren� !!!
	//9 - Paletka sa nach�dza v bariere dopravnika NG !!!
	//10 - V tla�iarni do�li etikety !!!
	//11 - V tla�iarni do�la termop�ska !!!
	//12 - Filtre ioniza�nej jednotky s� zanesen� !!!
	//13 - Kamera robota nieje READY !!!
	//14 - Dvere bunky niesu zamknut� !!!
    
    
	IF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN
		Vizu.StavZariadenia_Index:= 3;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF Linka.PAR.Zvoleny_MODEL = '' OR Linka.PAR.Zvoleny_LOT = '' THEN
		Vizu.StavZariadenia_Index:= 5;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF StoperEtiketovania.IN.Tlaciaren_Offline THEN
		Vizu.StavZariadenia_Index:= 6;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF NOT StoperEtiketovania.STAV.TlaciarenZaaretovana THEN
		Vizu.StavZariadenia_Index:= 7;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF NOT Robot.Automat AND NOT Safety.STAV.BarieraDopravnikaNG_AKTIVNA THEN
		Vizu.StavZariadenia_Index:= 9;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Vizu.StavZariadenia_Index:= 8;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF StoperEtiketovania.IN.Tlaciaren_KoniecEtikiet THEN
		Vizu.StavZariadenia_Index:= 10;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF StoperEtiketovania.IN.Tlaciaren_KoniecPasky THEN
		Vizu.StavZariadenia_Index:= 11;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF Linka.STAV.FiltreIonizacnejJednotkyZanesene THEN
		Vizu.StavZariadenia_Index:= 12;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF NOT Kamera.STAV.READY THEN
		Vizu.StavZariadenia_Index:= 13;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF NOT Safety.STAV.ZonaBunky_AKTIVNA THEN
		Vizu.StavZariadenia_Index:= 14;
		Vizu.StavZariadenia_Farba:= 3;
	ELSIF Linka.STAV.Automat AND Linka.STAV.UkoncenieCyklu_BUSY THEN
		Vizu.StavZariadenia_Index:= 4;
		Vizu.StavZariadenia_Farba:= 4;	
	ELSIF Linka.STAV.Automat AND NOT Linka.STAV.PoINIT THEN
		Vizu.StavZariadenia_Index:= 1;
		Vizu.StavZariadenia_Farba:= 1;
	ELSIF Linka.STAV.Automat AND Linka.STAV.PoINIT THEN
		Vizu.StavZariadenia_Index:= 2;
		Vizu.StavZariadenia_Farba:= 2;
	ELSE    
		Vizu.StavZariadenia_Index:= 0;
		Vizu.StavZariadenia_Farba:= 0;
	END_IF    
	
	
	//******************************************************Podsvietenie tla��tok**********************************************************//
	
	//Tla��tko alarmy//
	IF NastalaPorucha THEN
		Vizu.FarbaTlacitkaAlarm_Index:= Blikac500ms;
	ELSE
		Vizu.FarbaTlacitkaAlarm_Index:= FALSE;
	END_IF
	
	
	
	
	
	//Zobrazenie symbolov stla�en�ho CS//
	IF Safety.STAV.CS_VstupnyVytah_Odblokovany THEN
		Vizu.ZobrazSymbolCS_VstupVytah:= 1;
	ELSE	
		Vizu.ZobrazSymbolCS_VstupVytah:= 0;
	END_IF
	
	IF Safety.STAV.CS_VystupnyVytah_Odblokovany THEN
		Vizu.ZobrazSymbolCS_VystupVytah:= 1;
	ELSE	
		Vizu.ZobrazSymbolCS_VystupVytah:= 0;
	END_IF
	
	IF Safety.STAV.CS_OvlPanel_Odblokovany THEN
		Vizu.ZobrazSymbolCS_Panel:= 1;
	ELSE	
		Vizu.ZobrazSymbolCS_Panel:= 0;
	END_IF
	
	IF Safety.STAV.CS_Robot_Odblokovany THEN
		Vizu.ZobrazSymbolCS_Robot:= 1;
	ELSE	
		Vizu.ZobrazSymbolCS_Robot:= 0;
	END_IF
	
	
	
	//**********************************************Zobrazenie stavov jednotliv�ch pracovisk****************************************//
	//Vstupny v�tah//
	IF VstupVytah.Automat AND VstupVytah.KoniecCyklu THEN
		Vizu.StavPracoviskaVstupVytah_Index:= 4;	
	ELSIF VstupVytah.Automat AND NOT VstupVytah.STAV.PoINIT THEN
		Vizu.StavPracoviskaVstupVytah_Index:= 1;
	ELSIF VstupVytah.Automat AND VstupVytah.STAV.PoINIT THEN
		Vizu.StavPracoviskaVstupVytah_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaVstupVytah_Index:= 0;
	END_IF    
	
	
	//Stoper pred �isten�m//
	IF StoperPredCistenim.Automat AND StoperPredCistenim.KoniecCyklu THEN
		Vizu.StavPracoviskaStopPredCist_Index:= 4;	
	ELSIF StoperPredCistenim.Automat AND NOT StoperPredCistenim.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopPredCist_Index:= 1;
	ELSIF StoperPredCistenim.Automat AND StoperPredCistenim.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopPredCist_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaStopPredCist_Index:= 0;
	END_IF  
	
	//Stoper po �isten�//
	IF StoperPoCisteni.Automat AND StoperPoCisteni.KoniecCyklu THEN
		Vizu.StavPracoviskaStopPoCist_Index:= 4;	
	ELSIF StoperPoCisteni.Automat AND NOT StoperPoCisteni.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopPoCist_Index:= 1;
	ELSIF StoperPoCisteni.Automat AND StoperPoCisteni.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopPoCist_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaStopPoCist_Index:= 0;
	END_IF 
	
	//Dopravn�k �istenia//
	IF DopravCistenia.Automat AND DopravCistenia.KoniecCyklu THEN
		Vizu.StavPracoviskaDoprCistenia_Index:= 4;	
	ELSIF DopravCistenia.Automat AND NOT DopravCistenia.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprCistenia_Index:= 1;
	ELSIF DopravCistenia.Automat AND DopravCistenia.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprCistenia_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaDoprCistenia_Index:= 0;
	END_IF 
	
	
	//Stoper etiketovania//
	IF StoperEtiketovania.Automat AND StoperEtiketovania.KoniecCyklu THEN
		Vizu.StavPracoviskaStopEtiketov_Index:= 4;	
	ELSIF StoperEtiketovania.Automat AND NOT StoperEtiketovania.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopEtiketov_Index:= 1;
	ELSIF StoperEtiketovania.Automat AND StoperEtiketovania.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopEtiketov_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaStopEtiketov_Index:= 0;
	END_IF 
	
	
	//Robot//
	IF Robot.Automat AND Robot.KoniecCyklu THEN
		Vizu.StavPracoviskaRobota_Index:= 4;	
	ELSIF Robot.Automat AND NOT Robot.STAV.PoINIT THEN
		Vizu.StavPracoviskaRobota_Index:= 1;
	ELSIF Robot.Automat AND Robot.STAV.PoINIT THEN
		Vizu.StavPracoviskaRobota_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaRobota_Index:= 0;
	END_IF 
	
	
	
	//Stoper dopravn�ka NG//
	IF StoperDopravNG.Automat AND StoperDopravNG.KoniecCyklu THEN
		Vizu.StavPracoviskaStopDopNG_Index:= 4;	
	ELSIF StoperDopravNG.Automat AND NOT StoperDopravNG.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopDopNG_Index:= 1;
	ELSIF StoperDopravNG.Automat AND StoperDopravNG.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopDopNG_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaStopDopNG_Index:= 0;
	END_IF 
	
	
	//Dopravn�k bunky//
	IF DopravBunky.Automat AND DopravBunky.KoniecCyklu THEN
		Vizu.StavPracoviskaDoprBunky_Index:= 4;	
	ELSIF DopravBunky.Automat AND NOT DopravBunky.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprBunky_Index:= 1;
	ELSIF DopravBunky.Automat AND DopravBunky.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprBunky_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaDoprBunky_Index:= 0;
	END_IF 
	
	
	//Stoper v�stupn�ho dopravn�ka//
	IF StoperVystupDopravnika.Automat AND StoperVystupDopravnika.KoniecCyklu THEN
		Vizu.StavPracoviskaStopVystDopr_Index:= 4;	
	ELSIF StoperVystupDopravnika.Automat AND NOT StoperVystupDopravnika.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopVystDopr_Index:= 1;
	ELSIF StoperVystupDopravnika.Automat AND StoperVystupDopravnika.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopVystDopr_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaStopVystDopr_Index:= 0;
	END_IF 
	
	
	//V�stupn� dopravn�k//
	IF VystupnyDopravnik.Automat AND VystupnyDopravnik.KoniecCyklu THEN
		Vizu.StavPracoviskaDoprVystup_Index:= 4;	
	ELSIF VystupnyDopravnik.Automat AND NOT VystupnyDopravnik.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprVystup_Index:= 1;
	ELSIF VystupnyDopravnik.Automat AND VystupnyDopravnik.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprVystup_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaDoprVystup_Index:= 0;
	END_IF 
	
	
	//V�stupny v�tah//
	IF VystupVytah.Automat AND VystupVytah.KoniecCyklu THEN
		Vizu.StavPracoviskaVystupVytah_Index:= 4;	
	ELSIF VystupVytah.Automat AND NOT VystupVytah.STAV.PoINIT THEN
		Vizu.StavPracoviskaVystupVytah_Index:= 1;
	ELSIF VystupVytah.Automat AND VystupVytah.STAV.PoINIT THEN
		Vizu.StavPracoviskaVystupVytah_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaVystupVytah_Index:= 0;
	END_IF    
	
	
	//Stoper vratn�ho dopravn�ka//
	IF StoperVratDopravnika.Automat AND StoperVratDopravnika.KoniecCyklu THEN
		Vizu.StavPracoviskaStopVratDopr_Index:= 4;	
	ELSIF StoperVratDopravnika.Automat AND NOT StoperVratDopravnika.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopVratDopr_Index:= 1;
	ELSIF StoperVratDopravnika.Automat AND StoperVratDopravnika.STAV.PoINIT THEN
		Vizu.StavPracoviskaStopVratDopr_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaStopVratDopr_Index:= 0;
	END_IF 
	
	
	//Vratn� dopravn�k//
	IF VratnyDopravnik.Automat AND VratnyDopravnik.KoniecCyklu THEN
		Vizu.StavPracoviskaDoprVrat_Index:= 4;	
	ELSIF VratnyDopravnik.Automat AND NOT VratnyDopravnik.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprVrat_Index:= 1;
	ELSIF VratnyDopravnik.Automat AND VratnyDopravnik.STAV.PoINIT THEN
		Vizu.StavPracoviskaDoprVrat_Index:= 2;
	ELSE    
		Vizu.StavPracoviskaDoprVrat_Index:= 0;
	END_IF 
	
	
	
	//*********************************************Zobrazenie �vodnej obrazovky**********************************************//
	IF NOT Safety.STAV.SafetyPLC_Nabehlo THEN
		Vizu.CisloZadanejObrazovky:= 0;
		IF EDGEPOS (Blikac500ms = TRUE) THEN
			IF Vizu.Slider < 30 THEN
				Vizu.Slider:= Vizu.Slider+1;
			ELSE 
				Vizu.Slider:= 0;
			END_IF
		END_IF
	END_IF
	
	
	//************************************Prepnutie na obrazovku Automatick�ho re�imu******************************************//
	IF EDGEPOS (Safety.STAV.SafetyPLC_Nabehlo) THEN
		Vizu.CisloZadanejObrazovky:= 2;
	END_IF
	
	
	
	//*************************************************Zamknutie tla��tok*******************************************************//
	//Tla��tko re�im manual//
	IF Linka.STAV.Automat THEN
		Vizu.TL_RezimManual_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.TL_RezimManual_DISABLE:= TRUE;
	ELSE 
		Vizu.TL_RezimManual_DISABLE:= FALSE;
	END_IF
    
    
	//Tla��tko �tart Automat//
	IF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NastalaPorucha THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT Linka.STAV.Hardware_OK THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF Linka.PAR.Zvoleny_MODEL = '' THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF Linka.PAR.Zvoleny_LOT = '' THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF StoperEtiketovania.IN.Tlaciaren_Offline THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN	
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT StoperEtiketovania.STAV.TlaciarenZaaretovana THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT Robot.Automat AND NOT Safety.STAV.BarieraDopravnikaNG_AKTIVNA	THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF Linka.STAV.FiltreIonizacnejJednotkyZanesene THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF StoperEtiketovania.IN.Tlaciaren_KoniecEtikiet THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF StoperEtiketovania.IN.Tlaciaren_KoniecPasky THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT Kamera.STAV.READY THEN	
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZonaBunky_AKTIVNA THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSIF Linka.STAV.PoINIT THEN
		Vizu.TL_StartAutomat_DISABLE:= TRUE;
	ELSE    
		Vizu.TL_StartAutomat_DISABLE:= FALSE;
	END_IF    
    
	      
	//Tla��tko Ukon�enie cyklu//
	IF Linka.STAV.PoINIT THEN
		Vizu.TL_UkoncenieCyklu_DISABLE:= FALSE; 
	ELSE
		Vizu.TL_UkoncenieCyklu_DISABLE:= TRUE;
	END_IF  
	
	
	//Tla��tko Reset//
	IF Linka.STAV.PoINIT AND NOT Linka.STAV.UkoncenieCyklu_BUSY THEN
		Vizu.TL_Reset_DISABLE:= TRUE;
	ELSE    
		Vizu.TL_Reset_DISABLE:= FALSE;
	END_IF  
	
	
	//Zamknutie tla��tok ovl�dania z�mkov dver�//
	IF Linka.STAV.Automat THEN
		Vizu.TL_ZamokPredneDvere_DISABLE:= TRUE;
		Vizu.TL_ZamokZadneDvere_DISABLE:= TRUE;
	ELSE
		Vizu.TL_ZamokPredneDvere_DISABLE:= FALSE;
		Vizu.TL_ZamokZadneDvere_DISABLE:= FALSE;
	END_IF	
	
	
	//Tla��tko zmena modelu//
	IF Vizu.Nacitany_MODEL = '' THEN
		Vizu.TL_ZmenModel_DISABLE:= TRUE;
	ELSIF Vizu.Nacitany_LOT	= '' THEN
		Vizu.TL_ZmenModel_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_ZmenModel_DISABLE:= FALSE;
	END_IF	
	
	
	//Tla��tko Homing vstupn�ho v��ahu//
	IF NOT Safety.STAV.ZonaVstupnyVytah_AKTIVNA THEN
		Vizu.TL_VstupVytah_Homing_DISABLE:= TRUE;
	ELSIF VstupVytah.STAV.Zdvih_BUSY THEN
		Vizu.TL_VstupVytah_Homing_DISABLE:= TRUE;
	ELSIF VstupVytah.RR_Dopravnik_VPRED THEN
		Vizu.TL_VstupVytah_Homing_DISABLE:= TRUE;
	ELSIF VstupVytah.RR_Dopravnik_VZAD THEN
		Vizu.TL_VstupVytah_Homing_DISABLE:= TRUE;
	ELSIF VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
		Vizu.TL_VstupVytah_Homing_DISABLE:= TRUE;
	ELSIF NOT VstupVytah.MenicZdvihu_FM2.STAV.READY THEN
		Vizu.TL_VstupVytah_Homing_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_VstupVytah_Homing_DISABLE:= FALSE;
	END_IF	
	 
	//Tla��tka zdvihu vstupn�ho v��ahu//
	IF NOT Safety.STAV.ZonaVstupnyVytah_AKTIVNA THEN
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VstupVytah.RR_Dopravnik_VPRED THEN
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VstupVytah.RR_Dopravnik_VZAD THEN
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VstupVytah.STAV.Homing_BUSY THEN	
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VstupVytah.IN.PrechodDopravnikaVytahu_OS1 THEN
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF NOT VstupVytah.MenicZdvihu_FM2.STAV.READY THEN
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= TRUE;
	ELSE
		Vizu.TL_VstupVytah_Zdvih_DISABLE:= FALSE;
	END_IF	
		
	
	//Tla��tko Homing vystupneho v��ahu//
	IF NOT Safety.STAV.ZonaVystupnyVytah_AKTIVNA THEN
		Vizu.TL_VystupVytah_Homing_DISABLE:= TRUE;
	ELSIF VystupVytah.STAV.Zdvih_BUSY THEN
		Vizu.TL_VystupVytah_Homing_DISABLE:= TRUE;
	ELSIF VystupVytah.RR_Dopravnik_VPRED THEN	
		Vizu.TL_VystupVytah_Homing_DISABLE:= TRUE;
	ELSIF VystupVytah.RR_Dopravnik_VZAD THEN
		Vizu.TL_VystupVytah_Homing_DISABLE:= TRUE;
	ELSIF VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
		Vizu.TL_VystupVytah_Homing_DISABLE:= TRUE;
	ELSIF NOT VystupVytah.MenicZdvihu_FM3.STAV.READY THEN	
		Vizu.TL_VystupVytah_Homing_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_VystupVytah_Homing_DISABLE:= FALSE;
	END_IF
	
	
	
	//Tla��tka zdvihu v�stupn�ho v��ahu//
	IF NOT Safety.STAV.ZonaVystupnyVytah_AKTIVNA THEN
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VystupVytah.RR_Dopravnik_VPRED THEN
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VystupVytah.RR_Dopravnik_VZAD THEN
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VystupVytah.STAV.Homing_BUSY THEN	
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF VystupVytah.IN.PrechodDopravnikaVytahu_OS6 THEN
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= TRUE;
	ELSIF NOT VystupVytah.MenicZdvihu_FM3.STAV.READY THEN	
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= TRUE;
	ELSE
		Vizu.TL_VystupVytah_Zdvih_DISABLE:= FALSE;
	END_IF
	
	
	//Tla��tko odparkuj robota//
	IF Linka.STAV.Automat THEN
		Vizu.TL_OdparkujRobota_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZonaBunky_AKTIVNA THEN
		Vizu.TL_OdparkujRobota_DISABLE:= TRUE;
	ELSIF SC_Robot.Step <> 1 THEN
		Vizu.TL_OdparkujRobota_DISABLE:= TRUE;
	ELSIF Safety.STAV.MutingRobota_AKTIVNY THEN
		Vizu.TL_OdparkujRobota_DISABLE:= TRUE;
	ELSIF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN
		Vizu.TL_OdparkujRobota_DISABLE:= TRUE;
	ELSE
		Vizu.TL_OdparkujRobota_DISABLE:= FALSE;
	END_IF	
	
	//Tla��tka ovl�dania bunky v ru�nom re�ime//
	IF Safety.STAV.ZonaBunky_AKTIVNA THEN
		Vizu.TL_BunkyRR_DISABLE:= FALSE;
	ELSE
		Vizu.TL_BunkyRR_DISABLE:= TRUE;
	END_IF	
	
	//Tla��tko presun robota na poz�ciu ��tania intern�ho �t�tku//
	IF Linka.STAV.Automat THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF Robot.RR_PresunPoziciaCitaniaDMkodu THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF Robot.RR_PresunPoziciaOdobratiaEtikety THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZamkyBunky_AKTIVNE THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF NOT StoperEtiketovania.IN.SuflikTlaciarne_LS_IS23 OR NOT StoperEtiketovania.IN.SuflikTlaciarne_PS_IS22 THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSIF Linka.PAR.Zvoleny_MODEL = '' THEN
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_Robot_CitanieQRkodu_DISABLE:= FALSE;
	END_IF	
	
	//Tla��tko presun robota na poz�ciu ��tania z�kaznick�ho �t�tku//
	IF Linka.STAV.Automat THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF Robot.RR_PresunPoziciaCitaniaQRkodu THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF Robot.RR_PresunPoziciaOdobratiaEtikety THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZamkyBunky_AKTIVNE THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF NOT StoperEtiketovania.IN.SuflikTlaciarne_LS_IS23 OR NOT StoperEtiketovania.IN.SuflikTlaciarne_PS_IS22 THEN	
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSIF Linka.PAR.Zvoleny_MODEL = '' THEN
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_Robot_CitanieDMkodu_DISABLE:= FALSE;
	END_IF
	
	//Tla��tko presun robota na poz�ciu odobratia etikety z tla�iarne//
	IF Linka.STAV.Automat THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF Robot.RR_PresunPoziciaCitaniaQRkodu THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF Robot.RR_PresunPoziciaCitaniaDMkodu THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZamkyBunky_AKTIVNE THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF NOT StoperEtiketovania.IN.SuflikTlaciarne_LS_IS23 OR NOT StoperEtiketovania.IN.SuflikTlaciarne_PS_IS22 THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSIF Linka.PAR.Zvoleny_MODEL = '' THEN
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_Robot_OdoberEtiketu_DISABLE:= FALSE;
	END_IF
	
	//Tla��tko ovl�dania Ioniz�tora//
	IF NOT VstupVytah.IN.DvereVytahuZatvorene_MS2 THEN
		Vizu.TL_Ovl_Ionizatora_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_Ovl_Ionizatora_DISABLE:= FALSE;
	END_IF	
	
	//Ovl�danie dver� vstupn�ho v��ahu//
	IF NOT Safety.STAV.BarieraVstupVytahu_AKTIVNA THEN
		Vizu.TL_Ovl_DveriVstupVytahu_DISABLE:= TRUE;
	ELSE	
		Vizu.TL_Ovl_DveriVstupVytahu_DISABLE:= FALSE;
	END_IF	
	
	
	//Zad�vanie korekcii robota//
	IF OffsetRobota_NazovModelu = '' THEN
		Vizu.ZadavanieKorekciiRobota_DISABLE:= TRUE;
	ELSE
		Vizu.ZadavanieKorekciiRobota_DISABLE:= FALSE;
	END_IF	
	
	
	
	//Volby re�imov//
	IF Linka.STAV.Automat THEN
		Vizu.VolbyRezimov_DISABLE:= TRUE;
	ELSIF ZvolenaUroven < 20 THEN
		Vizu.VolbyRezimov_DISABLE:= TRUE;
	ELSE	
		Vizu.VolbyRezimov_DISABLE:= FALSE;
	END_IF	
	
	
	
	//Zad�vanie parametrov//
	IF Linka.STAV.Automat THEN
		Vizu.ZmenaParametrov_DISABLE:= TRUE;
	ELSE
		Vizu.ZmenaParametrov_DISABLE:= FALSE;
	END_IF	
	
	
	

	//Vypnutie hl�senia koniec p�sky alebo etikiet v tla�iarni//
	IF NOT StoperEtiketovania.IN.Tlaciaren_KoniecEtikiet AND NOT StoperEtiketovania.IN.Tlaciaren_KoniecPasky THEN
		Vizu.ZobrazHlasenie_DochadzaPaska:= 1;
	END_IF		

	
	//***********************************************Prep�nanie obr�zkov s�radnicov�ho syst�mu pre zad�vanie korekcii robota*******************************************************//
	IF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BD1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 1;
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BE1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 2;	
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BF1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 3;
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BV1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 4;
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'EH1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 4;
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'BW1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 5;
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'CN1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 6;
	ELSIF RFID_Hlava_2.PAR.PrecitanyTypPaletky = 'CP1' THEN
		Vizu.IndexSuradnicovehoSystemuPaletky:= 7;	
	END_IF	
	
	
	
	
	
	
	//***********************************************Zobrazenie stavov ladenia kamery***********************************************//
	//0 - READY.
	//1 - Paletka nieje zacentrovana !!!.
	//2 - Na poz�cii etiketovania nie je paletka !!!.
	//3 - Dvere bunky nie su zamknut� !!!
	//4 - Z�na CS nieje akt�vna !!! 
	//5 - Robot nie je prepnut� do automatick�ho re�imu !!!
	//6 - Ukon�i automatick� re�im linky !!!
	//7 - Servisn� dvere tla�iarne nie su zatvoren� !!!
	//8 - Tla�iare� nie je zaaretovan� !!!
	//9 - Na linke nieje zvolen� model !!!
	
	//Farba//
	//0 - �erven�
	//1 - zelen�
	
	
	IF NOT RFID_Hlava_2.STAV.PritomnostCipu THEN
		Vizu.IndexStavuLadenieKamery:= 2;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF NOT Safety.STAV.ZamkyBunky_AKTIVNE THEN
		Vizu.IndexStavuLadenieKamery:= 3;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF NOT Safety.STAV.ZonaCS_AKTIVNA THEN
		Vizu.IndexStavuLadenieKamery:= 4;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF NOT Robot.KOM_IN.Stav_RezimAUTOMAT THEN
		Vizu.IndexStavuLadenieKamery:= 5;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF Linka.STAV.Automat THEN
		Vizu.IndexStavuLadenieKamery:= 6;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF NOT Safety.STAV.ServisneDvereTlaciarne_AKTIVNE THEN
		Vizu.IndexStavuLadenieKamery:= 7;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF NOT StoperEtiketovania.IN.SuflikTlaciarne_LS_IS23 OR NOT StoperEtiketovania.IN.SuflikTlaciarne_PS_IS22 THEN
		Vizu.IndexStavuLadenieKamery:= 8;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSIF Linka.PAR.Zvoleny_MODEL = '' THEN
		Vizu.IndexStavuLadenieKamery:= 9;
		Vizu.IndexStavuLadenieKamery_Farba:= 0;
	ELSE    
		Vizu.IndexStavuLadenieKamery:= 0;
		Vizu.IndexStavuLadenieKamery_Farba:= 1;
	END_IF    
	
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


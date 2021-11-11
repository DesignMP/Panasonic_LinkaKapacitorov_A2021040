
PROGRAM _INIT

END_PROGRAM

PROGRAM _CYCLIC

	//Naèítanie receptur pri prvom spustení//
	IF EDGEPOS(Safety.STAV.SafetyPLC_Nabehlo = TRUE) THEN
		MpRecipeXml_1.Load:= TRUE;
	END_IF
	
	//Naèítanie receptur z pamäte//
	IF MpRecipeXml_1.Load AND (MpRecipeXml_1.CommandDone OR MpRecipeXml_1.Error) THEN
		MpRecipeXml_1.Load:= FALSE;
		old_i:= 1;
		i:= 0;
		IndexZoznam:= 0;
	END_IF	
	
	//Konfigurácia receptur//
	MpRecipeXml_1.MpLink:= ADR(gRecipeXmlLink);  //takto sa menuje mapp komponenta v configurating view//
	MpRecipeXml_1.Enable:= TRUE;
	MpRecipeXml_1.Category:= ADR('RECEPTURY');
	MpRecipeXml_1.DeviceName:= ADR('HDD');  //Názov media, kde sa budú receptury ukladat//
	MpRecipeXml_1.FileName:= ADR('UlozeneReceptury'); //Názov súboru do ktorého sa receptúry uložia//
	MpRecipeXml_1();
	
	MpRecipeRegPar_1.MpLink:= ADR(gRecipeXmlLink);
	MpRecipeRegPar_1.Enable:= TRUE;
	MpRecipeRegPar_1.Category:= ADR('RECEPTURY');
	MpRecipeRegPar_1.PVName:= ADR('Receptura'); //Názov premenné, kde je vytvorená štruktura dat pre receptury//
	MpRecipeRegPar_1();

	//Zobrazenie názvou receptúr//
	FOR IndexZoznam:=0 TO 150 BY 1 DO
		ZoznamReceptur[IndexZoznam]:= Receptura[IndexZoznam].NazovModelu;
	END_FOR
	
	//Posun indexu//
	IF MoveUP THEN
		IF i< 150 THEN
			i:= i+1;
		END_IF
		MoveUP:= FALSE;
	END_IF
	
	IF MoveDown THEN
		IF i>0 THEN
			i:= i-1;
		END_IF
		MoveDown:= FALSE;
	END_IF
	
	//Posun indexu po stranách//
	IF MoveUP_Page THEN
		IF i< (150 - 7) THEN
			i:= i+7;
		END_IF
		MoveUP_Page:= FALSE;
	END_IF
	
	IF MoveDown_Page THEN
		IF i>(0+7) THEN
			i:= i-7;
		END_IF
		MoveDown_Page:= FALSE;
	END_IF
	
	
	//Listovanie v uložených recepturach//
	IF old_i <> i THEN
		NazovModelu:= Receptura[i].NazovModelu;
		TypPaletky:= Receptura[i].TypPaletky;
		Robot_CisloProgramu:= Receptura[i].Robot_CisloProgramu;
		Kamera_CisloProgramu_QRkod:= Receptura[i].Kamera_CisloProgramuQRkod;
		Kamera_CisloProgramu_DMkod:= Receptura[i].Kamera_CisloProgramuDMkod;
		RychlostDopravnikaPriCisteni:= Receptura[i].RychlostDopravnikaPriCisteni;
		old_i:= i;
	END_IF
	
	//Vymazanie receptury//
	IF VymazRecepturu THEN
		RecipeVymazanie_DONE:= FALSE;
		Receptura[i].NazovModelu:= '';
		Receptura[i].TypPaletky:= '';
		Receptura[i].Robot_CisloProgramu:= 0;
		Receptura[i].Kamera_CisloProgramuQRkod:= 0;
		Receptura[i].Kamera_CisloProgramuDMkod:= 0;
		Receptura[i].RychlostDopravnikaPriCisteni:= 0;
		Receptura[i].Robot_PozLepenia_OffsetX:= 0;
		Receptura[i].Robot_PozLepenia_OffsetY:= 0;
		Receptura[i].Robot_PozLepenia_OffsetZ:= 0;
		MpRecipeXml_1.Save:= TRUE;
		RecipeVymazanie_DONE:= TRUE;
		VymazRecepturu:= FALSE;
	END_IF	
	
	//Prepísanie receptury//
	IF PrepisRecepturu THEN
		RecipePrepis_DONE:= FALSE;
		Receptura[i].NazovModelu:= NazovModelu;
		Receptura[i].TypPaletky:= TypPaletky;
		Receptura[i].Robot_CisloProgramu:= Robot_CisloProgramu;
		Receptura[i].Kamera_CisloProgramuQRkod:= Kamera_CisloProgramu_QRkod;
		Receptura[i].Kamera_CisloProgramuDMkod:= Kamera_CisloProgramu_DMkod;
		Receptura[i].RychlostDopravnikaPriCisteni:= RychlostDopravnikaPriCisteni;
		MpRecipeXml_1.Save:= TRUE;
		RecipePrepis_DONE:= TRUE;
		PrepisRecepturu:= FALSE;
	END_IF	
	
	//Uloženie receptury//
	IF UlozRecepturu THEN
		RecipeZapis_DONE:= FALSE;
		FOR a:= 0 TO 150 BY 1 DO
			IF Receptura[a].NazovModelu = NazovModelu AND NOT RecipeZapis_DONE THEN
				Receptura[a].TypPaletky:= TypPaletky;
				Receptura[a].Robot_CisloProgramu:= Robot_CisloProgramu;
				Receptura[a].Kamera_CisloProgramuQRkod:= Kamera_CisloProgramu_QRkod;
				Receptura[a].Kamera_CisloProgramuDMkod:= Kamera_CisloProgramu_DMkod;
				Receptura[a].RychlostDopravnikaPriCisteni:= RychlostDopravnikaPriCisteni;
				MpRecipeXml_1.Save:= TRUE;
				RecipeZapis_DONE:= TRUE;
			ELSIF Receptura[a].NazovModelu = '' AND NOT RecipeZapis_DONE THEN
				Receptura[a].NazovModelu:= NazovModelu;
				Receptura[a].TypPaletky:= TypPaletky;
				Receptura[a].Robot_CisloProgramu:= Robot_CisloProgramu;
				Receptura[a].Kamera_CisloProgramuQRkod:= Kamera_CisloProgramu_QRkod;
				Receptura[a].Kamera_CisloProgramuDMkod:= Kamera_CisloProgramu_DMkod;
				Receptura[a].RychlostDopravnikaPriCisteni:= RychlostDopravnikaPriCisteni;
				MpRecipeXml_1.Save:= TRUE;
				RecipeZapis_DONE:= TRUE;
			END_IF
		END_FOR
		UlozRecepturu:= FALSE;
	END_IF
	
	IF MpRecipeXml_1.CommandDone THEN
		MpRecipeXml_1.Save:= FALSE;
	END_IF	
	
	//Uloženie korekcii robota//
	IF UlozKorekcieRobota THEN
		UlozenieKorekcii_DONE:= FALSE;
		FOR b:= 0 TO 150 BY 1 DO
			IF Receptura[b].NazovModelu = OffsetRobota_NazovModelu AND NOT UlozenieKorekcii_DONE THEN
				Receptura[b].Robot_PozLepenia_OffsetX:= Linka.PAR.Zvolena_PozLepenia_OffsetX;
				Receptura[b].Robot_PozLepenia_OffsetY:= Linka.PAR.Zvolena_PozLepenia_OffsetY;
				Receptura[b].Robot_PozLepenia_OffsetZ:= Linka.PAR.Zvolena_PozLepenia_OffsetZ;
				MpRecipeXml_1.Save:= TRUE;
				UlozenieKorekcii_DONE:= TRUE;
			END_IF
		END_FOR	
		UlozKorekcieRobota:= FALSE;
	END_IF	
	
	
	
	//Nacitanie korekcii robota//
	IF NacitajKorekcieRobota THEN
		NacitanieKorekcii_DONE:= FALSE;
		FOR c:= 0 TO 150 BY 1 DO
			IF Receptura[c].NazovModelu = OffsetRobota_NazovModelu AND NOT NacitanieKorekcii_DONE THEN
				Linka.PAR.Zvolena_PozLepenia_OffsetX:= Receptura[c].Robot_PozLepenia_OffsetX;
				Linka.PAR.Zvolena_PozLepenia_OffsetY:= Receptura[c].Robot_PozLepenia_OffsetY;
				Linka.PAR.Zvolena_PozLepenia_OffsetZ:= Receptura[c].Robot_PozLepenia_OffsetZ;
				NacitanieKorekcii_DONE:= TRUE;
			END_IF
		END_FOR
		NacitajKorekcieRobota:= FALSE;
	END_IF	
				
	
	//Naèitanie receptur do premenných//
	IF NacitajRecepturu THEN
		Linka.PAR.Zvoleny_TypPaletky:= Receptura[Linka.PAR.IndexZvoleneReceptury].TypPaletky;
		Linka.PAR.Zvolene_CisloProgramuRobota:= Receptura[Linka.PAR.IndexZvoleneReceptury].Robot_CisloProgramu;
		Linka.PAR.Zvolene_KamCisloProg_QRkod:= Receptura[Linka.PAR.IndexZvoleneReceptury].Kamera_CisloProgramuQRkod;
		Linka.PAR.Zvolene_KamCisloProg_DMkod:= Receptura[Linka.PAR.IndexZvoleneReceptury].Kamera_CisloProgramuDMkod;
		Linka.PAR.Zvolena_RychlostDopravPriCisteni:= Receptura[Linka.PAR.IndexZvoleneReceptury].RychlostDopravnikaPriCisteni;
		NacitajRecepturu:= FALSE;
	END_IF
	
	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


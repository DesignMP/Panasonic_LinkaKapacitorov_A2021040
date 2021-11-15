
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	IF NOT Blikac1s THEN
		Blikac1s:= TRUE;
		Pocitadlo:= Pocitadlo + 1;
		IF Pocitadlo > 300 THEN
			Pocitadlo:= 0;
		END_IF	
	ELSE
		Blikac1s:= FALSE;
	END_IF	
	 
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM


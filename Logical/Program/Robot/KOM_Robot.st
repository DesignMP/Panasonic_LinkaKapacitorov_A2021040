
ACTION KOM_Robot: 

	//Vstupy z Robota do PLC//
	Robot.KOM_IN.Stav_RezimAUTOMAT:= Robot.KOM_IN.Profinet_PLC_INPUTS[0].0;	                	//0
	Robot.KOM_IN.Stav_ProgramRUN:= Robot.KOM_IN.Profinet_PLC_INPUTS[0].1;                   	//1
	Robot.KOM_IN.Stav_MotoryOFF:= Robot.KOM_IN.Profinet_PLC_INPUTS[0].2;                    	//2
	Robot.KOM_IN.Stav_MotoryON:= Robot.KOM_IN.Profinet_PLC_INPUTS[0].3;                     	//3
	Robot.KOM_IN.Stav_RobotCS:= Robot.KOM_IN.Profinet_PLC_INPUTS[0].4;                      	//4
	Robot.KOM_IN.Profinet_PLC_INPUTS[0].5;                                                  	//5
	Robot.KOM_IN.Profinet_PLC_INPUTS[0].6;                                                  	//6
	Robot.KOM_IN.Profinet_PLC_INPUTS[0].7;														//7
	
	Robot.KOM_IN.Stav_RobotCinnostUkoncena:= Robot.KOM_IN.Profinet_PLC_INPUTS[1].0;				//8
	Robot.KOM_IN.Stav_RobotOdparkovany:= Robot.KOM_IN.Profinet_PLC_INPUTS[1].1;					//9
	Robot.KOM_IN.Stav_VystupyZresetovane:= Robot.KOM_IN.Profinet_PLC_INPUTS[1].2;				//10
	Prisavka_ON:= Robot.KOM_IN.Profinet_PLC_INPUTS[1].3;
	(*Robot.PrisavanieEtikety_ZAPNI:= Robot.KOM_IN.Profinet_PLC_INPUTS[1].3;*)						//11
	Robot.KOM_IN.Profinet_PLC_INPUTS[1].4;														//12
	Robot.KOM_IN.Profinet_PLC_INPUTS[1].5;														//13
	Robot.KOM_IN.Profinet_PLC_INPUTS[1].6;														//14
	Robot.KOM_IN.Profinet_PLC_INPUTS[1].7;  										 			//15
	
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].0;														//16
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].1;														//17	
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].2;														//18
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].3;														//19
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].4;														//20
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].5;														//21
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].6;														//22
	Robot.KOM_IN.Profinet_PLC_INPUTS[2].7;														//23
	
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].0;														//24
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].1;														//25
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].2;														//26
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].3;														//27
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].4;														//28
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].5;														//29
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].6;														//30
	Robot.KOM_IN.Profinet_PLC_INPUTS[3].7;														//31
	
	
	
	
	
	//Vystupy z PLC do Robota//
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].0:= Robot.KOM_OUT.VypniMotory;						//0
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].1:= Robot.KOM_OUT.ZapniMotory;						//1
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].2:= Robot.KOM_OUT.PP_na_Main;							//2
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].3:= Robot.KOM_OUT.StartProgramu;						//3
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].4:= Robot.KOM_OUT.StartProgramuMain;					//4
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].5:= Robot.KOM_OUT.StopProgramu;						//5
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].6:= Robot.KOM_OUT.Reset_CS;							//6
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[0].7;													//7
	
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].0:= Robot.KOM_OUT.NalepEtiketu;						//8
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].1:= Robot.KOM_OUT.UkoncenieCykluRobota;				//9
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].2:= Robot.KOM_OUT.PresunDoMutingPozicie;				//10
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].3:= Robot.KOM_OUT.PresunDoPoziceKontrolyEtikety;		//11
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].4:= Robot.KOM_OUT.PresunDoPozicieKontrolyIntStitku;	//12
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].5:= Robot.KOM_OUT.PresunDoPozicieOdobratiaEtikety;	//13
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].6:= Robot.IN.PrisatieEtikety_OK_S1;					//14
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[1].7:= Robot.KOM_OUT.ServisnaPozicia;					//15
	
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].0:= Robot.KOM_OUT.ZahodEtiketu;						//16
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].1:= Robot.KOM_OUT.CitanieStitkuUkoncene; 				//17
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].2:= Robot.KOM_OUT.PresunDoPoziceKontrEtiketyPriamo;	//18
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].3;													//19
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].4;													//20
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].5;													//21
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].6;													//22
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[2].7;													//23
	
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].0:= Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetX;		//24
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].1:= Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetY;		//25
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].2:= Robot.KOM_OUT.LepenieStitku_ZnamienkoOffsetZ;		//26
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].3;													//27
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].4;													//28
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].5;													//29
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].6;													//30
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[3].7;													//31
    
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[4]:= Robot.KOM_OUT.CisloProduktu;						//32 - 39
	
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[5]:= Robot.KOM_OUT.LepenieStitku_OffsetX;				//40 - 47
	
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[6]:= Robot.KOM_OUT.LepenieStitku_OffsetY;				//48 - 55
	
	Robot.KOM_OUT.Profinet_PLC_OUTPUTS[7]:= Robot.KOM_OUT.LepenieStitku_OffsetZ;				//56 - 63
	
	
	
	
END_ACTION

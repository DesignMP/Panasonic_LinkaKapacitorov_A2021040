
{REDUND_ERROR} FUNCTION_BLOCK RiadenieFM (*Blok pre riadenie frekvencneho menica na Powerlinku*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		CMD : MenicCMD_typ;
		PAR : MenicPAR_typ;
		Powerlink_KOM_IN : PowerlinkKOM_IN_typ;
		Profinet_KOM_IN : ProfinetKOM_IN_typ;
	END_VAR
	VAR_OUTPUT
		Powerlink_KOM_OUT : PowerlinkKOM_OUT_typ;
		Profinet_KOM_OUT : ProfinetKOM_OUT_typ;
		STAV : MenicSTAV_typ;
	END_VAR
	VAR
		Step : USINT;
		SCAL_ZadanejFrekvencie : LCRScal;
		SCAL_AktualnejFrekvencie : LCRScal;
		SCAL_AktualnehoMomentu : LCRScal;
		CONV_ZadPoz_UDINT_to_UINT : UdintToUint;
		CONV_AktPoz_UINT_to_UDINT : UintToUdint;
		ZadanaFrekvencia_preFM : INT;
		AktualnaFrekvencia_zFM_REAL : REAL;
		AktualnaFrekvencia_zFM : INT;
		AktualnyMoment_zFM : INT;
		AktualnyMoment_zFM_REAL : REAL;
		ZadanaPozicia_LW_preFM : INT;
		ZadanaPozicia_HW_preFM : INT;
		AktualnaPozicia_LW_zFM : INT;
		AktualnaPozicia_HW_zFM : INT;
		StavoveSlovo : UINT;
		StavovaHodnota_1 : UINT;
		StavovaHodnota_2 : UINT;
		StavovaHodnota_3 : UINT;
		StavovaHodnota_4 : UINT;
		StavovaHodnota_5 : UINT;
		RiadiaceSlovo : UINT;
		ZadanaHodnota_1 : UINT;
		ZadanaHodnota_2 : UINT;
		ZadanaHodnota_3 : UINT;
		ZadanaHodnota_4 : UINT;
		ZadanaHodnota_5 : UINT;
		zzEdge00000 : BOOL;
		CasHomingu : TON;
		CasPolohovania : TON;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK UintToUdint (*Prevod 16 bitových premenných do jednej 32 bitovej premennej*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		InputArrayUINT : {REDUND_UNREPLICABLE} ARRAY[0..1] OF UINT;
	END_VAR
	VAR_OUTPUT
		OutputUDINT : {REDUND_UNREPLICABLE} UDINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK UdintToUint (*Prevod 32 bitovej premennej do 16 bitových premenných*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		InputUDINT : {REDUND_UNREPLICABLE} UDINT;
	END_VAR
	VAR_OUTPUT
		OutputArrayUINT : {REDUND_UNREPLICABLE} ARRAY[0..1] OF UINT;
	END_VAR
END_FUNCTION_BLOCK

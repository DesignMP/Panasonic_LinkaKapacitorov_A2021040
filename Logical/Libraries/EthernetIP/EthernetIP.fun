
{REDUND_ERROR} FUNCTION_BLOCK KOM_EthernetIP (*Komunikacia z Panasonic*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Server_IN : Inputs_typ;
		Mapping_IN : ARRAY[0..99] OF UDINT;
	END_VAR
	VAR_OUTPUT
		Server_OUT : Outputs_typ;
		Mapping_OUT : ARRAY[0..99] OF UDINT;
	END_VAR
	VAR
		SerNumber_InterEtiketa_PoleUSINT : ARRAY[0..47] OF USINT;
		SerNumber_InterEtiketa_PoleUDINT : ARRAY[0..47] OF UDINT;
		NazovPaletky_RFID_PoleUSINT : ARRAY[0..9] OF USINT;
		NazovPaletky_RFID_PoleUDINT : ARRAY[0..9] OF UDINT;
		Cislo_LOTU_PoleUSINT : ARRAY[0..19] OF USINT;
		Cislo_LOTU_PoleUDINT : ARRAY[0..19] OF UDINT;
		SerNumber_ZakazEtiketa_PoleUSINT : ARRAY[0..48] OF USINT;
		SerNumber_ZakazEtiketa_PoleUDINT : ARRAY[0..48] OF UDINT;
		ReturnProcessName_PoleUSINT : ARRAY[0..29] OF USINT;
		ReturnProcessName_PoleUDINT : ARRAY[0..29] OF UDINT;
		a : USINT;
		b : USINT;
		c : USINT;
		d : USINT;
		e : USINT;
	END_VAR
END_FUNCTION_BLOCK

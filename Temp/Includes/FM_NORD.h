/* Automation Studio generated header file */
/* Do not edit ! */
/* FM_NORD  */

#ifndef _FM_NORD_
#define _FM_NORD_
#ifdef __cplusplus
extern "C" 
{
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef struct MenicSTAV_typ
{	plcbit PORUCHA;
	plcbit Pozicia_DOSIAHNUTA;
	plcbit RUN;
	plcbit READY;
	plcbit Homing_OK;
	plcbit ParamSada_BIT0_ENABLE;
	plcbit ParamSada_BIT1_ENABLE;
	plcbit QuickStop_Aktivny;
	plcbit Komunikacia_OK;
} MenicSTAV_typ;

typedef struct MenicCMD_typ
{	plcbit Chod_VPRED;
	plcbit Chod_VZAD;
	plcbit QuickSTOP;
	plcbit Polohuj;
	plcbit Potvrd_PORUCHU;
	plcbit HOME;
	plcbit Pozicia_RESET;
} MenicCMD_typ;

typedef struct MenicPAR_typ
{	float ZadanaFrekvencia_Hz;
	float AktualnaFrekvencia_Hz;
	float AktualnyMoment_Nm;
	unsigned long ZadanaPozicia_MM;
	unsigned long AktualnaPozicia_MM;
	plcbit TypKomunikacieProfinet;
	plcbit SwapovanieKomunikacie;
	plcbit BUS_IN_Bit_0;
	plcbit BUS_IN_Bit_1;
	plcbit BUS_IN_Bit_2;
	plcbit BUS_IN_Bit_3;
	plcbit BUS_IN_Bit_4;
	plcbit BUS_IN_Bit_5;
	plcbit BUS_IN_Bit_6;
	plcbit BUS_OUT_Bit_0;
	plcbit BUS_OUT_Bit_1;
	plcbit BUS_OUT_Bit_2;
	plcbit BUS_OUT_Bit_3;
	plcbit BUS_OUT_Bit_4;
	plcbit BUS_OUT_Bit_5;
	plcbit BUS_OUT_Bit_6;
} MenicPAR_typ;

typedef struct PowerlinkKOM_IN_typ
{	unsigned short StavoveSlovo;
	signed short StavovaHodnota_1;
	signed short StavovaHodnota_2;
	signed short StavovaHodnota_3;
	signed short StavovaHodnota_4;
	signed short StavovaHodnota_5;
} PowerlinkKOM_IN_typ;

typedef struct PowerlinkKOM_OUT_typ
{	unsigned short RiadiaceSlovo;
	signed short ZadanaHodnota_1;
	signed short ZadanaHodnota_2;
	signed short ZadanaHodnota_3;
	signed short ZadanaHodnota_4;
	signed short ZadanaHodnota_5;
} PowerlinkKOM_OUT_typ;

typedef struct ProfinetKOM_IN_typ
{	unsigned short StavoveSlovo;
	unsigned short StavovaHodnota_1;
	unsigned short StavovaHodnota_2;
	unsigned short StavovaHodnota_3;
	unsigned short StavovaHodnota_4;
	unsigned short StavovaHodnota_5;
} ProfinetKOM_IN_typ;

typedef struct ProfinetKOM_OUT_typ
{	unsigned short RiadiaceSlovo;
	unsigned short ZadanaHodnota_1;
	unsigned short ZadanaHodnota_2;
	unsigned short ZadanaHodnota_3;
	unsigned short ZadanaHodnota_4;
	unsigned short ZadanaHodnota_5;
} ProfinetKOM_OUT_typ;

typedef struct UdintToUint
{
	/* VAR_INPUT (analog) */
	unsigned long InputUDINT;
	/* VAR_OUTPUT (analog) */
	unsigned short OutputArrayUINT[2];
} UdintToUint_typ;

typedef struct UintToUdint
{
	/* VAR_INPUT (analog) */
	unsigned short InputArrayUINT[2];
	/* VAR_OUTPUT (analog) */
	unsigned long OutputUDINT;
} UintToUdint_typ;

typedef struct RiadenieFM
{
	/* VAR_INPUT (analog) */
	struct MenicCMD_typ CMD;
	struct MenicPAR_typ PAR;
	struct PowerlinkKOM_IN_typ Powerlink_KOM_IN;
	struct ProfinetKOM_IN_typ Profinet_KOM_IN;
	/* VAR_OUTPUT (analog) */
	struct PowerlinkKOM_OUT_typ Powerlink_KOM_OUT;
	struct ProfinetKOM_OUT_typ Profinet_KOM_OUT;
	struct MenicSTAV_typ STAV;
	/* VAR (analog) */
	unsigned char Step;
	struct LCRScal SCAL_ZadanejFrekvencie;
	struct LCRScal SCAL_AktualnejFrekvencie;
	struct LCRScal SCAL_AktualnehoMomentu;
	struct UdintToUint CONV_ZadPoz_UDINT_to_UINT;
	struct UintToUdint CONV_AktPoz_UINT_to_UDINT;
	signed short ZadanaFrekvencia_preFM;
	float AktualnaFrekvencia_zFM_REAL;
	signed short AktualnaFrekvencia_zFM;
	signed short AktualnyMoment_zFM;
	float AktualnyMoment_zFM_REAL;
	signed short ZadanaPozicia_LW_preFM;
	signed short ZadanaPozicia_HW_preFM;
	signed short AktualnaPozicia_LW_zFM;
	signed short AktualnaPozicia_HW_zFM;
	unsigned short StavoveSlovo;
	unsigned short StavovaHodnota_1;
	unsigned short StavovaHodnota_2;
	unsigned short StavovaHodnota_3;
	unsigned short StavovaHodnota_4;
	unsigned short StavovaHodnota_5;
	unsigned short RiadiaceSlovo;
	unsigned short ZadanaHodnota_1;
	unsigned short ZadanaHodnota_2;
	unsigned short ZadanaHodnota_3;
	unsigned short ZadanaHodnota_4;
	unsigned short ZadanaHodnota_5;
	struct TON CasHomingu;
	struct TON CasPolohovania;
	/* VAR (digital) */
	plcbit zzEdge00000;
} RiadenieFM_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void RiadenieFM(struct RiadenieFM* inst);
_BUR_PUBLIC void UintToUdint(struct UintToUdint* inst);
_BUR_PUBLIC void UdintToUint(struct UdintToUint* inst);


#ifdef __cplusplus
};
#endif
#endif /* _FM_NORD_ */


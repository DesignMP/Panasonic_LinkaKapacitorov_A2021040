/* Automation Studio generated header file */
/* Do not edit ! */
/* EthernetIP  */

#ifndef _ETHERNETIP_
#define _ETHERNETIP_
#ifdef __cplusplus
extern "C" 
{
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef struct Inputs_typ
{	plcbit ProcessResult;
	plcbit RFID_Reading_Error;
	plcbit Blowing_Error;
	plcbit QRcode_Reading_Error;
	plcbit DMcode_Reading_Error;
	plcbit Text_Reading_Error;
	plcbit VytlacEtiketu_RucnyRezim;
	plcbit RezimBezTlaceEtikety;
	unsigned long CommandNumber;
	plcstring SerialNumber_InternaEtiketa[49];
	plcstring NazovPaletky_RFID[11];
	plcstring Cislo_LOTU[21];
	plcbit DataForServer_READY;
} Inputs_typ;

typedef struct Outputs_typ
{	plcbit ContinueToNextProcess;
	plcstring SerialNumber_ZakaznickaEtiketa[50];
	plcstring ReturnProcessName[31];
	plcbit DataForPLC_READY;
	unsigned long LastCommandNumber;
} Outputs_typ;

typedef struct KOM_EthernetIP
{
	/* VAR_INPUT (analog) */
	struct Inputs_typ Server_IN;
	unsigned long Mapping_IN[100];
	/* VAR_OUTPUT (analog) */
	struct Outputs_typ Server_OUT;
	unsigned long Mapping_OUT[100];
	/* VAR (analog) */
	unsigned char SerNumber_InterEtiketa_PoleUSINT[48];
	unsigned long SerNumber_InterEtiketa_PoleUDINT[48];
	unsigned char NazovPaletky_RFID_PoleUSINT[10];
	unsigned long NazovPaletky_RFID_PoleUDINT[10];
	unsigned char Cislo_LOTU_PoleUSINT[20];
	unsigned long Cislo_LOTU_PoleUDINT[20];
	unsigned char SerNumber_ZakazEtiketa_PoleUSINT[49];
	unsigned long SerNumber_ZakazEtiketa_PoleUDINT[49];
	unsigned char ReturnProcessName_PoleUSINT[30];
	unsigned long ReturnProcessName_PoleUDINT[30];
	unsigned char a;
	unsigned char b;
	unsigned char c;
	unsigned char d;
	unsigned char e;
} KOM_EthernetIP_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void KOM_EthernetIP(struct KOM_EthernetIP* inst);


#ifdef __cplusplus
};
#endif
#endif /* _ETHERNETIP_ */


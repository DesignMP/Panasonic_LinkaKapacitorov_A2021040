[LIT]
29
20	259	16	268	16
21	268	16	303	16
22	268	29	279	29
23	268	16	268	29
32	335	29	340	29
34	304	29	305	29
35	305	29	322	29
36	305	48	313	48
37	305	29	305	48
41	200	42	204	42
42	200	16	200	42
54	200	16	229	16
59	177	16	200	16
64	157	33	163	33
65	163	33	163	20
66	163	20	165	20
67	29	34	38	34
68	38	46	47	46
69	143	34	143	33
70	143	33	145	33
71	38	34	143	34
72	28	16	165	16
73	38	34	38	46
74	114	56	114	37
75	114	37	145	37
76	33	56	38	56
77	38	56	114	56
78	38	65	48	65
79	38	56	38	65

[TET]
14
0	2	15	28	17	4	5	Status_ZonaCS_AKTIVNA
12	222	11	229	13	4	5	TRUE
13	217	19	229	21	4	5	SAFETRUE
14	217	23	229	25	4	5	SAFETRUE
15	203	27	229	29	4	5	Reset_ZonyVstupnyVytah
16	303	15	325	17	4	3	soZonaVstupnyVytah
30	307	32	322	34	4	5	TIME#500ms
31	340	28	370	30	4	3	Release_soZonaVstupnyVytah
33	313	47	345	49	4	3	Stav_ZonaVstupVytah_AKTIVNA
43	229	41	263	43	4	3	Stav_ZonaVstupVytah_ODBLOKOV
44	5	33	29	35	4	5	siVstupnyVytah_Bariera
48	72	45	104	47	4	3	Stav_BarieraVstupVytahu_AKTIV
49	3	55	33	57	4	5	siVstupnyVytah_HornySnimac
50	73	64	107	66	4	3	Stav_MutingBarVstupVytah_AKTIV

[FBS]
8
10	231	8	257	32	0	SF_EmergencyStop_V1_00	Zona_VstupnyVytah
19	281	25	302	33	1	SAFEBOOL_TO_BOOL	
28	324	25	333	37	0	TON	CasRelease_ZonaVstupVytah
40	206	38	227	46	1	SAFEBOOL_TO_BOOL	
47	49	42	70	50	1	SAFEBOOL_TO_BOOL	
53	50	61	71	69	1	SAFEBOOL_TO_BOOL	
58	167	12	175	24	1	AND_S	
63	147	29	155	41	1	OR_S	

[FPT]
27
1	231	11	241	13	Activate	0	128	0	BOOL
2	231	15	243	17	S_EStopIn	0	128	0	SAFEBOOL
3	231	19	245	21	S_StartReset	0	128	0	SAFEBOOL
4	231	23	245	25	S_AutoReset	0	128	0	SAFEBOOL
5	231	27	239	29	Reset	0	128	0	BOOL
6	250	11	257	13	Ready	1	0	128	BOOL
7	245	15	257	17	S_EStopOut	1	0	128	SAFEBOOL
8	251	19	257	21	Error	1	0	128	BOOL
9	247	23	257	25	DiagCode	1	0	128	WORD
17	281	28	283	30		0	640	0	SAFEBOOL
18	301	28	302	30		1	0	640	BOOL
24	324	28	329	30	IN	0	129	0	BOOL
25	324	32	329	34	PT	0	128	0	TIME
26	330	28	333	30	Q	1	0	129	BOOL
27	329	32	333	34	ET	1	0	128	TIME
38	206	41	208	43		0	640	0	SAFEBOOL
39	226	41	227	43		1	0	640	BOOL
45	49	45	51	47		0	640	0	SAFEBOOL
46	69	45	70	47		1	0	640	BOOL
51	50	64	52	66		0	640	0	SAFEBOOL
52	70	64	71	66		1	0	640	BOOL
55	167	15	169	17		0	1665	0	ANY_SAFEBIT
56	167	19	169	21		0	1665	0	ANY_SAFEBIT
57	174	15	175	17		1	0	641	ANY_SAFEBIT
60	147	32	149	34		0	1665	0	ANY_SAFEBIT
61	147	36	149	38		0	1665	0	ANY_SAFEBIT
62	154	32	155	34		1	0	641	ANY_SAFEBIT

[KOT]
0

[VER]
0


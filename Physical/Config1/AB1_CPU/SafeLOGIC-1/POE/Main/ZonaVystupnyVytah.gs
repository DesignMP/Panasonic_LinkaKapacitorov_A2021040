[LIT]
28
20	172	48	176	48
25	239	15	249	15
26	249	15	271	15
27	249	33	258	33
28	249	15	249	33
38	283	33	290	33
39	290	33	318	33
40	290	51	299	51
41	290	33	290	51
52	172	15	172	48
53	172	15	209	15
58	151	15	172	15
63	135	31	137	31
64	137	31	137	19
65	137	19	139	19
66	37	15	139	15
67	37	32	44	32
68	44	43	51	43
69	44	32	121	32
70	121	32	121	31
71	121	31	123	31
72	44	32	44	43
73	39	52	45	52
74	45	60	52	60
75	45	52	121	52
76	121	52	121	35
77	121	35	123	35
78	45	52	45	60

[TET]
14
0	11	14	37	16	4	5	Status_ZonaCS_AKTIVNA
1	201	47	236	49	4	3	Stav_ZonaVystupVytah_ODBLOKOV
16	202	10	209	12	4	5	TRUE
17	197	18	209	20	4	5	SAFETRUE
18	197	22	209	24	4	5	SAFETRUE
19	182	26	209	28	4	5	Reset_ZonyVystupnyVytah
21	271	14	294	16	4	3	soZonaVystupnyVytah
35	303	36	318	38	4	5	TIME#500ms
36	331	32	362	34	4	3	Release_soZonaVystupnyVytah
37	299	50	332	52	4	3	Stav_ZonaVystupVytah_AKTIVNA
42	12	31	37	33	4	5	siVystupnyVytah_Bariera
43	76	42	109	44	4	3	Stav_BarieraVystupVytahu_AKTIV
47	8	51	39	53	4	5	siVystupnyVytah_HornySnimac
48	77	59	110	61	4	3	Stav_MutingBarVystVytah_AKTIV

[FBS]
8
4	178	44	199	52	1	SAFEBOOL_TO_BOOL	
14	211	7	237	31	0	SF_EmergencyStop_V1_00	Zona_VystupnyVytah
24	260	29	281	37	1	SAFEBOOL_TO_BOOL	
33	320	29	329	41	0	TON	CasRelease_ZonaVystupVytah
46	53	39	74	47	1	SAFEBOOL_TO_BOOL	
51	54	56	75	64	1	SAFEBOOL_TO_BOOL	
57	141	11	149	23	1	AND_S	
62	125	27	133	39	1	OR_S	

[FPT]
27
2	178	47	180	49		0	640	0	SAFEBOOL
3	198	47	199	49		1	0	640	BOOL
5	211	10	221	12	Activate	0	128	0	BOOL
6	211	14	223	16	S_EStopIn	0	128	0	SAFEBOOL
7	211	18	225	20	S_StartReset	0	128	0	SAFEBOOL
8	211	22	225	24	S_AutoReset	0	128	0	SAFEBOOL
9	211	26	219	28	Reset	0	128	0	BOOL
10	230	10	237	12	Ready	1	0	128	BOOL
11	225	14	237	16	S_EStopOut	1	0	128	SAFEBOOL
12	231	18	237	20	Error	1	0	128	BOOL
13	227	22	237	24	DiagCode	1	0	128	WORD
22	260	32	262	34		0	640	0	SAFEBOOL
23	280	32	281	34		1	0	640	BOOL
29	320	32	325	34	IN	0	129	0	BOOL
30	320	36	325	38	PT	0	128	0	TIME
31	326	32	329	34	Q	1	0	129	BOOL
32	325	36	329	38	ET	1	0	128	TIME
44	53	42	55	44		0	640	0	SAFEBOOL
45	73	42	74	44		1	0	640	BOOL
49	54	59	56	61		0	640	0	SAFEBOOL
50	74	59	75	61		1	0	640	BOOL
54	141	14	143	16		0	1665	0	ANY_SAFEBIT
55	141	18	143	20		0	1665	0	ANY_SAFEBIT
56	148	14	149	16		1	0	641	ANY_SAFEBIT
59	125	30	127	32		0	1665	0	ANY_SAFEBIT
60	125	34	127	36		0	1665	0	ANY_SAFEBIT
61	132	30	133	32		1	0	641	ANY_SAFEBIT

[KOT]
0

[VER]
0


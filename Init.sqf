if not (isServer) exitWith {};

_taken = profileNamespace getVariable ["RYD_WS_MapColors" + worldName,[]];

RydxHQ_NoRestPlayers = true;
RydxHQ_NoCargoPlayers = true;
RydHQ_Actions = true;
RydxHQ_ReconCargo = false;
RydHQ_Combining = true;

//RHQ SECTION

RHQ_Art = ["cup_b_m119_us","cup_b_m270_he_usa","lop_tka_static_d30","rhs_m119_d","rhs_m119_wd","rhs_2b14_82mm_vmf","rhs_2b14_82mm_msv","rhs_2b14_82mm_vdv","rhs_d30_vmf","rhs_d30_msv","rhs_d30_vdv","rhs_2s3_tv","rhsusf_m109d_usarmy","rhsusf_m109_usarmy","rhs_m252_d","rhs_m252_wd","rhs_bm21_msv_01","rhs_bm21_chdkz","rhs_bm21_vdv_01","rhs_bm21_vv_01","rhs_bm21_vmf_01","rhsusf_m142_usarmy_wd","rhsusf_m142_usarmy_d"];

RydHQ_Add_OtherArty = [
    [["cup_b_m270_he_usa","cup_b_m119_us"],["CUP_12Rnd_MLRS_HE","CUP_12Rnd_MLRS_HE","CUP_12Rnd_MLRS_HE","",""]],
    [["rhs_m119_d","rhs_m119_wd"],["RHS_mag_m1_he_12","RHS_mag_m1_he_12","RHS_mag_m1_he_12","rhs_mag_m60a2_smoke_4","rhs_mag_m314_ilum_4"]],
    [["lop_tka_static_d30"],["rhs_mag_of462_10","rhs_mag_of462_10","rhs_mag_of462_10","",""]],
    [["rhs_2b14_82mm_vmf","rhs_2b14_82mm_msv","rhs_2b14_82mm_vdv"],["rhs_mag_3vo18_10","rhs_mag_3vo18_10","rhs_mag_3vo18_10","rhs_mag_d832du_10","rhs_mag_3vs25m_10"]],
    [["rhs_d30_vmf","rhs_d30_msv","rhs_d30_vdv"],["rhs_mag_3of56_10","rhs_mag_3of69m_2","rhs_mag_3of56_10","rhs_mag_d462_2","rhs_mag_s463_2"]],
    [["rhs_2s3_tv"],["rhs_mag_HE_2a33","rhs_mag_LASER_2a33","rhs_mag_WP_2a33","rhs_mag_SMOKE_2a33","rhs_mag_ILLUM_2a33"]],
    [["rhsusf_m109d_usarmy","rhsusf_m109_usarmy"],["rhs_mag_155mm_m795_28","rhs_mag_155mm_m712_2","rhs_mag_155mm_m864_3","rhs_mag_155mm_m825a1_2","rhs_mag_155mm_485_2"]],
    [["rhs_m252_d","rhs_m252_wd"],["rhs_12Rnd_m821_HE","rhs_12Rnd_m821_HE","rhs_12Rnd_m821_HE","",""]],
    [["rhs_bm21_msv_01","rhs_bm21_chdkz","rhs_bm21_vdv_01","rhs_bm21_vv_01","rhs_bm21_vmf_01"],["RHS_mag_40Rnd_122mm_rockets","RHS_mag_40Rnd_122mm_rockets","RHS_mag_40Rnd_122mm_rockets","",""]],
    [["rhsusf_m142_usarmy_wd","rhsusf_m142_usarmy_d"],["rhs_ammo_m26a1_rocket","rhs_ammo_m26a1_rocket","rhs_ammo_m26a1_rocket","",""]],
    [["B_Ship_MRLS_01_F"],["magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_x18","magazine_Missiles_Cruise_01_Cluster_x18","",""]]
    ];


RydHQ_CargoFind = 100;   
RydHQB_CargoFind = 100;

RydHQ_SimpleMode = false;   
RydHQB_SimpleMode = false;   

_sumB = 0;
_sumO = 0;
_sumI = 0;

_bTaken = [];
_oTaken = [];
_iTaken = [];

RydxHQ_Markers = [];

RYD_Marker = 
	{
	private ["_name","_pos","_cl","_shape","_size","_dir","_alpha","_type","_brush","_text","_i"];	

	_name = _this select 0;
	_pos = _this select 1;
	_cl = _this select 2;
	_shape = _this select 3;

	_shape = toUpper (_shape);

	_size = _this select 4;
	_dir = _this select 5;
	_alpha = _this select 6;

	if not (_shape == "ICON") then {_brush = _this select 7} else {_type = _this select 7};
	_text = _this select 8;

	if not ((typename _pos) == "ARRAY") exitWith {};
	if ((_pos select 0) == 0) exitWith {};
	if ((count _pos) < 2) exitWith {};
//diag_log format ["BB mark: %1 pos: %2 col: %3 size: %4 dir: %5 text: %6",_name,_pos,_cl,_size,_dir,_text];
	if (isNil "_pos") exitWith {};

	_i = _name;
	_i = createMarker [_i,_pos];
	_i setMarkerColor _cl;
	_i setMarkerShape _shape;
	_i setMarkerSize _size;
	_i setMarkerDir _dir;
	if not (_shape == "ICON") then {_i setMarkerBrush _brush} else {_i setMarkerType _type};
	_i setMarkerAlpha _alpha;
	_i setmarkerText _text;
	
	RydxHQ_Markers set [(count RydxHQ_Markers),_i]; 

	_i
	};
	
RYD_WS_FreeChoice =
	{
	createDialog "RscFreeMap";

	openMap true; 
	
	waitUntil
		{
		not (isNull (findDisplay 2501))
		};
	
	_code = 
		{
		params ["_units", "_pos", "_alt", "_shift"];
		
		if not (surfaceIsWater _pos) then
			{
			if (_alt) then
				{
				deleteMarker RYD_WS_BPMarker;
				RYD_WS_BattlePosition = []
				}
			else
				{
				RYD_WS_BattlePosition = _pos;
				deleteMarker RYD_WS_BPMarker;
				RYD_WS_BPMarker = ["WS_BPMark",_pos,"ColorRed","ICON",[1,1],0,1,"mil_objective"," BATTLE LOCATION"] call RYD_Marker;
				}
			};
		};
	
	_ix = addMissionEventHandler ["MapSingleClick", _code];
		
	waitUntil
		{
		(isNull (findDisplay 2501))
		};
		
	removeMissionEventHandler ["MapSingleClick",_ix];
	deleteMarker RYD_WS_BPMarker;
	};
	
RYD_WS_BattlePosition = [];
RYD_WS_BPMarker = "";

_cpMarks = [];

	{
	_pos = _x select 0;
	_cl = _x select 1;
	
	switch (toLower _cl) do
		{
		case ("colorwest") : 
			{
			_sumB = _sumB + 1;
			_bTaken set [(count _bTaken),_pos];
			_mark = [str (_x),_pos,_cl,"RECTANGLE",[251.8035,251.8035],0,1,"Solid",""] call RYD_Marker;
			_cpMarks set [(count _cpMarks),_mark]
			};
			
		case ("coloreast") : 
			{
			_sumO = _sumO + 1;
			_oTaken set [(count _oTaken),_pos];
			_mark = [str (_x),_pos,_cl,"RECTANGLE",[251.8035,251.8035],0,1,"Solid",""] call RYD_Marker;
			_cpMarks set [(count _cpMarks),_mark]
			};
			
		case ("colorguer") : 
			{
			_sumI = _sumI + 1;
			_iTaken set [(count _iTaken),_pos];
			_mark = [str (_x),_pos,_cl,"RECTANGLE",[251.8035,251.8035],0,1,"Solid",""] call RYD_Marker;
			_cpMarks set [(count _cpMarks),_mark]
			};
		}
	}
foreach _taken;

0 fadeMusic 0.4;
0 fadeSound 0;
enableSentences false;

west setFriend [resistance, 0];
resistance setFriend [west, 0];

east setFriend [resistance, 0];
resistance setFriend [east, 0];

RYD_WS_SpawnPositions = [[0,0,0]];

RydBB_Debug = false;

RydHQ_Debug = false;
RydHQB_Debug = false;

RydHQ_DebugII = false;
RydHQB_DebugII = false;

RydHQ_CargoFind = 100;
RydHQB_CargoFind = 100;

RydHQ_PathFinding = 100;

RydHQ_LRelocating = true;
RydHQ_GetHQInside = true;

RydHQB_LRelocating = true;
RydHQB_GetHQInside = true;

RydHQ_IDChance = 15;
RydHQB_IDChance = 15;

RydHQ_DynForm = true;
RydHQB_DynForm = true;

RydHQ_AirEvac = true;
RydHQB_AirEvac = true;

RydHQ_AAO = true;
RydHQB_AAO = true;

RydHQ_Surr = true;
RydHQB_Surr = true;

RydHQ_Rush = true;
RydHQB_Rush = true;

RydHQ_ChatDebug = true;
//RydHQ_GroupMarks = [west,east,resistance,civilian];

RydHQ_SubAll = true;
RydHQB_SubAll = true;

RydHQ_SMed = true;
RydHQB_SMed = true;

RydHQ_SFuel = true;
RydHQB_SFuel = true;

RydHQ_SAmmo = true;
RydHQB_SAmmo = true;

RydHQ_SRep = true;
RydHQB_SRep = true;

RydHQ_Smoke = true;
RydHQB_Smoke = true;

RydHQ_Flare = true;
RydHQB_Flare = true;

RydHQ_ArtyShells = 1;
RydHQB_ArtyShells = 1;

RydHQ_KnowTL = true;

RydxHQ_AIChatDensity = 30;

RydHQ_Wait = 20;

RydHQ_MoraleConst = 1.1;
RydHQB_MoraleConst = 1.1;

RydHQ_OffTend = 1.1;
RydHQB_OffTend = 1.1;

RYD_WS_Debug = false;

RYD_WS_ArtyMarks = true;

RYD_WS_Ratio = 1;

RYD_WS_Marta = true;

RYD_WS_CReset = false;
RYD_WS_CAdd = true;

RYD_WS_Killed_A = [];
RYD_WS_Killed_B = [];

RYD_WS_Wounded_A = [];

RYD_WS_HSRatio_A = 1;
RYD_WS_HSRatio_B = 1;

RYD_WS_Reset = true;
RYD_WS_B_Factions = [["blu_f","NATO"],["blu_g_f","FIA"]];
RYD_WS_O_Factions = [["opf_f","CSAT"]];
RYD_WS_I_Factions = [["ind_f","AAF"]];

RYD_WS_Fatigue = true;

_facClass = configFile >> "CfgFactionClasses";

for "_i" from 0 to ((count _facClass) - 1) do
	{
	_class = _facClass select _i;
	
	if (isClass _class) then
		{
		_faction = toLower (configName _class);
		
		if not (_faction in ["blu_f","blu_g_f","opf_f","ind_f","ind_g_f","opf_g_f"]) then
			{
			_side = getNumber (_facClass >> _faction >> "side");
			
			if (_side in [0,1,2]) then
				{
				_displayName = getText (_facClass >> _faction >> "displayName");
				
				switch (_side) do
					{				
					case (0) : 
						{
						RYD_WS_O_Factions set [(count RYD_WS_O_Factions),[_faction,_displayName]]
						};
						
					case (1) : 
						{
						RYD_WS_B_Factions set [(count RYD_WS_B_Factions),[_faction,_displayName]]
						};
						
					case (2) : 
						{
						RYD_WS_I_Factions set [(count RYD_WS_I_Factions),[_faction,_displayName]]
						};
					}
				}
			};
		}
	};

RYD_WS_TakeValues = 
	{	
	_txt = "";
		
	_ix = lbCurSel 2100;

	switch (_ix) do
		{
		case (RYD_ix_SideA_B) : {RYD_WS_SideA = west;_txt = "WEST"};
		case (RYD_ix_SideA_I) : {RYD_WS_SideA = resistance;_txt = "RESISTANCE"};
		case (RYD_ix_SideA_O) : {RYD_WS_SideA = east;_txt = "EAST"};
		/*case (RYD_ix_SideA_R) :
			{
			_ix2 = floor (random 3);
			switch (_ix2) do
				{
				case (0) : {RYD_WS_SideA = west;_txt = "WEST"};
				case (1) : {RYD_WS_SideA = resistance;_txt = "RESISTANCE"};
				case (2) : {RYD_WS_SideA = east;_txt = "EAST"};
				};
			}*/
		};
		
	profileNamespace setVariable ["RYD_ix_SideA",_ix];
	
	_txtM = format ["<font size=13>SIDE A:</font><font color='#d0a900' size=12><br />%1</font>",_txt];
	
	_ix = lbCurSel 21000;
	
	RYD_WS_FacA = missionNamespace getVariable [(str _ix)+"_fl_21000",[0,"NATO","blu_f"]];
	
	profileNamespace setVariable ["RYD_ix_FacA",RYD_WS_FacA select 0];
	
	_txt = RYD_WS_FacA select 1;
	
	_txtM = _txtM + (format ["<font size=13><br /><br />FACTION A:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	
	_ix = lbCurSel 2101;

	switch (_ix) do
		{
		case (RYD_ix_SideB_B) : {RYD_WS_SideB = west;_txt = "WEST",""};
		case (RYD_ix_SideB_I) : {RYD_WS_SideB = resistance;_txt = "RESISTANCE"};
		case (RYD_ix_SideB_O) : {RYD_WS_SideB = east;_txt = "EAST"};
		/*case (RYD_ix_SideB_R) :
			{
			_ix2 = floor (random 3);
			switch (_ix2) do
				{
				case (0) : {RYD_WS_SideB = west;_txt = "WEST"};
				case (1) : {RYD_WS_SideB = resistance;_txt = "RESISTANCE"};
				case (2) : {RYD_WS_SideB = east;_txt = "EAST"};
				};
			}*/
		};
		
	profileNamespace setVariable ["RYD_ix_SideB",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />SIDE B:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 21010;
	
	RYD_WS_FacB = missionNamespace getVariable [(str _ix)+"_fl_21010",[0,"CSAT","opf_f"]];
	
	profileNamespace setVariable ["RYD_ix_FacB",RYD_WS_FacB select 0];
	
	_txt = RYD_WS_FacB select 1;
	
	_txtM = _txtM + (format ["<font size=13><br /><br />FACTION B:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 2105;

	switch (_ix) do
		{
		case (RYD_ix_Ratio_31) : {RYD_WS_Ratio = 3;_txt = "3:1"};
		case (RYD_ix_Ratio_21) : {RYD_WS_Ratio = 2;_txt = "2:1"};
		case (RYD_ix_Ratio_32) : {RYD_WS_Ratio = 1.5;_txt = "3:2"};
		case (RYD_ix_Ratio_11) : {RYD_WS_Ratio = 1;_txt = "1:1"};
		case (RYD_ix_Ratio_23) : {RYD_WS_Ratio = 0.67;_txt = "2:3"};
		case (RYD_ix_Ratio_12) : {RYD_WS_Ratio = 0.5;_txt = "1:2"};
		case (RYD_ix_Ratio_13) : {RYD_WS_Ratio = 0.33;_txt = "1:3"};
		case (RYD_ix_Ratio_R) :
			{
			_ix2 = floor (random 7);

			switch (_ix2) do
				{
				case (0) : {RYD_WS_Ratio = 3;_txt = "3:1"};
				case (1) : {RYD_WS_Ratio = 2;_txt = "2:1"};
				case (2) : {RYD_WS_Ratio = 1.5;_txt = "3:2"};
				case (3) : {RYD_WS_Ratio = 1;_txt = "1:1"};
				case (4) : {RYD_WS_Ratio = 0.67;_txt = "2:3"};
				case (5) : {RYD_WS_Ratio = 0.5;_txt = "1:2"};
				case (6) : {RYD_WS_Ratio = 0.33;_txt = "1:3"};
				};
			}
		};
		
	profileNamespace setVariable ["RYD_ix_Ratio",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />A/B Ratio:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 2102;

	switch (_ix) do
		{
		case (RYD_ix_Scale_S) : {RYD_WS_Scale = 1;_txt = "SMALL"};
		case (RYD_ix_Scale_M) : {RYD_WS_Scale = 1.5;_txt = "MEDIUM"};
		case (RYD_ix_Scale_B) : {RYD_WS_Scale = 2;_txt = "BIG"};
		case (RYD_ix_Scale_R) :
			{
			_ix2 = floor (random 3);
			switch (_ix2) do
				{
				case (0) : {RYD_WS_Scale = 1;_txt = "SMALL"};
				case (1) : {RYD_WS_Scale = 1.5;_txt = "MEDIUM"};
				case (2) : {RYD_WS_Scale = 2;_txt = "BIG"};
				};
			}
		};
		
	profileNamespace setVariable ["RYD_ix_Scale",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />SCALE:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 2107;

	switch (_ix) do
		{
		case (RYD_ix_HSRA_VL) : {RYD_WS_HSRatio_A = 2;_txt = "VERY LOW"};
		case (RYD_ix_HSRA_L) : {RYD_WS_HSRatio_A = 1.5;_txt = "LOW"};
		case (RYD_ix_HSRA_N) : {RYD_WS_HSRatio_A = 1;_txt = "NORMAL"};
		case (RYD_ix_HSRA_H) : {RYD_WS_HSRatio_A = 0.75;_txt = "HIGH"};
		case (RYD_ix_HSRA_VH) : {RYD_WS_HSRatio_A = 0.5;_txt = "VERY HIGH"};
		case (RYD_ix_HSRA_R) :
			{
			_ix2 = floor (random 5);
			switch (_ix2) do
				{
				case (0) : {RYD_WS_HSRatio_A = 2;_txt = "VERY LOW"};
				case (1) : {RYD_WS_HSRatio_A = 1.5;_txt = "LOW"};
				case (2) : {RYD_WS_HSRatio_A = 1;_txt = "NORMAL"};
				case (3) : {RYD_WS_HSRatio_A = 0.75;_txt = "HIGH"};
				case (4) : {RYD_WS_HSRatio_A = 0.5;_txt = "VERY HIGH"};
				};
			}
		};
		
	profileNamespace setVariable ["RYD_ix_HSRA",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />ARMOR DENSITY (A):</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 2108;

	switch (_ix) do
		{
		case (RYD_ix_HSRB_VL) : {RYD_WS_HSRatio_B = 2;_txt = "VERY LOW"};
		case (RYD_ix_HSRB_L) : {RYD_WS_HSRatio_B = 1.5;_txt = "LOW"};
		case (RYD_ix_HSRB_N) : {RYD_WS_HSRatio_B = 1;_txt = "NORMAL"};
		case (RYD_ix_HSRB_H) : {RYD_WS_HSRatio_B = 0.75;_txt = "HIGH"};
		case (RYD_ix_HSRB_VH) : {RYD_WS_HSRatio_B = 0.5;_txt = "VERY HIGH"};
		case (RYD_ix_HSRB_R) :
			{
			_ix2 = floor (random 5);
			switch (_ix2) do
				{
				case (0) : {RYD_WS_HSRatio_B = 2;_txt = "VERY LOW"};
				case (1) : {RYD_WS_HSRatio_B = 1.5;_txt = "LOW"};
				case (2) : {RYD_WS_HSRatio_B = 1;_txt = "NORMAL"};
				case (3) : {RYD_WS_HSRatio_B = 0.75;_txt = "HIGH"};
				case (4) : {RYD_WS_HSRatio_B = 0.5;_txt = "VERY HIGH"};
				};
			}
		};
		
	profileNamespace setVariable ["RYD_ix_HSRB",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />ARMOR DENSITY (B):</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 2103;

	switch (_ix) do
		{
		case (RYD_ix_Daytime_D) : {RYD_WS_Daytime = 5.5;_txt = "DAWN"};
		case (RYD_ix_Daytime_N) : {RYD_WS_Daytime = 12;_txt = "HIGH NOON"};
		case (RYD_ix_Daytime_S) : {RYD_WS_Daytime = 17.5;_txt = "EVENING"};
		case (RYD_ix_Daytime_M) : {RYD_WS_Daytime = 0;_txt = "MIDNIGHT"};
		case (RYD_ix_Daytime_R) :
			{
			RYD_WS_Daytime = (random 24);_txt = str (round RYD_WS_Daytime)
			}
		};
		
	profileNamespace setVariable ["RYD_ix_Daytime",_ix];

	_txtM = _txtM + (format ["<font size=13><br /><br />DAYTIME:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
		
	_ix = lbCurSel 2104;

	switch (_ix) do
		{
		case (RYD_ix_Weather_VG) : {RYD_WS_Weather = (random 0.15);_txt = "CLEAR"};
		case (RYD_ix_Weather_G) : {RYD_WS_Weather = 0.15 + (random 0.25);_txt = "LIGHT"};
		case (RYD_ix_Weather_M) : {RYD_WS_Weather = 0.4 + (random 0.2);_txt = "MEDIUM"};
		case (RYD_ix_Weather_P) : {RYD_WS_Weather = 0.6 + (random 0.25);_txt = "HEAVY"};
		case (RYD_ix_Weather_VP) : {RYD_WS_Weather = 0.85 + (random 0.15);_txt = "FULL"};
		case (RYD_ix_Weather_NC) : {RYD_WS_Weather = -1;_txt = "NO CHANGE"};
		case (RYD_ix_Weather_R) :
			{
			RYD_WS_Weather = (random 1);

			switch (true) do
				{
				case (RYD_WS_Weather < 0.15) : {_txt = "CLEAR"};
				case (RYD_WS_Weather < 0.4) : {_txt = "LIGHT"};
				case (RYD_WS_Weather < 0.6) : {_txt = "MEDIUM"};
				case (RYD_WS_Weather < 0.85) : {_txt = "HEAVY"};
				default {_txt = "FULL"};
				};
			}
		};
		
	profileNamespace setVariable ["RYD_ix_Weather",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />OVERCAST:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	_ix = lbCurSel 2106;

	switch (_ix) do
		{
		case (RYD_ix_Campaign_C) : {RYD_WS_CReset = false;RYD_WS_CAdd = true;_txt = "INCLUDE"};
		case (RYD_ix_Campaign_O) : {RYD_WS_CReset = false;RYD_WS_CAdd = false;_txt = "EXCLUDE"};
		case (RYD_ix_Campaign_R) : {RYD_WS_CReset = true;RYD_WS_CAdd = true;_txt = "RESET"};
		};
		
	profileNamespace setVariable ["RYD_ix_Campaign",_ix];
	
	_txtM = _txtM + (format ["<font size=13><br /><br />CAMPAIGN:</font><font color='#d0a900' size=12><br />%1</font>",_txt]);
	
	RYD_WS_txtM = _txtM;	
					
	_code = ctrlText 120;
	
	call compile _code;
	
	profileNamespace setVariable ["RYD_ix_Code",_code];
	
	saveProfileNamespace;
	
	RYD_WS_Reset = false;
	};
	
finishMissionInit;

_tracks = 
	[
	"LeadTrack02_F_Bootcamp"
	];

_track = _tracks select 0;

playMusic _track;

sleep 0.1;

1 fadeSound 1;

removeGoggles dummyPlayer;
dummyPlayer addGoggles "G_Shades_Blue";

dummyPlayer setDir (getDir sc1); 
(group dummyPlayer) setFormDir (getDir sc1);
dummyPlayer setPos (sc1 modelToWorld [0,-0.28,0.3]);
dummyPlayer disableAI "ANIM";
dummyPlayer switchMove "Acts_SittingWounded_in";
_ppos = dummyPlayer modelToWorld [0,100,1000];
//hideObject dummyPlayer;
RYD_init_cam = "camera" camCreate _ppos;
RYD_init_cam setDir 180;
RYD_init_cam camSetTarget dummyPlayer;
RYD_init_cam cameraEffect ["internal", "BACK"];
RYD_init_cam camCommit 0;

RYD_init_cam camSetRelPos [-2.5,1.5,1];
RYD_init_cam camCommit 180;

RYD_FactionFill = 
	{
	private ["_ctrl","_ix","_ctrlA","_ctrlB","_ctrlFill","_fac","_name","_factions","_newIx"];
	
	disableSerialization;
	
	_ctrl = _this select 0;
	_ix = _this select 1;
	
	_ctrlA = (findDisplay 2500) displayCtrl 2100;
	_ctrlB = (findDisplay 2500) displayCtrl 2101;
	
	_ctrlFill = switch (_ctrl) do
		{
		case (_ctrlA) : {21000};
		case (_ctrlB) : {21010};
		};
		
		
	lbClear _ctrlFill;
	
	_factions = switch (_ix) do
		{		
		case (RYD_ix_SideA_B) : {RYD_WS_B_Factions};
		case (RYD_ix_SideB_B) : {RYD_WS_B_Factions};		
		case (RYD_ix_SideA_I) : {RYD_WS_I_Factions};
		case (RYD_ix_SideB_I) : {RYD_WS_I_Factions};
		case (RYD_ix_SideA_O) : {RYD_WS_O_Factions};
		case (RYD_ix_SideB_O) : {RYD_WS_O_Factions};
		};
	
/*	_factions = [];
	
	switch (true) do
		{		
		case ((_ix == RYD_ix_SideA_B) and (_ctrl in [_ctrlA])) : {_factions = RYD_WS_B_Factions};
		case ((_ix == RYD_ix_SideB_B) and (_ctrl in [_ctrlB])) : {_factions = RYD_WS_B_Factions};		
		case ((_ix == RYD_ix_SideA_I) and (_ctrl in [_ctrlA])) : {_factions = RYD_WS_I_Factions};
		case ((_ix == RYD_ix_SideB_I) and (_ctrl in [_ctrlB])) : {_factions = RYD_WS_I_Factions};
		case ((_ix == RYD_ix_SideA_O) and (_ctrl in [_ctrlA])) : {_factions = RYD_WS_O_Factions};
		case ((_ix == RYD_ix_SideB_O) and (_ctrl in [_ctrlB])) : {_factions = RYD_WS_O_Factions};
		};*/
		
		{
		_fac = _x select 0;
		_name = _x select 1;
		
		_newIx = lbAdd [_ctrlFill, _name];

		missionNamespace setVariable [(str _newIx)+"_fl_"+(str _ctrlFill),[_newIx,_name,toLower _fac]];
		}
	foreach _factions;
		
	lbSetCurSel [_ctrlFill, profileNamespace getVariable ["RYD_ix_FacA",0]];
		
	true
	};
	
RYD_SideFill = 
	{
	private ["_ctrl","_ix","_ctrlA","_ctrlB"];
	
	_ctrl = _this select 0;
	_ix = _this select 1;
	
	_ctrlA = (findDisplay 2500) displayCtrl 2100;
	_ctrlB = (findDisplay 2500) displayCtrl 2101;
	
	switch (_ctrl) do
		{
		case (_ctrlA) :
			{
			_ctrlB ctrlRemoveEventHandler ["LBSelChanged",RYD_eh_SB];
			//lbClear 2101;
			
			switch (_ix) do
				{
				case (RYD_ix_SideA_B) :
					{
					//RYD_ix_SideB_B = -1;
					//RYD_ix_SideB_I = lbAdd [2101, "RESISTANCE"];
					//RYD_ix_SideB_O = lbAdd [2101, "EAST"];
					
					if ((lbCurSel 2101) in [RYD_ix_SideB_B]) then
						{
						lbSetCurSel [2101,RYD_ix_SideB_O];
						
						[_ctrlB,RYD_ix_SideB_O] call RYD_FactionFill
						};
					};
					
				case (RYD_ix_SideA_I) :
					{
					//RYD_ix_SideB_B = lbAdd [2101, "WEST"];
					//RYD_ix_SideB_I = -1;
					//RYD_ix_SideB_O = lbAdd [2101, "EAST"];
					
					if ((lbCurSel 2101) in [RYD_ix_SideB_I]) then
						{
						lbSetCurSel [2101,RYD_ix_SideB_O];
						
						[_ctrlB,RYD_ix_SideB_O] call RYD_FactionFill
						};
					};
					
				case (RYD_ix_SideA_O) :
					{
					//RYD_ix_SideB_B = lbAdd [2101, "WEST"];
					//RYD_ix_SideB_I = lbAdd [2101, "RESISTANCE"];
					//RYD_ix_SideB_O = -1;

					if ((lbCurSel 2101) in [RYD_ix_SideB_O]) then
						{
						lbSetCurSel [2101,RYD_ix_SideB_I];
						
						[_ctrlB,RYD_ix_SideB_I] call RYD_FactionFill
						};
					};
				};
				
			RYD_eh_SB = _ctrlB ctrlAddEventHandler ["LBSelChanged","_this call RYD_FactionFill;_this call RYD_SideFill"];
			};
			
		case (_ctrlB) :
			{
			_ctrlA ctrlRemoveEventHandler ["LBSelChanged",RYD_eh_SA];
			//lbClear 2100;
			
			switch (_ix) do
				{
				case (RYD_ix_SideB_B) :
					{
					//RYD_ix_SideA_B = -1;
					//RYD_ix_SideA_I = lbAdd [2100, "RESISTANCE"];
					//RYD_ix_SideA_O = lbAdd [2100, "EAST"];
					
					if ((lbCurSel 2100) in [RYD_ix_SideA_B]) then
						{
						lbSetCurSel [2100,RYD_ix_SideA_I];
						
						[_ctrlA,RYD_ix_SideA_I] call RYD_FactionFill
						};
					};
					
				case (RYD_ix_SideB_I) :
					{
					//RYD_ix_SideA_B = lbAdd [2100, "WEST"];
					//RYD_ix_SideA_I = -1;
					//RYD_ix_SideA_O = lbAdd [2100, "EAST"];
					
					if ((lbCurSel 2100) in [RYD_ix_SideA_I]) then
						{
						lbSetCurSel [2100,RYD_ix_SideA_B];
						
						[_ctrlA,RYD_ix_SideA_B] call RYD_FactionFill
						};
					};
					
				case (RYD_ix_SideB_O) :
					{
					//RYD_ix_SideA_B = lbAdd [2100, "WEST"];
					//RYD_ix_SideA_I = lbAdd [2100, "RESISTANCE"];
					//RYD_ix_SideA_O = -1;
					
					if ((lbCurSel 2100) in [RYD_ix_SideA_O]) then
						{
						lbSetCurSel [2100,RYD_ix_SideA_B];
						
						[_ctrlA,RYD_ix_SideA_B] call RYD_FactionFill
						};
					};
				};
			
			RYD_eh_SA = _ctrlA ctrlAddEventHandler ["LBSelChanged","_this call RYD_FactionFill;_this call RYD_SideFill"];
			}
		};
	true
	};

RYD_WS_Dialog = 
	{
	_dl = createDialog "RscHWS";

	waitUntil {dialog};

	ctrlShow [1, false];
	RYD_ix_SideA_B = lbAdd [2100, "WEST"];
	RYD_ix_SideA_I = lbAdd [2100, "RESISTANCE"];
	RYD_ix_SideA_O = lbAdd [2100, "EAST"];
	//RYD_ix_SideA_R = lbAdd [2100, "RANDOM"];

	lbSetCurSel [2100, profileNamespace getVariable ["RYD_ix_SideA",RYD_ix_SideA_B]];
	RYD_eh_SA = ((findDisplay 2500) displayCtrl 2100) ctrlAddEventHandler ["LBSelChanged","_this call RYD_FactionFill;_this call RYD_SideFill"];
	
		
	RYD_ix_SideB_B = lbAdd [2101, "WEST"];
	RYD_ix_SideB_I = lbAdd [2101, "RESISTANCE"];
	RYD_ix_SideB_O = lbAdd [2101, "EAST"];
	//RYD_ix_SideB_R = lbAdd [2101, "RANDOM"];

	lbSetCurSel [2101,profileNamespace getVariable ["RYD_ix_SideB",RYD_ix_SideB_O]];
	RYD_eh_SB = ((findDisplay 2500) displayCtrl 2101) ctrlAddEventHandler ["LBSelChanged","_this call RYD_FactionFill;_this call RYD_SideFill"];
	
	
	[((findDisplay 2500) displayCtrl 2100),profileNamespace getVariable ["RYD_ix_SideA",RYD_ix_SideA_B]] call RYD_FactionFill;
	
	lbSetCurSel [21000, profileNamespace getVariable ["RYD_ix_FacA",0]];
		
	
	[((findDisplay 2500) displayCtrl 2101),profileNamespace getVariable ["RYD_ix_SideB",RYD_ix_SideB_O]] call RYD_FactionFill;
	
	lbSetCurSel [21010, profileNamespace getVariable ["RYD_ix_FacB",0]];	
	
	
	RYD_ix_Scale_S = lbAdd [2102, "SMALL"];
	RYD_ix_Scale_M = lbAdd [2102, "MEDIUM"];
	RYD_ix_Scale_B = lbAdd [2102, "BIG"];
	RYD_ix_Scale_R = lbAdd [2102, "RANDOM"];

	lbSetCurSel [2102, profileNamespace getVariable ["RYD_ix_Scale",RYD_ix_Scale_S]];
	
	
	RYD_ix_Daytime_D = lbAdd [2103, "DAWN"];
	RYD_ix_Daytime_N = lbAdd [2103, "HIGH NOON"];
	RYD_ix_Daytime_S = lbAdd [2103, "EVENING"];
	RYD_ix_Daytime_M = lbAdd [2103, "MIDNIGHT"];
	RYD_ix_Daytime_R = lbAdd [2103, "RANDOM"];

	lbSetCurSel [2103, profileNamespace getVariable ["RYD_ix_Daytime",RYD_ix_Daytime_N]];
	

	RYD_ix_Weather_VG = lbAdd [2104, "NONE"];
	RYD_ix_Weather_G = lbAdd [2104, "LIGHT"];
	RYD_ix_Weather_M = lbAdd [2104, "MEDIUM"];
	RYD_ix_Weather_P = lbAdd [2104, "HEAVY"];
	RYD_ix_Weather_VP = lbAdd [2104, "FULL"];
	RYD_ix_Weather_NC = lbAdd [2104, "NO CHANGE"];
	RYD_ix_Weather_R = lbAdd [2104, "RANDOM"];

	lbSetCurSel [2104, profileNamespace getVariable ["RYD_ix_Weather",RYD_ix_Weather_NC]];
	
		
	RYD_ix_Ratio_31 = lbAdd [2105, "3:1"];
	RYD_ix_Ratio_21 = lbAdd [2105, "2:1"];
	RYD_ix_Ratio_32 = lbAdd [2105, "3:2"];
	RYD_ix_Ratio_11 = lbAdd [2105, "1:1"];
	RYD_ix_Ratio_23 = lbAdd [2105, "2:3"];
	RYD_ix_Ratio_12 = lbAdd [2105, "1:2"];
	RYD_ix_Ratio_13 = lbAdd [2105, "1:3"];
	RYD_ix_Ratio_R = lbAdd [2105, "RANDOM"];

	lbSetCurSel [2105, profileNamespace getVariable ["RYD_ix_Ratio",RYD_ix_Ratio_11]];
	
	RYD_ix_Campaign_C = lbAdd [2106, "INCLUDE"];
	RYD_ix_Campaign_O = lbAdd [2106, "EXCLUDE"];
	RYD_ix_Campaign_R = lbAdd [2106, "RESET"];

	lbSetCurSel [2106, profileNamespace getVariable ["RYD_ix_Campaign",RYD_ix_Campaign_C]];
	
	
	RYD_ix_HSRA_VL = lbAdd [2107, "VERY LOW"];
	RYD_ix_HSRA_L = lbAdd [2107, "LOW"];
	RYD_ix_HSRA_N = lbAdd [2107, "NORMAL"];
	RYD_ix_HSRA_H = lbAdd [2107, "HIGH"];
	RYD_ix_HSRA_VH = lbAdd [2107, "VERY HIGH"];
	RYD_ix_HSRA_R = lbAdd [2107, "RANDOM"];

	lbSetCurSel [2107, profileNamespace getVariable ["RYD_ix_HSRA",RYD_ix_HSRA_N]];
	
	
	RYD_ix_HSRB_VL = lbAdd [2108, "VERY LOW"];
	RYD_ix_HSRB_L = lbAdd [2108, "LOW"];
	RYD_ix_HSRB_N = lbAdd [2108, "NORMAL"];
	RYD_ix_HSRB_H = lbAdd [2108, "HIGH"];
	RYD_ix_HSRB_VH = lbAdd [2108, "VERY HIGH"];
	RYD_ix_HSRB_R = lbAdd [2108, "RANDOM"];

	lbSetCurSel [2108, profileNamespace getVariable ["RYD_ix_HSRB",RYD_ix_HSRB_N]];
	
	_code = profileNamespace getVariable ["RYD_ix_Code",""];
	
	ctrlSetText [120, _code];
	
	waitUntil {not (dialog)};
	
	if (RYD_WS_Reset) then
		{
		RYD_WS_Caller globalChat "Restoring default settings";
		
			{
			profileNamespace setVariable [_x,nil]
			}
		foreach ["RYD_ix_SideA","RYD_ix_SideB","RYD_ix_FacA","RYD_ix_FacB","RYD_ix_Scale","RYD_ix_Daytime","RYD_ix_Weather","RYD_ix_Ratio","RYD_ix_Campaign","RYD_ix_HSRA","RYD_ix_HSRB","RYD_ix_Code"];
		
		saveProfileNamespace;
		
		[] call RYD_WS_Dialog;
		};
	};

[] call RYD_WS_Dialog;

2 fadeMusic 0;

sleep 2.2;

playMusic "";

0 fadeMusic 0.4;

startloadingscreen ["HETMAN: War Stories","RscDisplayLoadCustom"];

call compile preprocessfile "WS_fnc.sqf";
call compile preprocessFile "SC\CamManip.sqf";

call RYD_WS_DynamicRHQ;
call RYD_WS_MapAnalyze;

_sectors = RydBB_Sectors;

_sumAll = {(_x getVariable "Topo_SeaP") < 50} count _sectors;

if (_sumAll < 1) exitWith 
	{
	endLoadingScreen;
	hintC "Initialization failed: No sufficient landmass";
	sleep 0.1;
	failMission "END1";
	};

if (RYD_WS_CReset) then 
	{
		{
		deleteMarker _x
		}
	foreach _cpMarks;
	profileNamespace setVariable ["RYD_WS_MapColors" + worldName,[]];
	saveProfileNamespace
	};

_sumA = switch (RYD_WS_SideA) do
	{
	case (west) : {_sumB};
	case (east) : {_sumO};
	case (resistance) : {_sumI};
	};
	
_sumB = switch (RYD_WS_SideB) do
	{
	case (west) : {_sumB};
	case (east) : {_sumO};
	case (resistance) : {_sumI};
	};
	
_takenA = switch (RYD_WS_SideA) do
	{
	case (west) : {_bTaken};
	case (east) : {_oTaken};
	case (resistance) : {_iTaken};
	};
	
_takenB = switch (RYD_WS_SideB) do
	{
	case (west) : {_bTaken};
	case (east) : {_oTaken};
	case (resistance) : {_iTaken};
	};

_rnd = random 1;

_fA = (_sumA/(_sumAll max 1));
_fB = (_sumB/(_sumAll max 1));

_dAdv = _fA - _fB;

_dAdef = _dAdv;
if (_dAdef > 0) then {_dAdef = _dAdef/5};

_dAatt = _dAdv;
if (_dAatt < 0) then {_dAatt = _dAatt/5};

_defChance = ((0.2 - _dAdef) max 0.05) min 0.75;
_attChance = ((0.2 + _dAatt) max 0.05) min 0.75;

//diag_log format ["defc: %1 attc: %2 fA: %3 fB: %4",_defChance,_attChance,_fA,_fB];

_bType = switch (true) do
	{
	case ((_rnd < _defChance) and ((_sumA > 0) or ((random 100) < 50))) : {0};//player def
	case ((_rnd < (_defChance + _attChance)) and ((_sumB > 0) or ((random 100) < 50))) : {1};//AI def
	default {2};// meeting engagement
	};
	
_battlefield = [_bType,[_takenB,_takenA]] call RYD_WS_Battlefield;

_bfPos = _battlefield select 2;
RYD_WS_BFPos = +_bfPos;
RYD_WS_BFPos set [2,0];

	/*{
	_mark = "battlef" + str (random 1000);
	_mark = [_mark,_x,"ColorBlue","ICON",[1.5,1.5],0,1,"mil_dot",(str ([_x,600] call RYD_WS_NearSea))] call RYD_Marker;
	}
foreach _battlefield;*/

RYD_WS_BFRadius = (_battlefield select 0) distance (_battlefield select 1);

_topo = [(_battlefield select 2),RYD_WS_BFRadius] call RYD_WS_Topo;

_infFr = ((_topo select 0) + (_topo select 1) + (_topo select 2) + (_topo select 4))/100;

_sideA = RYD_WS_SideA;
_sideB = RYD_WS_SideB;

if not (RYD_WS_Weather < 0) then
	{
	0 setOvercast RYD_WS_Weather;
	forceweatherchange;
	};

setDate [2030, 6, 24, RYD_WS_Daytime, 0];

_percA = 1 + (_sumA/_sumAll);
_percB = 1 + (_sumB/_sumAll);

_sAdvantageA = _percA/_percB;
_sAdvantageB = _percB/_percA;

RYD_WS_AdvantageA = _sAdvantageA;
RYD_WS_AdvantageB = _sAdvantageB;

//diag_log format ["all: %1 adv: %2",_sumAll,_sAdvantageA];

if (isNil "RydHQ_Muu") then {RydHQ_Muu = _sAdvantageB};
if (isNil "RydHQB_Muu") then {RydHQB_Muu = _sAdvantageA};

_forces = [_bType,RYD_WS_Scale,[_sideA,_sideB],_infFr] call RYD_WS_Forces;

	/*{
	diag_log format ["st: %1",_x];
	}
foreach RHQ_Static;*/

_gpsA = [];
_gpsB = [];

_fcsA = [];
_fcsB = [];

//_forces = [[_forcesA_inf,_forcesA_mot,_forcesA_mech,_forcesA_arm],[_forcesB_inf,_forcesB_mot,_forcesB_mech,_forcesB_arm]];

_sum = 0;

	{
		{
			{
			_sum = _sum + 1
			}
		foreach _x	
		}
	foreach _x
	}
foreach _forces;

//diag_log format ["sum: %1",_sum];

_sum = 2 * _sum;

if (_sum == 0) then {_sum = 1};

_prog = 0;

	{
	_mainIx = _foreachIndex;
	_mainPos = _battlefield select _foreachIndex;
	_eyeOfBattle = _battlefield select 2;

	if ((_mainPos distance _eyeOfBattle) < 500) then
		{
		_ix = 0;
		if (_foreachIndex == 0) then
			{
			_ix = 1
			};
			
		_eyeOfBattle = _battlefield select _ix
		};
		
	_dst = _mainPos distance _eyeOfBattle;
	
		{
			{
			//diag_log format ["GP: %1",_x];
			_posL = _mainPos;
			_dir = [_mainPos,_eyeOfBattle,10] call RYD_AngTowards;
			
			if (_x select 3) then
				{
				_posL = [_posL,_dir + 190 - (random 20),(((random (_dst/3)) + (random (_dst/3))) min 2000) max 1000] call RYD_PosTowards2D
				};	
							
			_posL = [_posL,50,350,100,50] call RYD_WS_FindLandPos;
							
			_spawnPos = [_posL,0,300,12,0,5,0] call BIS_fnc_findSafePos;
			
			_spawnPos set [2,0];	
			
			_type = _x select 1;
			_side = _x select 0;
			
			_gp = [_spawnPos,_side,_type,_dir,true] call RYD_WS_SpawnGroupSafe;
			
			_gp setVariable ["RYD_WS_myKind",_x select 2];
			
			_prog = _prog + 1;
			
			progressLoadingScreen (0.5 + (_prog/_sum));
			
			if not (isNull _gp) then
				{
				switch (_mainIx) do
					{
					case (0) : 
						{
						_gpsA set [(count _gpsA),_gp];
						_fcsA = _fcsA + (units _gp)
						};
						
					case (1) : 
						{
						_gpsB set [(count _gpsB),_gp];
						_fcsB = _fcsB + (units _gp)
						};
					};
				}
			}
		foreach _x	
		}
	foreach _x
	}
foreach _forces;

_vehClass = configFile >> "CfgVehicles";

	{
	_sec = [RydHQ_Sec1,RydHQ_Sec2,RydHQ_IdleDecoy];
	if (_foreachIndex == 1) then 
		{
		_sec = [RydHQB_Sec1,RydHQB_Sec2,RydHQB_IdleDecoy]
		};
	
	_mainIx = _foreachIndex;
	_mainPos = switch (_foreachIndex) do
		{
		case (0) : {(_battlefield select 0)};
		case (1) : {(_battlefield select 1)};
		};
		
	_opPos = switch (_foreachIndex) do
		{
		case (0) : {(_battlefield select 1)};
		case (1) : {(_battlefield select 0)};
		};
		
	_perc = switch (_foreachIndex) do
		{
		case (0) : {_percA};
		case (1) : {_percB};
		};
		
	_eyeOfBattle = _battlefield select 2;
		
	if ((_mainPos distance _eyeOfBattle) < 500) then
		{
		_ix = 0;
		if (_foreachIndex == 0) then
			{
			_ix = 1
			};
			
		_eyeOfBattle = _battlefield select _ix
		};
		
	_dir = [_mainPos,_eyeOfBattle,10] call RYD_AngTowards;
	_dirL = [_mainPos,_opPos,10] call RYD_AngTowards;
	_dst = _mainPos distance _eyeOfBattle;
	
	_ldrClassArr = [];
	
	switch (_x) do
		{
		case (west) : 
			{
			_ldrClassArr = RYD_WS_B_Officers_G2;
			if ((count _ldrClassArr) < 1) then
				{
				_ldrClassArr = ["B_officer_F"];
				}
			};
			
		case (east) : 
			{
			_ldrClassArr = RYD_WS_O_Officers_G2;
			if ((count _ldrClassArr) < 1) then
				{
				_ldrClassArr = ["O_officer_F"];
				}
			};
			
		case (resistance) : 
			{
			_ldrClassArr = RYD_WS_I_Officers_G2;
			if ((count _ldrClassArr) < 1) then
				{
				_ldrClassArr = ["I_officer_F"];
				}
			};
		};
		
	_ldrClass = _ldrClassArr select (floor (random (count _ldrClassArr)));
		
	_ldrGp = createGroup _x;
	
	_ldrPos0 = +_mainPos;
	
	_ldrPos0 = [_ldrPos0,_dirL + 180,((_dst/3) min 800) max 500] call RYD_PosTowards2D;
	
	_ldrPos = [_ldrPos0,0,160,5,0,1.5,0] call BIS_fnc_findSafePos;
	_fe = not (isOnRoad _ldrPos);
	_nR = _ldrPos nearRoads 50;
	if (((count _nR) > 0) or ((_ldrPos0 distance _ldrPos) > 5000)) then {_fe = false};
	_ct = 0;
	
	while {(not _fe)} do
		{
		_ldrPos = [_ldrPos0,10,100 + (_ct * 5)] call RYD_RandomAroundMM;
		_ldrPos = [_ldrPos,0,160,5,0,1.5,0] call BIS_fnc_findSafePos;
		_ct = _ct + 1;
		if (_ct > 20) exitWith {};
		_fe = not (isOnRoad _ldrPos);
		_nR = _ldrPos nearRoads 50;
		if (((count _nR) > 0) or ((_ldrPos0 distance _ldrPos) > 5000)) then {_fe = false};
		};
		
//_mark = [str (random 1000),_ldrPos,"ColorPink","ICON",[1.25,1.25],0,1,"mil_triangle",""] call RYD_Marker;
	
	switch (_foreachIndex) do
		{
		case (0) :
			{
			leaderHQ = _ldrGp createUnit [_ldrClass, _ldrPos, [], 0, "NONE"];
			leaderHQ setDir _dir;
			(group leaderHQ) setVariable ["RydHQ_MyDir",_dir]
			};
			
		case (1) :
			{
			leaderHQB = _ldrGp createUnit [_ldrClass, _ldrPos, [], 0, "NONE"];
			leaderHQB setDir _dir;
			(group leaderHQB) setVariable ["RydHQ_MyDir",_dir]
			};
		};
			
	_middlePos = [_mainPos,_dir,_dst * 0.6] call RYD_PosTowards2D;
	
	_range = (((_middlePos distance _eyeOfBattle)/1.5) max 400) min 600;
	
	//diag_log format ["range: %1",_range];
	
		{
		_fPos = [_middlePos,0,_range] call RYD_RandomAroundMM;
		_x setPos _fPos;
		//_mark = [str (random 100),_fPos,"ColorBlack","ICON",[1,1],0,1,"mil_box",(str _x)] call RYD_Marker;
		}
	foreach _sec;
	
	_airClasses = switch (_x) do
		{
		case (west) : {RYD_WS_B_Air_G2 + RYD_WS_Air_class_B};
		case (east) : {RYD_WS_O_Air_G2 + RYD_WS_Air_class_O};
		case (resistance) : {RYD_WS_I_Air_G2 + RYD_WS_Air_class_I};
		};
		
	_facM = switch (_foreachIndex) do
		{
		case (0) : {RYD_WS_FacA select 2};
		case (1) : {RYD_WS_FacB select 2};
		};
		
		{
		_fac = toLower (getText (_vehClass >> _x >> "faction"));
		
		if not (_fac == _facM) then
			{
			_airClasses set [_foreachIndex,0]
			}
		}
	foreach _airClasses;
	
	_airClasses = _airClasses - [0];
		
	_staticClasses = switch (_x) do
		{
		case (west) : {RYD_WS_B_Static_G2 + RYD_WS_Static_class_B};
		case (east) : {RYD_WS_O_Static_G2 + RYD_WS_Static_class_O};
		case (resistance) : {RYD_WS_I_Static_G2 + RYD_WS_Static_class_I};
		};
		
		{
		_fac = toLower (getText (_vehClass >> _x >> "faction"));
		
		if not (_fac == _facM) then
			{
			_staticClasses set [_foreachIndex,0]
			}
		}
	foreach _staticClasses;
	
	_staticClasses = _staticClasses - [0];
		
	_supportClasses = switch (_x) do
		{
		case (west) : {RYD_WS_B_Support_G2 + RYD_WS_Support_class_B};
		case (east) : {RYD_WS_O_Support_G2 + RYD_WS_Support_class_O};
		case (resistance) : {RYD_WS_I_Support_G2 + RYD_WS_Support_class_I};
		};
		
		{
		_fac = toLower (getText (_vehClass >> _x >> "faction"));
		
		if not (_fac == _facM) then
			{
			_supportClasses set [_foreachIndex,0]
			}
		}
	foreach _supportClasses;
	
	_supportClasses = _supportClasses - [0];
	
	_cargoClasses = switch (_x) do
		{
		case (west) : {RYD_WS_B_NCCargo_G2 + RYD_WS_NCCargo_class_B};
		case (east) : {RYD_WS_O_NCCargo_G2 + RYD_WS_NCCargo_class_O};
		case (resistance) : {RYD_WS_I_NCCargo_G2 + RYD_WS_NCCargo_class_I};
		};
		
		{
		_fac = toLower (getText (_vehClass >> _x >> "faction"));
		
		if not (_fac == _facM) then
			{
			_cargoClasses set [_foreachIndex,0]
			}
		}
	foreach _cargoClasses;
	
	_cargoClasses = _cargoClasses - [0];
	//diag_log format ["[side,faction]: %1",[_x,_facM]];
	
		{
		_amnt = (floor (random (2 * RYD_WS_Scale))) * _perc;
		
		if (_foreachIndex == 3) then
			{
			_amnt = 2 + ((ceil (random (3 * RYD_WS_Scale))) * _perc)
			};
			
		//diag_log format ["classes: %1",[_foreachindex,count _x]];
		
		for "_i" from 1 to _amnt do
			{
			switch (_foreachIndex) do
				{
				case (0) :
					{
					if ((count _airClasses) > 0) then
						{
						_gp = [_mainPos,_dir,_airClasses] call RYD_WS_SpawnAir;
						
						if not (isNull _gp) then
							{
							_vh = assignedVehicle (leader _gp);
							_name = getText (configFile >> "CfgVehicles" >> (typeof _vh) >> "displayName");
							_gp setVariable ["RYD_WS_myKind",_name + " crew"];
							switch (_mainIx) do
								{
								case (0) : 
									{
									_gpsA set [(count _gpsA),_gp];
									_fcsA = _fcsA + (units _gp)
									};
									
								case (1) : 
									{
									_gpsB set [(count _gpsB),_gp];
									_fcsB = _fcsB + (units _gp)
									};
								};
							}
						}
					};
					
				case (1) :
					{
					if ((count _staticClasses) > 0) then
						{
						_stPos = +_mainPos;
						if (_bType == _mainIx) then
							{
							_stPos = +_ldrPos;
							};
							
						_gp = [_stPos,_dir,_staticClasses] call RYD_WS_SpawnStatic;

						if not (isNull _gp) then
							{
							_vh = assignedVehicle (leader _gp);
							_name = getText (configFile >> "CfgVehicles" >> (typeof _vh) >> "displayName");
							_gp setVariable ["RYD_WS_myKind",_name + " crew"];
							
							switch (_mainIx) do
								{
								case (0) : 
									{
									_gpsA set [(count _gpsA),_gp];
									_fcsA = _fcsA + (units _gp)
									};
									
								case (1) : 
									{
									_gpsB set [(count _gpsB),_gp];
									_fcsB = _fcsB + (units _gp)
									};
								};
							}
						}
					};
					
				case (2) :
					{
					if ((count _supportClasses) > 0) then
						{
						_gp = [_mainPos,_dir,_supportClasses] call RYD_WS_SpawnSupport;
						
						if not (isNull _gp) then
							{
							_vh = assignedVehicle (leader _gp);
							_name = getText (configFile >> "CfgVehicles" >> (typeof _vh) >> "displayName");
							_gp setVariable ["RYD_WS_myKind",_name + " crew"];
							
							switch (_mainIx) do
								{
								case (0) : 
									{
									_gpsA set [(count _gpsA),_gp];
									_fcsA = _fcsA + (units _gp)
									};
									
								case (1) : 
									{
									_gpsB set [(count _gpsB),_gp];
									_fcsB = _fcsB + (units _gp)
									};
								}
							}
						};				
					};
					
				case (3) :
					{
					if ((count _cargoClasses) > 0) then
						{
						_gp = [_mainPos,_dir,_cargoClasses] call RYD_WS_SpawnSupport;
						
						if not (isNull _gp) then
							{
							_vh = assignedVehicle (leader _gp);
							_name = getText (configFile >> "CfgVehicles" >> (typeof _vh) >> "displayName");
							_gp setVariable ["RYD_WS_myKind",_name + " crew"];
							
							switch (_mainIx) do
								{
								case (0) : 
									{
									_gpsA set [(count _gpsA),_gp];
									_fcsA = _fcsA + (units _gp)
									};
									
								case (1) : 
									{
									_gpsB set [(count _gpsB),_gp];
									_fcsB = _fcsB + (units _gp)
									};
								}
							}
						};				
					};
				}
			}
		}	
	foreach [_airClasses,_staticClasses,_supportClasses,_cargoClasses];
	}
foreach [_sideA,_sideB];

if (((count _fcsA) < 1) or {((count _fcsB) < 1)}) exitWith
	{
	endLoadingScreen;
	hintC "Initialization failed: no forces to use";
	sleep 0.1;
	failMission "END1";
	};

_dirL = [(_battlefield select 0),(_battlefield select 1),10] call RYD_AngTowards;
_dst = (_battlefield select 0) distance (_battlefield select 2);

_ldrPosA = [(_battlefield select 0),_dirL + 180,((_dst/3) min 800) max 500] call RYD_PosTowards2D;

_ldrPosA = [_ldrPosA,0,200,50,200] call RYD_WS_FindLandPos;

_ldrPosA set [2,0];

_dirL2 = [(_battlefield select 1),(_battlefield select 0),10] call RYD_AngTowards;

_dst2 = (_battlefield select 1) distance (_battlefield select 2);

_ldrPosB = [(_battlefield select 1),_dirL2 + 180,((_dst2/3) min 800) max 500] call RYD_PosTowards2D;

_ldrPosB = [_ldrPosB,0,200,50,200] call RYD_WS_FindLandPos;

_ldrPosB set [2,0];

_set1 = [RydHQ_Obj1,RydHQ_Obj2,RydHQB_Obj1,RydHQB_Obj2];
_set2 = [RydHQ_Obj3,RydHQ_Obj4];
_set3 = [RydHQB_Obj3,RydHQB_Obj4];

	{
	_x setPos (_battlefield select 2)
	}
foreach _set1;

switch (_bType) do
	{
	case (0) : 
		{
			{
			_x setPos (_battlefield select 2)
			}
		foreach _set2;
		
			{
			_x setPos _ldrPosA
			}
		foreach _set3;		
		};
		
	case (1) : 
		{
			{
			_x setPos _ldrPosB
			}
		foreach _set2;
		
			{
			_x setPos (_battlefield select 2)
			}
		foreach _set3;	
		};
		
	default
		{
			{
			_x setPos _ldrPosB
			}
		foreach _set2;
		
			{
			_x setPos _ldrPosA
			}
		foreach _set3;				
		}
	};
	
	/*{
	diag_log format ["pos: %1",position _x];
	_i = str _x;
	_i = createMarker [_i,(position _x)];
	_i setMarkerColor "colorBrown";
	_i setMarkerShape "ICON";
	_i setMarkerType "mil_box";
	_i setMarkerSize [0.8,0.8];
	_i setMarkerText (str _foreachIndex);
	}
foreach (_set1 + _set2 + _set3);*/
	


{
	addSwitchableUnit _x;
	_x setVariable ["MARTA_showRules",[(RYD_WS_FacA select 1),1,(RYD_WS_FacB select 1),0]];
	_x setVariable ["RYD_WS_Aside",true];
}

foreach _fcsA;

_player = _fcsA select (floor (random (count _fcsA)));

_player setVariable ["WS_myName",name _player];

selectPlayer _player;

RYD_WS_ForcesA = _fcsA;
RYD_WS_ForcesB = _fcsB;

RYD_WS_GroupsA = _gpsA;
RYD_WS_GroupsB = _gpsB;

player setName profileName;

if (isNil "RYD_Path") then {RYD_Path = "RYD_HAL\"};

call compile preprocessfile (RYD_Path + "VarInit.sqf");
call compile preprocessfile (RYD_Path + "HAC_fnc.sqf");
call compile preprocessfile (RYD_Path + "HAC_fnc2.sqf");

_date = format ["%1-%2-%3",date select 0,"0" + (str (date select 1)), date select 2];
_daytime = format ["%1:%2",date select 3,date select 4];
_where = toUpper (worldName);
_dayTimedescr = "day";

if ((dayTime < 9) and (dayTime >= 5)) then {_dayTimedescr = "morning"};
if ((dayTime <= 22) and (dayTime > 18)) then {_dayTimedescr = "evening"};
if ((dayTime > 22) or (dayTime < 5)) then {_dayTimedescr = "night"};

_weather = switch (true) do
	{
	case (overCast < 0.25) : {"Serene"};
	case (overCast < 0.4) : {"Slightly cloudy"};
	case (overCast < 0.7) : {"Cloudy"};
	default {"Gloomy"};
	};

_rain = switch (true) do
	{
	case (rain < 0.05) : {""};
	case (rain < 0.2) : {" and wet"};
	case (rain < 0.4) : {" and rainy"};
	case (rain < 0.7) : {" and very rainy"};
	default {" and stormy"};
	};

_placeA = (nearestLocations [_battlefield select 0, ["Hill","NameCityCapital","NameCity","NameVillage","NameLocal"], 1500]) select 0;
_placeB = (nearestLocations [_battlefield select 1, ["Hill","NameCityCapital","NameCity","NameVillage","NameLocal"], 1500]) select 0;
_target = (nearestLocations [_battlefield select 2, ["Hill","NameCityCapital","NameCity","NameVillage","NameLocal"], 100]) select 0;

//diag_log format ["battlefield: %1 A: %2 B: %3 T: %4",_battlefield,_placeA,_placeB,_target];

_locS = "";
_locS0 = "";
_nameS = "";

_nameA = "";
_typeA = "";
_posA = _battlefield select 0;

if not (isNil "_placeA") then
	{
	_typeA = toLower (type _placeA);
	_nameA = text _placeA;
	_posA = position _placeA;
	_posA set [2,0]
	};

_mNameA = "_markA";
_markA = [_mNameA,_posA,"ColorBlack","ICON",[1,1],0,1,"Empty",""] call RYD_Marker;

switch (_typeA) do
	{
	case ("mount") : 
		{
		_locS = "";
		if not (_nameA in [""]) then
			{
			_locS = format ["%1",_nameA];
			_locS0 = _locS;
			
			if ((random 100) > 80) then
				{
				_locS = format ["the mountain called %1",_nameA]
				}
			}
		};
		
	case ("hill") : 
		{
		_locS = format ["the hill called %1",_nameA];
			
		if ((random 100) < 80) then
			{
			_locS = format ["%1",_nameA];
			};
		
		if (_nameA in [""]) then
			{
			_hgt = getTerrainHeightASL _posA;
			_nameA = str (ceil _hgt);
			_locS = format ["the hill %1",_nameA]
			};
			
		_locS0 = _nameA;	
		};
		
	case ("namecitycapital") : 
		{
		_locS = "the city";
		if not (_nameA in [""]) then
			{
			_locS = format ["%1",_nameA];
			_locS0 = _locS;
			
			if ((random 100) > 80) then
				{
				_locS = format ["the city of %1",_nameA]
				}
			}
		};
		
	case ("namecity") : 
		{
		_locS = "the town";
		if not (_nameA in [""]) then
			{
			_locS = format ["%1",_nameA];
			_locS0 = _locS;
			
			if ((random 100) > 80) then
				{
				_locS = format ["the town of %1",_nameA]
				}
			}
		};
		
	case ("namevillage") : 
		{
		_locS = "the village";
		if not (_nameA in [""]) then
			{
			_locS = format ["%1",_nameA];
			_locS0 = _locS;
			
			if ((random 100) > 80) then
				{
				_locS = format ["the village named %1",_nameA]
				}
			}
		};
		
	case ("namelocal") : 
		{
		_locS = "";
		if not (_nameA in [""]) then
			{
			_locS0 = _nameA;
			_locS = format ["the %1 area",_nameA]
			}
		};
	};

_howFarS = _posA distance (_battlefield select 0);

_distanceDescrS = switch (true) do
	{
	case (_locS in [""]) : {""};
	case (_howFarS < 200) : {"at "};
	case (_howFarS < 500) : {"near "};
	default {"not far from "};
	};

if (_locS in [""]) then
	{
	_dir = [(_battlefield select 2),(_battlefield select 0),0] call RYD_AngTowards;
	_locS = [_dir] call RYD_WS_WindRose;
	_locS0 = _locS;
	};
	
_locT = "";
_locT0 = "";
_nameT = "";
_typeT = "";

_nameT = "";
_posT = _battlefield select 2;

if not (isNil "_target") then
	{
	_typeT = toLower (type _target);
	_nameT = text _target;
	_posT = position _target;
	_posT set [2,0];
	};

_mNameT = "_markT";
_markT = [_mNameT,_posT,"ColorBlack","ICON",[1,1],0,1,"Empty",""] call RYD_Marker;

switch (_typeT) do
	{
	case ("mount") : 
		{
		_locT = "";
		if not (_nameT in [""]) then
			{
			_locT = format ["%1",_nameT];
			_locT0 = _locT;
			
			if ((random 100) > 80) then
				{
				_locT = format ["the mountain called %1",_nameT]
				}
			}
		};
		
	case ("hill") : 
		{
		_locT = format ["the hill called %1",_nameT];
		
		if ((random 100) < 80) then
			{
			_locT = format ["%1",_nameT];
			};		
		
		if (_nameT in [""]) then
			{
			_hgt = getTerrainHeightASL _posT;
			_nameT = str (ceil _hgt);
			_locT = format ["the hill %1",_nameT]
			};
			
		_locT0 = _nameT;	
		};
		
	case ("namecitycapital") : 
		{
		_locT = "the city";
		if not (_nameT in [""]) then
			{
			_locT = format ["%1",_nameT];
			_locT0 = _locT;
			
			if ((random 100) > 80) then
				{
				_locT = format ["the city of %1",_nameT]
				}
			}
		};
		
	case ("namecity") : 
		{
		_locT = "the town";
		if not (_nameT in [""]) then
			{
			_locT = format ["%1",_nameT];
			_locT0 = _locT;
			
			if ((random 100) > 80) then
				{
				_locT = format ["the town of %1",_nameT]
				}
			}
		};
		
	case ("namevillage") : 
		{
		_locT = "the village";
		if not (_nameT in [""]) then
			{
			_locT = format ["%1",_nameT];
			_locT0 = _locT;
			
			if ((random 100) > 80) then
				{
				_locT = format ["the village named %1",_nameT]
				}
			}
		};
		
	case ("namelocal") : 
		{
		_locT = "";
		if not (_nameT in [""]) then
			{
			_locT0 = _nameT;
			_locT = format ["the %1 area",_nameT]
			}
		};
	};
	
_howFarT = _posT distance (_battlefield select 0);

_distanceDescrT = switch (true) do
	{
	case (_locT in [""]) : {""};
	case (_howFarT < 200) : {"at "};
	case (_howFarT < 500) : {"near "};
	default {"not far from "};
	};

if (_locT in [""]) then
	{
	_dir = [(_battlefield select 0),(_battlefield select 2),0] call RYD_AngTowards;
	_locT = [_dir] call RYD_WS_WindRose;
	_locT0 = _locT;
	};
	
_locB = "";
_locB0 = "";
_nameB = "";
_typeB = "";

_nameB = "";
_posB = _battlefield select 2;

if not (isNil "_placeB") then
	{
	_typeB = toLower (type _placeB);
	_nameB = text _placeB;
	_posB = position _placeB;
	_posB set [2,0];
	};

_mNameB = "_markB";
_markB = [_mNameB,_posB,"ColorBlack","ICON",[1,1],0,1,"Empty",""] call RYD_Marker;

//diag_log format ["nameA: %1 (%2) nameT: %3 (%4) nameB: %5 (%6) %7-%8-%9",_nameA,_placeA,_nameT,_target,_nameB,_placeB,(type _placeA),(type _target),(type _placeB)];

switch (_typeB) do
	{
	case ("mount") : 
		{
		_locB = "";
		if not (_nameB in [""]) then
			{
			_locB = format ["%1",_nameB];
			_locB0 = _locB;
			
			if ((random 100) > 80) then
				{
				_locB = format ["the mountain called %1",_nameB]
				}
			}
		};
		
	case ("hill") : 
		{
		_locB = format ["the hill called %1",_nameB];
		
		if ((random 100) < 80) then
			{
			_locB = format ["%1",_nameB];
			};
					
		if (_nameB in [""]) then
			{
			_hgt = getTerrainHeightASL _posB;
			_nameB = str (ceil _hgt);
			_locB = format ["the hill %1",_nameB]
			};
			
		_locB0 = _nameB;		
		};
		
	case ("namecitycapital") : 
		{
		_locB = "the city";
		if not (_nameB in [""]) then
			{
			_locB = format ["%1",_nameB];
			_locB0 = _locB;
			
			if ((random 100) > 80) then
				{
				_locB = format ["the city of %1",_nameB]
				}
			}
		};
		
	case ("namecity") : 
		{
		_locB = "the town";
		if not (_nameB in [""]) then
			{
			_locB = format ["%1",_nameB];
			_locB0 = _locB;
			
			if ((random 100) > 80) then
				{
				_locB = format ["the town of %1",_nameB]
				}
			}
		};
		
	case ("namevillage") : 
		{
		_locB = "the village";
		if not (_nameB in [""]) then
			{
			_locB = format ["%1",_nameB];
			_locB0 = _locB;
			
			if ((random 100) > 80) then
				{
				_locB = format ["the village named %1",_nameB]
				}
			}
		};
		
	case ("namelocal") : 
		{
		_locB = "";
		if not (_nameB in [""]) then
			{
			_locB0 = _nameB;
			_locB = format ["the %1 area",_nameB]
			}
		};
	};
	
_howFarB = _posB distance (_battlefield select 1);

_distanceDescrB = switch (true) do
	{
	case (_locB in [""]) : {""};
	case (_howFarB < 200) : {"at "};
	case (_howFarB < 500) : {"near "};
	default {"not far from "};
	};

if (_locB in [""]) then
	{
	_dir = [(_battlefield select 0),(_battlefield select 1),0] call RYD_AngTowards;
	_locB = [_dir] call RYD_WS_WindRose;
	_locB0 = _locB;
	};
	
//diag_log format ["locS: %1 (%6) locB: %2 (%7) locT: %3 (%8) dst: %4 type: %5",_locS,_locB,_locT,_distanceDescrT,_bType,_locS0,_locB0,_locT0];

_clA = switch (RYD_WS_SideA) do
	{
	case (west) : {"ColorWEST"};
	case (east) : {"ColorEAST"};
	case (resistance) : {"ColorGUER"};
	};
	
_clB = switch (RYD_WS_SideB) do
	{
	case (west) : {"ColorWEST"};
	case (east) : {"ColorEAST"};
	case (resistance) : {"ColorGUER"};
	};

_markPerA = [_gpsA,_clA,"FDiagonal"] call RYD_WS_ClusterMark;
_markPerB = [_gpsB,_clB,"FDiagonal"] call RYD_WS_ClusterMark;

if not (_bType == 0) then
	{
	_posM = getMarkerPos _markPerA;	
	_dst = _posM distance _posT;
	_angle = [_posM,_posT,0] call RYD_AngTowards;
	
	_center = [((_posM select 0) + (_posT select 0))/2,((_posM select 1) + (_posT select 1))/2,0];
	
	if (_dst > 500) then
		{
		_markArrA = ["Arrow_" + (str RYD_WS_SideA),_center,_clA,"ICON",[_dst/2400,_dst/1250],_angle,1,"mil_arrow2",""] call RYD_Marker;
		}
	};
	
if not (_bType == 1) then
	{
	_posM = getMarkerPos _markPerB;	
	_dst = _posM distance _posT;
	_angle = [_posM,_posT,0] call RYD_AngTowards;
	
	_center = [((_posM select 0) + (_posT select 0))/2,((_posM select 1) + (_posT select 1))/2,0];
	
	if (_dst > 500) then
		{
		_markArrB = ["Arrow_" + (str RYD_WS_SideB),_center,_clB,"ICON",[_dst/2400,_dst/1250],_angle,1,"mil_arrow2",""] call RYD_Marker;
		}
	};

_mission = "";
_missionB = "";

switch (_bType) do
	{
	case (0) :
		{
		_mission = format ["Our job was to hold the ground %1%2. Enemy came from %3.",_distanceDescrT,_locT,_locB];
		_missionB = format ["Our job was to hold the ground %1<marker name = '_markT'>%2</marker>. Enemy came from <marker name = '_markB'>%3</marker>.",_distanceDescrT,_locT,_locB];
		
		if (_locT0 == _locB0) then
			{
			_mission = format ["Our job was to hold the ground %1%2. Enemy already was here though.",_distanceDescrT,_locT];
			_missionB = format ["Our job was to hold the ground %1<marker name = '_markT'>%2</marker>. Enemy already was here though.",_distanceDescrT,_locT];
			};
		
		RydHQ_Order = "DEFEND";
		RydHQ_Taken = [RydHQ_Obj1,RydHQ_Obj2,RydHQ_Obj3,RydHQ_Obj4];
		RydHQB_Order = "ATTACK";
		};
		
	case (1) :
		{
		_mission = format ["That day we were tasked to take area held by enemy forces %1%2. We've launched the attack from %3.",_distanceDescrT,_locT,_locS];
		_missionB = format ["That day we were tasked to take area held by enemy forces %1<marker name = '_markT'>%2</marker>. We've launched the attack from <marker name = '_markA'>%3</marker>.",_distanceDescrT,_locT,_locS];
		
		if (_locT0 == _locS0) then
			{
			_mission = format ["That day we were tasked to take area held by enemy forces %1%2. We've launched the attack by surprise.",_distanceDescrT,_locT];
			_missionB = format ["That day we were tasked to take area held by enemy forces %1<marker name = '_markT'>%2</marker>. We've launched the attack by surprise.",_distanceDescrT,_locT];
			};		
		
		RydHQ_Order = "ATTACK";
		RydHQB_Order = "DEFEND";
		RydHQ_Taken = [RydHQB_Obj1,RydHQB_Obj2,RydHQB_Obj3,RydHQB_Obj4];
		};
		
	case (2) :
		{				
		_part1 = format ["We're heading from %1 towards %2. ",_locS,_locT];
		_part2 = format ["Enemy came from %1.",_locB];
		
		_part1B = format ["We're heading from <marker name = '_markA'>%1</marker> towards <marker name = '_markT'>%2</marker>. ",_locS,_locT];
		_part2B = format ["Enemy came from <marker name = '_markB'>%1</marker>.",_locB];
		
		if (_locS0 == _locT0) then
			{
			_part1 = format ["We approached %1. ",_locT];
			_part1B = format ["We approached <marker name = '_markT'>%1</marker>. ",_locT]
			};
			
		if (_locB0 == _locT0) then
			{
			_part2 = "Enemy was there already.";
			_part2B = "Enemy was there already."
			};
			
		if (_locS0 == _locB0) then
			{
			_part2 = "It was one big mess.";
			_part2B = "It was one big mess."
			};
		
		_mission = _part1 + _part2;
		_missionB = _part1B + _part2B;
		
		RydHQ_Order = "ATTACK";
		RydHQB_Order = "ATTACK";
		};		
	};
	
_plName = (getText (configFile >> "CfgVehicles" >> (typeOf player) >> "displayName"));
_asVh = assignedVehicle player;

if not (isNull _asVh) then
	{
	//_vhName = getText (configFile >> "CfgVehicles" >> (typeOf _asVh) >> "displayName");
	switch (true) do
		{
		case (player == (commander _asVh)) : {_plName = "Commander"};
		case (player == (driver _asVh)) : {_plName = "Driver"};
		case (player == (gunner _asVh)) : {_plName = "Gunner"};
		};
	};
	
_plName = _plName + ", "  + (toLower (rank player));
_gpName = (group player) getVariable ["RYD_WS_myKind",""];

if not (_gpName in [""]) then
	{
	_gpName = " (" + _gpName + ")"
	};

_briefing = format ["%1. %4%5 %6. %7",_where,_date,_daytime,_weather,_rain,_dayTimedescr,_mission];
_briefingB = format ["%1. %4%5 %6. %7<br /><br />%8<br />%9%10",_where,_date,_daytime,_weather,_rain,_dayTimedescr,_missionB,player getVariable ["WS_myName",""],_plName,_gpName];

//player createDiaryRecord ["Diary", ["Situation",_briefingB]];
	
//_briefing1 = format ["%1, %2 %3.",_where,_date,_daytime];
//_briefing2 = format ["%1%2 %3.",_weather,_rain,_dayTimedescr];
//_briefing3 = _mission;

//diag_log _briefingB;

RydxHQ_AllLeaders = [];
RydxHQ_AllHQ = [];

if not (isNull leaderHQ) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQ];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQ)];(group leaderHQ) setVariable ["RydHQ_CodeSign","A"];if not (isNil ("HET_FA")) then {(group leaderHQ) setVariable ["RydHQ_Front",HET_FA]}};
if not (isNull leaderHQB) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQB];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQB)];(group leaderHQB) setVariable ["RydHQ_CodeSign","B"];if not (isNil ("HET_FB")) then {(group leaderHQB) setVariable ["RydHQ_Front",HET_FB]}};
if not (isNull leaderHQC) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQC];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQC)];(group leaderHQC) setVariable ["RydHQ_CodeSign","C"];if not (isNil ("HET_FC")) then {(group leaderHQC) setVariable ["RydHQ_Front",HET_FC]}};
if not (isNull leaderHQD) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQD];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQD)];(group leaderHQD) setVariable ["RydHQ_CodeSign","D"];if not (isNil ("HET_FD")) then {(group leaderHQD) setVariable ["RydHQ_Front",HET_FD]}};
if not (isNull leaderHQE) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQE];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQE)];(group leaderHQE) setVariable ["RydHQ_CodeSign","E"];if not (isNil ("HET_FE")) then {(group leaderHQE) setVariable ["RydHQ_Front",HET_FE]}};
if not (isNull leaderHQF) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQF];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQF)];(group leaderHQF) setVariable ["RydHQ_CodeSign","F"];if not (isNil ("HET_FF")) then {(group leaderHQF) setVariable ["RydHQ_Front",HET_FF]}};
if not (isNull leaderHQG) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQG];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQG)];(group leaderHQG) setVariable ["RydHQ_CodeSign","G"];if not (isNil ("HET_FG")) then {(group leaderHQG) setVariable ["RydHQ_Front",HET_FG]}};
if not (isNull leaderHQH) then {RydxHQ_AllLeaders set [(count RydxHQ_AllLeaders),leaderHQH];RydxHQ_AllHQ set [(count RydxHQ_AllHQ),(group leaderHQH)];(group leaderHQH) setVariable ["RydHQ_CodeSign","H"];if not (isNil ("HET_FH")) then {(group leaderHQH) setVariable ["RydHQ_Front",HET_FH]}};

call compile preprocessfile (RYD_Path + "Front.sqf");

_maxHeight = 0;

_vh = vehicle player;

_lastPos = ATLtoASL _ppos;
_lastHeight = _lastPos select 2;
_targetPos = getPosASL _vh;
_targetHeight = _targetPos select 2;

_refHeight = _lastHeight min _targetHeight;

_angle = [_lastPos,_targetPos,0] call RYD_AngTowards;

_lPosATL = _ppos;
_tPosATL = getPosATL _vh;

_dst = _lPosATL distance _tPosATL;

_stepsC = floor (_dst/50);
_step = 50;

if (_stepsC < 1) then
	{
	_stepsC = 1;
	_step = _dst/2 
	};

_dst = 0;

for "_i" from 1 to _stepsC do
	{
	_dst = _dst + _step;
	_posStep = [_lastPos,_angle,_dst] call RYD_PosTowards2D;
	_actHeight = getTerrainHeightASL [(_posStep select 0),(_posStep select 1)];
	if (_actHeight > _maxHeight) then
		{
		_maxHeight = _actHeight
		}
	};
	
if ((dayTime < 6) or (dayTime > 20)) then
	{
	 camUseNVG true 
	}
else
	{
	 camUseNVG false 
	};
		
	{
	_eh = _x addEventHandler ["Hit",{_this call RYD_WS_onHit}];
	_eh2 = _x addEventHandler ["Killed",{_this call RYD_WS_onDeathA}];
	_x setVariable ["WS_myName",name _x]
	}
foreach (_fcsA - [player]);

	{
	_eh = _x addEventHandler ["Killed",{_this call RYD_WS_onDeathB}]
	}
foreach _fcsB;

//player allowdamage false;
	
endLoadingScreen;

//0.4 fadeSound 1;

sleep 0.5;

RYD_init_cam camSetRelPos [0,100,1000];
RYD_init_cam camCommit 5;

RYD_WS_Typed = false;

	[
		[
			[_briefing,nil]
		],
		
		nil,
		nil,
		nil

	] spawn RYD_BIS_fnc_typeText;
	
sleep 5;

[] execVM "RydHQInit.sqf";

RYD_init_cam camSetTarget _vh;
RYD_init_cam camSetPos ((_vh modelToWorld [0,-35 - (_maxHeight - _targetHeight),_maxHeight - _targetHeight + 10]));
RYD_init_cam camCommit 10;

sleep 10;

	{
	deleteVehicle _x
	}
foreach [sc3,dummyPlayer,dummyPlayer_1,sc2,sc1];

enableSentences true;

waitUntil
	{
	sleep 0.1;
	RYD_WS_Typed
	};
	
sleep 1;

RYD_init_cam camSetTarget player;
RYD_init_cam camSetPos ((player modelToWorld [0,0,1.8]));
RYD_init_cam camCommit 0.8;

sleep 0.79;

RYD_init_cam cameraEffect ["Terminate", "BACK"];

deleteVehicle RYD_init_cam;

//GAM_setupData = compile preProcessFileLineNumbers 'scripts\gam_setupdata.sqf';

sleep 2;

/*[] spawn 
	{
	selectPlayer leaderHQ;
	sleep 10;
	[] spawn GAM_setupData;
	};*/

sleep 2;

	{
	_spectate = [_x,"HWSSpectator","","","CommunicationMenuItemAdded"] call BIS_fnc_addCommMenuItem;
	_newRole = [_x,"HWSNewRole","","","CommunicationMenuItemAdded"] call BIS_fnc_addCommMenuItem;
	_marta = [_x,"HWSMarta","","","CommunicationMenuItemAdded"] call BIS_fnc_addCommMenuItem;
	_ft = [_x,"HWSFT","","",""] call BIS_fnc_addCommMenuItem;
	
	_x createDiaryRecord ["Diary", ["Settings review",RYD_WS_txtM]];
	_x createDiaryRecord ["Diary", ["Situation",_briefingB]];
	}
foreach switchableUnits;

[] spawn
	{
	_panic_A = false;
	_panic_B = false;
	_noEnemy = false;
	_noAlly = false;
	_noLeaders = false;
	_moraleA = 0;
	_moraleB = 0;
	_lossesA = false;
	_lossesB = false;
		
	waitUntil
		{
		sleep 15;

		_noEnemy = (({(((side _x) in [RYD_WS_SideB]) and (((leader _x) distance RYD_WS_BFPos) < 5000))} count AllGroups) < 1);
		_noAlly = (({(((side _x) in [RYD_WS_SideA]) and (((leader _x) distance RYD_WS_BFPos) < 5000))} count AllGroups) < 1);
		_noLeaders = (({alive _x} count [leaderHQ,leaderHQB]) < 1);
		
		_HQa = group leaderHQ;
		_HQb = group leaderHQB;

		_moraleA_new = _HQa getVariable "RydHQ_Morale";

		if (isNil "_moraleA_new") then 
			{
			_moraleA = _moraleA - (random 1)
			}
		else
			{
			_combatAvG = (_HQa getVariable ["RydHQ_Friends",RYD_WS_GroupsA]) - ((_HQa getVariable ["RydHQ_Exhausted",[]]) + ((_HQa getVariable ["RydHQ_AirG",[]]) - (_HQa getVariable ["RydHQ_NCrewInfG",[]])) + (_HQa getVariable ["RydHQ_SpecForG",[]]) + (_HQa getVariable ["RydHQ_CargoOnly",[]]) + (_HQa getVariable ["RydHQ_NavalG",[]]) + (_HQa getVariable ["RydHQ_StaticG",[]]) + (_HQa getVariable ["RydHQ_SupportG",[]]) + (_HQa getVariable ["RydHQ_ArtG",[]]) + (_HQa getVariable ["RydHQ_Garrison",[]]) + ((_HQa getVariable ["RydHQ_NCCargoG",[]]) - ((_HQa getVariable ["RydHQ_NCrewInfG",[]]) - (_HQa getVariable ["RydHQ_SupportG",[]]))));		
			
				{
				switch (true) do
					{
					case (isNil {_x}) : {_combatAvG set [_foreachIndex,grpNull]};
					case not ((typeName _x) in [(typeName grpNull)]) : {_combatAvG set [_foreachIndex,grpNull]};
					case (isNull _x) : {_combatAvG set [_foreachIndex,grpNull]};
					};
				}
			foreach _combatAvG;
			
			_combatAvG = _combatAvG - [grpNull];
			
			_combatAv = 0;
			
				{
				_combatAv = _combatAv + ({alive _x} count (units _x))
				}
			foreach _combatAvG;
			
			//diag_log format ["_combatAv A: %1",_combatAv];
			
			_minimalEff = _HQa getVariable ["RydHQ_CaptLimit",10];
			
			_lossesA = ((_HQa getVariable ["RydHQ_LTotal",0]) > 0.75) or (_combatAv < _minimalEff);
			
			if (({alive _x} count (units _HQa)) < 1) then 
				{
				_moraleA = _moraleA - (random 1)
				}
			else
				{
				_moraleA = _moraleA_new
				}
			};
			
		_moraleB_new = _HQb getVariable "RydHQ_Morale";

		if (isNil "_moraleB_new") then 
			{
			_moraleB = _moraleB - (random 1)
			}
		else
			{
			_combatAvG = (_HQb getVariable ["RydHQ_Friends",RYD_WS_GroupsB]) - ((_HQb getVariable ["RydHQ_Exhausted",[]]) + ((_HQb getVariable ["RydHQ_AirG",[]]) - (_HQb getVariable ["RydHQ_NCrewInfG",[]])) + (_HQb getVariable ["RydHQ_SpecForG",[]]) + (_HQb getVariable ["RydHQ_CargoOnly",[]]) + (_HQb getVariable ["RydHQ_NavalG",[]]) + (_HQb getVariable ["RydHQ_StaticG",[]]) + (_HQb getVariable ["RydHQ_SupportG",[]]) + (_HQb getVariable ["RydHQ_ArtG",[]]) + (_HQb getVariable ["RydHQ_Garrison",[]]) + ((_HQb getVariable ["RydHQ_NCCargoG",[]]) - ((_HQb getVariable ["RydHQ_NCrewInfG",[]]) - (_HQb getVariable ["RydHQ_SupportG",[]]))));					

				{
				switch (true) do
					{
					case (isNil {_x}) : {_combatAvG set [_foreachIndex,grpNull]};
					case not ((typeName _x) in [(typeName grpNull)]) : {_combatAvG set [_foreachIndex,grpNull]};
					case (isNull _x) : {_combatAvG set [_foreachIndex,grpNull]};
					};
				}
			foreach _combatAvG;
			
			_combatAvG = _combatAvG - [grpNull];
			
			_combatAv = 0;
			
				{
				_combatAv = _combatAv + ({alive _x} count (units _x))
				}
			foreach _combatAvG;
			
			//diag_log format ["_combatAv B: %1",_combatAv];
			
			_minimalEff = _HQb getVariable ["RydHQ_CaptLimit",10];
			
			_lossesB = ((_HQb getVariable ["RydHQ_LTotal",0]) > 0.75) or (_combatAv < _minimalEff);
			
			if (({alive _x} count (units _HQb)) < 1) then 
				{
				_moraleB = _moraleB - (random 1)
				}
			else
				{
				_moraleB = _moraleB_new
				}
			};
		
		_panic_A = (_moraleA < -49);
		_panic_B = (_moraleB < -49);
		
		//diag_log format ["ma: %1 mb: %2 noen: %3 nol: %4 noa: %5",_moraleA,_moraleB,_noEnemy,_noLeaders,_noAlly];
		
		((_noEnemy) or (_noLeaders) or (_panic_A) or (_panic_B) or (_noAlly) or (_lossesA) or (_lossesB))
		};
		
	diag_log "END OF BATTLE";
		
	_cl = "";
	_clA = switch (RYD_WS_SideA) do
		{
		case (west) : {"ColorWEST"};
		case (east) : {"ColorEAST"};
		case (resistance) : {"ColorGUER"};
		};
		
	_clB = switch (RYD_WS_SideB) do
		{
		case (west) : {"ColorWEST"};
		case (east) : {"ColorEAST"};
		case (resistance) : {"ColorGUER"};
		};
		
	switch (true) do
		{
		case ((_noEnemy) and (_noAlly)) : {TitleText ["Both armies withdrew!","PLAIN",5];missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>BOTH ARMIES WITHDREW</t>"]};
		case (_noEnemy) : {TitleText ["Enemy withdrew!","PLAIN",5];_cl = _clA;missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>ENEMY WITHDREW</t>"]};
		case (_noAlly) : {TitleText ["Our forces withdrew!","PLAIN",5];_cl = _clB;missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>OUR FORCES WITHDREW</t>"]};
		case (_noLeaders) : {TitleText ["Both armies lost their HQ!","PLAIN",5];missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>BOTH ARMIES LOST HQ</t>"]};
		case ((_panic_A) and (_panic_B)) : {TitleText ["Morale of both armies is broken!","PLAIN",5];missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>BOTH ARMIES LOST WILL OF FIGHT</t>"]};
		case (_panic_A) : {TitleText ["Morale of your army is broken!","PLAIN",5];_cl = _clB;missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>OUR ARMY LOST WILL OF FIGHT</t>"]};
		case (_panic_B) : {TitleText ["Morale of enemy army is broken!","PLAIN",5];_cl = _clA;missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>ENEMY ARMY LOST WILL OF FIGHT</t>"]};
		case ((_lossesA) and (_lossesB)) : {TitleText ["Both armies sustained too heavy losses to continue the fight!","PLAIN",5];missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>BOTH ARMIES LOST FIGHTING CAPACITY</t>"]};
		case (_lossesA) : {TitleText ["Your commander-in-chief gave the order to surrender due to massive losses!","PLAIN",5];_cl = _clB;missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>OUR ARMY LOST FIGHTING CAPACITY AND SURRENDERED</t>"]};
		case (_lossesB) : {TitleText ["Enemy commander-in-chief gave the order to surrender due to massive losses!","PLAIN",5];_cl = _clA;missionNamespace setVariable ["RYD_WS_Reason","<t align='center' size='2.0'>ENEMY ARMY LOST FIGHTING CAPACITY AND SURRENDERED</t>"]};
		};
		
	sleep 10;
	
	TitleText ["","PLAIN",0];
	
	if (RYD_WS_CAdd) then
		{
		if not (_cl == "") then
			{
			_colors = profileNamespace getVariable ["RYD_WS_MapColors" + worldName,[]];
			_ns = [RYD_WS_BFPos,RYD_WS_NearSectors,0,RYD_WS_BFRadius * 0.55] call RYD_WS_FindSectorInRange;
			
				{
				if ((_x getvariable "Topo_SeaP") < 50) then
					{
					_posL = position _x;
					_posL set [2,0];
					
						{
						_pos = _x select 0;
						
						if ((_pos distance _posL) < 50) exitWith {_colors set [_foreachIndex,0]}
						}
					foreach _colors;
					
					_colors = _colors - [0];
					
					_colors set [(count _colors),[_posL,_cl]]
					}
				}
			foreach _ns;
			
			profileNamespace setVariable ["RYD_WS_MapColors" + worldName,_colors];
			
			saveProfileNamespace;
			}
		};
		
	_KIAs = missionNamespace getVariable ["WS_KIA_A",[]];
	
	_KIAlist = "";
	
		{
		_KIAlist = _KIAlist + _x + "<br/>"
		}
	foreach _KIAs;
	
	//_KIAlist = composeText _KIAlist;
		
	missionNameSpace setVariable ["RYD_WS_KIA_list",_KIAlist];
	
	RYD_WS_Wounded_A = RYD_WS_Wounded_A - RYD_WS_Killed_A;
	
	//diag_log format ["Killed: %1 wounded: %2",RYD_WS_Killed_A,RYD_WS_Wounded_A];
	
	_woundList = "";
	
		{
		if not (isNull _x) then
			{			
			_woundList = _woundList + (_x getVariable ["WS_myName",name _x]) + "<br/>"
			}
		}
	foreach RYD_WS_Wounded_A;
	
	missionNameSpace setVariable ["RYD_WS_WIA_list",_woundList];
	
	_indicted = [];
	_gpsSurr = [];
	
	_indictedList = "";
	
		{
		if not (isNull _x) then
			{
			_acc = "";
			_gp = group _x;
			
			if (_x getVariable ["RYD_WS_Indicted",false]) then
				{
				_acc = "MANSLAUGHTER"
				};
			
			if (_gp getVariable ("isCaptive" + (str _gp))) then
				{
				if not (_gp in _gpsSurr) then 
					{
					_gpsSurr set [(count _gpsSurr),_gp];
					
					if not (_acc in [""]) then
						{
						_acc = _acc + " AND COWARDICE"
						}
					else
						{
						_acc = "COWARDICE" 
						}
					};
				};
				
			if (_acc in [""]) exitWith {};
			_indicted set [(count _indicted),_x];
				
			_indictedList = _indictedList + (name _x) + " - " + _acc + "<br/>"
			};
		}
	foreach (RYD_WS_ForcesA - RYD_WS_Killed_A);
	
	missionNameSpace setVariable ["RYD_WS_Indicted_list",_indictedList];
	
	_killers = [];
	
		{
		_name = _x getVariable ["WS_myName",name _x];
		_kills = (missionNamespace getVariable ["WS_KIA_B" + _name,[_name,0]]) select 1;
				
		if (_kills > 0) then
			{			
			_killers set [(count _killers),[_x,_kills]]
			}
		}
	foreach RYD_WS_ForcesA;
	
	_killers = [_killers] call RYD_WS_SortByKills;
	
	_killsList = "";
	_awardedList = "";
	
		{
		_sd = _x select 0;
		if not (isNull _sd) then
			{
			_name = _sd getVariable ["WS_myName",name _sd];
			
			_kills = missionNamespace getVariable ["WS_KIA_B" + _name,[_name,0]];
			_amnt = _kills select 1;
			
			_killsList = _killsList + (_kills select 0) + " - " + (str _amnt) + "<br/>";
			
			if not (_x in _indicted) then
				{
				if (_amnt > 9) then
					{
					_awardedList = _awardedList + _name + "<br/>"
					}
				};
			}
		}
	foreach _killers;
	
	missionNameSpace setVariable ["RYD_WS_Kills_list",_killsList];
	missionNameSpace setVariable ["RYD_WS_Awarded_list",_awardedList];
				
	["END1",true,true,true] call BIS_fnc_endMission;
	};


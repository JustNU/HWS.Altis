//Tasking

Action1ct = {

	(group (_this select 0)) setVariable [('Resting' + (str (group (_this select 0)))),false]; 
	(group (_this select 0)) setVariable [('Garrisoned' + (str (group (_this select 0)))),false];
	(group (_this select 0)) setVariable [('NOGarrisoned' + (str (group (_this select 0)))),true];


	[(_this select 0),RydxHQ_AIC_OrdDen,'OrdDen'] call RYD_AIChatter;
	deleteWaypoint [(group (_this select 0)),(currentWaypoint (group (_this select 0)))];

	{
	[_x,'CANCELED',true] call BIS_fnc_taskSetState;
	} foreach ((group (_this select 0)) getVariable ['HACAddedTasks',[]]);

	(group (_this select 0)) setVariable ["Break",true];



};

Action1fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Tasking] Deny Assigned Task","[_this select 3] remoteExec ['Action1ct',2]",_Unit,-2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	_Unit setVariable ["HAL_TaskAddedID",_Action];
};

ACEAction1fnc = {

	private ["_Unit","_ACEAction","_ACEActionP"];

	_Unit = _this select 0;

	_ACEActionP = ["ACEActionP","HAL Tasking","",{},{true}] call ace_interact_menu_fnc_createAction;
	_ACEAction = ["HALDenyAssignedTask","Deny Assigned Task","",{

		[_target] remoteExec ['Action1ct',2]
				
		},{true},{}] call ace_interact_menu_fnc_createAction;
	[_Unit, 1, ["ACE_SelfActions"], _ACEActionP] call ace_interact_menu_fnc_addActionToObject;
	[_Unit, 1, ["ACE_SelfActions","ACEActionP"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;

};

Action2ct = {

	[(_this select 0),'Command, we are unavailable for further tasking - Over'] remoteExecCall ["RYD_MP_Sidechat"];
	group (_this select 0) setVariable ['Unable',true];
	group (_this select 0) setVariable ['BUnable',true];

};

Action2fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Tasking] Disable Tasking", 
		"
		[_this select 3] remoteExecCall ['Action2ct',2]
		"
		, 
		_Unit,-2.1,false,false,"","_target isEqualTo (vehicle player)",0.01];

	_Unit setVariable ["HAL_TaskDisabledID",_Action];

};

ACEAction2fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALDisableTasking","Disable Tasking","",{

			[_target] remoteExecCall ['Action2ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;
		[_Unit, 1, ["ACE_SelfActions","ACEActionP"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;

};

Action3ct = {

	[(_this select 0),'Command, we are available for further tasking - Over'] remoteExecCall ["RYD_MP_Sidechat"];
	group (_this select 0) setVariable ['Unable',false];
	group (_this select 0) setVariable ['BUnable',false];

};

Action3fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Tasking] Enable Tasking", 
		"
		[_this select 3] remoteExecCall ['Action3ct',2]
		"
		, 
		_Unit,-2.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_TaskEnabledID",_Action];

};

ACEAction3fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALEnableTasking","Enable Tasking","",{

			[_target] remoteExecCall ['Action3ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;
		[_Unit, 1, ["ACE_SelfActions","ACEActionP"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action1fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_TaskAddedID";
	_Unit removeAction _Action;

};

ACEAction1fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionP","HALDenyAssignedTask"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action2fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_TaskDisabledID";
	_Unit removeAction _Action;

};

ACEAction2fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionP","HALDisableTasking"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action3fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_TaskEnabledID";
	_Unit removeAction _Action;

};

ACEAction3fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionP","HALEnableTasking"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_Unit,1,["ACE_SelfActions","ACEActionP"]] call ace_interact_menu_fnc_removeActionFromObject;

};

//Supports

Action4ct = {

	private ["_trg","_chosen","_HQ","_dist","_request"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting close air support at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 3;

	_trg = (_this select 0) findNearestEnemy (position (_this select 0));
	_request = false;

	if (_trg isEqualTo objNull) then {
		_trg = (_this select 0);
		_request = true;
	};

	if (((_this select 0) distance2D _trg) > 500) then {
		_trg = (_this select 0);
		_request = true;
	};

	_trg = (vehicle (leader (group _trg)));

	_chosen = grpNull;

	_dist = 10000000;

	{
	
	if (not (_x getvariable [("Busy" + (str _x)),false]) and not (_x == (group (_this select 0))) and not (_x getvariable ["Unable",false]) and (((_this select 0) distance2D (leader _x)) < _dist)) then {_chosen = _x; _dist = ((_this select 0) distance2D (leader _x));};
	
	} forEach ((_HQ getVariable ["RydHQ_AirG",[]]) - ((_HQ getVariable ["RydHQ_NCAirG",[]]) + (_HQ getVariable ["RydHQ_NCrewInfG",[]])));

	if (_chosen isEqualTo grpNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No air support units are available at the moment - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	_chosen setVariable ["Busy" + (str _chosen),true];
	_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];
								
	[[_chosen,_trg,_HQ,_request],(["AIR"] call RYD_GoLaunch)] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', ' + (groupId _chosen) + ' has been dispatched for CAS - Out'] remoteExecCall ["RYD_MP_Sidechat"];


};

Action4fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Air Support", 
		"
		[_this select 3] remoteExec ['Action4ct',2]
		"
		, 
		_Unit,-3,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqAirID",_Action];

};

ACEAction4fnc = {

	private ["_Unit","_ACEAction","_ACEActionR"];

	_Unit = _this select 0;

	_ACEActionR = ["ACEActionR","HAL Supports","",{},{true}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions"], _ACEActionR] call ace_interact_menu_fnc_addActionToObject;

	_ACEAction = ["HALReqAir","Request Air Support","",{

		[_target] remoteExec ['Action4ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action4fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqAirID";
	_Unit removeAction _Action;

};

ACEAction4fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqAir"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action5ct = {

	private ["_trg","_chosen","_HQ","_dist","_request"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting infantry support at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 3;

	_trg = (_this select 0) findNearestEnemy (position (_this select 0));
	_request = true;

	if (_trg isEqualTo objNull) then {
		_trg = (_this select 0);
		_request = true;
	};

	if (((_this select 0) distance2D _trg) > 250) then {
		_trg = (_this select 0);
		_request = true;
	};

	_trg = (vehicle (leader (group _trg)));

	_chosen = grpNull;

	_dist = 10000000;

	{
	
	if (not (_x getvariable [("Busy" + (str _x)),false]) and not (_x == (group (_this select 0))) and not (_x getvariable ["Unable",false]) and (((_this select 0) distance2D (leader _x)) < _dist)) then {_chosen = _x; _dist = ((_this select 0) distance2D (leader _x));};
	
	} forEach (((_HQ getVariable ["RydHQ_NCrewInfG",[]]) - (_HQ getVariable ["RydHQ_SpecForG",[]])) + ((_HQ getVariable ["RydHQ_CarsG",[]]) - ((_HQ getVariable ["RydHQ_ATInfG",[]]) + (_HQ getVariable ["RydHQ_AAInfG",[]]) + (_HQ getVariable ["RydHQ_SupportG",[]]) + (_HQ getVariable ["RydHQ_NCCargoG",[]]))));

	if (_chosen isEqualTo grpNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No infantry squads are available at the moment - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	
	_chosen setVariable ["Busy" + (str _chosen),true];
	_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];
								
	[[_chosen,_trg,_HQ,_request],(["INF"] call RYD_GoLaunch)] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', ' + (groupId _chosen) + ' has been dispatched - Out'] remoteExecCall ["RYD_MP_Sidechat"];


};

Action5fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Infantry Support", 
		"
		[_this select 3] remoteExec ['Action5ct',2]
		"
		, 
		_Unit,-3.1,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqInfID",_Action];

};

ACEAction5fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqInf","Request Infantry Support","",{

		[_target] remoteExec ['Action5ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action5fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqInfID";
	_Unit removeAction _Action;

};

ACEAction5fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqInf"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action6ct = {

	private ["_trg","_chosen","_HQ","_dist","_request"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting armored support at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 3;

	_trg = (_this select 0) findNearestEnemy (position (_this select 0));
	_request = true;

	if (_trg isEqualTo objNull) then {
		_trg = (_this select 0);
		_request = true;
	};

	if (((_this select 0) distance2D _trg) > 250) then {
		_trg = (_this select 0);
		_request = true;
	};

	_trg = (vehicle (leader (group _trg)));

	_chosen = grpNull;

	_dist = 10000000;

	{
	
	if (not (_x getvariable [("Busy" + (str _x)),false]) and not (_x == (group (_this select 0))) and not (_x getvariable ["Unable",false]) and (((_this select 0) distance2D (leader _x)) < _dist)) then {_chosen = _x; _dist = ((_this select 0) distance2D (leader _x));};
	
	} forEach ((_HQ getVariable ["RydHQ_HArmorG",[]]) + (_HQ getVariable ["RydHQ_LArmorATG",[]]));

	if (_chosen isEqualTo grpNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No armored units are available at the moment - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	_chosen setVariable ["Busy" + (str _chosen),true];
	_HQ setVariable ["RydHQ_AttackAv",(_HQ getVariable ["RydHQ_AttackAv",[]]) - [_chosen]];
								
	[[_chosen,_trg,_HQ,_request],(["ARM"] call RYD_GoLaunch)] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', ' + (groupId _chosen) + ' has been dispatched - Out'] remoteExecCall ["RYD_MP_Sidechat"];


};

Action6fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Armored Support", 
		"
		[_this select 3] remoteExec ['Action6ct',2]
		"
		, 
		_Unit,-3.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqArmID",_Action];

};

ACEAction6fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqArm","Request Armored Support","",{

		[_target] remoteExec ['Action6ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action6fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqArmID";
	_Unit removeAction _Action;

};

ACEAction6fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqArm"]] call ace_interact_menu_fnc_removeActionFromObject;
//	[_Unit,1,["ACE_SelfActions","ACEActionR"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action7ct = {

	private ["_unitvar","_chosen","_HQ","_dist"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting airlift at our position - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	_unitvar = str (group (_this select 0));

	if not ((group (_this select 0)) getVariable [("CC" + _unitvar), true]) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. air transport already assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	(group (_this select 0)) setVariable [("CC" + _unitvar), false, true];

	[[(group (_this select 0)),_HQ,[0,0],false,true],HAL_SCargo] call RYD_Spawn;

	sleep 15;

	if ((group (_this select 0)) getVariable [("CC" + _unitvar), false]) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No air assets are available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Air transport has been assigned - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action7fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Supports] Request Transport Support", 
		"
		[_this select 3] remoteExec ['Action7ct',2]
		"
		, 
		_Unit,-3.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqTraID",_Action];

};

ACEAction7fnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqTra","Request Transport Support","",{

		[_target] remoteExec ['Action7ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionR"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action7fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqTraID";
	_Unit removeAction _Action;

};

ACEAction7fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionR","HALReqTra"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_Unit,1,["ACE_SelfActions","ACEActionR"]] call ace_interact_menu_fnc_removeActionFromObject;

};

//LOGISTICS

Action8ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_FlyBoy","_ammoBox"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ammunition drop - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_FlyBoy = objNull;

	{
		_unitvar = str _x;
		if ( not (_x getVariable [("Busy" + _unitvar),false]) and not (_x == (group (_this select 0))) and not (_x getVariable ["Unable",false]) and not (_x isEqualTo grpNull) and (canMove (vehicle (leader _x))) and not ((vehicle (leader _x)) == (leader _x))) exitwith {_FlyBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_AmmoDrop",[]]);

	if (_FlyBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No supply services are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	if not ((count (_HQ getVariable ["RydHQ_AmmoBoxes",[]])) > 0) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. Supplies have been depleted - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	_ammoBox = (_HQ getVariable ["RydHQ_AmmoBoxes",[]]) select 0;
	_HQ setVariable ["RydHQ_AmmoBoxes",(_HQ getVariable ["RydHQ_AmmoBoxes",[]]) - [_ammoBox]];

	[[assignedvehicle (leader _FlyBoy),(_this select 0),[],[],true,_ammoBox,_HQ],HAL_GoAmmoSupp] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Supplies are on their way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action8fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Ammunition Drop", 
		"
		[_this select 3] remoteExec ['Action8ct',2]
		"
		, 
		_Unit,-4,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqDSuppID",_Action];

};

ACEAction8fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;


	_ACEActionL = ["ACEActionL","HAL Logistics","",{},{true}] call ace_interact_menu_fnc_createAction;
	[_Unit, 1, ["ACE_SelfActions"], _ACEActionL] call ace_interact_menu_fnc_addActionToObject;

	_ACEAction = ["HALReqDSupp","Request Ammunition Drop","",{

		[_target] remoteExec ['Action8ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action8fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqDSuppID";
	_Unit removeAction _Action;

};

ACEAction8fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqDSupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action9ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_AmmoBoy"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ammunition truck - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Ammo + RYD_WS_ammo - RHQs_Ammo;

	_AmmoBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_AmmoBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_AmmoBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No rearming services are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[[_AmmoBoy,(_this select 0),[],[],false,objNull,_HQ,true],HAL_GoAmmoSupp] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Ammunition truck is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action9fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Ammunition Truck", 
		"
		[_this select 3] remoteExec ['Action9ct',2]
		"
		, 
		_Unit,-4.1,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqASuppID",_Action];

};

ACEAction9fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqASupp","Request Ammunition Truck","",{

		[_target] remoteExec ['Action9ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action9fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqASuppID";
	_Unit removeAction _Action;

};

ACEAction9fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqASupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action10ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_FuelBoy","_Pool"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting fuel truck - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Fuel + RYD_WS_fuel - RHQs_Fuel;

	_FuelBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_FuelBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_FuelBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No refueling services are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[[_FuelBoy,(_this select 0),[],_HQ,true],HAL_GoFuelSupp] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Fuel truck is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action10fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Fuel Truck", 
		"
		[_this select 3] remoteExec ['Action10ct',2]
		"
		, 
		_Unit,-4.2,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqFSuppID",_Action];

};

ACEAction10fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqFSupp","Request Fuel Truck","",{

		[_target] remoteExec ['Action10ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action10fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqFSuppID";
	_Unit removeAction _Action;

};

ACEAction10fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqFSupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action11ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_MedBoy"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting ambulance - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Med + RYD_WS_med - RHQs_Med;

	_MedBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not (_x in (_HQ getVariable ["RydHQ_AirG",[]])) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_MedBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_MedBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No ambulances are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[[_MedBoy,(_this select 0),[],_HQ,true],HAL_GoMedSupp] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Ambuance is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action11fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Ambulance", 
		"
		[_this select 3] remoteExec ['Action11ct',2]
		"
		, 
		_Unit,-4.3,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqMSuppID",_Action];

};

ACEAction11fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqMSupp","Request Ambulance","",{

		[_target] remoteExec ['Action11ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action11fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqMSuppID";
	_Unit removeAction _Action;

};

ACEAction11fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqMSupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};

Action12ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_MedBoy"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting aerial medical support - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Med + RYD_WS_med - RHQs_Med;

	_MedBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and (_x in (_HQ getVariable ["RydHQ_AirG",[]])) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_MedBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_MedBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No MEDEVAC helicopters are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[[_MedBoy,(_this select 0),[],_HQ,true],HAL_GoMedSupp] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Helicopter is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action12fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Aerial Medical Support", 
		"
		[_this select 3] remoteExec ['Action12ct',2]
		"
		, 
		_Unit,-4.4,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqMASuppID",_Action];

};

ACEAction12fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqMASupp","Request Aerial Medical Support","",{

		[_target] remoteExec ['Action12ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action12fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqMASuppID";
	_Unit removeAction _Action;

};

ACEAction12fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqMASupp"]] call ace_interact_menu_fnc_removeActionFromObject;

};


Action13ct = {

	private ["_unitvar","_chosen","_HQ","_dist","_FixBoy"];

	if not (isnil "LeaderHQ") then {if ((group (_this select 0)) in ((group LeaderHQ) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQ)}};
	if not (isnil "LeaderHQB") then {if ((group (_this select 0)) in ((group LeaderHQB) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQB)}};
	if not (isnil "LeaderHQC") then {if ((group (_this select 0)) in ((group LeaderHQC) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQC)}};
	if not (isnil "LeaderHQD") then {if ((group (_this select 0)) in ((group LeaderHQD) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQD)}};
	if not (isnil "LeaderHQE") then {if ((group (_this select 0)) in ((group LeaderHQE) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQE)}};
	if not (isnil "LeaderHQF") then {if ((group (_this select 0)) in ((group LeaderHQF) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQF)}};
	if not (isnil "LeaderHQG") then {if ((group (_this select 0)) in ((group LeaderHQG) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQG)}};
	if not (isnil "LeaderHQH") then {if ((group (_this select 0)) in ((group LeaderHQH) getVariable ["RydHQ_Friends",[]])) then {_HQ = (group LeaderHQH)}};

	[(_this select 0), 'Command, requesting repair support - Over'] remoteExecCall ["RYD_MP_Sidechat"];

	sleep 5;

	_Pool = RHQ_Rep + RYD_WS_rep - RHQs_Rep;

	_FixBoy = objNull;

	{
		_unitvar = str (group _x);
		if ( not ((group _x) getVariable [("Busy" + _unitvar),false]) and not ((group _x) == (group (_this select 0))) and not ((group _x) getVariable ["Unable",false]) and not ((group _x) isEqualTo grpNull) and (canMove _x) and ((toLower (typeOf (assignedvehicle (leader (group _x))))) in _Pool) and not ((group _x) in ((_HQ getVariable ["RydHQ_SpecForG",[]]) + (_HQ getVariable ["RydHQ_CargoOnly",[]]))))  exitwith {_FixBoy = _x};
	} foreach (_HQ getVariable ["RydHQ_Support",[]]);

	if (_FixBoy isEqualTo objNull) exitwith {[leader _HQ, (groupId (group (_this select 0))) + ', negative. No repair trucks are currently available - Out'] remoteExecCall ["RYD_MP_Sidechat"]};

	[[_FixBoy,(_this select 0),[],_HQ,true],HAL_GoRepSupp] call RYD_Spawn;

	[leader _HQ, (groupId (group (_this select 0))) + ', affirmative. Repair truck is on its way - Out'] remoteExecCall ["RYD_MP_Sidechat"];

};

Action13fnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL Logistics] Request Repair Support", 
		"
		[_this select 3] remoteExec ['Action13ct',2]
		"
		, 
		_Unit,-4.5,false,false,"","_target isEqualTo (vehicle player)",0.01];
	
	_Unit setVariable ["HAL_ReqRSuppID",_Action];

};

ACEAction13fnc = {

	private ["_Unit","_ACEAction","_ACEActionL"];

	_Unit = _this select 0;

	_ACEAction = ["HALReqRSupp","Request Repair Support","",{

		[_target] remoteExec ['Action13ct',2]

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions","ACEActionL"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

Action13fncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqRSuppID";
	_Unit removeAction _Action;

};

ACEAction13fncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","ACEActionL","HALReqRSupp"]] call ace_interact_menu_fnc_removeActionFromObject;
	[_Unit,1,["ACE_SelfActions","ACEActionL"]] call ace_interact_menu_fnc_removeActionFromObject;

};

// MENU

ActionMfnc = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit addAction ["[HAL] Show Communication Menu", 
		"
		showCommandingMenu '#USER:NR6_Player_Menu';
		"
		, 
		_Unit,-4.5,false,false,"","_target isEqualTo (vehicle player)",50];
	
	_Unit setVariable ["HAL_ReqMenuID",_Action];

};

ACEActionMfnc = {

	private ["_Unit","_ACEAction"];

	_Unit = _this select 0;

	_ACEAction = ["HALMenu","[HAL] Show Communication Menu","",{

		showCommandingMenu '#USER:NR6_Player_Menu';

		},{true},{}] call ace_interact_menu_fnc_createAction;

	[_Unit, 1, ["ACE_SelfActions"], _ACEAction] call ace_interact_menu_fnc_addActionToObject;


};

ActionMfncR = {

	private ["_Unit","_Action"];

	_Unit = _this select 0;

	_Action = _Unit getVariable "HAL_ReqMenuID";
	_Unit removeAction _Action;

};

ACEActionMfncR = {

	private ["_Unit"];

	_Unit = _this select 0;

	[_Unit,1,["ACE_SelfActions","HALMenu"]] call ace_interact_menu_fnc_removeActionFromObject;

};
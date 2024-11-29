RYD_EndMission = 
	{
	waitUntil 
		{
		not (isNull(findDisplay 46))
		};

	(findDisplay 46) displayAddEventHandler ["KeyDown", "enableEndDialog"]; 
	};
	
RYD_CamSwitchOff = 
	{
	if not (RydSC_ViewSwitch) exitWith 
		{
		waitUntil 
			{
			not (isNull(findDisplay 46))
			};
			
		(findDisplay 46) displayRemoveEventHandler ["KeyDown", (missionNameSpace getVariable ["RYD_CSwitch_EH",-1])];
		};
		
	RYD_Cam_SOff = true;
	TitleText ["","BLACK OUT", 0.1];
	
	waitUntil 
		{
		not (isNull(findDisplay 46))
		};
		
	(findDisplay 46) displayRemoveEventHandler ["KeyDown", (missionNameSpace getVariable ["RYD_CSwitch_EH",-1])];

	sleep 0.15;

	if (RydSC_PPEffects) then
		{	
		((missionNameSpace getVariable ["RYD_SCam_PPE",[]]) select 0) ppEffectEnable false;
		"FilmGrain" ppEffectEnable false;
		"chromAberration" ppEffectEnable false
		};
	
	(missionNameSpace getVariable ["RydSC_Camera",objNull]) cameraEffect ["Terminate", "BACK"];
	
	/*_aIDs = [];
	
	_aID = player addAction ["<t color='#d0a900'>Spectator</t>", "SC\CamSwitchOn.sqf", [], 1, false, true, "", "(RydSC_ViewSwitch) and (player == (vehicle player))"];
	_aIDs set [(count _aIDs),_aID];
	
	if not (player == (vehicle player)) then
		{
		_aID = (vehicle player) addAction ["<t color='#d0a900'>Spectator</t>", "SC\CamSwitchOn.sqf", [], 1, false, true, "", "(RydSC_ViewSwitch) and (_this in _target)"];
		_aIDs set [(count _aIDs),_aID]
		};
		
	missionNameSpace setVariable ["RYD_CSwitch_EH",[_aIDs,[player,(vehicle player)]]];*/
	
	TitleText ["","BLACK IN", 1]
	};
	
RYD_CamSwitchOn = 
	{
	if (isNil "RYD_SCam_Exist") exitWith {[] execVM "SC\CamInit.sqf"};
	
	if not (RydSC_ViewSwitch) exitWith {};
	RYD_Cam_SOff = false;
	TitleText ["","BLACK OUT", 0.1];
	
	/*_action = missionNameSpace getVariable ["RYD_CSwitch_EH",[]];
	
		{
		(_action select _foreachIndex) removeAction (_x select 0)
		}
	foreach _action;*/

	sleep 0.15;

	if (RydSC_PPEffects) then
		{	
		((missionNameSpace getVariable ["RYD_SCam_PPE",[]]) select 0) ppEffectEnable true;
		"FilmGrain" ppEffectEnable true;
		"chromAberration" ppEffectEnable true
		};
	
	(missionNameSpace getVariable ["RydSC_Camera",objNull]) cameraEffect ["internal", "BACK"];
	
	waitUntil 
		{
		not (isNull(findDisplay 46))
		};
		
	_eh = (findDisplay 46) displayAddEventHandler ["KeyDown", "nul = [] spawn RYD_CamSwitchOff;true"];
	missionNameSpace setVariable ["RYD_CSwitch_EH",_eh];
	
	TitleText ["","BLACK IN", 1];
	};
	
RYD_BaitFN = 
	{
	private ["_val","_unit","_bait","_stoper"];

	_val = _this select 0;
	_unit = _this select 1;

	_stoper = _unit getVariable ["FromLast",0];

	if ((time - _stoper) < 0.5) exitWith {};

	_unit setVariable ["FromLast",time];

	_bait = _unit getVariable ["RYDBait",0];

	_unit setVariable ["RYDBait",_bait + (_val/(1 + sqrt(_bait + _val + 0.0001)))];
	};

if (isNil "RydSC_RelPos") then
	{
	RydSC_RelPos = 
		[
		[0,-2,1.5],
		[0,-3,1.75],
		[0,-5,2.0],
		[0,-60,25],
		[60,0,25],
		[0,60,25],
		[-60,0,25],
		[3,0,1.75],
		[5,0,2.0],
		[-3,0,1.75],
		[-5,0,2.0],
		[-3,-3,1.75],
		[3,-3,1.75],
		[-3,3,1.75],
		[3,3,1.75],
		[5,-5,2.0],
		[-5,5,2.0],
		[5,5,2.0]
		];
	};
		
RYD_CAM_LOSCheck = 
	{
	private ["_pos1","_pos2","_tint","_lint","_isLOS","_cam","_target","_pX1","_pY1","_pX2","_pY2","_pos1ATL","_pos2ATL"];

	_pos1 = _this select 0;
	_pos2 = _this select 1;

	_pX1 = _pos1 select 0;
	_pY1 = _pos1 select 1;

	_pX2 = _pos2 select 0;
	_pY2 = _pos2 select 1;

	_pos1ATL = [_pX1,_pY1,1.5];
	_pos2ATL = [_pX2,_pY2,1.5];

	_cam = objNull;

	if ((count _this) > 2) then {_cam = _this select 2};

	_target = objNull;

	if ((count _this) > 3) then {_target = _this select 3};

	_tint = terrainintersect [_pos1ATL, _pos2ATL]; 
	_lint = lineintersects [_pos1, _pos2,_cam,_target]; 

	_isLOS = true;

	if ((_tint) or (_lint)) then {_isLOS = false};

	_isLOS
	};

RYD_SceneC = 
	{
	private ["_target","_cam","_speed","_dst","_relPos","_tPos","_plnPos","_ct","_ab","_posT","_posE","_nE","_isLOS","_height","_angle","_size"];

	_cam = _this select 0;
	_target = _this select 1;

	_dst = _cam distance _target;

	_speed = _dst/40;

	if (_speed < 1.5) then {_speed = 1.5};
	if (_speed > 10) then {_speed = 10};
	
	_nE = _target findNearestEnemy _target;

	if ((isNull _nE) or ((random 100) > 85)) then
		{
		_relPos = RydSC_RelPos select (floor (random (count RydSC_RelPos)));
		_plnPos = _target modelToWorld _relPos;
		}
	else
		{
		_posT = getPosASL _target;
		_posE = getPosASL _nE;
		
		_isLOS = [_posT,_posE,_target,_nE] call RYD_CAM_LOSCheck;

		if (_isLOS) then
			{
			_height = 1 + (random 1.5);
			if (_target in Vehicles) then
				{
				_height = _height * 1.5
				};
				
			_dst = _height * (4 + (random 2));

			_angle = [_posT,_posE,10] call RYD_CAM_AngTowards;
			_angle = _angle + 180;
				
			_plnPos = [_posT,_angle,_dst] call RYD_CAM_PosTowards2D;
			_plnPos = [_plnPos select 0,_plnPos select 1,((getPosATL _target) select 2) + _height];
			_relPos = _target worldToModel _plnPos;
			if ((_relPos select 2) < 1) then {_relPos set [2,1]};
			if ((_relPos select 2) < 2) then 
				{
				if (_target in Vehicles) then
					{
					_relPos set [2,2]
					}
				}
			}
		else
			{
			_relPos = RydSC_RelPos select (floor (random (count RydSC_RelPos)));
			_plnPos = _target modelToWorld _relPos;
			}
		};
		
	if (true) then
		{
		if ((_plnPos distance _target) < 20) then 
			{
			_tPos = getPosASL _target;
			_tPos = [(_tPos select 0),(_tPos select 1),(_tPos select 2) + 1.5];
			_plnPos = [(_plnPos select 0),(_plnPos select 1),(getTerrainHeightASL [(_plnPos select 0),(_plnPos select 1)]) + 1.5];
			_ct = 1;

			while {(not ([_plnPos,_tPos,_cam,_target] call RYD_CAM_LOSCheck) and not ((_plnPos distance _target) >= 20))} do
				{
				_relPos = RydSC_RelPos select (floor (random (count RydSC_RelPos)));
				_plnPos = _target modelToWorld _relPos;
				_plnPos = [(_plnPos select 0),(_plnPos select 1),(getTerrainHeightASL [(_plnPos select 0),(_plnPos select 1)]) + 1.5];
				if (_ct > 20) exitWith {};
				_ct = _ct + 1
				};
			};
		};
				
	if (_target in Vehicles) then 
		{
		_vx = _relPos select 0;
		_vy = _relPos select 1;
		_vz = (_relPos select 2)/2;
		_ct = 0;

		_size = (sizeOf (typeOf _target))/2.5;

			{
			_ab = _x;
			if ((abs _x) < 10) then 
				{
				if (_ct == 2) then
					{
					_ab = _size * _x * 1.2;
					if (_ab < 2) then {_ab = 2}
					}
				else
					{
					_ab = (_size * 1.1) * _x
					};
				};

			_relPos set [_ct,_ab];
			_ct = _ct + 1
			}
		foreach [_vx,_vy,_vz];
		};

	[_cam,_target,_relPos,_speed,50,true] call RYD_CAM_MoveCamRel;
	};
		
RYD_CAM_RandomAroundMM = 
	{//based on Muzzleflash' function
	private ["_pos","_xPos","_yPos","_a","_b","_dir","_angle","_mag","_nX","_nY","_temp"];

	_pos = _this select 0;
	_a = _this select 1;
	_b = _this select 2;

	_xPos = _pos select 0;
	_yPos = _pos select 1;

	_dir = random 360;

	_mag = _a + (sqrt ((random _b) * _b));
	_nX = _mag * (sin _dir);
	_nY = _mag * (cos _dir);

	_pos = [_xPos + _nX, _yPos + _nY,0];  

	_pos	
	};
	
RYD_CAM_AngTowards = 
	{
	private ["_source0", "_target0", "_rnd0","_dX0","_dY0","_angleAzimuth0"];

	_source0 = _this select 0;
	_target0 = _this select 1;
	_rnd0 = _this select 2;

	_dX0 = (_target0 select 0) - (_source0 select 0);
	_dY0 = (_target0 select 1) - (_source0 select 1);

	_angleAzimuth0 = (_dX0 atan2 _dY0) + (random (2 * _rnd0)) - _rnd0;
	
	if (_angleAzimuth0 < 0) then {_angleAzimuth0 = _angleAzimuth0 + 360};

	_angleAzimuth0
	};
	
RYD_CAM_PosTowards2D = 
	{
	private ["_source","_distT","_angle","_dXb","_dYb","_px","_py"];

	_source = _this select 0;
	_angle = _this select 1;
	_distT = _this select 2;

	_dXb = _distT * (sin _angle);
	_dYb = _distT * (cos _angle);

	_px = (_source select 0) + _dXb;
	_py = (_source select 1) + _dYb;

	[_px,_py,0]
	};
		
RYD_PosTowards3D = 
	{
	private ["_pos","_angleH","_angleV","_distT","_sx","_sy","_sz","_tPos","_tx","_ty","_tz","_sPos","_dZ","_dist3D","_dXb","_dYb","_dZb","_px","_py","_pz"];

	_pos = _this select 0;//ASL
	_angleH = _this select 1;
	_angleV = _this select 2;
	_distT = _this select 3;
	_dist3D = _this select 4;

	_sx = _pos select 0;
	_sy = _pos select 1;
	_sz = _pos select 2;

	_tPos = [_pos,_angleH,_distT] call RYD_CAM_PosTowards2D;
	_tx = _tPos select 0;
	_ty = _tPos select 1;

	_tPos = [_tx,_ty];
	_tz = (getTerrainHeightASL _tPos);

	_sPos = [_sx,_sy];

	_dZ = _tz - _sz;

	_dXb = _distT * (sin _angleH);
	_dYb = _distT * (cos _angleH);
	_dZb = _dist3D * (sin _angleV);

	_px = (_pos select 0) + _dXb;
	_py = (_pos select 1) + _dYb;
	_pz = _dZb - _dZ;

	[_px,_py,_pz]//AGL
	};		
		
RYD_CAM_Shake = 
	{
	_obj = _this select 0;
	_tgt = _this select 1;
	_cam = _this select 2;
	
	addCamShake [10, 1, 25];
	
	if (true) exitWith {};
	
	sleep 0.001;
	
	detach _obj;
	_obj setPosATL (getPosATL _tgt);
	
	_ct = 1;
	_final = [];
	_wasShake = false;
	
	while {not ((isNull _obj) or (isNull _tgt) or (isNull _cam))} do
		{
		_tgt = vehicle _tgt;
		_cDst = _cam distance _tgt;
		_pos = getPosATL _tgt;
		_oPos = getPosATL _obj;
		_speedF = (1 + ((sqrt (abs (speed _tgt)))/1.5));
	
		_dst = 0.02 * _cDst * _speedF * (0.75 + (random 0.5));
		
		_newPos = _pos;

		_chance = (((sqrt (1 + ((abs (speed _tgt)) * 10))) + (_cDst/10) + (_oPos distance _newPos))/100) * _ct * 1.5;
				
		if (_chance < 0.1) then {_chance = 0.1};
		if (_chance > 0.9) then {_chance = 0.9};

		_shakeIt = ((random 1) < _chance);
		_wasShake = false;

		if (_shakeIt) then
			{
			_wasShake = true;
			if (_ct > 0.05) then {_ct = _ct * 0.95};
			if (_ct < 0.5) then
				{
				if ((random 1) > 0.95) then
					{
					_ct = _ct * (1 + (random 1))
					}
				};
			
			_slp = 0.003;
			
			if (_tgt isKindOf "Air") then
				{
				if (_speedF > 1.1) then
					{
					_slp = 0.002
					}
				};
				
			_tgtPos = getPosASL _tgt;
			_camPos = getPosASL _cam;
				
			_dX = (_tgtPos select 0) - (_camPos select 0);
			_dY = (_tgtPos select 1) - (_camPos select 1);
			_dZ = ((_tgtPos select 2) + 1.5) - (_camPos select 2);
			_2D = sqrt ((_dX^2) + (_dY^2));
			
			_speedF = sqrt (_speedF * 10);
			if (_speedF > 9) then {_speedF = 9};

			_angleV = (_dZ atan2 _2D) + (random (2 * _speedF)) - _speedF;
			_angleH = (_dX atan2 _dY) + (random (2 * _speedF)) - _speedF;
	
			_baseDst = [_camPos select 0,_camPos select 1] distance [_tgtPos select 0,_tgtPos select 1];
			
			_newPos = [_camPos,_angleH,_angleV,_baseDst,_camPos distance _tgtPos] call RYD_PosTowards3D;
			
			_oPos = getPosATL _obj;
			
			_nRel = _tgt worldToModel _newPos;
			_oRel = _tgt worldToModel _oPos;

			if ((count _final) > 0) then {_oRel = _final};
												
			_dst = _oPos distance _newPos;
			_midRel = _final;

			if (_dst > 0.35) then
				{
				_dX = (_nRel select 0) - (_oRel select 0);
				_dY = (_nRel select 1) - (_oRel select 1);
				_dZ = (_nRel select 2) - (_oRel select 2);

				_nr = 30 + (floor (random 20));

				_stepX0 = (_dX/_nr) * 4;
				_stepY0 = (_dY/_nr) * 4;
				_stepZ0 = (_dZ/_nr) * 4;
				
				_sumX = 0;
				_sumY = 0;
				_sumZ = 0;
		
				for "_i" from 1 to _nr do
					{
					_midFar = ((10 * _i)/_nr);//(1 + (abs (_i - _nr)));//abs ((_nr/2) - _i);
					
					_stepX = (_stepX0/(1 + _midFar));
					_sumX = _sumX + _stepX;
					_stepY = (_stepY0/(1 + _midFar));
					_sumY = _sumY + _stepY;
					_stepZ = (_stepZ0/(1 + _midFar));
					_sumZ = _sumZ + _stepZ;

					_midRel = [(_oRel select 0) + _sumX,(_oRel select 1) + _sumY,(_oRel select 2) + _sumZ];

					_obj attachTo [_tgt,_midRel];

					sleep (_slp * (sqrt (1 + _midFar)))
					};
					
				_oPos = getPosATL _obj;
				_newPos = [(((_oPos select 0) + (_newPos select 0))/2),(((_oPos select 1) + (_newPos select 1))/2),(((_oPos select 2) + (_newPos select 2))/2)];
								
				_nRel = _tgt worldToModel _newPos;
				_oRel = _tgt worldToModel _oPos;

				_dst = _oPos distance _newPos;

				_midRel = _final;

				if (_dst > 0.175) then
					{
					_dX = (_nRel select 0) - (_oRel select 0);
					_dY = (_nRel select 1) - (_oRel select 1);
					_dZ = (_nRel select 2) - (_oRel select 2);

					_nr = 30 + (floor (random 20));

					_stepX0 = (_dX/_nr) * 4;
					_stepY0 = (_dY/_nr) * 4;
					_stepZ0 = (_dZ/_nr) * 4;
					
					_sumX = 0;
					_sumY = 0;
					_sumZ = 0;
			
					for "_i" from 1 to _nr do
						{
						_midFar = ((10 * _i)/_nr);//(1 + (abs (_i - _nr)));//abs ((_nr/2) - _i);
						
						_stepX = (_stepX0/(1 + _midFar));
						_sumX = _sumX + _stepX;
						_stepY = (_stepY0/(1 + _midFar));
						_sumY = _sumY + _stepY;
						_stepZ = (_stepZ0/(1 + _midFar));
						_sumZ = _sumZ + _stepZ;

						_midRel = [(_oRel select 0) + _sumX,(_oRel select 1) + _sumY,(_oRel select 2) + _sumZ];

						_obj attachTo [_tgt,_midRel];

						sleep (_slp * (sqrt (1 + _midFar)))
						};				
					};
				};
				
			_final = _midRel;
			};
			
		_dur = 0.001;
		
		_chance = 1;
		if (_wasShake) then {_chance = 0.1};

		if ((random 1) < (random _chance)) then
			{
			_dur = 0.05 + (random 0.2);
			};
			
		sleep _dur
		};
	};
	
RYD_CAM_Focus = 
	{
	_cam = _this select 0;
	
	_focus = 1;
	
	while {not (isNull _cam)} do
		{
		if not (isNull RYD_SCam_Observed) then
			{
			_dst = _cam distance RYD_SCam_Observed;
			_mpl = 1;
			if (RYD_SCam_Observed isKindOf "Air") then
				{
				_mpl = 2
				};
			
			if ((_dst >= (20 * _mpl)) and (RYD_Cam_isAttached)) then
				{
				if ((random 1) > 0.8) then
					{
					if ((missionNameSpace getVariable ["RYD_Cam_FOV",0.7]) == 0.7) then
						{
						_fov = (7/_dst) * _mpl;
						missionNameSpace setVariable ["RYD_Cam_FOV",_fov];
												
						_cam camSetFOV _fov;
						_cam camCommit (0.5 + (random 0.5));
						waitUntil {(camCommitted _cam)}
						}
					}
				};
			
			if (((abs (_focus - _dst)) > (_dst/50))) then
				{
				_rangeF = 0.25;

				_focus = _dst * (_rangeF + (random ((1/_rangeF) - _rangeF)));
				
				while {((abs (_focus - _dst)) > (_dst/50))} do
					{
					if (isNull _cam) exitWith {};
					if (isNull RYD_SCam_Observed) exitWith {};
					
					_dst = _cam distance RYD_SCam_Observed;
					
					_cam camSetFocus [_focus, 1.5];
					_cam camCommit (0.5 + (random 0.5));
					waitUntil {(camCommitted _cam)};
					
					_mpl = 1.25 + (random 0.25);
					if (_rangeF > 1) then {_mpl = 1/_mpl};
					
					_rangeF = _rangeF * _mpl;  
					
					_focus = _dst * (_rangeF + (random ((1/_rangeF) - _rangeF)));
					};
				};
			};
			
		sleep 0.1;	
		};
	};

RYD_CAM_MoveCamRel = 
	{
	private ["_cam","_target","_relPos","_speed","_interest","_isAttach","_last","_lastRpos","_lastPos","_lastHeight","_targetPos","_targetHeight","_refHeight",
	"_angle","_lPosATL","_tPosATL","_dst","_stepsC","_maxHeight","_finalHeight","_posStep","_actHeight","_target","_step","_shake"];

	_cam = _this select 0;
	
	_target = _this select 1;
	_relPos = _this select 2;
	_speed = _this select 3;
	_interest = 50;
				
	if ((count _this) > 4) then {_interest = _this select 4};
	_isAttach = false;
	if ((count _this) > 5) then {_isAttach = _this select 5};
	
	if (RydSC_ImmediateTrans > (random 100)) exitWith
		{
		if ((RydSC_Active) and not (RYD_Cam_SOff)) then 
			{
			10 cutText ["","BLACK OUT",0.05];
			0.04 fadeSound 0;
			};
		
		
		_last = missionNameSpace getVariable ["CamTgt",[objNull,[]]];
		_lastRpos = _last select 1;
		_last = _last select 0;
		
		sleep 0.05;
		
		if not (isNull _last) then
			{
			if not ((missionNameSpace getVariable ["RYD_Cam_FOV",0.7]) == 0.7) then
				{
				_cam camSetFOV 0.7;
				missionNameSpace setVariable ["RYD_Cam_FOV",0.7]
				};

			_cam camCommit 0;

			waitUntil {(camCommitted _cam)};
			
			sleep 0.001;
			};
		
		detach _cam;
		RYD_Cam_isAttached = false;
		
		if (RydSC_Additional) then
			{	
			terminate RYD_CamFocus_handle;
			terminate RYD_CamShake_handle
			};
			
		detach RYD_CamAnch;
		RYD_CamAnch setDir (getDir _target);
		RYD_CamAnch setPosATL [((getPosATL _target) select 0),((getPosATL _target) select 1),((getPosATL _target) select 2) + 1.5];
		RYD_CamAnch attachTo [_target,[0,0,1.5]];
		RYD_CamAnch setVariable ["RYD_attachedTo",_target];

		_cam camSetTarget RYD_CamAnch;
		_cam camSetRelPos _relPos;
		_cam camCommit 0;

		waitUntil {(camCommitted _cam)};
		
		_mapPos = (getPosATL _cam);
		_hgt = (_mapPos select 2) - ((getPosATL _target) select 2);

		if (_hgt < 1.5) then
			{
			_mapPos = [(_mapPos select 0),(_mapPos select 1),((getPosATL _target) select 2) + 1.5]
			};

		_cam attachTo [_target,(_target worldToModel _mapPos)];
		RYD_Cam_isAttached = true;
		
		if (RydSC_Additional) then
			{
			RYD_CamShake_handle = [RYD_CamAnch,_target,_cam] spawn RYD_CAM_Shake;
			RYD_CamFocus_handle = [_cam] spawn RYD_CAM_Focus
			};
			
		if ((RydSC_Active) and not (RYD_Cam_SOff)) then 
			{
			10 cutText ["","BLACK IN",0.05];
			0.04 fadeSound 1;
			};
			
		missionNameSpace setVariable ["CamTgt",[_target,_relPos]];
		};

	_last = missionNameSpace getVariable ["CamTgt",[objNull,[]]];
	_lastRpos = _last select 1;
	_last = _last select 0;
	
	_maxHeight = 0;
	_lastHeight = 0;
	_targetHeight = 0;

	if not ((isNull (_last)) or (_last == _target)) then
		{
		_lastPos = getPosASL _last;
		_lastHeight = _lastPos select 2;
		_targetPos = getPosASL _target;
		_targetHeight = _targetPos select 2;
		
		_refHeight = _lastHeight min _targetHeight;

		_angle = [_lastPos,_targetPos,0] call RYD_CAM_AngTowards;
		
		_lPosATL = getPosATL _last;
		_tPosATL = getPosATL _target;
		
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
			_posStep = [_lastPos,_angle,_dst] call RYD_CAM_PosTowards2D;
			_actHeight = getTerrainHeightASL [(_posStep select 0),(_posStep select 1)];
			if (_actHeight > _maxHeight) then
				{
				_maxHeight = _actHeight
				}
			}
		}
	else
		{
		if (isNull (_last)) then
			{
			_maxHeight = 165
			}
		};
		
	detach _cam;
	RYD_Cam_isAttached = false;
	
	if (RydSC_Additional) then
		{	
		terminate RYD_CamFocus_handle
		};

	if not (isNull _last) then
		{
		if not ((missionNameSpace getVariable ["RYD_Cam_FOV",0.7]) == 0.7) then
			{
			_cam camSetFOV 0.7;
			missionNameSpace setVariable ["RYD_Cam_FOV",0.7]
			};
		
		_cam camSetRelPos [_lastRpos select 0,_lastRpos select 1,_maxHeight - _lastHeight + RydSC_TransHeight];
		_spd = RydSC_TransHeight/35;
		if (_spd > 1) then {_spd = 1};
		if (_spd < 0.5) then {_spd = 0.5};
		_cam camCommit _spd;

		waitUntil {(camCommitted _cam)};
		
		sleep 0.001;
		};
				
	_cam camSetTarget _target;
	_cam camSetRelPos [_relPos select 0,_relPos select 1,_maxHeight - _targetHeight + RydSC_TransHeight];

	_cam camCommit _speed;

	waitUntil {(camCommitted _cam)};
	
	if (RydSC_Additional) then
		{
		terminate RYD_CamShake_handle
		};
	
	detach RYD_CamAnch;
	RYD_CamAnch setDir (getDir _target);
	RYD_CamAnch setPosATL [((getPosATL _target) select 0),((getPosATL _target) select 1),((getPosATL _target) select 2) + 1.5];
	RYD_CamAnch attachTo [_target,[0,0,1.5]];
	RYD_CamAnch setVariable ["RYD_attachedTo",_target];
		
	if (RydSC_Additional) then
		{
		RYD_CamShake_handle = [RYD_CamAnch,_target,_cam] spawn RYD_CAM_Shake
		};
			
	sleep 0.001;

	_cam camSetTarget _target;
	_cam camSetRelPos _relPos;
	_cam camCommit (_speed/5);

	waitUntil {(camCommitted _cam)};
	sleep 0.001;
	
	_cam camSetTarget RYD_CamAnch;
	_cam camSetRelPos _relPos;
	
	_cam camCommit (_speed/25);

	waitUntil {(camCommitted _cam)};
	sleep 0.001;
	
	_mapPos = (getPosATL _cam);
	_hgt = (_mapPos select 2) - ((getPosATL _target) select 2);

	if (_hgt < 1.5) then
		{
		_mapPos = [(_mapPos select 0),(_mapPos select 1),((getPosATL _target) select 2) + 1.5]
		};

	_cam attachTo [_target,(_target worldToModel _mapPos)];

	RYD_Cam_isAttached = true;
	
	if (RydSC_Additional) then
		{
		RYD_CamFocus_handle = [_cam] spawn RYD_CAM_Focus
		};

	missionNameSpace setVariable ["CamTgt",[_target,_relPos]];
	};

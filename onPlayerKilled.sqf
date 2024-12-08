oldPlayer = _this select 0;

selectPlayer dummyPlayer;

_camera = "camera" camcreate position oldPlayer;      //some camera shots for effect
_camera cameraeffect ["Internal","back"];
_camera camsetPos position oldPlayer;
_camera camsetTarget position oldPlayer;
_camera CamCommit 0;
_cou = 0;
//titletext ["","black in",1];
_0 = [] spawn 
{
	sleep 1;
	//titleText ["","black out", 2];
};
while {_cou < 100} do {
	_camera camSetPos [(position oldPlayer select 0)+10, position oldPlayer select 1,_cou / 10];
	_camera camcommit 0;
	_cou = _cou + 1;
	sleep 0.01;
};
//1 fadeSound 1;	titletext ["","black in",1];
_camera cameraeffect ["terminate","back"];          //stop using custom camera
_camera camcommit 0;
camdestroy _camera;

_pool = switchableUnits;

{
	switch (true) do
	{
		case (isNil {_x}) : {_pool set [_foreachIndex,0]};
		case not ((typeName _x) in [typename objNull]) : {_pool set [_foreachIndex,0]};
		case (isNull _x) : {_pool set [_foreachIndex,0]};
		case not (alive _x) : {_pool set [_foreachIndex,0]};
	}
} foreach _pool;
_pool = _pool - [0,oldPlayer];

_squadPool = units oldPlayer;
{
	switch (true) do
	{
		case (isNil {_x}) : {_squadPool set [_foreachIndex,0]};
		case not ((typeName _x) in [typename objNull]) : {_squadPool set [_foreachIndex,0]};
		case (isNull _x) : {_squadPool set [_foreachIndex,0]};
		case not (alive _x) : {_squadPool set [_foreachIndex,0]};
	}
} foreach _squadPool;
_squadPool = _squadPool - [0,oldPlayer];

if ((count _squadPool) > 0) then
{
	_pool = _squadPool;
};
if ((count _pool) > 0) then
{
	selectPlayer (_pool select (floor (random (count _pool))));
	player switchcamera "internal";
}
else
{
	EnableEndDialog;
}
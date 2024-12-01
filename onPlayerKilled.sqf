_pool = +RYD_WS_ForcesA;

	{
	switch (true) do
		{
		case (isNil {_x}) : {_pool set [_foreachIndex,0]};
		case not ((typeName _x) in [typename objNull]) : {_pool set [_foreachIndex,0]};
		case (isNull _x) : {_pool set [_foreachIndex,0]};
		case not (alive _x) : {_pool set [_foreachIndex,0]};
		}
	}
	
foreach _pool;
	
_pool = _pool - [0,player];
	
if ((count _pool) > 0) then
{
	selectPlayer (_pool select (floor (random (count _pool))));
}
else
{
	EnableEndDialog;
}
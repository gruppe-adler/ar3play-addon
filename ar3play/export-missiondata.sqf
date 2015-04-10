private "_getUnitData";

_logscript = compile preprocessFileLineNumbers "\ar3play\vendor\sock-rpc\log.sqf";
call _logscript;

_sockscript = compile preprocessFileLineNumbers "\ar3play\vendor\sock-rpc\sock.sqf";
call _sockscript;

_getUnitData = compile preprocessFileLineNumbers "\ar3play\getUnitData.sqf";

diag_log "ar3play: loaded. start pinging sock_rpc...";

[] spawn {
	while {true} do {
		['echo', ['keep-alive']] call sock_rpc;
		sleep 20;
	};
};

['echo', ['keep-alive']] call sock_rpc;

if (isDedicated) then {

	addMissionEventHandler ["Ended", {
		['missionEnd', []] call sock_rpc;
	}];

	waitUntil { count allUnits > 0 };

	['missionStart', [missionName, worldName]] call sock_rpc;

	['setIsStreamable', [IS_STREAMABLE]] call sock_rpc;

	[_getUnitData] spawn {
		private "_getUnitData";
		_getUnitData = _this select 0;

		while {(count allUnits > 0) and (ENABLE_REPLAY)} do {
			_unitsDataArray = [];
			{
				if ((side _x != sideLogic) && (_x isKindOf "AllVehicles")) then {
					_unitsDataArray pushBack ([_x] call _getUnitData);
				};
			} forEach allUnits + allDead + vehicles;


			['setAllUnitData', [_unitsDataArray]] call sock_rpc;
			sleep 1;
		};
	};
};

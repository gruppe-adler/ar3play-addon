#include "init.hpp"

private "_getUnitData";
private "_arePlayersConnected";
private "_sendDataLoop";
private "_echoLoop";

_logscript = compile preprocessFileLineNumbers "\ar3play\vendor\sock-rpc\log.sqf";
call _logscript;

_sockscript = compile preprocessFileLineNumbers "\ar3play\vendor\sock-rpc\sock.sqf";
call _sockscript;

_getUnitData = compile preprocessFileLineNumbers "\ar3play\getUnitData.sqf";

_arePlayersConnected = {
	private ["_result", "_now"];
	_result = ({isPlayer _x} count playableUnits) > 0;
	if (_result) then {
		AR3PLAY_MOST_RECENT_PLAYER_DETECTED = time;
	} else {
		_result = AR3PLAY_MOST_RECENT_PLAYER_DETECTED > (time - AR3PLAY_TIMEOUT_PLAYERS);
	};
	 _result
};

_sendDataLoop = {
	private "_getUnitData";
	private "_arePlayersConnected";

	_getUnitData = _this select 0;
	_arePlayersConnected = _this select 1;

	while {(call _arePlayersConnected) && (AR3PLAY_ENABLE_REPLAY)} do {
		_unitsDataArray = [];
		{
			if ((side _x != sideLogic) && (_x isKindOf "AllVehicles")) then {
				_unitData = [_x] call _getUnitData;
				if ((_unitData select 7) != "iconObject_1x1") then {
					_unitsDataArray pushBack _unitData;
				};
			};
		} forEach allUnits + allDead + vehicles;


		['setAllUnitData', [_unitsDataArray]] call sock_rpc;
		sleep 1;
	};
	['missionEnd', ['replay disabled or players left']] call sock_rpc;
};

//--------------------------------------------------------------

LOG("ar3play: loaded. waiting for mission start...");

if (isDedicated) then {

	addMissionEventHandler ["Ended", {
		LOG("ar3play: mission ended. stopping updates, sending endMission.");
		AR3PLAY_ENABLE_REPLAY = false;
		sleep 2;
		['missionEnd', ['mission ended event']] call sock_rpc;
	}];

	waitUntil {time > 0};

	LOG("ar3play: mission has been started. starting to send updates...");

	['missionStart', [missionName, worldName]] call sock_rpc;
	['setIsStreamable', [AR3PLAY_IS_STREAMABLE]] call sock_rpc;
	[_getUnitData, _arePlayersConnected] spawn _sendDataLoop;
};

if (isNil "ENABLE_REPLAY") then {
	ENABLE_REPLAY = true;
};
if (isNil "IS_STREAMABLE") then {
	IS_STREAMABLE = true;
};

waitUntil {isDedicated || {not(isNull player)}};

SYSTEM_LOG_LEVEL = 0;
AR3PLAY_NEXTID = 1;

execVM "\ar3play\export-missiondata.sqf";

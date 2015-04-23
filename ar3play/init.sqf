if (isNil "AR3PLAY_ENABLE_REPLAY") then {
	AR3PLAY_ENABLE_REPLAY = true;
};
if (isNil "AR3PLAY_IS_STREAMABLE") then {
	AR3PLAY_IS_STREAMABLE = false;
};
if (isNil "AR3PLAY_TIMEOUT_PLAYERS") then {
	AR3PLAY_TIMEOUT_PLAYERS = 60;
};

waitUntil {isDedicated || {not(isNull player)}};

SYSTEM_LOG_LEVEL = 0;
AR3PLAY_NEXTID = 1;
AR3PLAY_MOST_RECENT_PLAYER_DETECTED = 0;

if (AR3PLAY_ENABLE_REPLAY) then {
	execVM "\ar3play\export-missiondata.sqf";
};

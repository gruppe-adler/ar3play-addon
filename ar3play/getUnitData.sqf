private [
	'_unit',
	'_objectId',
	'_pos',
	'_dir',
	'_side',
	'_icon',
	'_container',
	'_contents',
	'_name',
	'_health',
	'_vehicletype',
	'_getObjectId',
	'_getContainerObjectId',
	'_getHealth'
];


_getObjectId = {
	private ['_objectId'];

	_objectId = _this getVariable ['ar3play_id', 0];
	if (_objectId == 0) then {
		_objectId = AR3PLAY_NEXTID;
		_this setVariable ['ar3play_id', _objectId];
		AR3PLAY_NEXTID = AR3PLAY_NEXTID + 1;
	};

	_objectId
};

_getContainerObjectId = {
	private ['_container', '_containerObjectId'];

	_container = vehicle _this;
	_containerObjectId = 0;
	if (_container != _this) then {
		_containerObjectId = _container call _getObjectId;
	};

	_containerObjectId
};

_getHealth = {
	private ['_health'];

	_health = 'dead';
	if (alive _this) then {
		if (_this getVariable ["AGM_isUnconscious", false]) then {
			_health = 'unconscious';
		} else {
			_health = 'alive';
		};
	};

	_health
};

_getName = {
	private ['_name'];

	_name = '';
	if (alive _this) then {
		_name = name _this;
	};

	_name
};

_getContentsObjectIds = {
	private ['_contentsObjectIds'];

	_contentsObjectIds = [];
	{
		if (_x != _this) then {
			_contentsObjectIds pushBack (_x call _getObjectId);
		};
	} forEach (crew _this);

	_contentsObjectIds
};

_unit = _this select 0;

_objectId = _unit call _getObjectId;
_pos = getPosATL _unit;
_dir = getDir _unit;
_side  = format ["%1", side _unit];
_health = _unit call _getHealth;
_icon = getText(configFile >> "CfgVehicles" >> typeOf _unit >> "icon");
_name = _unit call _getName;
_container = _unit call _getContainerObjectId;
_contents = _unit call _getContentsObjectIds;

[
	_objectId,
	(_pos select 0),
	(_pos select 1),
	(_pos select 2),
	_dir,
	_side,
	_health,
	_icon,
	_name,
	_container,
	_contents
]


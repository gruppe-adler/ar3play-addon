class CfgPatches
{
	class ar3play
	{
		units[] = { };
		weapons[] = { };
		requiredVersion = 0.100000;
		requiredAddons[] = {"CBA_Extended_EventHandlers"};
		version = "2";
		projectName = "ar3play";
		author[] = {
			"Fusselwurm <fusselwurm@gmail.com>",
			"ZiP"
		};
		authorUrl = "https://github.com/gruppe-adler/ar3play-addon";
	};
};

class Extended_PostInit_EventHandlers
{
	class ar3play
	{
		Init = "call compile preprocessFileLineNumbers '\ar3play\init.sqf'";
	};
};

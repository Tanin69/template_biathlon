/* 

Convertit des secondes en heures-minutes-secondes
En entrée : un nombre de secondes (entier)
Renvoie une chaîne de caractères au format "HH:MM:SS";

Sinon,  BIS_fnc_secondsToString, ça existe aussi :-(

Bon, finalement, ma fonction n'est pas si mal par rapport
à celle de Bohemia :-)
A3\functions_f\Strings\fn_secondsToString.sqf

*/

params["_secondesConv"];

padString = {
	_str = "";
	if (_this < 10) then {
		if (_this == 0) then {
			_str = "00";
		} else {
			_str = "0" + str _this;
		};
	} else {
		_str = str _this;
	};
	_str
};

//Convertit les secondes en heures et minutes (entiers), puis en chaine paddée avec des 0
_heures = floor(_secondesConv / 3600);
_strHeures = _heures call padString;
_tmp = _secondesConv % 3600;
_minutes = floor(_tmp / 60);
_strMinutes = _minutes call padString;
_secondes = _tmp % 60;
_strSecondes = _secondes call padString;

_strHMS = _strHeures + ":" + _strMinutes + ":" + _strSecondes;

_strHMS
/* convertit une heure au format daytime en secondes */
params ["_heureDayTime"];

_heures = floor _heureDayTime;
_minutes = floor ((_heureDayTime - _heures) * 60);
_secondes = floor (((((_heureDayTime) - (_heures))*60) - _minutes)*60);
_total_secondes = (_heures * 3600) + (_minutes *60) + _secondes;

_total_secondes

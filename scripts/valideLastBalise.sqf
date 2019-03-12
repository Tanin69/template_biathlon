// Déclenche la validation de la dernière balise par un joueur. Doit être déclenché par le addAction de la dernière balise.

private _balise = _this select 0;
private _joueur = _this select 1;
private _groupeJoueur = group _joueur;

chronoServeur = 0;

_balise removeAction 1;

//Enregistre la validation de balise sur le serveur
[["valideBalise",_balise,true],_joueur,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];

//Enregistre l'événement localement
waitUntil {chronoServeur > 0};
tableauPassagesJoueur pushBack [_balise,chronoServeur];
["FinCourse", player, ["Dernière balise (" + str _balise + ") validée à " + (chronoServeur call BIS_fnc_timeToString), "Valider la dernière balise"],[], "SUCCEEDED", 0, true, false, "", false] call BIS_fnc_setTask;




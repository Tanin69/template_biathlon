/*

Déclenche le chrono de la partie
Appelé par un addAction sur un objet réservé au GM et au GM assistant

this addAction ["Donner le top départ", "scripts\topChrono.sqf",nil,1.5,true,true,"","(vehicleVarName _this) == 'gm' || (vehicleVarName _this) == 'gm_a'",5,false,"",""];
this addAction ["Calculer le score des équipes", "scripts\calculeScores.sqf",nil,1.5,true,true,"","(vehicleVarName _this) == 'gm' || (vehicleVarName _this) == 'gm_a'",5,false,"",""];

*/

//Lance le top départ à partir de l'heure du serveur
[group player] remoteExecCall ["fn_topChrono",2];

//Assigne à tous les joueurs automatiquement l'objectif de départ sur la balise de départ -> non utilisé dans cette mission
//remoteExec ["fn_assigneBalDep"];

/* 

Valide le tir du joueur si la cible est touchée.
Appelé par l'event handler "hitPart" de la cible
_this contient les paramètres de l'EH hitPart

this addEventHandler ["hitPart", {_this execVM "scripts\valideTir.sqf"}];

*/

private _cibleTouchee = (_this select 0) select 0;
private _joueur = (_this select 0) select 1;
private _groupeJoueur = group(_joueur);


if (topChrono > 0) then {
	// Si le joueur est sur une position de tir autorisée, on enregistre le tir (côté serveur)... 
	{
		if (player inArea _x) then {
			[["valideCible",_cibleTouchee,false],_joueur,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];
		};
	} forEach tableauPosTir;
} else {
	hint "Le Top Départ n'a pas été donné !";
};
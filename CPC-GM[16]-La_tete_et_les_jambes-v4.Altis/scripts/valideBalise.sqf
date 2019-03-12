/*

Déclenche la validation d'une balise par un joueur. Doit être déclenché par un addAction sur une balise.

this addAction["Valider la balise", "scripts\valideBalise.sqf",nil,1.5,true,true,"","",2,false,"",""];

*/

private _balise = _this select 0;
private _joueur = _this select 1;
private _groupeJoueur = group(_this select 1);
chronoServeur = 0;

if (topChrono > 0) then {

	//Supprime le addAction de la balise pour éviter les validations multiples par les maladroits ou les malhonnêtes (et ceux qui cumulent les deux traits)
	_balise removeAction 0;

	//Déclenche l'enregistrement serveur et le broadcast du temps serveur vers ce client
	//DBG! systemChat format["valeurs envoyées:%1, %2, %3",["valideBalise",_balise,false],_joueur,_groupeJoueur];
	[["valideBalise",_balise,false],_joueur,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];
	
	//Enregistre le passage en local au client.
	waitUntil {chronoServeur > 0};
	tableauPassagesJoueur pushBack [_balise,chronoServeur];
	
	//Si c'est la première balise qui est validée, on enregistre la balise de départ
	if (count tableauPassagesJoueur == 1) then {baliseDepart = _balise};

	//Si c'est la (l'avant-) dernière balise du parcours, on ajoute un objectif pour valider à nouveau la première balise et une action sur la balise (balise de départ/arrivée)
	if ((count tableauPassagesJoueur) == (count tableauBalises)) then {
		_description = ["Pour valider une balise, faites une action molette à proximité immédiate d'icelle","Valider la dernière balise (" +  str baliseDepart + ")"];
		if (masquePosBalises == 0) then {_destination = getPos _x;} else {_destination = []};
		["FinCourse", player, _description, _destination, "CREATED", 0, true, false, "", false] call BIS_fnc_setTask;
		baliseDepart addAction["<t color='#bc230f'>Valider la dernière balise</t>", "scripts\valideLastBalise.sqf",nil,1.5,true,true,"","",2,false,"",""];
	};
	
	//Valide l'objectif (task) localement
    [str _balise, player, ["Balise validée à " + (chronoServeur call BIS_fnc_timeToString), "Valider la balise " + str _balise],[], "SUCCEEDED", 0, true, false, "", false] call BIS_fnc_setTask;

} else {
	hint "Le Top Départ n'a pas été donné !";
};

//DBG!
//systemChat ("CLI : " + " chronoServeur=" + str chronoServeur + " / _cliID=" + str _cliID + " / _balise=" + str _balise + " / _groupeJoueur=" + str _groupeJoueur + " / _joueur=" + str _joueur);
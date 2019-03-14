/*

Déclenche la validation d'une balise par un joueur. Doit être déclenché par un addAction sur une balise.

this addAction["Valider la balise", "scripts\valideBalise.sqf",nil,1.5,true,true,"","",2,false,"",""];

*/

private _balise       = _this select 0;
private _joueur       = _this select 1;
private _groupeJoueur = group(_this select 1);
private _baliseFin    = "";
chronoServeur         = 0;

//Ajoute un objectif (task) et une action sur la balise de fin
defBaliseFin = {
	params ["_balFin"];
	_description = ["Pour valider une balise, faites une action molette à proximité immédiate d'icelle","Valider la dernière balise (" +  str _balFin + ")"];
	if (masquePosBalises == 0) then {_destination = getPos _x;} else {_destination = []};
	["FinCourse", player, _description, _destination, "CREATED", 0, true, false, "", false] call BIS_fnc_setTask;
	_balFin addAction["<t color='#bc230f'>Valider la dernière balise</t>", "scripts\valideLastBalise.sqf",nil,1.5,true,true,"","",2,false,"",""];
};

if (topChrono > 0) then {

	//Supprime le addAction de la balise pour éviter les validations multiples par les maladroits ou les malhonnêtes (et ceux qui cumulent les deux traits)
	_balise removeAction 0;

	//Déclenche l'enregistrement serveur et le broadcast du temps serveur vers ce client
	//DBG! systemChat format["valeurs envoyées:%1, %2, %3",["valideBalise",_balise,false],_joueur,_groupeJoueur];
	[["valideBalise",_balise,false],_joueur,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];
	waitUntil {chronoServeur > 0};
	tableauPassagesJoueur pushBack _balise;

	//On est dans une course en boucle : la première balise validée doit être revalidée pour boucler le chrono
	if (courseEnBoucle == 1) then {
		//Si c'est la première balise qui est validée, on enregistre la balise de départ
		if (count tableauPassagesJoueur == 1) then {_baliseFin = _balise};
		//Si c'est l'avant-dernière balise du parcours, on paramètre la balise de fin
		if ((count tableauPassagesJoueur) == (count tableauBalises)) then {
			[_baliseFin] call defBaliseFin;
		};
	//On est dans le cas où la fin de course est la validation de la dernière balise
	} else {
		if (count tableauPassagesJoueur == (count tableauBalises) -1)  then {
			//On trouve la dernière balise
			_baliseFin = (tableauBalises - tableauPassagesJoueur) select 0;
			//On supprime l'action de validation "simple" de la dernière balise (ajoutée à toutes les balises lors de l'initialsiation)
			_baliseFin removeAction 0;
			//On paramètre la balise de fin
			[_baliseFin] call defBaliseFin;
		}
	};
	
	//Valide l'objectif (task) localement
    [str _balise, player, ["Balise validée à " + (chronoServeur call BIS_fnc_timeToString), "Valider la balise " + str _balise],[], "SUCCEEDED", 0, true, false, "", false] call BIS_fnc_setTask;

} else {
	hint "Le Top Départ n'a pas été donné !";
};

//DBG!
//systemChat ("CLI : " + " chronoServeur=" + str chronoServeur + " / _cliID=" + str _cliID + " / _balise=" + str _balise + " / _groupeJoueur=" + str _groupeJoueur + " / _joueur=" + str _joueur);
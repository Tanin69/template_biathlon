/*

Récupère les informations sur les événements de course 
et les affiches dans le diary, section Tasks :
- Temps de passage aux différentes balises
- Résultats des tirs
- Pénalités
- Stats de tir

*/

hint "Récupération des infos course en cours...";

//On initialise localement le tableau d'info course
//pour s'assurer qu'on ne le traite qu'une fois reçues du serveur
tableauEvenCourse = 0;

//Récupère les infos course sur le serveur
_cliID = clientOwner;
[
 ([_cliID]),
 {
   params["_cliID"];
   _cliID publicVariableClient "tableauEvenCourse";
 }
] 
remoteExec ["call", 2];

waitUntil {(typename tableauEvenCourse isEqualTo "ARRAY")};

private _tbEven = [tableauEvenCourse, [], {_x}, "DESCEND"] call BIS_fnc_sortBy;
private _strTempsPassage = "";
private _strLigne = "";
private _tbPassages = [];
private _strAffichePassages = "";
private _tbCibles = [];
private _strAfficheCibles = "";
private _tbPenals = [];
private _strAffichePenals = "";
private _nbCartouches = 0;
private _nbCiblesValidees = 0;
private _equipe = "";
private _efficaciteTir = 0;
private _tbStats = [];
private _strAfficheStats = "";

{
	_strTempsPassage = (_x select 3) call BIS_fnc_timeToString;
	
	//Lit et met en forme les infos sur les validations de balise
	if (((_x select 0) select 0) isEqualTo "valideBalise") then {
		_strLigne = format ["%1: <font color='#FFFFBB'>équipe %4</font> - balise <font color='#FFFFBB'>%2</font> validée par <font color='#FFFFBB'>%3</font>", _strTempsPassage, str ((_x select 0) select 1), name (_x select 1), groupID (_x select 2)];
		_tbPassages pushBack _strLigne;
	};

	//Lit et met en forme les infos sur les cibles
	if (((_x select 0) select 0) isEqualTo "valideCible") then {		
		_strLigne = format ["%1: <font color='#FFFFBB'>équipe %4</font> - cible <font color='#FFFFBB'>%2</font> validée par <font color='#FFFFBB'>%3</font>", _strTempsPassage, str ((_x select 0) select 1), name (_x select 1), groupID (_x select 2)];
		_tbCibles pushBack _strLigne;
	};

	//Lit et met en forme les infos sur les pénalités
	if (((_x select 0) select 0) isEqualTo "enregPenal") then {		
		_strLigne = format ["%1: <font color='#FFFFBB'>équipe %4</font> - pénalité <font color='#FFFFBB'>%2</font> reçue par <font color='#FFFFBB'>%3</font>", _strTempsPassage, str ((_x select 0) select 1), name (_x select 1), groupID (_x select 2)];
		_tbPenals pushBack _strLigne;
	};
	
} forEach _tbEven;

//Ajoute les infos balises, cibles et pénalités dans le diary
_strAffichePassages = _tbPassages joinString "<br />";
[player, ["tPas"], [_strAffichePassages,"Passages",""], objNull, "CREATED", 0, false, "", false] call BIS_fnc_taskCreate;
_strAfficheCibles = _tbCibles joinString "<br />";
[player, ["tCib"], [_strAfficheCibles,"Cibles",""], objNull, "CREATED", 0, false, "", false] call BIS_fnc_taskCreate;
_strAffichePenals = _tbPenals joinString "<br />";
[player, ["tPen"], [_strAffichePenals,"Pénalités",""], objNull, "CREATED", 0, false, "", false] call BIS_fnc_taskCreate;


//Calcule les statistiques de tir pour chaque équipe
{
	
	_efficaciteTir = 0;
	_equipe = _x;
	_nbCartouches = {(_x select 2 isEqualTo _equipe) && (((_x select 0) select 0) isEqualTo "enregTir")} count tableauEvenCourse;
	_nbCiblesValidees = {((_x select 2) isEqualTo _equipe) && (((_x select 0) select 0) isEqualTo "valideCible")} count tableauEvenCourse;
	if ((_nbCiblesValidees)>0) then {_efficaciteTir = (((_nbCiblesValidees / _nbCartouches)*100) toFixed 2)+"%"};
	_strLigne = format ["<font color='#FFFFBB'>Equipe %1</font> - efficacité de tir: <font color='#FFFFBB'>%2</font> (<font color='#FFFFBB'>%3</font> cartouche(s), <font color='#FFFFBB'>%4</font> succès)",groupId(_equipe),_efficaciteTir,_nbCartouches,_nbCiblesValidees];
	_tbStats pushBack _strLigne;

} forEach allGroups;

//Ajoute les stats dans le diary
_strAfficheStats = _tbStats joinString "<br /><br />";
[player, ["tSta"], [_strAfficheStats,"Stats de tir",""], objNull, "CREATED", 0, false, "", false] call BIS_fnc_taskCreate;

hint "Infos course récupérées. Consultez votre journal (section Tasks)";
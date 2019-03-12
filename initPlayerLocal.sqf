/*
 * Initialisation des scripts, fonctions et variables locales aux clients (joueurs).
 * Tous les paramètres de configuration sont dans le fichier description.ext,
 * il n'y a rien à modifier ici pour le créateur de mission.
*/

/*
Récupération des variables de configuration à partir du description.ext
Les variables sont documentées dans le description.ext
*/
	objCmdGm                   = ["objCmdGm"] call BIS_fnc_getCfgDataObject;
	private _objGm             = ["objGm"] call BIS_fnc_getCfgDataObject;
	private _objGmA            = ["objGmA"] call BIS_fnc_getCfgDataObject;
	private _gmTeleporte       = getMissionConfigValue "gmTeleporte";
	private _gmParticipe       = getMissionConfigValue "gmParticipe";
	private _gmVoitUnites      = getMissionConfigValue "gmVoitUnites";
	private _clsBalise         = getMissionConfigValue "clsBalise";
	private _clsCible          = getMissionConfigValue "clsCible";
	private _clsCibleIA        = getMissionConfigValue "clsCibleIA";
	private _nbCartouches      = getMissionConfigValue "numCartouches";
	masquePosBalises           = getMissionConfigValue "masquePosBalises";
	private _markerBalisesAuto = getMissionConfigValue "markerBalisesAuto";
	private _markerPosTirAuto  = getMissionConfigValue "markerBalisesAuto";
	

/*
scripts excutés sur le client (joueur).
*/
	valideBalise = compile preprocessFile "scripts\valideBalise.sqf";
	valideTir    = compile preprocessFile "scripts\valideTir.sqf";
	verifTir     = compile preprocessFile "scripts\verifTir.sqf";
	penalTirAmi  = compile preprocessFile "scripts\penalTirAmi.sqf";
	metMenottes  = compile preprocessFile "scripts\metMenottes.sqf";
	QS_icons     = compile preprocessFile "scripts\QS_icons.sqf";

/*
Initialisation des variables côté client (joueur)
*/
	//la valeur du chrono est toujours initialisée sur le serveur
	chronoServeur = 0;
	//Tableau des balises à valider. Ce tableau est local pour tous les joueurs
	tableauBalises = allMissionObjects (_clsBalise);
	//Tableau des cibles
	private _tbCibles = [];
	if (_clsCibleIA == 1) then {
		_tbCibles = entities [[_clsCible],[]];}
	else {
		_tbCibles = allMissionObjects (_clsCible);
	};
	
//Ajoute des marqueurs sur les positions des balises si l'option est activée
if (_markerBalisesAuto == 1) then {
	{
		_nomMarker = "mkrBal" + str _x;
		createMarker [_nomMarker, getPos _x];
		_nomMarker setMarkerType "mil_objective";
		_nomMarker setMarkerText " Balise " + str _x;
		_nomMarker setMarkerColor "ColorBlue";
		 
	} forEach tableauBalises
};

//Ajoute des marqueurs sur les positions des tir si l'option est activée
if (_markerPosTirAuto == 1) then {
	{
		_nomMarker = "mkrPosTir" + str _x;
		createMarker [_nomMarker, getPos _x];
		_nomMarker setMarkerType "mil_dot";
		_nomMarker setMarkerText " Pas de tir";
		_nomMarker setMarkerColor "ColorRed";
		 
	} forEach tableauPosTir
};

//Initialisation de l'environnement pour les joueurs
_initJoueur = 
{
	params ["_nbCartouches","_clsBalise","_clsCible","_tbCibles"];
	
	//EH pour le contrôle des tirs
	player addEventHandler ["Fired", { _this call verifTir}];
	player addEventHandler ["HandleDamage", {_this call penalTirAmi}];

	//Nombre de cartouches chargées dans l'arme principale
	player setAmmo [primaryWeapon player, _nbCartouches];
	
	//Initialisation des variables globales (sur le client)
	tableauPassagesJoueur = [];
	baliseDepart = nil;

	//Tableau des balises à valider. Ce tableau est local pour tous les joueurs
	tableauBalises = allMissionObjects (_clsBalise);
	//DBG! tableauBalises = [Orga,Orga_1];
	
	//Créé les taches de validation des balises dans le diary et ajoute les addAction aux balises
	private _description = "";
	private _destination = "";
	{ 
		_description = ["Pour valider une balise, faites une action molette à proximité immédiate d'icelle","Valider la balise " + str _x];
		if (masquePosBalises == 0) then {_destination = getPos _x;} else {_destination = []};
		[str _x, player, _description, _destination, "CREATED", 0, false, false, "", false] call BIS_fnc_setTask; 
		_x addAction["Valider la balise", "scripts\valideBalise.sqf",nil,1.5,true,true,"","",2,false,"",""];
	} forEach tableauBalises;

	//Ajoute les EH pour les cibles
	{_x addEventHandler ["hitPart", {_this call valideTir}];} forEach _tbCibles;
};

//Initalisation de l'environnement pour les joueurs de l'équipe d'organisation (appelés GM)
//NOTE : player == gm (ou gm_a) renvoie une erreur à l'exécution si le slot est fermé.
if ( if (!(isNil (str _objGm))) then {player == _objGm} else {false} || if (!(isNil str _objGmA)) then {player == _objGmA} else {false} ) then {

	//Ajoute le tracking des unités sur carte pour les GM si l'option est activée
	if (_gmVoitUnites == 1) then {[] spawn QS_icons;};
	
	//Permet aux GM de se téléporter si l'option est activée
	if (_gmTeleporte == 1) then {
		player addaction ["<t color='#892D97'>Teleportation</t>", "scripts\teleport_player.sqf",0,0,false,true,"","(_target == _this)"];
	};

	//Ajoute les addActions de gestion pour le GM et le GM Assistant.
	objCmdGm addAction ["<t color='#83d123'>Donner le top départ</t>", "scripts\topChrono.sqf",nil,1.5,true,true,"","",5,false,"",""];
	objCmdGm addAction ["Récupérer les infos courses", "scripts\recupInfosCourse.sqf",nil,1.5,true,true,"","",5,false,"",""];
	
	//On ajoute les actions accessibles aux GM sur chaque joueur (sauf les GM) : menottage/démenottage
	{ 
		if (_x != player) then {
			_x addAction ["Menotter/démenotter le joueur","scripts\metMenottes.sqf",nil,1.5,false,true,"","",5,true,"",""]
		};
	} forEach playableUnits;

	//Les GM participent également à la course
	if (_gmParticipe == 1) then {[_nbCartouches,_clsBalise,_clsCible,_tbCibles] call _initJoueur};
	
//Initalisation de l'environnement pour tous les autres joueurs
} else {
	[_nbCartouches,_clsBalise,_clsCible,_tbCibles] call _initJoueur
};

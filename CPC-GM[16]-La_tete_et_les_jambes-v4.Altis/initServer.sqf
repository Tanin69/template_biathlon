/*
 * Initialisation des scripts, fonctions et variables server only.
 * Tous les paramètres de configuration sont dans le fichier description.ext,
 * il n'y a rien à modifier ici pour le créateur de mission.
*/

/*
Récupération des variables de configuration à partir du description.ext
Les variables sont documentées dans le description.ext
*/

private _patternPosTir    = getMissionConfigValue "strPatTrg";
private _clsCible         = getMissionConfigValue "clsCible";
private _clsCibleIA       = getMissionConfigValue "clsCibleIA";
penalTirInterdit          =  getMissionConfigValue "numPenalTirInterdit";
penalCibleManquee         = getMissionConfigValue "numPenalCibleManquee";


//Fonctions d'enregistrement des temps de passage, des tirs, des pénalités, des scores finaux et diverses fonctions utilitaires.
fn_convDaytime_secondes = compile preprocessFile "scripts\fn_convDaytime_secondes.sqf";
fn_convSecondes_hms = compile preprocessFile "scripts\fn_convSecondes_hms.sqf";
fn_calculeScoreEquipe = compile preprocessFile "scripts\fn_calculeScoreEquipe.sqf";
fn_topChrono = compile preprocessFile "scripts\fn_topChrono.sqf";
fn_enregistreEvenCourse = compile preprocessFile "scripts\fn_enregistreEvenCourse.sqf";

//Chrono de départ. Mise à jour par topChrono.sqf. Portée: publique (sur tous les clients et le serveur).
topChrono = 0;
publicVariable "topChrono";

//TODO: cela peut  probablement être déplacé sur le client (initPlayerLocal.sqf)
//Tableaux des positions de tir autorisées. Utilisé par fn_valideTir.sqf. Portée: publique (sur tous les clients et le serveur).
//Initialisé à partir de la liste de tous les triggers dont le nom commence par _patternPosTir
tableauPosTir = [];
private _tbtmp = allMissionObjects "EmptyDetector";
{if ([_patternPosTir, (str _x)] call BIS_fnc_inString) then {tableauPosTir pushBack _x;}} forEach _tbtmp;
publicVariable "tableauPosTir";

//Nombre de cibles du parcours. Portée: global sur le serveur.
//DBG! nbreTotalCibles = 40;
if (_clsCibleIA == 1) then {
		nbreTotalCibles = count entities [[_clsCible],[]];}
	else {
		nbreTotalCibles = count allMissionObjects (_clsCible);
	};
publicVariable "nbreTotalCibles";
//DBG! systemChat ("Nombre de cibles du parcours: " + str nbreTotalCibles);

//Tableau d'enregistrement des evenements de course: [array [string: type d'evenement, any: objet de l'evenement ou type de penalite, bool: true si derniere balise], obj player: joueur qui a declenche l'evenement, obj group: group du joueur, num: chrono de l'événement]
tableauEvenCourse = [];
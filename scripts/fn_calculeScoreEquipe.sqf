/* 

Calcule le score final des équipes : temps total du parcours + pénalités
Appelé par fn_enregistreEvenCourse lors de la validation de la balise d'arrivée 
par le dernier joeur de l'équipe.

Renvoie :
Un tableau 

*/

params ["_groupeJoueur","_tempsCourse"];

if (isServer || isDedicated) then {

	private _nbCiblesValidees    = {((_x select 2) isEqualTo _groupeJoueur) && (((_x select 0) select 0) isEqualTo "valideCible")} count tableauEvenCourse;
	private _nbTirsInterdits     = {((_x select 2) isEqualTo _groupeJoueur) && (((_x select 0) select 1) isEqualTo "penalTirInterdit")} count tableauEvenCourse;
	private _nbCartouches        = {((_x select 2) isEqualTo _groupeJoueur) && (((_x select 0) select 0) isEqualTo "enregTir")} count tableauEvenCourse;
	private _penalCiblesRatees   = 0;
	private _penalTirsInterdits  = 0;
	private _penalTotal          = 0;
	private _tempsCourseSecondes = 0;
	private _tempsTotalSecondes  = 0;
	private _strTempsTotal       = "";
	private _resultat            = [];

	//On calcule les pénalités pour cibles manquées : (nombre total des cibles du parcours - nbre de cibles touchées) * pénalité pour cible mmanquée
	_penalCiblesRatees = (nbreTotalCibles -  _nbCiblesValidees) * penalCibleManquee;
	//Puis, les pénalités pour tir interdit
	_penalTirsInterdits = _nbTirsInterdits * penalTirInterdit;
	//Et donc les pénalités totales
	_penalTotal = _penalCiblesRatees + _penalTirsInterdits;
	//Conversion de _tempsCourse en secondes pour additionner les temps
	_tempsCourseSecondes = _tempsCourse call fn_convDaytime_secondes;
	//Addition des temps et conversion au format "hh:mm:ss";
	_tempsTotalSecondes = _tempsCourseSecondes + _penalTotal;
	_strTempsTotal = _tempsTotalSecondes call fn_convSecondes_hms;
	//On enregistre le score de l'équipe dans tableauScores
	//TODO:à supprimer- tableauScores pushback [_groupeJoueur,_tempsCourse,_penalCiblesRatees,_penalTirsInterdits,_strTempsTotal];

	_resultat = [_nbCiblesValidees,_penalCiblesRatees,_nbTirsInterdits,_penalTirsInterdits,_strTempsTotal,_nbCartouches];
	_resultat

} else {
	systemChat ("Cette fonction ne peut être exécutée que sur le serveur.")
};



/*
	A chaque tir, vérifie que le joueur est sur une position de tir autorisée
	Déclenché par l'event handler "Fired" du joueur.
	
	Sans le hintC pas sûr que ceci résiste à des tirs en rafale simultanés de plusieurs joueurs
	
*/

private _joueur = player;
private _groupeJoueur = group _joueur;
private _posTirOK = false;

//On enregistre la cartouche tirée
[["enregTir","tirJoueur",false],_joueur,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];

//Le joueur se trouve sur une position de tir autorisée, on passe le flag _posTirOK à vrai (il y a sûrement une façon plus propre de faire ça) 
{
	if (player inArea _x) exitWith {_posTirOK = true;};
} forEach tableauPosTir;

//Le joueur n'a tiré à partir d'aucune position de tir autorisée
if !(_posTirOK) then {
	//On applique la pénalité sur le tableau géré par le serveur
	[["enregPenal","penalTirInterdit",false],_joueur,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];
	//Et on l'informe...
	hintC "Tir non autorisé ! Votre équipe a reçu une pénalité.";
};

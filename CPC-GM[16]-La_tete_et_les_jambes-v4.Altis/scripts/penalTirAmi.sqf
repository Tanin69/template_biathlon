/*

Applique une pénalité en cas de tir ami
appelé par player addEventHandler ["HandleDamage", {_this execVM "scripts\penalTirAmi.sqf"}];

*/

private _degatJoueur =  _this select 2;
private _joueurTir = _this select 3;
private _groupeJoueur = group _joueurTir;

if (!(isnull _joueurTir) && (name _joueurTir!="Error: No unit") && (isplayer _joueurTir)) then {
	[["enregPenal","penalTirAmi",false],_joueurTir,_groupeJoueur] remoteExecCall ["fn_enregistreEvenCourse",2];
};
//TODO: à supprimer- _joueurTir enableSimulationGlobal false;

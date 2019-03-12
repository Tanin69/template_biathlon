/*

Menotte ou démenotte un joueur. Appelé par un addAction disponible uniquement pour les GM

*/

private _joueur = _this select 0;
private _cliID = owner _joueur;
//systemChat ("_this select 0 : " + str (_this select 0));

//Si le joueur est captif, on le démenotte
if (captive _joueur ) then {
	//_joueur enableSimulationGlobal true;
	_joueur setCaptive false;
	[_joueur, false] remoteExec ['ACE_captives_fnc_setHandcuffed',_cliID];
	
} else {
	_joueur setCaptive true;
	[_joueur, true] remoteExec ['ACE_captives_fnc_setHandcuffed',_cliID];
};

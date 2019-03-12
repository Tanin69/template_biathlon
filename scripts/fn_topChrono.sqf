/* 

Déclenche le chrono de la course et informe les joueurs
qu'il a été lancé. Appelé par topChrono.sqf

Paramètre(s) :
0: OBJ group : groupe du joueur qui appelle la fonction

Renvoie :
Rien

*/

params ["_groupeGm"];

if (isServer || isDedicated) then {

	if (topChrono == 0) then {
		
		//Initialise le chrono et broadcaste la variable car elle est utilisée dans les scripts clients (valideBalise.sqf et valideTir.sqf)
		topChrono = daytime;
		publicVariable "topChrono";
		
		//Informe les joueurs que le top chrono a été donné
		_strTopChrono = topChrono call BIS_fnc_timeToString;
		[([_strTopChrono]),{params ["_strTopChrono"]; player createDiaryRecord ["logChrono", ["Top départ", "Top départ donné à " + _strTopChrono]];}] remoteExec ["call"];
		[([_strTopChrono]),{params ["_strTopChrono"]; hint parseText ("<t color='#83d123' font='RobotoCondensedBold' size='2'> Top départ donné à " + _strTopChrono + "</t>")}] remoteExec ["call"];

		//Supprime le addAction de déclenchement du chrono au GM et au GM assistant
		{
			[
				([_x]),
				{
					params ["_x"]; objCmdGm removeAction 0;
				}
			] remoteExec ["call",owner _x];
		} foreach (units _groupeGm);

	} else {
		"Le chrono a déjà été déclenché" remoteExec ["hint",remoteExecutedOwner];
	};

} else {
	systemChat ("Cette fonction ne peut être exécutée que sur le serveur.")
};
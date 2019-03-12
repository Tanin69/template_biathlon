/*
 
 Fonction qui enregistre les événements de course dans un tableau unique.
 Exécutée uniquement sur le serveur.

 Arguments :
 0: ARRAY, 
        STRING type d'événement ("valideBalise", "valideCible", "enregPenal"),
		ANY OBJ objet balise ou objet cible ou STRING si pénalité,
		BOOL TRUE si évén. de type valideBalise et dernière balise]
 1: OBJ player, joueur qui a déclenché l'événement
 2: OBJ group, équipe du joueur qui a déclenché l'événement
 
*/

params ["_tbTypeEven","_joueur","_groupeJoueur"];

//DBG! systemChat format ["Valeurs reçues:%1, %2, %3",_tbTypeEven,_joueur,_groupeJoueur];

if (isServer || isDedicated) then {

	//Calcule le chrono de l'événement
	private _chronoEven = daytime - topChrono;

	//Broadcaste le chrono vers le client appelant
	chronoServeur = _chronoEven;
	remoteExecutedOwner publicVariableClient "chronoServeur";
	
	switch (_tbTypeEven select 0) do {
		
		//L'événement est un tir
		case "enregTir": {
			
			tableauEvenCourse pushBack [_tbTypeEven,_joueur,_groupeJoueur,_chronoEven];
		
		};

		//L'événement est une validation de balise
		case "valideBalise": { 
			
			//Enregistre l'évenement dans le tableau
			tableauEvenCourse pushBack [_tbTypeEven,_joueur,_groupeJoueur,_chronoEven];
			
			//Le joueur a validé la dernière balise !
			if (_tbTypeEven select 2) then {
				
				//Si tous les joueurs de l'équipe ont validé la dernière balise, c'est la fin de course pour l'équipe !
				if (({((_x select 2) isEqualTo (_groupeJoueur)) && (((_x select 0) select 0) isEqualTo "valideBalise") && ((_x select 0) select 2)} count tableauEvenCourse) == count units _groupeJoueur) then {
					
					//DBG! systemChat format ["Fin de course:%1, %2, %3",_tbTypeEven,str _joueur,str _groupeJoueur];
					
					//On calcule le score de l'équipe et les stats
					_scoreEquipe = [_groupeJoueur,_chronoEven] call fn_calculeScoreEquipe;
					_strTempsPassage = _chronoEven call BIS_fnc_timeToString;
					_nbTirs = _scoreEquipe select 5;
					_nbHits = _scoreEquipe select 0;
					_efficaciteTir = "0";
					_nbTotalCibles = nbreTotalCibles;
					if ((_nbHits)>0) then {_efficaciteTir = (((_nbHits / _nbTirs)*100) toFixed 2)+"%"};
										
					//On inscrit le score dans le journal de tous les joueurs							
					[
						([_groupeJoueur,_strTempsPassage,_scoreEquipe,_nbTirs,_efficaciteTir,_nbHits,_nbTotalCibles]),
						{
							params ["_groupeJoueur", "_strTempsPassage","_scoreEquipe","_nbTirs","_efficaciteTir","_nbHits","_nbTotalCibles"];
							_nomGrpJoueur = groupID(_groupeJoueur);
							_joueursEquipe = "";
							_joueursEquipe = {_joueursEquipe + (name _x) + " "} forEach units _groupeJoueur;
							player createDiaryRecord ["logChrono", 
							["Arrivées", 
								"<br/><font color='#FFFFBB'><font size=20>Résultats de l'équipe " + _nomGrpJoueur + "</font></font><br/><br /> 
								<font color='#FFFFBB'><font size=15>Joueurs: " + _joueursEquipe + "</font></font><br/><br/> 
								<font color='#ff9605'><font size=18>Temps total : " + (_scoreEquipe select 4) + "</font></font><br /><br /> 
								<font size=15>- Temps de course: " + _strTempsPassage + "<br/><br />      - Pénalités: " + str ((_scoreEquipe select 1) + (_scoreEquipe select 3)) + " seconde(s)</font><br />  
									+ " + str(_scoreEquipe select 1) + " s. pour " + str (_nbTotalCibles - (_scoreEquipe select 0)) + " cible(s) manquée(s)<br />  
									+ " + str(_scoreEquipe select 3) + " s. pour " + str (_scoreEquipe select 2) + " tir(s) interdit(s))<br /><br /> 
								<font size=15>- Efficacité de tir: "+ _efficaciteTir + "</font><br /> 
									+ Cartouches tirées: " + str _nbTirs + "<br /> 
									+ Cibles validées: " + str _nbHits + " (sur " + str _nbTotalCibles +")"] 
							];
							//Et on informe tous les joueurs de l'arrivée de l'équipe et des principaux scores
							[_nomGrpJoueur,_strTempsPassage,_scoreEquipe] spawn
							{
								params ["_nomGrpJoueur", "_strTempsPassage","_scoreEquipe"];
								hint parseText ("L'équipe<br /><t color='#fc0f0f' size='1.2' font='RobotoCondensedBold'>" + _nomGrpJoueur + "<br /></t> a bouclé le parcours.<br/><br />
								** Résultats **<br/><t align='left' size='0.8'><br/>
								Temps de course: " + _strTempsPassage + ".<br />
								Pénalité pour cibles manquées: " + str (_scoreEquipe select 1) + " seconde(s).<br />
								Pénalité pour tirs interdits: " + str (_scoreEquipe select 3) + " seconde(s).<br /><br /></t><t color='#fc0f0f' size='1.2' font='RobotoCondensedBold'>
								Temps total : " + (_scoreEquipe select 4) + "</t><br /><br />
								<t size='0.8'>(Les résultats détaillés sont disponibles dans le journal)</t>");
								sleep 20;
								hint "";
							}
						}
					]
					remoteExec ["call"];
				
				};
			
			};		
		
		};
		
		//L'événement est une cible touchée
		case "valideCible": {
			
			//Si la cible n'a pas encore été tapée par l'équipe
			private _cibleTouchee = _tbTypeEven select 1;
			
			if (({((_x select 2) isEqualTo (_groupeJoueur)) && ((_x select 0) select 1 isEqualTo _cibleTouchee)} count tableauEvenCourse == 0)) then { 
								
				//DBG! systemChat format ["Cible validée: %1, %2, %3",_tbTypeEven,_joueur,_groupeJoueur];

				//Enregistre l'évenement dans le tableau du serveur
				tableauEvenCourse pushBack [_tbTypeEven,_joueur,_groupeJoueur,_chronoEven];

				//Envoie la confirmation de l'enregistrement au tireur
				[([_cibleTouchee]),{params ["_cibleTouchee"]; hint format ["Cible %1 validée", str _cibleTouchee]}] remoteExec ["call", remoteExecutedOwner];
		
				//Inscrit la validation du tir dans le journal de chaque joueur de l'équipe
				{
					[
						([_cibleTouchee,_x]),
						{
							params ["_cibleTouchee", "_x"];
							player createDiaryRecord ["logChrono", ["Tirs","Cible " + str _cibleTouchee + " validée par votre équipe"]];
						}
					] remoteExec ["call", owner _x];
				} forEach units _groupeJoueur;

			//Sinon informe le tireur que la cible a déjà été validée
			} else {
				[([_cibleTouchee]),{params ["_cibleTouchee"]; hint format ["La cible %1 a déjà été validée par l'équipe", _cibleTouchee]}] remoteExec ["call", remoteExecutedOwner];
			};
	
		};
		
		//L'événement est une pénalité de jeu
		case "enregPenal" : {
			//On enregistre l'événement dans le tableau côté serveur
			tableauEvenCourse pushBack [_tbTypeEven,_joueur,_groupeJoueur,_chronoEven];
			
			//La pénalité est de type tir ami
			if ((_tbTypeEven select 1) == "penalTirAmi") then {
				private _strGrpJoueur = groupID(_groupeJoueur);
				[([_joueur, _strGrpJoueur]),{params["_joueur","_strGrpJoueur"]; hint parseText ("<t color='#fc0f0f'>" + (name _joueur) + " (équipe " + _strGrpJoueur + ") a été mis aux arrêts pour tir ami.</t>")}] remoteExec ["call"];
				_cliID = owner (_joueur);
				_joueur setCaptive true;
				[_joueur, true] remoteExec ["ACE_captives_fnc_setHandcuffed",_cliID];
				//sleep 5;
				//_joueur enableSimulationGlobal false;	
			};
		};
	};

} else {

	systemChat ("Cette fonction ne peut être exécutée que sur le serveur.");

};
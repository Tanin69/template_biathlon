_penalTirInterdit  =  str (getMissionConfigValue "numPenalTirInterdit");
_penalCibleManquee = str (getMissionConfigValue "numPenalCibleManquee");

player createDiarySubject ["logChrono", "Infos course"];

player createDiaryRecord ["Diary", ["Crédits","Mission SIMPLE faite avec patience et bienveillance par tanin69 pour les Canards de Arma 3"]];

player createDiaryRecord ["Diary", ["Conseils","La ligne droite à l'azimut n'est pas forcément la solution gagnante : les repères visuels (dont le relief) peuvent s'avérer plus fiables. Pensez également à gérer votre fatigue."]];

player createDiaryRecord ["Diary", ["Equipe d'organisation","L'équipe d'organisation déclenche le chronomètre par une action molette sur le laptop qui se trouve à proximité immédiate.<br /><br />Elle peut récupérer les informations de course et de tir par une action molette sur le même objet. Celles-ci seront mises à jour dans le menu 'Tasks'<br /><br />Enfin, elle peut menotter ou démenotter les joueurs par une action molette sur le joueur en question. A elle de faire respecter la discipline !<br /><br />C'est également elle qui met fin à la partie (radio Alpha 0-0-1)"]];

player createDiaryRecord ["Diary", ["Règlement","<font color='#ff9605'>**COURSE**</font color><br />Il s'agit d'une course contre la montre. Le top départ est donné par l'équipe d'organisation.<br />Chaque équipe (et chaque joueur de l'équipe) doit valider chaque balise du parcours, puis valider à nouveau la balise de départ. Les balises à valider sont précisées dans le journal (tasks).<br /><br /><font color='#ff9605'>**TIR**</font color><br />Nombre de cibles du parcours: " + str nbreTotalCibles + ".<br />Vous n'avez le droit de tirer qu'à partir d'une position de tir autorisée.<br /><br />
<font color='#ff9605'>**PENALITES**</font color> (comptabilisées en fin de course)<br />+ Cible manquée : " + _penalCibleManquee + " secondes par cible manquée<br />+ Tir en dehors d'une zone autorisée : " + _penalTirInterdit + " secondes pour chaque tir<br / >+ Autres infractions au réglement : vous aurez à faire à votre hiérarchie...<br /><br /><font color='#ff9605'>Les informations sur les événements de course (top chrono, temps de passage, cibles validées) sont accessibles dans le journal (infos course)</font color><br /><br />Ci-dessous la photo d'une balise (elles sont toutes identiques) et d'une position de tir.<br /><br /><img image='img\balise.jpg' width='200' height='295'/><br /><br /><img image='img\posTir.jpg' width='300' height='233'/>"]];

player createDiaryRecord ["Diary", ["Insertion et équipement","Chaque équipe est insérée dans un rayon de 100 m. autour de la balise portant le nom de son équipe.<br /><br />Vous n'êtes pas équipés de radio. Vous avez par contre une carte et une boussole, l'outil de navigation (map tool), des jumelles et une montre.<br /><br />En outre, chaque équipe dispose d'une arme (HK416 + ARCO) avec le nombre de munitions correspondant exactement au nombre de cibles à toucher. Libre à chaque équipe de définir les rôles ou de les changer en cours de course.<br /><br />Au top départ (vous serez informés par un message), une fumi verte est déclenchée sur la balise de départ.<br /><br />L'équipe d'organisation dispose de GPS, de stuff médical et d'un système de géolocalisation des joueurs (accessible par la carte et le GPS)."]];

player createDiaryRecord ["Diary", ["Contexte","Décrassage du groupe de combat ! Course et tir sur cible chronométrés."]];

// vert: <font color='#5ACE00'>+</font color><br/>
// orange: <font color='#ff9605'>++</font color><br/>
// rouge: <font color='#ff0505'>+++</font color><br/>

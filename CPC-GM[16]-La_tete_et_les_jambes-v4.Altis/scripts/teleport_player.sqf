
hint "Ouvrez votre map et cliquez à l'endroit désiré";
player onMapSingleClick {
	player setPos _pos;
	player onMapSingleClick "";
	hint "";
};
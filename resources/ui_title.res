panel
{
	position 		0 0;
	size 			640 480;	// map hud size to 640x480

	child file "resources/ui_partial/menu_fonts.res";

	child image "background"
	{
		path		"ui/syndiclassic_bg";
		position	0 0;
		size		920  510;
		align		vcenter hcenter;

		scaling		aspecth;
	}

	child image "game_logo"
	{
		path		"ui/syndiclassic_logo";
		position	0 64;
		size		620 151;

		align		hcenter;// vcenter;

		scaling		aspecth;
	}

	child label "title"
	{
		position	0 70;
		size		640 20;
		//anchors		right bottom;
		scaling		aspecth;

		align		bottom hcenter;
		textAlign	center;

		font		TitleStart;

		label		"#MENU_TITLE_PRESS_ENTER";
		fontScale	18 18;
	}

	child label "copyright"
	{
		position	0 30;
		size		640 14;
		//anchors		right bottom;
		scaling		aspecth;
		align		bottom hcenter;

		textAlign	center;

		font		TitleCopy;

		label		"#INSCOPYRIGHT";
	}
}
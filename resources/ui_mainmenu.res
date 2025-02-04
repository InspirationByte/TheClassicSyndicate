panel
{
	position 		0 0;
	size 			640 480;	// map hud size to 640x480
	
	child file "resources/ui_partial/menu_fonts.res";
	
	child image "background"
	{
		path		"ui/ui_menu_bg2";
		position	200 0;
		size		896  504;
		align		vcenter hcenter;

		scaling		aspecth;
	}
	
	child file "resources/ui_partial/menu_stripes_main.res";
	
	//---------------------------------------------------------------

	child label "VersionText"
	{
		position	40 40;
		visible		1;
		
		size		400 14;
		scaling		uniform;
		
		align		top left;
		textalign	left;
		
		label		"#GAME_VERSION";
		font		Version;
	}

	child image "game_logo"
	{
		path		"ui/syndiclassic_logo";
		position	30 60;
		size		400 100;
		
		scaling		aspecth;
	}

	child container "Menu"
	{
		clipChilds	0;
		position	50 170;
		size		300 220;
		scaling		uniform;
	}
	
	child image "MenuTitle"
	{
		visible		0;
		path		"ui/ui_menu_title_gradient";
		position	-50 140;
		size		300 30;
		scaling		uniform;
		color    	1.0 0.57 0.0 1;
		
		child label "text"
		{
			align		left vcenter;
			position	100 3;
			size		400 20;
			scaling		uniform;
			label		"MENU TITLE";
		}
	}
	
	//---------------------------------------------------------------
	
	child file "resources/ui_partial/menu_hints_main.res";
}
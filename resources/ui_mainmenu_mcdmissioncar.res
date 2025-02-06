panel
{
	position 		0 0;
	size 			640 480;	// map hud size to 640x480
	
	//font			Roboto 30;

	child file "resources/ui_partial/menu_fonts.res";

	child panel "fade"
	{
		position	0 0;
		size		1000  500;
		align		vcenter hcenter;
		scaling		aspecth;
		color		0 0 0 0;
	}

	child container "menu_bg_top"
	{
		clipChilds		0;
		
		align			bottom left;
		scaling			uniform;
		position 		0 0;
		size 			800 600;	// map hud size to 640x480

		transform
		{
			rotate 15;
			translate 0 0;
		}
		
		child panel "items_bg"
		{
			color		0.08 0.08 0.08 1;
			position 	-650 0;
			size		800 2000;
			align		right vcenter;
			scaling		aspecth;
		}
	}

	child HudElement "Menu"
	{
		clipChilds		0;
		position	100 200;
		
		size		200 200;
		scaling		uniform;
		
		textalign	right;
		align		right top;

		fontScale	16 16;
	}
	
	child file "resources/ui_partial/menu_hints_main.res";
}
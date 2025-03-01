position 		0 0;
size 			640 480;	// map hud size to 640x480

fonts
{
	Default 	"Cooper" 30
	{
		fontScale	16 16;
	}
	FelonyBar	"Cooper" 30
	{
		fontScale	16 16;
	}
	Timer		"Cooper" 30
	{
		fontScale	16 16;
	}
	Message		"Cooper" 30
	{
		fontScale	16 16;
	}
	Alert		"Cooper" 30
	{
		fontScale	30 30;
		textCase 	upperCase;
	}
}

font		Default;
fontScale	16 16;

// main is used for hiding HUD elements
// Note that screen alert and message aren't hidden
child Container "main"
{
	position 		0 0;
	size 			640 480;	// map hud size to 640x480
	scaling			inherit;

	child ProgressBar "damageBar"
	{
		clipChilds	0;
		position	20 30;
		
		size		210 17;
		scaling		inherit_min;

		child label "damageLabel"
		{
			position	5 -5;
			
			size		200 40;
			scaling		uniform;
			
			label		"#HUD_DAMAGE_TITLE";
		}
	}

	child ProgressBar "damageBar2"
	{
		clipChilds	0;
		visible		0;
		position	20 30;
		
		size		210 17;
		scaling		inherit_min;

		align		right;

		child label "damageLabel"
		{
			position	5 -5;
			
			size		200 40;
			scaling		uniform;

			align		top right;
			textAlign	right;
			
			label		"#HUD_DAMAGE_TITLE";
		}
	}

	child ProgressBar "felonyBar"
	{
		clipChilds	0;
		position	20 60;
		
		size		210 17;
		scaling		inherit_min;

		child label "felonyLabel"
		{
			position	5 -5;
			
			size		200 40;
			scaling		uniform;
			
			label		"#HUD_FELONY_TITLE";
		}
	}

	child Timer "timer"
	{
		position	-20 0;	// -50 because we want center it
		size		220 80;
		
		align		hcenter;
		textAlign	center;
		
		scaling		inherit_min;

		font		Timer;
		fontScale	38 38;
		
		visible		0;
	}

	child image "map"
	{
		path		"_hudMap";
		position	20 30;
		align		bottom right;
		
		size		160 120;
		scaling		inherit_min;
		color		1 1 1 0.7;

		child image "radarColor"
		{
			position 	0 0;
			size 		160 120;
			scaling 	inherit;
			path		"_hudWhite";
		}
	}
}

child label "messageText"
{
	position	0 0;
	visible		1;
	
	size		400 75;
	scaling		uniform;
	
	align		vcenter hcenter;
	textalign	center;
	
	label		"";
	font		Message;
}

child image "alert"
{
	visible		0;
	path		"ui/ui_menu_title_gradient";
	position	0 -60;
	size		640 30;
	scaling		aspect_min;
	color    	1.0 0.57 0.0 1;
	align		vcenter hcenter;
	
	child label "text"
	{
		align		left vcenter;
		position	0 8;
		size		640 30;
		scaling		uniform;
		textalign	center;
		label		"";
		font		Alert;
	}
}
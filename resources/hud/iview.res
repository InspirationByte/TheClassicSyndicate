base "classichud.res";

font	"Cooper" 30;

child Container "main"
{
	child ProgressBar "damageBar"
	{
		visible 	0;
	}

	child ProgressBar "felonyBar"
	{
		visible 	0;
	}

	child image "map"
	{
		visible 	0;
	}

	// items found by Lua GUI API
	child image "timer_gauge"
	{
		atlas		"ui/ui_intro_watch" "stopwatch";
		position	25 25;
		size		120 150;
				
		scaling		inherit_min;
		/*
		child image "timer_arrow"
		{
			atlas		"ui/ui_intro_watch" "stopwatch_arrow";
			position	0 0;
			size		100 100;
		}*/
	}

	child Timer "timer"
	{
		position	41 85;
		size		85 75;
		
		scaling		inherit_min;

		visible		0;

		font		"Roboto Condensed" 30;
		fontScale	30 30;
		textcolor	0 0 0 1;
		
		type		1;	// set timer type to have arrow
	}

	child image "tasks"
	{
		atlas		"ui/ui_intro_list" "tasklist";
		
		align		right top;
		position	25 5;
		
		size		200 200;
		scaling		inherit_min;
		
		// damage
		child image "marker_hit_1"
		{
			atlas		"ui/ui_intro_list" "marker_x1";
			position	45 36;
			size		20 26;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_hit_2"
		{
			atlas		"ui/ui_intro_list" "marker_x2";
			position	75 36;
			size		20 26;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_hit_3"
		{
			atlas		"ui/ui_intro_list" "marker_x3";
			position	105 36;
			size		20 26;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_hit_4"
		{
			atlas		"ui/ui_intro_list" "marker_x4";
			position	135 36;
			size		20 26;
			scaling		inherit;
			visible 	0;
		}
		
		// completion
		child image "marker_burnout"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	50 51;
			size		200 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_handbrake"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	42 64;
			size		215 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_slalom"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	45 76;
			size		190 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_180"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	48 87;
			size		125 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_360"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	50 100;
			size		125 6;
			scaling		inherit;
			visible 	0;
		}

		child image "marker_rev180"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	48 114;
			size		265 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_speed"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	50 124;
			size		190 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_brake"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	52 138;
			size		240 6;
			scaling		inherit;
			visible 	0;
		}
		
		child image "marker_lap"
		{
			atlas		"ui/ui_intro_list" "marker_strike";
			position	55 148;
			size		125 6;
			scaling		inherit;
			visible 	0;
		}
	}
}
panel
{
	position 		0 0;
	size 			640 480;	// map hud size to 640x480

	font			"Cooper" 30 italic;
	fontScale		16 16;
	
	color			0 0 0 1;
	
	child image "background"
	{
		path		"ui/story_movie_image";
		position	0 0;
		size		840  480;
		align		vcenter hcenter;

		scaling		aspecth;
	}
}
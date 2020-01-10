////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Comic Crazy II
// Dwayne Hurst
// 
////////////////////////////////////////////////////////////////////////////////////////////////////////   

class UserConfig {
</ label="--------  Main theme layout  --------", help="Show or hide additional images", order=1 /> uct1="select below";
   </ label="Select listbox, wheel, vert_wheel", help="Select wheel type or listbox", options="listbox", order=4 /> enable_list_type="listbox";
   </ label="Select spinwheel art", help="The artwork to spin", options="marquee,wheel", order=5 /> orbit_art="wheel";
   </ label="Wheel transition time", help="Time in milliseconds for wheel spin.", order=6 /> transition_ms="25";  
</ label=" ", help=" ", options=" ", order=10 /> divider5="";
</ label="--------    Miscellaneous    --------", help="Miscellaneous options", order=16 /> uct6="select below";
   </ label="Enable monitor static effect", help="Show static effect when snap is null", options="Yes,No", order=18 /> enable_static="No"; 
   </ label="Random Wheel Sounds", help="Play random sounds when navigating games wheel", options="Yes,No", order=25 /> enable_random_sound="Yes";
}

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font="badabb.ttf";

// modules
fe.load_module("fade");
fe.load_module( "animate" );
fe.load_module("scrollingtext");

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// create surface for snap
local surface_snap = fe.add_surface( 640, 480 );
local snap = FadeArt("snap", 0, 0, 640, 480, surface_snap);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = false;

// now position and pinch surface of snap
// adjust the below values for the game video preview snap
surface_snap.set_pos(flx*0.347, fly*0.2, flw*0.425, flh*0.555);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = 0;
surface_snap.pinch_x = 0;
surface_snap.rotation = -2.8;

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// Load background image
local b_art = fe.add_image("Default.png", 0, 0, flw, flh );
local b_art = fe.add_image("backgrounds/[DisplayName].png", 0, 0, flw, flh );

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// The following section sets up what type and wheel and displays the users choice
if ( my_config["enable_list_type"] == "listbox" )
{
local listbox = fe.add_listbox( flx*0.01, fly*0.235, flw*0.325, flh*0.75 );
listbox.rows = 20;
listbox.charsize = 34;
listbox.set_rgb( 0, 0, 0 );
listbox.bg_alpha = 0;
listbox.align = Align.Left;
listbox.selbg_alpha = 0;
listbox.sel_red = 225;
listbox.sel_green = 0;
listbox.sel_blue = 0;
}

// Play random sound when transitioning to next / previous game on wheel
function sound_transitions(ttype, var, ttime) 
{
	if (my_config["enable_random_sound"] == "Yes")
	{
		local random_num = floor(((rand() % 1000 ) / 1000.0) * (124 - (1 - 1)) + 1);
		local sound_name = "sounds/GS"+random_num+".mp3";
		switch(ttype) 
		{
		case Transition.EndNavigation:		
			local Wheelclick = fe.add_sound(sound_name);
			Wheelclick.playing=true;
			break;
		}
		return false;
	}
}
fe.add_transition_callback("sound_transitions")

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

//Game count text info
local textgc = fe.add_text( "[ListEntry]-[ListSize]", flx*0.555, fly*0.1, flw*0.4, flh*0.025  );
textgc.set_rgb( 0, 0, 0 );
//textgc.style = Style.Bold;
textgc.align = Align.Centre;
textgc.rotation = 0;
textgc.word_wrap = true;

//Filter text info
local textf = fe.add_text( "Filter: [ListFilterName]", flx*0.555, fly*0.075, flw*0.4, flh*0.025  );
textf.set_rgb( 0, 0, 0 );
//textgc.style = Style.Bold;
textf.align = Align.Centre;
textf.rotation = 0;
textf.word_wrap = true;

//Emulator text info
local textemu = fe.add_text( "[Emulator]", flx*0.27, fly*0.765, flw*0.6, flh*0.035  );
textemu.set_rgb( 0, 0, 0 );
//textemu.style = Style.Bold;
textemu.align = Align.Centre;
textemu.rotation = -2.8;
textemu.word_wrap = true;

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//word pop

class PopImage1
{
    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local random_num = floor(((rand() % 1000 ) / 1000.0) * (10 - (1 - 1)) + 1);
            ref.file_name = "pop/"+random_num+".png";
        }
    }
}

::OBJECTS <- {
  wordpop1 = fe.add_image("pop/1.png", flx*0.125, fly*0.05, flw*0.15, flh*0.2),
}
local move_transition1 = {
  when = Transition.EndNavigation ,property = "rotation", start = -180, end = 0, time = 750, tween = Tween.Back
}
OBJECTS.wordpop1.trigger = Transition.EndNavigation;
animation.add( PropertyAnimation( OBJECTS.wordpop1, move_transition1 ) );
PopImage1(OBJECTS.wordpop1);

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
// Box art and cart art, uses the emulator.cfg path for boxart image location

local boxart = fe.add_artwork("boxart", flx*0.4, fly*0.81, flw*0.175, flh*0.175 );
boxart.preserve_aspect_ratio = true;

local cartart = fe.add_artwork("cartart", flx*0.6, fly*0.825, flw*0.1, flh*0.15 );
cartart.preserve_aspect_ratio = true;

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//Year 

::OBJECTS <- {
  yeartest = fe.add_image("year/[Year].png", flx*0.825, fly*0.001, flw*0.175, flh*0.1 ),
}
local move_transition1 = {
  when = Transition.EndNavigation ,property = "y", start = fly*-2.0, end = fly*0.001, time = 850, tween = Tween.Linear
}
OBJECTS.yeartest.trigger = Transition.EndNavigation;
animation.add( PropertyAnimation( OBJECTS.yeartest, move_transition1 ) );

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//category genre 

class GenreImage1
{
    mode = 1;       //0 = first match, 1 = last match, 2 = random
    supported = {
        //filename : [ match1, match2 ]
        "action": [ "action","gun", "climbing" ],
        "adventure": [ "adventure" ],
        "arcade": [ "arcade" ],
        "casino": [ "casino" ],
        "computer": [ "computer" ],
        "console": [ "console" ],
        "collection": [ "collection" ],
        "fighter": [ "fighting", "fighter", "beat-'em-up" ],
        "handheld": [ "handheld" ],
		"jukebox": [ "jukebox" ],
        "platformer": [ "platformer", "platform" ],
        "mahjong": [ "mahjong" ],
        "maze": [ "maze" ],
        "paddle": [ "breakout", "paddle" ],
        "puzzle": [ "puzzle" ],
	    "pinball": [ "pinball" ],
	    "quiz": [ "quiz" ],
	    "racing": [ "racing", "driving","motorcycle" ],
        "rpg": [ "rpg", "role playing", "role-playing" ],
	    "rhythm": [ "rhythm" ],
        "shooter": [ "shooter", "shmup", "shoot-'em-up" ],
	    "simulation": [ "simulation" ],
        "sports": [ "sports", "boxing", "golf", "baseball", "football", "soccer", "tennis", "hockey" ],
        "strategy": [ "strategy"],
        "utility": [ "utility" ]
    }

    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local cat = " " + fe.game_info(Info.Category, var).tolower();
            local matches = [];
            foreach( key, val in supported )
            {
                foreach( nickname in val )
                {
                    if ( cat.find(nickname, 0) ) matches.push(key);
                }
            }
            if ( matches.len() > 0 )
            {
                switch( mode )
                {
                    case 0:
                        ref.file_name = "glogos/" + matches[0] + "1.png";
                        break;
                    case 1:
                        ref.file_name = "glogos/" + matches[matches.len() - 1] + "1.png";
                        break;
                    case 2:
                        local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0);
                        ref.file_name = "glogos/" + matches[random_num] + "1.png";
                        break;
                }
            } else
            {
			      local random_num = floor(((rand() % 1000 ) / 1000.0) * (20 - (1 - 1)) + 1);
                  ref.file_name = "glogos/unknown" + random_num + ".png";
//				  ref.file_name = "glogos/unknown1.png";
            }
        }
    }
}
		
::OBJECTS <- {
  glogo1 = fe.add_image("glogos/blank.png", flx*0.7, fly*0.15, flw*0.3, flh*0.85),
}

local move_transition1 = {
  when = Transition.EndNavigation ,property = "x", start = flx*2.0, end = flx*0.7, time = 750, tween = Tween.Linear
}
OBJECTS.glogo1.trigger = Transition.EndNavigation;
animation.add( PropertyAnimation( OBJECTS.glogo1, move_transition1 ) );
GenreImage1(OBJECTS.glogo1);




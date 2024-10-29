/**
 * * obj_creation is used as part of the main menu new game and chapter creation logic
 * It contains data and logic for setting up custom chapters as well as populating the new game menu with data for pre-existing chapters.
 */

keyboard_string="";

#region Global Settings: volume, fullscreen etc
ini_open("saves.ini");
master_volume=ini_read_real("Settings","master_volume",1);
effect_volume=ini_read_real("Settings","effect_volume",1);
music_volume=ini_read_real("Settings","music_volume",1);
large_text=ini_read_real("Settings","large_text",0);
settings_heresy=ini_read_real("Settings","settings_heresy",0);
settings_fullscreen=ini_read_real("Settings","fullscreen",1);
settings_window_data=ini_read_string("Settings","window_data","fullscreen");
ini_close();
#endregion

window_data=string(window_get_x())+"|"+string(window_get_y())+"|"+string(window_get_width())+"|"+string(window_get_height())+"|";
window_old=window_data;
if (window_get_fullscreen()=1){
	window_old="fullscreen";
	window_data="fullscreen";
}
restarted=0;
custom_icon=0;

/// Stores the chapter icon in one spot so we dont have to keep checking whether we're using a custom image or not every time we wanna display it somewhere
global.chapter_icon_sprite = spr_icon_chapters;
global.chapter_icon_frame = 0;
global.chapter_icon_path = "";


audio_stop_all();
audio_play_sound(snd_diboz,0,true);
audio_sound_gain(snd_diboz, 0, 0);
var nope=0;
if (master_volume=0) or (music_volume=0) then nope=1;
if (nope!=1){
	audio_sound_gain(snd_diboz,0.25*master_volume*music_volume,2000);
}

global.load=0;

skip=false;
premades=true;

/// Opt in/out of loading from json vs hardcoded for specific chapters, this way i dont have to do all in one go to test
use_chapter_object = 0;

livery_picker = new colour_item(100,230);
livery_picker.scr_unit_draw_data();
full_liveries = array_create(21,DeepCloneStruct(livery_picker.map_colour));
complex_livery=false;
complex_selection = "sgt";
complex_depth_selection = 0;
//TODO probably make this array based at some point ot match other unit data
complex_livery_data = complex_livery_default();

standard_livery_components = 0;
enum LiveryComponents{
	Body,
	Helm,
	Trim,
}
test_sprite = 0;
fade_in=50;
slate1=80;
slate2=0;
slate3=-2;
slate4=0;
slate5=0;
slate6=0;
mouse_left=0;
mouse_right=0;
change_slide=0;
goto_slide=1;
highlight=0;
highlighting=0;
old_highlight=0;
slide=1;
slide_show=1;
cooldown=0;
name_bad=0;
heheh=0;
icons_top=1;
icons_max=0;
turn_selection_change=false;

scrollbar_engaged=0;

text_selected="none";
text_bar=0;
tooltip="";
tooltip2="";
popup="";
temp=0;
target_gear=0;
tab=0;
role_names_all="";

// 
chapter_name="Unnamed";
chapter_string="Unnamed";
chapter_year=0;
icon=1;
icon_name="da";
custom=0;
founding=1;
chapter_tooltip="";
points=0;
maxpoints=100;
fleet_type=1;
strength=5;
cooperation=5;
purity=5;
stability=5;
adv=[];
adv_num=[];
dis=[];
dis_num=[];
for(var i=0; i<16; i++){
    adv[i]="";
    adv_num[i]=0;
    dis[i]="";
    dis_num[i]=0;
}
var i = 9;

homeworld="Temperate";
homeworld_name=global.name_generator.generate_star_name();
recruiting="Death";
recruiting_name=global.name_generator.generate_star_name();
flagship_name=global.name_generator.generate_imperial_ship_name();
recruiting_exists=1;
homeworld_exists=1;
homeworld_rule=1;
aspirant_trial=eTrials.BLOODDUEL;
discipline="default";

battle_cry="For the Emperor";

main_color=1;secondary_color=1;main_trim=1;
left_pauldron=1;right_pauldron=1;// Left/Right pauldron
lens_color=1;weapon_color=1;col_special=0;trim=1;
skin_color=0;

color_to_main="";
color_to_secondary="";
color_to_trim="";
color_to_pauldron="";
color_to_pauldron2="";
color_to_lens="";
color_to_weapon="";

hapothecary=global.name_generator.generate_space_marine_name();
hchaplain=global.name_generator.generate_space_marine_name();
clibrarian=global.name_generator.generate_space_marine_name();
fmaster=global.name_generator.generate_space_marine_name();
honorcapt=global.name_generator.generate_space_marine_name();		//1st
watchmaster=global.name_generator.generate_space_marine_name();		//2nd
arsenalmaster=global.name_generator.generate_space_marine_name();	//3rd
admiral=global.name_generator.generate_space_marine_name();			//4th
marchmaster=global.name_generator.generate_space_marine_name();		//5th
ritesmaster=global.name_generator.generate_space_marine_name();		//6th
victualler=global.name_generator.generate_space_marine_name();		//7th
lordexec=global.name_generator.generate_space_marine_name();		//8th
relmaster=global.name_generator.generate_space_marine_name();		//9th
recruiter=global.name_generator.generate_space_marine_name();		//10th




equal_specialists=0;
load_to_ships=[2,0,0];

successors=0;

mutations=0;mutations_selected=0;
preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;

disposition[0]=0;
disposition[1]=0;// Prog
disposition[2]=0;// Imp
disposition[3]=0;// Mech
disposition[4]=0;// Inq
disposition[5]=0;// Ecclesiarchy
disposition[6]=0;// Astartes
disposition[7]=0;// Reserved

chapter_master_name=global.name_generator.generate_space_marine_name();
chapter_master_melee=1;
chapter_master_ranged=1;
chapter_master_specialty=2;

enum CHAPTERS {
    UNKNOWN = 0,
    DARK_ANGELS = 1,
    WHITE_SCARS,
    SPACE_WOLVES,
    IMPERIAL_FISTS,
    BLOOD_ANGELS,
    IRON_HANDS,
    ULTRAMARINES,
    SALAMANDERS,
    RAVEN_GUARD,

    BLACK_TEMPLARS = 10,
    MINOTAURS,
    BLOOD_RAVENS,
    CRIMSON_FISTS,
    LAMENTERS,
    CARCHARODONS,
    SOUL_DRINKERS,

    ANGRY_MARINES = 17,
    EMPERORS_NIGHTMARE,
    STAR_KRAKENS,
    CONSERVATORS,

    CUSTOM_1 = 21,
    CUSTOM_2 = 22,
    CUSTOM_3 = 23,
    CUSTOM_4 = 24,
    CUSTOM_5 = 25,
}
enum CHAPTER_ORIGIN {
    NONE,
    FOUNDING,
    SUCCESSOR,
    NON_CANON,
    CUSTOM
}

/**
 * @description chapter constructor. This is just for the main menu bit, the full data comes in scr_chapter_new
 * @param {Enum.CHAPTERS} _id e.g. CHAPTERS.DARK_ANGELS
 * @param {Enum.CHAPTER_ORIGIN} _origin e.g. CHAPTER_ORIGIN.FOUNDING 
 * @param {Enum.CHAPTERS} _progenitor This chapter's founding chapter, if one exits. Use 0 if none.
 * @param {String} _name e.g. "Dark Angels" 
 * @param {String} _tooltip e.g. "Some extremely lore friendly backstory"
 */
function ChapterDataLite(_id, _origin,_progenitor, _name , _tooltip) constructor {
    id = _id;
    origin = _origin;
    name = _name;
    progenitor = _progenitor;
    tooltip = _tooltip;
    disabled = false;
    json = false;
    icon = _id;
    splash = _id;
}

// For new additions, as long as the order in the array is the same as the enum order,
//you will be able to index the array by using syntax like so: `var dark_angels = all_chapters[CHAPTERS.DARK_ANGELS]`
all_chapters = [
    new ChapterDataLite(CHAPTERS.UNKNOWN, CHAPTER_ORIGIN.NONE, 0, "Unknown", "Error: The tooltip is missing"),
    new ChapterDataLite(CHAPTERS.DARK_ANGELS, CHAPTER_ORIGIN.FOUNDING, 0, "Dark Angels", 
    "The Dark Angels claim complete allegiance and service to the Emperor of Mankind, though their actions and secret goals seem to run counter to this- above all other things they strive to atone for an ancient crime of betrayal."),
    new ChapterDataLite(CHAPTERS.WHITE_SCARS, CHAPTER_ORIGIN.FOUNDING, 0, "White Scars", "Known and feared for their highly mobile way of war, the White Scars are the masters of lightning strikes and hit-and-run tactics.  They are particularly adept in the use of Attack Bikes and field large numbers of them."),
    new ChapterDataLite(CHAPTERS.SPACE_WOLVES, CHAPTER_ORIGIN.FOUNDING, 0, "Space Wolves", "Brave sky warriors hailing from the icy deathworld of Fenris, the Space Wolves are a non-Codex compliant chapter, and deadly in close combat.  They fight on their own terms and damn any who wish otherwise." ),
    new ChapterDataLite(CHAPTERS.IMPERIAL_FISTS, CHAPTER_ORIGIN.FOUNDING, 0, "Imperial Fists", "Siege-masters of utmost excellence, the Imperial Fists stoicism has lead them to great victories and horrifying defeats. To them, the idea of a tactical retreat is utterly inconsiderable. They hold ground on Inwit vigilantly, refusing to back down from any fight."),
    new ChapterDataLite(CHAPTERS.BLOOD_ANGELS, CHAPTER_ORIGIN.FOUNDING, 0,"Blood Angels", "One of the most noble and renowned chapters, their combat record belies a dark flaw in their gene-seed caused by the death of their primarch. Their primarch had wings and a propensity for close combat, and this shows in their extensive use of jump packs and close quarters weapons."),
    new ChapterDataLite(CHAPTERS.IRON_HANDS, CHAPTER_ORIGIN.FOUNDING, 0,"Iron Hands","The flesh is weak, and the weak shall perish. Such is the creed of these mercilessly efficient cyborg warriors. A chapter with strong ties to the Mechanicum, they crush the foes of the Emperor and Machine God alike with a plethora of exotic technology and ancient weaponry."),
    new ChapterDataLite(CHAPTERS.ULTRAMARINES, CHAPTER_ORIGIN.FOUNDING, 0,"Ultramarines","An honourable and venerated chapter, the Ultramarines are considered to be amongst the best of the best. Their Primarch was the author of the great tome of the “Codex Astartes”, and they are considered exemplars of what a perfect Space Marine Chapter should be like."),
    new ChapterDataLite(CHAPTERS.SALAMANDERS, CHAPTER_ORIGIN.FOUNDING, 0,"Salamanders", "Followers of the Promethean Cult, the jet-black skinned Salamanders are forgemasters of legend. They are armed with the best wargear available and prefer flame based weaponry. Their only drawback is their low numbers and slow recruiting."),
    new ChapterDataLite(CHAPTERS.RAVEN_GUARD, CHAPTER_ORIGIN.FOUNDING, 0,"Raven Guard","Clinging to the shadows and riding the edge of lightning the Raven Guard strike out at the hated enemy with stealth and speed. Using lightning strikes, hit and run tactics, and guerrilla warfare, they are known for being there one second and gone the next."),
    new ChapterDataLite(CHAPTERS.BLACK_TEMPLARS, CHAPTER_ORIGIN.SUCCESSOR, CHAPTERS.IMPERIAL_FISTS, "Black Templars","Not adhering to the Codex Astartes, Black Templars are a Chapter on an Eternal Crusade with unique organization and high numbers. Masters of assault, they charge at the enemy with zeal unmatched. They hate psykers, and as such, have no Librarians."),
    new ChapterDataLite(CHAPTERS.MINOTAURS, CHAPTER_ORIGIN.SUCCESSOR, CHAPTERS.IMPERIAL_FISTS, "Minotaurs","Bronze-clad Astartes of unknown Founding, the Minotaurs prefer to channel their righteous fury in a massive storm of fire, with tanks and artillery. They could be considered the Inquisition’s attack dog, since they often attack fellow chapters suspected of heresy."),
    new ChapterDataLite(CHAPTERS.BLOOD_RAVENS, CHAPTER_ORIGIN.SUCCESSOR,0, "Blood Ravens","Of unknown origins and Founding, the origins of the Blood Ravens are shrouded in mystery and are believed to be tied to a dark truth. This elusive Chapter is drawn to the pursuit of knowledge and ancient lore and produces an unusually high number of Librarians."),
    new ChapterDataLite(CHAPTERS.CRIMSON_FISTS, CHAPTER_ORIGIN.SUCCESSOR, CHAPTERS.IMPERIAL_FISTS ,"Crimson Fists","An Imperial Fists descendant, the Crimson Fists are more level-minded than their Progenitor and brother chapters.  They suffer the same lacking zygotes as their ancestors, and more resemble the Ultramarines in their balanced approach to combat. After surviving a devastating Ork WAAAGH! the chapter clings dearly to its future."),
    new ChapterDataLite(CHAPTERS.LAMENTERS, CHAPTER_ORIGIN.SUCCESSOR, CHAPTERS.BLOOD_ANGELS,"Lamenters","The Lamenter's accursed and haunted legacy seems to taint much of what they have achieved; their victories often become bitter ashes in their hands.  Nearly extinct, they fight their last days on behalf of the common folk in a crusade of endless penitence."),
    new ChapterDataLite(CHAPTERS.CARCHARODONS, CHAPTER_ORIGIN.SUCCESSOR, CHAPTERS.RAVEN_GUARD, "Carcharodons","Rumored to be Successors of the Raven Guard, these Astartes are known for their sudden attacks and shock assaults. Travelling through the Imperium via self-sufficient Nomad-Predation based fleets, no enemy is safe from the fury of these bloodthirsty Space Marines."),
    new ChapterDataLite(CHAPTERS.SOUL_DRINKERS, CHAPTER_ORIGIN.SUCCESSOR,CHAPTERS.IMPERIAL_FISTS, "Soul Drinkers","Sharing ancestry of the Black Templars or Crimson fists. As proud sons of Dorn they share the strong void combat traditions, fielding a large amount of Battle Barges. As well as being fearsome in close combat. Whispers of the Ruinous Powers are however quite enticing."),
    new ChapterDataLite(CHAPTERS.ANGRY_MARINES, CHAPTER_ORIGIN.NON_CANON,0, "Angry Marines","Frothing with pathological rage since the day their Primarch emerged from his pod with naught but a dented copy of battletoads.  Every last Angry Marine is a homicidal, suicidal berserker with a voice that projects, and are always angry, all the time.  A /tg/ classic."),
    new ChapterDataLite(CHAPTERS.EMPERORS_NIGHTMARE, CHAPTER_ORIGIN.NON_CANON,0, "Emperor’s Nightmare","The Emperor's Nightmare bear the curse of a bizarre mutation within their gene-seed. The Catalepsean Node is in a state of decay and thus do not sleep for months at a time until falling asleep suddenly. They prefer shock and awe tactics with stealth."),
    new ChapterDataLite(CHAPTERS.STAR_KRAKENS, CHAPTER_ORIGIN.NON_CANON,0, "Star Krakens","In darkness, they dwell in The Deep. The Star Krakens stand divided in individual companies but united in the form of the Ten-Flag Council. They utilize boarding tactics and are the sole guardians of the ancient sensor array called “The Lighthouse”."),
    new ChapterDataLite(CHAPTERS.CONSERVATORS, CHAPTER_ORIGIN.NON_CANON,0, "Conservators","Hailing from the Asharn Marches and having established their homeworld on the planet Dekara, these proud sons of Dorn suffer from an extreme lack of supplies, Ork raids, and more. Though under strength and lacking equipment, they managed to forge an interstellar kingdom loyal to both Emperor and Imperium."),
    new ChapterDataLite(CHAPTERS.CUSTOM_1, CHAPTER_ORIGIN.CUSTOM,0,"Custom","Your Chapter", "")
    // new ChapterDataLite(CHAPTERS.CUSTOM_2, CHAPTER_ORIGIN.CUSTOM,0,"Custom","Your Chapter",),
    // new ChapterDataLite(CHAPTERS.CUSTOM_3, CHAPTER_ORIGIN.CUSTOM,0,"Custom","Your Chapter",),
    // new ChapterDataLite(CHAPTERS.CUSTOM_4, CHAPTER_ORIGIN.CUSTOM,0,"Custom","Your Chapter",),
    // new ChapterDataLite(CHAPTERS.CUSTOM_5, CHAPTER_ORIGIN.CUSTOM,0,"Custom","Your Chapter",),
]
// for now the extra custom chapters are messing with the UI too much

var missing_splash = 100;
var custom_splash = 98;
all_chapters[CHAPTERS.EMPERORS_NIGHTMARE].splash = missing_splash;
all_chapters[CHAPTERS.CARCHARODONS].splash = missing_splash;
all_chapters[CHAPTERS.CONSERVATORS].splash = missing_splash;
all_chapters[CHAPTERS.CUSTOM_1].splash = custom_splash;


global.normal_icons_count = 0;
// Load from files to overwrite hardcoded ones
for(var c = 0; c < 30; c++){
    var json_chapter = new ChapterData();
    var success = json_chapter.load_from_json(c); 
    if(success){
        all_chapters[c] = new ChapterDataLite(
            json_chapter.id,
            json_chapter.origin,
            json_chapter.founding,
            json_chapter.name,
            json_chapter.flavor,
        );
        all_chapters[c].json = true;
        all_chapters[c].icon = json_chapter.icon;
        all_chapters[c].splash = json_chapter.splash;
    }

    var icon = file_exists($"{working_directory}\\images\\creation\\chapters\\icons\\{c}.png");
    if(icon) {global.normal_icons_count += 1;}
}

global.chapters_count = array_length(all_chapters);

// test_chap = all_chapters[CHAPTERS.BLOOD_ANGELS];
// show_debug_message(test_chap);
// test_chap2 = all_chapters[CHAPTERS.BLACK_TEMPLARS];
// show_debug_message(test_chap2);

/** 
 * * Not all Chapters are implemented yet, disable the ones that arent, remove a line if the chapter gets made
 */
all_chapters[CHAPTERS.UNKNOWN].disabled = true; //this should always be disabled, it exists for array indexing purposes for now
// all_chapters[CHAPTERS.CARCHARODONS].disabled = true;
all_chapters[CHAPTERS.ANGRY_MARINES].disabled = true;
all_chapters[CHAPTERS.EMPERORS_NIGHTMARE].disabled = true;
all_chapters[CHAPTERS.STAR_KRAKENS].disabled = true;
all_chapters[CHAPTERS.CONSERVATORS].disabled = true;
// all_chapters[CHAPTERS.CUSTOM_2].disabled = true;
// all_chapters[CHAPTERS.CUSTOM_3].disabled = true;
// all_chapters[CHAPTERS.CUSTOM_4].disabled = true;
// all_chapters[CHAPTERS.CUSTOM_5].disabled = true;


// TODO refactor into a script which converts these static arrays to dynamic struct arrays

chapter_id[21]= "Custom";
chapter_tooltip[21]="Your Chapter";

//Stores info for custom chapter




chaptersave  = "chaptersave#1.ini"

chapter21 ="Custom";
if(file_exists("chaptersave#1.ini")=true){
	chapter_made=1;
}
else if (file_exists("chaptersave#1.ini")=false){
	chapter_made=0;
}




if((file_exists("chaptersave#1.ini")=true) and (chapter_made=1)){
	ini_open("chaptersave#1.ini")
		all_chapters[CHAPTERS.CUSTOM_1].name= ini_read_string("Save","chapter_id","Custom");
		chapter21 = ini_read_string("Save","chapter_name",chapter_name);
		icon21= ini_read_real("Save","icon#",icon);
	   	icon_name21= ini_read_string("Save","icon_name","custom");
	   	strength21 = ini_read_real("Save","strength",strength);
	    purity21 = ini_read_real("Save","purity",purity);
	   	stability21= ini_read_real("Save","stability",stability);
		cooperation21=ini_read_real("Save","cooperation",cooperation);
		founding21 = ini_read_real("Save","founding",1);
		
		fleet_type21=ini_read_real("Save","fleet_type",1);
		homeworld21 = ini_read_string("Save","homeworld",homeworld);
		homeworld_name21 = ini_read_string("Save","homeworld_name",homeworld_name);
		 recruiting_world21= ini_read_string("Save","recruiting",recruiting);
		recruiting_name21 = ini_read_string("Save","recruiting_name",recruiting_name);
		homeworld_exists21 = ini_read_real("Save","home_worldexists",homeworld_exists);
		recruiting_exists21= ini_read_real("Save","recruiting_exists",recruiting_exists);
		homeworld_rule21= ini_read_real("Save","home_world_rule",homeworld_rule);
		aspirant_trial21=ini_read_real("Save","aspirant_trial",aspirant_trial);
		discipline21=ini_read_string("Save","discipline",discipline);
		
		color_to_main21= ini_read_string("Controller","main_color","Red");
	    color_to_secondary21= ini_read_string("Controller","secondary_color","Red");
	    color_to_trim21 = ini_read_string("Controller","main_trim","Red");
	   color_to_pauldron2_21 = ini_read_string("Controller","left_pauldron","Red");
	    color_to_pauldron21 = ini_read_string("Controller","right_pauldron","Red")
	   color_to_lens21 = ini_read_string("Controller","lens_color","Lime");
	   color_to_weapon21 = ini_read_string("Controller","weapon_color","Red");
	   col_special21 = ini_read_real("Controller","col_special",col_special);
	   trim21 = ini_read_real("Controller","trimmed",trim);
	   equal_specialists21 = ini_read_real("Controller","equal_specialists",1);
		
	
	
	
		preomnor21= ini_read_real("Creation","preomnor",preomnor);
	    voice21 = ini_read_real("Creation","voice",voice);
	    doomed21 = ini_read_real("Creation","doomed",doomed);
	    lyman21 = ini_read_real("Creation","lyman",lyman);
	    omophagea21 = ini_read_real("Creation","omophagea",omophagea);
	    ossmodula21 = ini_read_real("Creation","ossmodula",ossmodula);
	    membrane21 = ini_read_real("Creation","membrane",membrane);
	    zygote21 = ini_read_real("Creation","zygote",zygote);
	    betchers21= ini_read_real("Creation","betchers",betchers);
	    catalepsean21 = ini_read_real("Creation","catalepsean",catalepsean);
	    secretions21= ini_read_real("Creation","secretions",secretions);
	    occulobe21 = ini_read_real("Creation","occulobe",occulobe);
	    mucranoid21=ini_read_real("Creation","mucranoid",mucranoid)
		battle_cry_21 = ini_read_string("Creation","battle_cry","For The Emperor");
		
		recruiter21= ini_read_string("Creation","recruiter_name",recruiter);
		mutations21= ini_read_string("Creation","mutation",mutations);
		mutations_selected21=ini_read_real("Creation","mutations_selected",2);
	    successors21= ini_read_real("Creation","successors",successors);
	    disposition21[1]= ini_read_real("Creation","progenitor_disposition",disposition[1]);
	    disposition21[2]=ini_read_real("Creation","imperium_disposition",disposition[2]);
	    disposition21[3]=ini_read_real("Creation","admech_disposition",disposition[3]);
		disposition21[6]=ini_read_real("Creation","astartes_disposition",disposition[6]);
		disposition21[4]=ini_read_real("Creation","inquisition_disposition",disposition[4]);
		disposition21[5]=ini_read_real("Creation","ecclesiarchy_disposition",disposition[5]);
		disposition21[7]=ini_read_real("Creation","reserved_disposition",disposition[7]);
		complex_livery21 = return_json_from_ini("Creation","complex_livery", complex_livery_default());
		
		
		
	    clibrarian21= ini_read_string("Creation","chief_name",clibrarian);
	    hchaplain21 = ini_read_string("Creation","high_name",hchaplain);
	    hapothecary21=ini_read_string("Creation","high2_name",hapothecary);
	    fmaster21= ini_read_string("Creation","forgey_name",fmaster);
	    admiral21=ini_read_string("Creation","lord_name",admiral);
		chapter_master_name21 = ini_read_string("Creation","master_name",chapter_master_name);
		chapter_master_melee21 = ini_read_real("Creation","chapter_master_melee",chapter_master_melee);
		chapter_master_ranged21= ini_read_string("Creation","master_ranged",chapter_master_ranged);
		chapter_master_specialty21=ini_read_string("Creation","master_specialty",chapter_master_specialty);
		adv21=[1,2,3,4,5,6,7,8];
		dis21=[1,2,3,4,5,6,7,8];
		for(var i =1;i<=8;i++){
			
			adv21[i]=ini_read_string("Creation","adv21"+string(i),"")
			dis21[i]=ini_read_string("Creation","dis21"+string(i),"")
		}
		
		for(var i=0;i<=22;i++){
		    role_21[i]= ini_read_string("Save","role_21"+string(i),"Tactical");
			wep1_21[i]= ini_read_string("Save","wep1_21"+string(i),"Combat Knife");
			wep2_21[i]=ini_read_string("Save","wep2_21"+string(i),"Bolter")
			armour_21[i]= ini_read_string("Save","armour_21"+string(i),"Power Armour");
			 gear_21[i]= ini_read_string("Save","gear_21"+string(i),"");
			mobi_21[i]= ini_read_string("Save","mobi_21"+string(i),"");
		}
stage = 6;
ini_close();
}


else if (file_exists("chaptersave#1.ini")=false){
    adv21 = [1,2,3,4,5,6,7,8]
    dis21 =[1,2,3,4,5,6,7,8]
    disposition21 = [1,2,3,4,5,6,7]
    founding21=4;

    icon21=4;
    icon_name21="if";
    fleet_type21=1;
    strength21=2;
    purity21=5;
    stability21=5;
    cooperation21=2;
    homeworld21=1
    homeworld_name21="World"
    recruiting_world21=homeworld_name21
    recruiting_name21=homeworld_name21
    homeworld_exists21=1;
    recruiting_exists21=1;
    homeworld_rule21=2;
    aspirant_trial21=2;
    role_21= []
    race_21=[]
    wep1_21=[]
    wep2_21=[]
    armour_21=[]
    gear_21=[]
    mobi_21=[];

    // Pauldron2: Left, Pauldron: Right
    color_to_main21="Red"
    color_to_secondary21="";
    color_to_trim21="Red";
    color_to_pauldron21="Red"; 
    color_to_pauldron2_21="Red";
    color_to_lens21="Red";
    color_to_weapon21="Red";
    col_special21="Red";
    trim21=1;
    hapothecary21="Doc";
    hchaplain21="Warg";
    clibrarian21="Witch";
    fmaster21="Smith";
    admiral21="Sailor";
    recruiter21="Sarge";
    battle_cry_21="WAAAGH";
    monastery_name21="Okay";
    master_name21="SHH";
    equal_specialists21=1;

    load_to_ships=[2,0,0];
    // load_to_ships=0;

    successors21=4;
    mutations21=2;
    mutations_selected21=2;
    preomnor21=0;
    voice21=0;
    doomed21=0;
    lyman21=0;
    omophagea21=0;
    ossmodula21=0;
    membrane21=1;
    zygote21=0;
    betchers21=1;
    catalepsean21=0;
    secretions21=0;
    occulobe21=0;
    mucranoid21=0;
    disposition21[1]=20;// Prog
    disposition21[2]=20;
    disposition21[3]=20;
    disposition21[4]=20;
    disposition21[5]=20;
    disposition21[6]=20;// Astartes
    disposition21[7]=20;// Reserved
    chapter_master_name21="Git smacka";
    chapter_master_melee21=1;
    chapter_master_ranged21=1;
    chapter_master_specialty21=1;

    adv21[1]="Ambushers";
    adv21[2]="Boarders";
    adv21[3]="Crafters";
    adv21[4]="Enemy; Orks";

    dis21[1]="Suspicious";
    dis21[2]="Tolerant";
    dis21[3]="Blood Debt";
    dis21[4]="Sieged";
    i=100
	repeat(3){i+=1;// First is for the correct slot, second is for default
	race_21[i,2]=1;
    role_21[i,2]="Honour Guard";
    wep1_21[i,2]="Power Sword";
    wep2_21[i,2]="Bolter";
    armour_21[i,2]="Artificer Armour";
	gear_21[i,2]=""
	mobi_21[i,2]="";
	
    race_21[i,3]=1;
    role_21[i,3]="Veteran";
    wep1_21[i,3]="Chainsword";
    wep2_21[i,3]="Bolter";
    armour_21[i,3]="Power Armour";
	gear_21[i,3]=""
	mobi_21[i,3]="";
	
    race_21[i,4]=1;
    role_21[i,4]="Terminator";
    wep1_21[i,4]="Power Fist";
    wep2_21[i,4]="Storm Bolter";
    armour_21[i,4]="Terminator Armour";
	gear_21[i,4]=""
	mobi_21[i,4]="";
	
    race_21[i,5]=1;
    role_21[i,5]="Captain";
    wep1_21[i,5]="Power Sword";
    wep2_21[i,5]="Bolt Pistol";
    armour_21[i,5]="Power Armour";
	gear_21[i,5]="Iron Halo";
	mobi_21[i,15]="";
	
	
    race_21[i,6]=1;
    role_21[i,6]="Dreadnought";
    wep1_21[i,6]="Close Combat Weapon";
    wep2_21[i,6]="Twin Linked Lascannon";
    armour_21[i,6]="Dreadnought";
	gear_21[i,6]=""
	mobi_21[i,6]="";
	
    race_21[i,7]=1;
    role_21[i,7]="Champion";
    wep1_21[i,7]="Power Sword";
    wep2_21[i,7]="Bolt Pistol";
    armour_21[i,7]="Power Armour";
	gear_21[i,7]="Combat Shield"
	mobi_21[i,7]="";

        race_21[i,8]=1;
        role_21[i,8]="Tactical Marine";
        wep1_21[i,8]="Bolter";
        wep2_21[i,8]="Combat Knife";
        armour_21[i,8]="Power Armour";
        gear_21[i,8]=""
        mobi_21[i,8]="";

        race_21[i,9]=1;
        role_21[i,9]="Devastator Marine";
        wep1_21[i,9]="";
        wep2_21[i,9]="Combat Knife";
        armour_21[i,9]="Power Armour";
        gear_21[i,9]=""
        mobi_21[i,9]="";

        race_21[i,10]=1;
        role_21[i,10]="Assault Marine";
        wep1_21[i,10]="Chainsword";
        wep2_21[i,10]="Bolt Pistol";
        armour_21[i,10]="Power Armour";
        gear_21[i,10]=""
        mobi_21[i,10]="Jump Pack";

        race_21[i,11]=1;
        role_21[i,11]="Ancient";
        wep1_21[i,11]="Company Standard";
        wep2_21[i,11]="Power Sword";
        armour_21[i,11]="Power Armour";
        gear_21[i,11]=""
        mobi_21[i,11]="";

        race_21[i,12]=1;
        role_21[i,12]="Scout";
        wep1_21[i,12]="Sniper Rifle";
        wep2_21[i,12]="Combat Knife";
        armour_21[i,12]="Scout Armour";
        gear_21[i,12]=""
        mobi_21[i,12]="";

        race_21[i,14]=1;
        role_21[i,14]="Chaplain";
        wep1_21[i,14]="Crozius Arcanum";
        wep2_21[i,14]="Bolt Pistol";
        armour_21[i,14]="Power Armour";
        gear_21[i,14]="Rosarius";

        race_21[i,15]=1;
        role_21[i,15]="Apothecary";
        wep1_21[i,15]="Chainsword";
        wep2_21[i,15]="Bolt Pistol";
        armour_21[i,15]="Power Armour";
        gear_21[i,15]="Narthecium";

        race_21[i,16]=1;
        role_21[i,16]="Techmarine";
        wep1_21[i,16]="Power Axe";
        wep2_21[i,16]="Storm Bolter";
        armour_21[i,16]="Artificer Armour";
        mobi_21[i,16]="Servo-arm";
        gear_21[i,16]="";

        race_21[i,17]=1;
        role_21[i,17]="Librarian";
        wep1_21[i,17]="Force Staff";
        wep2_21[i,17]="Storm Bolter";
        armour_21[i,17]="Power Armour";
        gear_21[i,17]="Psychic Hood";

        race_21[i,18]=1;
        role_21[i,18]="Sergeant";
        wep1_21[i,18]="Chainsword";
        wep2_21[i,18]="Combiflamer";
        armour_21[i,18]="Power Armour";
        mobi_21[i,18]="";
        gear_21[i,18]="";

        race_21[i,19]=1;
        role_21[i,19]="Veteran Sergeant";
        wep1_21[i,19]="Chainsword";
        wep2_21[i,19]="Combiflamer";
        armour_21[i,19]="Power Armour";
        mobi_21[i,19]="";
        gear_21[i,19]="";
	}
	stage = 6;
}


// TODO refactor into struct constructors stored in which are struct arrays 

// meta provides a universal way to control not having contradictory advatages and disadvantages
// the player can not have any two advantages or disadvatages taht have the same piece of meta thus removing clunky checks in the draw sequence
chapter_trait_meta = [];
function ChapterTrait(_id, _name, _description, _points_cost, _meta = []) constructor{

    id = _id;
    name = _name;
    description = _description;
    points = _points_cost;
    disabled = false;
    meta = _meta;

    static add_meta = function(){
        for (var i=0;i<array_length(meta);i++){
            array_push(obj_creation.chapter_trait_meta, meta[i]);
        }
        show_debug_message($"Meta updated: {meta}");

    }
    static remove_meta = function(){
        for (var i=0;i<array_length(meta);i++){
            var len = array_length(obj_creation.chapter_trait_meta);
            for (var s=0;s<len;s++){
                if (obj_creation.chapter_trait_meta[s]==meta[i]){
                    array_delete(obj_creation.chapter_trait_meta, s, 1);
                    s--;
                    len--;
                }
            }
        }
        show_debug_message($"Meta updated: {meta}");
    }

    static print_meta = function(){
        if(array_length(meta) ==0){
            return "None";
        } else {
            return string_join_ext(", ", meta);
        }
    }

}

function Advantage(_id, _name, _description, _points_cost) : ChapterTrait(_id, _name, _description, _points_cost) constructor {

    static add = function(slot){
        show_debug_message($"Adding adv {name} to slot {slot} for points {points}");
        obj_creation.adv[slot] = name;
        obj_creation.adv_num[slot] = id;
        obj_creation.points+=points;
        add_meta();
    }
    static remove = function(slot){
        show_debug_message($"removing adv {name} from slot {slot} for points {points}");
        obj_creation.adv[slot] = "";
        obj_creation.points-=points;
        obj_creation.adv_num[slot]=0;
        remove_meta();
    }

    static disable = function(){
        var is_disabled= false;
        for (var i=0;i<array_length(meta);i++){
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])){
                is_disabled = true;
            }
        }
        if(obj_creation.points + points > obj_creation.maxpoints){
            is_disabled = true;
        }
        return is_disabled;
    }

}
function Disadvantage(_id, _name, _description, _points_cost) : ChapterTrait(_id, _name, _description, _points_cost) constructor {

    static add = function(slot){
        show_debug_message($"Adding disadv {name} to slot {slot} for points {points}");
        obj_creation.dis[slot] = name;
        obj_creation.dis_num[slot] = id;
        obj_creation.points-=points;
        add_meta();
    }

    static remove = function(slot){
        show_debug_message($"Removing disadv {name} from slot {slot} for points {points}");
        obj_creation.dis[slot] = "";
        obj_creation.points+=points;
        obj_creation.dis_num[slot]=0;
        remove_meta();
    }

    static disable = function(){
        var is_disabled= false;
        for (var i=0;i<array_length(meta);i++){
            if (array_contains(obj_creation.chapter_trait_meta, meta[i])){
                is_disabled = true;
            }
        }
        return is_disabled;
    }
}

//later we can use json maybe
/// @type {Array<Struct.Advantage>}
obj_creation.all_advantages = [];
var all_advantages = [
        {
            name : "",
            description : "",
            value : 0,
        },
        {
            name : "Ambushers",
            description : "Your chapter is especially trained with ambushing foes; they have a bonus to attack during the start of a battle.",
            value : 20,
        },
        {
            name : "Boarders",
            description : "Boarding other ships is the specialty of your chapter.  Your chapter is more lethal when boarding ships, have dedicated boarding squads, and two extra strike cruisers.",
            value : 20,
        },
        {
            name : "Bolter Drilling",
            description : "Bolter drills are sacred to your chapter; all marines have increased attack with Bolter weaponry.",
            value : 25,
        },
        {
            name : "Brothers",
            description : "Your chapter places great emphasis on comradely and loyalty.  You start with a well-equipped Honour Guard.",
            value : 20,
        },
        {
            name : "Crafters",
            description : "Your chapter views artifacts as sacred; you start with better gear and maintain all equipment with more ease.",
            value : 35,
        },
        {
            name : "Daemon Binders",
            description : "Powers are replaced with a more powerful Witchfire variant.  Perils are also less likely to occur but are more disasterous when they do.",
            value : 20,
        },
        {
            name : "Enemy: Eldar",
            description : "Eldar are particularly hated by your chapter.  When fighting Eldar damage is increased.",
            value : 10,
            meta : ["Main Enemy"],
        },
        {
            name : "Enemy: Fallen",
            description : "Chaos Marines are particularly hated by your chapter.  When fighting the traitors damage is increased.",
            value : 15,
            meta : ["Main Enemy"],
        },
        {
            name : "Enemy: Necrons",
            description : "Necrons are particularly hated by your chapter.  When fighting Necrons damage is increased.",
            value : 15,
            meta : ["Main Enemy"],
        },  
        {
            name : "Enemy: Orks",
            description : "Orks are particularly hated by your chapter.  When fighting Orks damage is increased.",
            value : 35,
            meta : ["Main Enemy"]
        },
        {
            name : "Enemy: Tau",
            description : "Tau are particularly hated by your chapter.  When fighting Tau damage is increased.",
            value : 20,
            meta : ["Main Enemy"],
        },
        {
            name : "Enemy: Tyranids",
            description : "Tyranids are particularly hated by your chapter. A large number of your veterans and marines are tyrannic war veterans and when fighting Tyranids damage is increased.",
            value : 25,
            meta : ["Main Enemy"],
        },
        {
            name : "Kings of Space",
            description : "Veterans of naval combat, your chapter fleet has bonuses to offense, defence, an additional battle barge, and may always be controlled regardless of whether or not the Chapter Master is present.",
            value : 40,
            meta : [],
        },
        {
            name : "Lightning Warriors",
            description : "Your chapter's style of warfare is built around the speedy execution of battle. Infantry have boosted attack at the cost of defense as well as two additional Land speeders and Biker squads.",
            value : 35,
            meta : ["Doctrine"],
        },
        {
            name : "Paragon",
            description : "You are a pale shadow of the primarchs.  Larger, stronger, faster, your Chapter Master is on a higher level than most, gaining additional health and combat effectiveness.",
            value : 10,
            meta : ["Chapter Master"],
        },
        {
            name : "Psyker Abundance",
            description : "The Psyker mutation runs rampant in your chapter.  Librarians train in 60% the normal time and receive bonus experience.",
            value : 30,
            meta : ["Psyker Views"],
        }, 
        {
            name : "Reverent Guardians",
            description : "Your chapter places great faith in the Imperial Cult; you start with more Chaplains and any Ecclesiarchy disposition increases are enhanced.",
            value : 10,
            meta : ["Faith","Imperium Trust"],
        },
        {
            name : "Tech-Brothers",
            description : "Your chapter has better ties to the mechanicus; you have more techmarines and higher mechanicus disposition.",
            value : 25,
            meta : ["Mechanicus Faith"],
        }, 
        {
            name : "Tech-Scavengers",
            description : "Your Astartes have a knack for finding what has been lost.  Items and wargear are periodically found and added to the Armamentarium.",
            value : 30,
        },
        {
            name : "Siege Masters",
            description : "Your chapter is familiar with the ins-and-outs of fortresses.  They are better at defending and attacking fortifications. And better at garrisoning",
            value : 15,
        },
        {
            name : "Slow and Purposeful",
            description : "Careful and steady is your chapters doctrine; all infantry have slightly less attack but boosted defences.",
            value : 15,
            meta : ["Doctrine"],
        },
        {
            name : "Melee Enthusiasts",
            description : "Rip and tear! Each Company has an additional Assault Squad.  Your marines and dreadnoughts also have boosted attack with melee weapons.",
            value : 15,
            meta : ["Doctrine"],
        },
        {
            name : "Venerable Ancients",
            description : "Even in death they still serve. Your chapter places a staunch reverence for its forebears and has a number of additional venerable dreadnoughts in service.",
            value : 25,
            meta : ["Doctrine"],
        },
        {
            name : "Medicae Primacy",
            description : "Your chapter reveres its Apothecarion above all of it's specialist; You start with more Apothecaries.",
            value : 25,
        },                                                                                                                                                                              
    ]


var new_adv,cur_adv;
for (var i=0;i<array_length(all_advantages);i++){
    cur_adv = all_advantages[i];
    new_adv = new Advantage(i, cur_adv.name, cur_adv.description, cur_adv.value);
    if (struct_exists(cur_adv, "meta")){
        new_adv.meta = cur_adv.meta;
    }
    array_push(obj_creation.all_advantages, new_adv);
}


//advantage[i]="Battle Cousins";
//advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;
//advantage[i]="Comrades in Arms";
//advantage_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;

/// @type {Array<Struct.Disadvantage>}
var all_disadvantages = [
    {
        name : "",
        description : "",
        value : 0,
    },
    {
        name : "Black Rage",
        description : "Your marines are susceptible to Black Rage, having a chance each battle to become Death Company.  These units are locked as Assault Marines and are fairly suicidal.",
        value : 30,
    },
    {
        name : "Blood Debt",
        description : "Prevents your Chapter from recruiting new Astartes until enough of your marines, or enemies, have been killed.  Incompatible with Penitent chapter types.",
        value : 50,
    },
    {
        name : "Fresh Blood",
        description : "Due to being newly created your chapter has little special wargear or psykers.",
        value : 30,
        meta : ["Status"],
    }, 
    {
        name : "Never Forgive",
        description : "In the past traitors broke off from your chapter.  They harbor incriminating secrets or heritical beliefs, and as thus, must be hunted down whenever possible.",
        value : 15,
    },
    {
        name : "Sieged",
        description : "A recent siege has reduced the number of your marines greatly.  You retain a normal amount of equipment but some is damaged.",
        value : 30,
        meta : ["Status"],
    },
    {
        name : "Splintered",
        description : "Your marines are unorganized and splintered.  You require greater time to respond to threats en masse.",
        value : 10,
        meta : ["Location"],
    },
    {
        name : "Suspicious",
        description : "Some of your chapter's past actions or current practices make the inquisition suspicious.  Their disposition is lowered.",
        value : 10,
        meta : ["Imperium Trust"],
    },
    {
        name : "Tech-Heresy",
        description : "Your chapter does things that makes the Mechanicus upset.  Mechanicus disposition is lowered and you have less Tech Marines. You start as a tech heretic tolerant chapter",
        value : 15,
        meta : ["Mechanicus Faith"],
    },
    {
        name : "Tolerant",
        description : "Your chapter is more lenient with xenos.  All xeno disposition is slightly increased and all Imperial disposition is lowered.",
        value : 10,
    },
    {
        name : "Warp Touched",
        description : "Your chapter is more lenient with xenos.  All xeno disposition is slightly increased and all Imperial disposition is lowered.",
        value : 10,
    },
    {
        name : "Psyker Intolerant",
        description : "Witches are hated by your chapter.  You cannot create Librarians but gain a little bonus attack against psykers.",
        value : 20,
        meta : ["Psyker Views"]
    },                  
]

obj_creation.all_disadvantages = []
var new_dis,cur_dis;
for (var i=0;i<array_length(all_disadvantages);i++){
    cur_dis = all_disadvantages[i];
    new_dis = new Disadvantage(i, cur_dis.name, cur_dis.description, cur_dis.value);
    if (struct_exists(cur_dis, "meta")){
        new_dis.meta = cur_dis.meta;
    }
    array_push(obj_creation.all_disadvantages, new_dis);
}
show_debug_message(obj_creation.all_advantages);
show_debug_message(obj_creation.all_disadvantages);



// disadvantage[i]="Embargo";dis_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;// Greatly increases the cost of common wargear and disallows advanced items.
// disadvantage[i]="First In, Last Out";dis_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;
// disadvantage[i]="Rival Brotherhood";dis_tooltip[i]="NOT IMPLEMENTED YET.";i+=1;

// Default Marine Loadouts
for(var slot = 99; slot <= 103; slot++){
    for(var i = 0; i <= 50; i++){
        race[slot,i]=1;
        loc[slot,i]="";
        role[slot,i]="";
        wep1[slot,i]="";
        wep2[slot,i]="";
        armour[slot,i]="";
        gear[slot,i]="";
        mobi[slot,i]="";
    }
}

defaults_slot = 100;

function load_default_gear(_role_id, _role_name, _wep1, _wep2, _armour, _mobi, _gear){
    role[defaults_slot, _role_id] = _role_name;
    wep1[defaults_slot, _role_id] = _wep1;
    wep2[defaults_slot, _role_id] = _wep2;
    armour[defaults_slot, _role_id] = _armour;
    mobi[defaults_slot, _role_id] = _mobi;
    gear[defaults_slot, _role_id] = _gear;
    race[defaults_slot, _role_id] = 1;
}
load_default_gear(Role.HONOUR_GUARD, "Honour Guard", "Power Sword", "Bolter", "Artificer Armour", "", "");
load_default_gear(Role.VETERAN, "Veteran", "Chainsword", "Combiflamer", "Power Armour", "", "");
load_default_gear(Role.TERMINATOR, "Terminator", "Power Fist", "Storm Bolter", "Terminator Armour", "", "");
load_default_gear(Role.CAPTAIN, "Captain", "Power Sword", "Bolt Pistol", "Power Armour", "", "Iron Halo");
load_default_gear(Role.DREADNOUGHT, "Dreadnought", "Dreadnought Lightning Claw", "Lascannon", "Dreadnought", "", "");
load_default_gear(Role.CHAMPION, "Champion", "Power Sword", "Power Armour", "Power Armour", "", "Combat Shield");
load_default_gear(Role.TACTICAL, "Tactical", "Bolter", "Combat Knife", "Power Armour", "", "");
load_default_gear(Role.DEVASTATOR, "Devastator", "", "Combat Knife", "Power Armour", "", "");
load_default_gear(Role.ASSAULT, "Assault", "Chainsword", "Bolt Pistol", "Power Armour", "Jump Pack", "");
load_default_gear(Role.ANCIENT, "Ancient", "Company Standard", "Bolt Pistol", "Power Armour", "", "");
load_default_gear(Role.SCOUT, "Scout", "Bolter", "Combat Knife", "Scout Armour", "", "");
load_default_gear(Role.CHAPLAIN, "Chaplain", "Crozius Arcanum", "Bolt Pistol", "Power Armour", "", "Rosarius");
load_default_gear(Role.APOTHECARY, "Apothecary", "Chainsword", "Bolt Pistol", "Power Armour", "", "Narthecium");
load_default_gear(Role.TECHMARINE, "Techmarine", "Power Axe", "Bolt Pistol", "Artificer Armour", "Servo-arm", "");
load_default_gear(Role.LIBRARIAN, "Librarian", "Force Staff", "Bolt Pistol", "Power Armour", "", "Psychic Hood");
load_default_gear(Role.SERGEANT, "Sergeant", "Chainsword", "Bolt Pistol", "Power Armour", "", "");
load_default_gear(Role.VETERAN_SERGEANT, "Veteran Sergeant", "Chainsword", "Plasma Pistol", "Power Armour", "", "");




if (global.restart>0){
    fade_in=-1;
    slate1=-1;
    slate=22;
    slate3=22;
    slate4=50;
    
    change_slide=0;
    slide=2;
    slide_show=2;
    
    scr_restart_variables(4);
    with(obj_restart_vars){instance_destroy();}
    global.restart=0;
}


if (skip=true){
    fade_in=-1;
    slate1=-1;
    slate=22;
    slate3=22;
    slate4=50;
    
    change_slide=0;
    slide=6;
    slide_show=slide;
    
    icon_name="ih";
    icon=6;founding=6;
    
    chapter_name="Sons of Duke";
    custom=2;
    battle_cry="The flesh is weak!  The flesh is weak!  The flesh is weak!  The flesh is weak!  The flesh is weak";
    
    purity=5;
    
    /*main_color=5;secondary_color=5;main_trim=2;
    left_pauldron=5;// Left pauldron
    right_pauldron=5;// Right pauldron
    lens_color=7;weapon_color=2;col_special=0;*/
    
    main_color=7;
    secondary_color=5;
    main_trim=5;
    left_pauldron=5;// Left pauldron
    right_pauldron=5;// Right pauldron
    lens_color=6;
    weapon_color=4;
    col_special=0;
    
    scr_chapter_new("Doom Benefactors");
}

/* */
col = [];
col_r = [];
col_g = [];
col_b = [];

scr_colors_initialize();

/// todo turn this into an array of structs with dynamic access
/// todo change references to colours by number to use the Colours enum

	colour_to_find1 = shader_get_uniform(sReplaceColor, "f_Colour1");
	colour_to_set1 = shader_get_uniform(sReplaceColor, "f_Replace1");
	body_colour_find=[0/255,0/255,255/255];
	body_colour_replace=[
		col_r[main_color]/255,
		col_g[main_color]/255,
		col_b[main_color]/255,

	]

	colour_to_find2 = shader_get_uniform(sReplaceColor, "f_Colour2");
	colour_to_set2 = shader_get_uniform(sReplaceColor, "f_Replace2");
	secondary_colour_find=[255/255,0/255,0/255];
	secondary_colour_replace=[
		col_r[secondary_color]/255,
		col_g[secondary_color]/255,
		col_b[secondary_color]/255,

	];

	colour_to_find3 = shader_get_uniform(sReplaceColor, "f_Colour3");
	colour_to_set3 = shader_get_uniform(sReplaceColor, "f_Replace3");

	pauldron_colour_find=[255/255,255/255,0/255];
	pauldron_colour_replace=[
		col_r[right_pauldron]/255,
		col_g[right_pauldron]/255,
		col_b[right_pauldron]/255,

	];

	colour_to_find4 = shader_get_uniform(sReplaceColor, "f_Colour4");
	colour_to_set4 = shader_get_uniform(sReplaceColor, "f_Replace4");
	lens_colour_find=[0/255,255/255,0/255];
	lens_colour_replace=[
		col_r[lens_color]/255,
		col_g[lens_color]/255,
		col_b[lens_color]/255,

	];

	colour_to_find5 = shader_get_uniform(sReplaceColor, "f_Colour5");
	colour_to_set5 = shader_get_uniform(sReplaceColor, "f_Replace5");
	trim_colour_find=[255/255,0/255,255/255];
	trim_colour_replace=[
		col_r[main_trim]/255,
		col_g[main_trim]/255,
		col_b[main_trim]/255,
	];

	colour_to_find6 = shader_get_uniform(sReplaceColor, "f_Colour6");
	colour_to_set6 = shader_get_uniform(sReplaceColor, "f_Replace6");
	pauldron2_colour_find=[250/255,250/255,250/255];
	pauldron2_colour_replace=[
		col_r[left_pauldron]/255,
		col_g[left_pauldron]/255,
		col_b[left_pauldron]/255,

	];

	colour_to_find7 = shader_get_uniform(sReplaceColor, "f_Colour7");
	colour_to_set7 = shader_get_uniform(sReplaceColor, "f_Replace7");

	weapon_colour_find=[0/255,255/255,255/255];
	weapon_colour_replace=[
		col_r[weapon_color]/255,
		col_g[weapon_color]/255,
		col_b[weapon_color]/255,
	];
/* */
action_set_alarm(30, 1);
/*  */

	

/// @description Constructor for loading Chapter data from JSON and providing type completion
function ChapterData() constructor {
	id = CHAPTERS.UNKNOWN;
	name = "";
	points = 0;
	flavor = "";
	origin = CHAPTER_ORIGIN.NONE;
	founding = CHAPTERS.UNKNOWN;
	successors = 0;
	splash = 0;
	icon = 0;
	icon_name = "";
	aspirant_trial = eTrials.BLOODDUEL;
	fleet_type = FLEET_TYPE.NONE;
	strength = 0;
	purity = 0;
	stability = 0;
	cooperation = 0;
	homeworld_exists = 0;
	recruiting_exists = 0;
	homeworld_rule = HOMEWORLD_RULE.NONE;
	advantages = [];
	disadvantages = [];

	full_liveries = "none"

	colors = {
		main: "Grey",
		secondary: "Grey",
		pauldron_r: "Grey",
		pauldron_l: "Grey",
		trim: "Grey",
		lens: "Grey",
		weapon: "Grey",
		/// 0 - normal, 1 - Breastplate, 2 - Vertical, 3 - Quadrant
		special: 0,
		/// 0 no, 1 yes for special trim colours
		trim_on: 0,
	};
	names = {
		hchaplain: "",
		clibrarian: "",
		fmaster: "",
		hapothecary: "",
		honorcapt: "",
		watchmaster: "",
		arsenalmaster: "",
		admiral: "",
		marchmaster: "",
		ritesmaster: "",
		victualler: "",
		lordexec: "",
		relmaster: "",
		recruiter: "",
	};
	mutations = {
		preomnor: 0,
		voice: 0,
		doomed: 0,
		lyman: 0,
		omophagea: 0,
		ossmodula: 0,
		membrane: 0,
		zygote: 0,
		betchers: 0,
		catalepsean: 0,
		secretions: 0,
		occulobe: 0,
		mucranoid: 0,
	};
	battle_cry = "For the Emperor!";
	equal_specialists = 0;
	load_to_ships = {
		escort_load: 0,
		split_scouts: 0,
		split_vets: 0,
	};
	/// @type {Array<Real>} 
	disposition = [];
	/// @type {Array<String>} 
	company_titles = [];
	chapter_master = {
		name: "",
		melee: 0,
		ranged: 0,
		specialty: CM_SPECIALTY.NONE,
		/// @type {Array<String>}
		traits: []
	};

	/// @desc Returns true if loaded successfully, false if not. Should probably crash the game if false
	/// @param {Enum.CHAPTERS} chapter_id 
	/// @returns {Bool} 
	function load_from_json(chapter_id){
		var file_loader = new JsonFileListLoader();

		var load_result = file_loader.load_struct_from_json_file($"main\\chapters\\{chapter_id}.json", "chapter");
		if(!load_result.is_success){
			debugl($"No chapter json exits for chapter_id {chapter_id}");
			return false;
		}
		var json_chapter = load_result.value.chapter;
		var keys = struct_get_names(json_chapter);
		for(var i = 0; i < array_length(keys); i++){
			var key = keys[i];
			var val = struct_get(json_chapter, key);
			struct_set(self, key, val);
		}
		return true;
	}
}

/// @mixin obj_creation
function scr_chapter_new(argument0) {

	full_liveries = "none"; // until chapter objects are in full use kicks off livery propogation

	// argument0 = chapter
	obj_creation.use_chapter_object = 0; // for the new json testing
	var chapter_id = CHAPTERS.UNKNOWN;

	//1st captain =	honor_captain_name	
	//2nd captain =	watch_master_name	
	//3rd captain = arsenal_master_name	
	//4th captain =	lord_admiral_name
	//5th captain =	march_master_name
	//6th captain =	rites_master_name
	//7th captain =	chief_victualler_name
	//8th captain =	lord_executioner_name
	//9th captain =	relic_master_name
	//10th captain = recruiter_name

	var i;i=-1;
	repeat(21){i+=1;world[i]="";world_type[i]="";world_feature[i]="";}
	var i;i=-1;repeat(6){i+=1;adv[i]="";adv_num[i]=0;dis[i]="";dis_num[i]=0;}
	points=100;maxpoints=100;custom=0;
	//Chapter Staff
	hapothecary=global.name_generator.generate_space_marine_name();
	hchaplain=global.name_generator.generate_space_marine_name();
	clibrarian=global.name_generator.generate_space_marine_name();
	fmaster=global.name_generator.generate_space_marine_name();
	//Company Captains
	honorcapt=global.name_generator.generate_space_marine_name();
	watchmaster=global.name_generator.generate_space_marine_name();
	arsenalmaster=global.name_generator.generate_space_marine_name();
	admiral=global.name_generator.generate_space_marine_name();
	marchmaster=global.name_generator.generate_space_marine_name();
	ritesmaster=global.name_generator.generate_space_marine_name();
	victualler=global.name_generator.generate_space_marine_name();
	lordexec=global.name_generator.generate_space_marine_name();
	relmaster=global.name_generator.generate_space_marine_name();
	recruiter=global.name_generator.generate_space_marine_name();
	
	i=99;
	repeat(3){i+=1;// First is for the correct slot, second is for default
	    role[i,2]="Honour Guard";wep1[i,2]="Power Sword";wep2[i,2]="Bolter";armour[i,2]="Artificer Armour";
	    role[i,3]="Veteran";wep1[i,3]="Chainsword";wep2[i,3]="Combiflamer";armour[i,3]="Power Armour";
	    role[i,4]="Terminator";wep1[i,4]="Power Fist";wep2[i,4]="Storm Bolter";armour[i,4]="Terminator Armour";
	    role[i,5]="Captain";wep1[i,5]="Power Sword";wep2[i,5]="Bolt Pistol";armour[i,5]="Power Armour";gear[i,5]="Iron Halo";
	    role[i,6]="Dreadnought";wep1[i,6]="Close Combat Weapon";wep2[i,6]="Lascannon";armour[i,6]="Dreadnought";
	    role[i,8]="Tactical Marine";wep1[i,8]="Bolter";wep2[i,8]="Combat Knife";armour[i,8]="Power Armour";
	    role[i,9]="Devastator Marine";wep1[i,9]="Heavy Ranged";wep2[i,9]="Combat Knife";armour[i,9]="Power Armour";mobi[i,9]="Heavy Weapons Pack";
	    role[i,10]="Assault Marine";wep1[i,10]="Chainsword";wep2[i,10]="Bolt Pistol";armour[i,10]="Power Armour";mobi[i,10]="Jump Pack";
		role[i,11]="Ancient";wep1[i,11]="Company Standard";wep2[i,11]="Bolt Pistol";armour[i,11]="Power Armour";
	    role[i,12]="Scout";wep1[i,12]="Bolter";wep2[i,12]="Combat Knife";armour[i,12]="Scout Armour";
	    role[i,14]="Chaplain";wep1[i,14]="Crozius Arcanum";wep2[i,14]="Bolt Pistol";armour[i,14]="Power Armour";gear[i,14]="Rosarius";
	    role[i,15]="Apothecary";wep1[i,15]="Chainsword";wep2[i,15]="Bolt Pistol";armour[i,15]="Power Armour";gear[i,15]="Narthecium";
	    role[i,16]="Techmarine";wep1[i,16]="Power Axe";wep2[i,16]="Bolt Pistol";armour[i,16]="Artificer Armour";mobi[i,16]="Servo-arm";gear[i,16]="";
	    role[i,17]="Librarian";wep1[i,17]="Force Staff";wep2[i,17]="Bolt Pistol";armour[i,17]="Power Armour";gear[i,17]="Psychic Hood";
		role[i,18]="Sergeant";wep1[i,18]="Chainsword";wep2[i,18]="Bolt Pistol";armour[i,18]="Power Armour";gear[i,18]="";
		role[i,19]="Veteran Sergeant";wep1[i,19]="Chainsword";wep2[i,19]="Plasma Pistol";armour[i,19]="Power Armour";gear[i,19]="";
	}i=100;


	for(var c = 0; c < array_length(obj_creation.all_chapters); c++){
		if(argument0 == obj_creation.all_chapters[c].name && obj_creation.all_chapters[c].json == true){
			obj_creation.use_chapter_object = 1;
			chapter_id = obj_creation.all_chapters[c].id;
		}
	}

	if (argument0=="Dark Angels" || argument0 == CHAPTERS.DARK_ANGELS){
		obj_creation.use_chapter_object = 1;
		chapter_id = CHAPTERS.DARK_ANGELS;

		#region old data
		// founding="N/A";points=150;
	    // selected_chapter=1;chapter=argument0;icon=1;icon_name="da";founding=0;fleet_type=1;strength=10;purity=8;stability=10;cooperation=5;
	    // homeworld="Dead";homeworld_name="The Rock";recruiting="Death";recruiting_name="Kimmeria";
	    // homeworld_exists=1;recruiting_exists=1;homeworld_rule=3;aspirant_trial=eTrials.SURVIVAL;
	    // adv[1]="Enemy: Fallen";dis[1]="Never Forgive";
	    // // Pauldron2: Left, Pauldron: Right
	    // color_to_main="Caliban Green";color_to_secondary="Caliban Green";color_to_trim="Grey";
	    // color_to_pauldron="Caliban Green";color_to_pauldron2="Caliban Green";color_to_lens="Red";
	    // color_to_weapon="Dark Red";col_special=0;trim=0;

	    // hchaplain="Sapphon";clibrarian="Ezekial";fmaster="Sepharon";hapothecary="Razaek";
		// honorcapt="Belial";watchmaster="Sammael";arsenalmaster="Astoran";admiral="Korahael";marchmaster="Balthazar";
		// ritesmaster="Araphil";victualler="Ezekiah";lordexec="Molochi";relmaster="Xerophus";recruiter="Ranaeus";
	    // battle_cry="Repent!  For tomorow you may die";
	    // equal_specialists=0;load_to_ships=[2,0,0];successors=9;
	    // mutations=0;mutations_selected=0;
	    // preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    // zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    // // disposition[1]=0;// Prog
	    // disposition[2]=65;disposition[3]=60;disposition[4]=60;disposition[5]=60;
	    // disposition[6]=50;// Astartes
	    // disposition[7]=0;// Reserved
	    // chapter_master_name="Azreal";chapter_master_specialty=2;
	    // chapter_master_melee=5;chapter_master_ranged=4;
		
	    // company_title[1]="Deathwing";
	    // company_title[2]="Ravenwing";
	    // company_title[3]="The Unmerciful";
		// company_title[4]="The Feared";
		// company_title[5]="The Unrelenting";
		// company_title[6]="The Resolute";
		// company_title[7]="The Unbowed";
		// company_title[8]="The Wrathful";
		// company_title[9]="The Remorseless";
		// company_title[10]="The Redeemed";
		
		// for(i=100;i<=102;i++){
		// // role[i,1]="Supreme Grand Master";
		// role[i,5]="Master";
		// wep1[i,5]="Power Sword";
		// role[i,2]="Deathwing Knight"
	
		// }
		#endregion


	}
		if (argument0=="White Scars" || argument0 == CHAPTERS.WHITE_SCARS){

		obj_creation.use_chapter_object = 0;
		chapter_id = CHAPTERS.WHITE_SCARS;
		#region data
		points=150;
		    selected_chapter=2;chapter=argument0;icon=2;icon_name="ws";founding=0;fleet_type=1;strength=5;purity=10;stability=8;cooperation=5;
		    homeworld="Feudal";homeworld_name="Chogoris";
		    homeworld_exists=1;recruiting_exists=0;homeworld_rule=3;aspirant_trial=eTrials.SURVIVAL;discipline="rune Magick";
			adv[1]="Lightning Warriors";adv[2]="Brothers, All";adv[3]="Melee Enthusiasts";dis[1]="Splintered";
		    // Pauldron2: Left, Pauldron: Right
		    color_to_main="White";color_to_secondary="White";color_to_trim="Red";
		    color_to_pauldron="White";color_to_pauldron2="White";color_to_lens="Red";
		    color_to_weapon="Black";col_special=0;
		    hapothecary="Ogholei";hchaplain="Jaghorin";clibrarian="Saghai";fmaster="Khamkar";
			honorcapt="Jurga";watchmaster="Khajog";arsenalmaster="Kor'sarro";admiral="Joghaten";
			marchmaster="Suboden";ritesmaster="Seglei";victualler="Dorghai";lordexec="Vorgha";relmaster="Khadajei";
			recruiter="Jodagha";
		    battle_cry="For the Emperor and the Khan!";// monastery_name="Quan Zhou";master_name=
		    equal_specialists=0;load_to_ships=[2,0,0];successors=12;
		    mutations=0;mutations_selected=0;
		    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
		    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
		    // disposition[1]=0;// Prog
		    disposition[2]=50;disposition[3]=50;disposition[4]=50;disposition[5]=50;
		    disposition[6]=65;// Astartes
		    disposition[7]=0;// Reserved
		    chapter_master_name="Jubal Khan";chapter_master_melee=5;
		    chapter_master_ranged=3;chapter_master_specialty=1;
		    company_title[1]="The Spearpoint Brotherhood";company_title[2]="The Firefist Brotherhood";company_title[3]="The Eagle Brotherhood";
		    company_title[4]="The Tulwar Brotherhood";company_title[5]="The Stormwrath Brotherhood";company_title[6]="The Hawkeye Brotherhood";
			company_title[7]="The Plainstalker Brotherhood";company_title[8]="The Bloodrider Brotherhood";company_title[9]="The Stormbolt Brotherhood";
			company_title[10]="The Windspeaker Brotherhood";
			
			i=99;repeat(3){i+=1;
			role[i,2]="Keshig";wep1[i,2]="Power Sword";wep2[i,2]="Bolter";armour[i,2]="Terminator Armour";
			role[i,5]="Khan";wep1[i,5]="Power Sword"
			role[i,15]="Emchi";
			role[i,17]="Stormseer";
			
			}
		#endregion
	}

	if(obj_creation.use_chapter_object == 1){

		var chapter_obj = new ChapterData();
		var successfully_loaded = chapter_obj.load_from_json(chapter_id);
		if(!successfully_loaded){
			var issue = $"No json file exists for chapter id {chapter_id} and name {argument0}";
			debugl (issue);
			scr_popup("Error Loading Chapter", issue, "debug");
			return false;
		}

		global.chapter_creation_object = chapter_obj;


	}


	#region V1 Chapter Initialised factions

	if (argument0="Ultramarines"){points=150;
	    selected_chapter=7;chapter=argument0;icon=7;icon_name="um";founding=0;fleet_type=1;strength=5;purity=10;stability=10;cooperation=10;
	    homeworld="Temperate";homeworld_name="Macragge";recruiting="Death";recruiting_name="Parmenio";
	    homeworld_exists=1;recruiting_exists=1;homeworld_rule=3;aspirant_trial=eTrials.EXPOSURE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Dark Ultramarine";color_to_secondary="Dark Ultramarine";color_to_trim="Gold";
	    color_to_pauldron="Dark Ultramarine";color_to_pauldron2="Dark Ultramarine";color_to_lens="Red";
	    color_to_weapon="Red";col_special=0;
	    hapothecary="Corpus Helix";hchaplain="Ortan Cassius";clibrarian="Varro Tigurius";fmaster="Fennias Maxim";
		honorcapt="Severus Agemman";watchmaster="Cato Sicarius";arsenalmaster="Mikael Fabian";admiral="Uriel Ventris";
		marchmaster="Caito Galenus";ritesmaster="Maximus Epathus";victualler="Gerad Ixion";lordexec="Numitor";relmaster="Sinon";
		recruiter="Antilochus";
	    battle_cry="Courage and honor";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=0;load_to_ships=[2,0,0];successors=27;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    // disposition[1]=0;// Prog
	    disposition[2]=80;disposition[3]=65;disposition[4]=65;disposition[5]=65;
	    disposition[6]=65;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Marneus Calgar";chapter_master_melee=1;
	    chapter_master_ranged=1;chapter_master_specialty=1;
	    company_title[1]="Warriors of Ultramar"; company_title[2]="Guardians of the Temple"; company_title[3]="Scourge of the Xenos";
	    company_title[4]="Defenders of Ultramar"; company_title[5]="Wardens of the Eastern Fringe"; company_title[6]="Brethren of the Forge";
		company_title[7]="Defenders of Caeserean"; company_title[8]="Honourblades"; company_title[9]="Stormbringers";
		company_title[10]="The Scions of Ultramar";

	}
	//Waiting on new disadv to give anymore adv.
  if (argument0="Imperial Fists"){points=150;
		selected_chapter=4;chapter=argument0;icon=4;icon_name="if";founding=0;fleet_type=1;strength=6;purity=7;stability=10;cooperation=8;
		adv[1]="Bolter Drilling";adv[2]="Siege Masters";
		homeworld="Ice";homeworld_name="Inwit";recruiting="Hive";recruiting_name="Necromunda";
		homeworld_exists=1;recruiting_exists=1;homeworld_rule=2;aspirant_trial=eTrials.SURVIVAL;discipline="telekinesis";

		color_to_main="Gold";color_to_secondary="Gold";color_to_trim="Red";color_to_pauldron="Gold"
		color_to_pauldron2="Gold";color_to_lens="Red";color_to_weapon="Black"
		hapothecary="Dyserna";hchaplain="Guaron";clibrarian="Vidos Harn";fmaster="Atornus Geis";
		admiral="Kyne Phasn";honorcapt="Darnath Lysander";watchmaster="Helion";arsenalmaster="Tor Garadon";;marchmaster="Maluan";
		ritesmaster="Antaros";victualler="Jonas";lordexec="Chalosa";relmaster="Kaheron";recruiter="Taelos";

		battle_cry="Primarch-Progenitor, to your glory and the glory of him on earth!";
	        equal_specialists=0;load_to_ships=[2,0,0];
			successors=21;
	        mutations=2;mutations_selected=2;
	        preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=1;
	        zygote=0;betchers=1;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	        // disposition[1]=0;// Prog
	        disposition[2]=75;disposition[3]=60;disposition[4]=50;disposition[5]=60;
	        disposition[6]=60;// Astartes
	        disposition[7]=0;// Reserved
	        chapter_master_name="Vorn Hagen";chapter_master_melee=4;
	        chapter_master_ranged=7;chapter_master_specialty=1;

	        company_title[1]="The Fists of Dorn";company_title[2]="The Scions of Redemption";company_title[3]="The Sentinels of Terra";
	        company_title[4]="The Reductors";company_title[5]="The Heralds of Truth";company_title[6]="The Siege Hammers";
	        company_title[7]="Guardians of Phalanx";company_title[8]="Dorn's Huscarls";company_title[9]="The Wardens";
	        company_title[10]="The Eyes of Dorn";

	    i=99;repeat(3){
	    	i+=1;
	        role[i,2]="Huscarl";wep1[i,2]="Power Sword";wep2[i,2]="Storm Shield";armour[i,2]="Power Armour";
		}
	}


	if (argument0="Space Wolves"){points=150;
	    selected_chapter=3;chapter=argument0;icon=3;icon_name="sw";founding=0;fleet_type=1;strength=10;purity=8;stability=5;cooperation=4;
	    adv[1]="Melee Enthusiasts";dis[1]="Black Rage";dis[2]="Suspicious";
	    homeworld="Ice";homeworld_name="Fenris";
	    homeworld_exists=1;recruiting_exists=0;homeworld_rule=2;aspirant_trial=eTrials.EXPOSURE;discipline="rune Magick";
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Fenrisian Grey";color_to_secondary="Fenrisian Grey";color_to_trim="Dark Gold";
	    color_to_pauldron="Dark Gold";color_to_pauldron2="Dark Gold";color_to_lens="Red";
	    color_to_weapon="Dark Gold";col_special=0;trim=0;
	    hapothecary="Ulstvan Morkaison";hchaplain="Ulrik the Slayer";clibrarian="Njal Stormcaller";fmaster="Krom Dragongaze";
		honorcapt="Bran Redmaw";watchmaster="Engir Krakendoom";arsenalmaster="Erik Morkai";admiral="Gunnar Red Moon";marchmaster="Harald Deathwolf";
		ritesmaster="Bjorn Stormwolf";victualler="Vorek Gnarlfist";lordexec="Krom Dragongaze";relmaster="Ragnar Blackmane";recruiter="Sven Bloodhowl";
	    battle_cry="For Russ and the Allfather";// monastery_name="The Fang";master_name=
	    equal_specialists=1;load_to_ships=[2,0,0];successors=1;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    // disposition[1]=0;// Prog
	    disposition[2]=50;disposition[3]=40;disposition[4]=15;disposition[5]=15;
	    disposition[6]=40;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Logan Grimnar";chapter_master_melee=6;
	    chapter_master_ranged=1;chapter_master_specialty=2;
		
		//Weird since they have 13 companies if the hard coding changes in the future this will as well
	    /*company_title[0]="Champions of Fenris";*/company_title[1]="The Bloodmaws";company_title[2]="The Seawolves";
	    company_title[3]="The Sons of Morkai";company_title[4]="The Red Moons";company_title[5]="The Deathwolves";
	    company_title[6]="The Stormwolves";company_title[7]="The Ironwolves";company_title[8]="The Drakeslayers";
	    company_title[9]="The Blackmanes";/*company_title[10]="The Firehowlers";company_title[12]="The Grimbloods";
	    company_title[13]="The Wulfen";*/
    
	    i=99;repeat(3){i+=1;
	        role[i,2]="Wolf Guard";wep1[i,2]="Power Axe";wep2[i,2]="Bolter";armour[i,2]="Power Armour";
	        role[i,3]="Veteran";wep1[i,3]="Chainaxe";
	        role[i,5]="Wolf Lord";role[i,8]="Grey Hunter";role[i,9]="Long Fang";
	        role[i,10]="Blood Claw";wep1[i,10]="Chainaxe";
	        role[i,12]="Wolf Scout";wep1[i,12]="Sniper Rifle";wep2[i,12]="Chainaxe";
	        race[i,14]=0;role[i,14]="Wolf Priest";wep1[i,14]="Power Axe";
	        role[i,15]="Wolf Priest";wep1[i,15]="Power Axe";
	        role[i,16]="Iron Priest";wep1[i,16]="Power Axe";
	        role[i,17]="Rune Priest";wep1[i,17]="Force Staff";
			role[i,18]="Pack Leader";wep1[i,18]="Chainaxe";
			role[i,19]="Wolf Guard Pack Leader";wep1[i,19]="Chainaxe";
	    }
	}




	if (argument0="Blood Angels"){points=150;
	    selected_chapter=5;chapter=argument0;icon=5;icon_name="ba";founding=0;fleet_type=1;strength=5;purity=9;stability=9;cooperation=7;
	    adv[1]="Melee Enthusiasts";dis[1]="Black Rage";
	    homeworld="Desert";homeworld_name="Baal";
	    homeworld_exists=1;recruiting_exists=0;homeworld_rule=3;aspirant_trial=eTrials.BLOODDUEL;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Sanguine Red";color_to_secondary="Sanguine Red";color_to_trim="Lighter Black";
	    color_to_pauldron="Sanguine Red";color_to_pauldron2="Sanguine Red";color_to_lens="Lime";
	    color_to_weapon="Black";col_special=0;trim=0;
	    hchaplain="Astorath the Grim";clibrarian="Mephiston";fmaster="Incarael";hapothecary="Corbulo";
		honorcapt="Areno Karlaen";watchmaster="Donatos Aphael";arsenalmaster="Machiavi";admiral="Castigon";marchmaster="Sendini";
		ritesmaster="Raxiatel";victualler="Phaeton";lordexec="Zedrenael";relmaster="Sendroth";recruiter="Borgio";
	    battle_cry="For the Emperor and Sanguinius! Death! DEATH";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=0;load_to_ships=[2,0,0];successors=3;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    // disposition[1]=0;// Prog
	    disposition[2]=75;disposition[3]=60;disposition[4]=50;disposition[5]=60;
	    disposition[6]=60;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Dante";chapter_master_melee=6;
	    chapter_master_ranged=2;chapter_master_specialty=2;
	    company_title[1]="Archangels";company_title[2]="The Blooded";company_title[3]="Ironhelms";
	    company_title[4]="Knights of Baal";company_title[5]="Daemonbanes";company_title[6]="Eternals";
	    company_title[7]="Unconquerables";company_title[8]="Bloodbanes";company_title[9]="Sunderers";
	    company_title[10]="Redeemers";
    
	    i=99;repeat(3){i+=1;
	        role[i,2]="Sanguinary Guard";wep1[i,2]="Power Axe";wep2[i,2]="Bolt Pistol";mobi[i,2]="Jump Pack";
	        role[i,15]="Sanguinary Priest";wep1[i,15]="Power Axe";
	    }
	}


	if (argument0="Iron Hands"){points=150;
	    selected_chapter=6;chapter=argument0;icon=6;icon_name="ih";founding=0;fleet_type=1;strength=5;purity=8;stability=8;cooperation=2;
	    adv[1]="Tech-Brothers";adv[2]="Slow and Purposeful";dis[1]="Splintered";dis[2]="Suspicious";
	    homeworld="Lava";homeworld_name="Medusa";homeworld_exists=1;recruiting_exists=0;
	    homeworld_rule=3;aspirant_trial=eTrials.KNOWLEDGE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Black";color_to_secondary="Black";color_to_trim="Silver";
	    color_to_pauldron="Black";color_to_pauldron2="Black";color_to_lens="Dark Red";
	    color_to_weapon="Silver";col_special=0;trim=0;
	    hchaplain="Jorggir Shidd";clibrarian="Lydriik";fmaster="Feirros";hapothecary="Anaar Telech";
		honorcapt="Caanok Var";watchmaster="Eutuun Hes";arsenalmaster="Sind Grolvoch";admiral="Maarkul Rumann";marchmaster="Tyrrod";
		ritesmaster="Golloth";victualler="Raan";lordexec="Doroor Hesh";relmaster="Verrox";recruiter="Telavech";
	    battle_cry="The flesh is weak";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=1;load_to_ships=[2,0,0];successors=6;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    // disposition[1]=0;// Prog
	    disposition[2]=30;disposition[3]=80;disposition[4]=35;disposition[5]=30;
	    disposition[6]=50;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Kardan Stronos";chapter_master_melee=4;
	    chapter_master_ranged=3;chapter_master_specialty=2;
    
	    company_title[1]="Clan Avernii";company_title[2]="Clan Garrsak";company_title[3]="Clan Raukaan";
	    company_title[4]="Clan Kaargul";company_title[5]="Clan Haarmek";company_title[6]="Clan Sorrgol";
	    company_title[7]="Clan Borrgos";company_title[8]="Clan Morlaag";company_title[9]="Clan Vurgaan";
	    company_title[10]="Clan Dorrvok";
    
	   for(i=100;i<=102;i++){
	        race[i,14]=0;role[i,14]="Iron Father";role[i,16]="Iron Father";
			role[i,5]="Iron Captain";wep1[i,5]="Power Axe";
	    }
	}



	if (argument0="Salamanders"){points=150;
	    selected_chapter=8;chapter=argument0;icon=8;icon_name="sl";founding=0;fleet_type=1;strength=2;purity=8;stability=8;cooperation=10;
	    adv[1]="Crafters";adv[2]="Slow and Purposeful";
	    homeworld="Lava";homeworld_name="Nocturne";homeworld_exists=1;recruiting_exists=0;
	    homeworld_rule=1;aspirant_trial=eTrials.APPRENTICESHIP;discipline="pyromancy";
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Firedrake Green";color_to_secondary="Firedrake Green";color_to_trim="Dark Gold";
	    color_to_pauldron="Black";color_to_pauldron2="Black";color_to_lens="Red";
	    color_to_weapon="Black";col_special=0;trim=0;
	    fmaster="Argos";clibrarian="Velcona";hapothecary="Harath Shen";hchaplain="Leotrak Esar";
		watchmaster="Pellas Mir'San";arsenalmaster="Adrax Agatone" admiral="Dac'tyr";
		marchmaster="Mulcebor";ritesmaster="Ur'zan Draakgard";recruiter="Sol Ba'ken";
	    battle_cry="Into the fires of battle!  Unto the anvil of war";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=0;load_to_ships=[2,0,0];successors=2;
	    mutations=1;mutations_selected=1;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=1;occulobe=0;mucranoid=0;
	    // disposition[1]=0;// Prog
	    disposition[2]=80;disposition[3]=65;disposition[4]=65;disposition[5]=60;
	    disposition[6]=60;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Tu'Shan";chapter_master_melee=4;
	    chapter_master_ranged=2;chapter_master_specialty=2;
		
	    company_title[1]="The Firedrakes";company_title[2]="Defenders of Nocturne";company_title[3]="The Pyroclasts";
		company_title[4]="The Branded";company_title[5]="The Drake Hunters";company_title[6]="The Flamehammers";
		company_title[10]="Sons of Nocturne";
	
		    for(i=100;i<=102;i++){
	        role[i,3]="Firedrake";wep1[i,3]="Power Sword";
			role[i,19]="Firedrake Master";wep1[i,3]="Power Sword";
			}
	}


	if (argument0="Raven Guard"){points=150;
		selected_chapter=9;chapter=argument0;icon=9;icon_name="rg";founding=0;fleet_type=1;strength=5;purity=8;stability=4;cooperation=5;
	    adv[1]="Ambushers";adv[2]="Melee Enthusiasts";dis[1]="Splintered";
	    homeworld="Dead";homeworld_name="Deliverance";homeworld_exists=1;recruiting_exists=1;
	    homeworld_rule=1;aspirant_trial=eTrials.EXPOSURE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Black";color_to_secondary="Black";color_to_trim="Silver";
	    color_to_pauldron="Black";color_to_pauldron2="Black";color_to_lens="Dark Red";
	    color_to_weapon="Black";col_special=0;trim=0;
	    hchaplain="Jolaran Tael";fmaster="Saar Laeron";clibrarian="Taalis Shraek";hapothecary="Vynda Aason"
	    honorcapt="Vykar Kaed";watchmaster="Aaja Solari";arsenalmaster="Vordin Krayn";admiral="Aethon Shaan";marchmaster="Kyrin Solaq";
		ritesmaster="Syras Colfaen";victualler="Aervar Qeld";lordexec="Reszasz Krevaan";relmaster="Vos Delorn";recruiter="Kalae Korvydae";
	    battle_cry="Victorus aut Mortis";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=0;load_to_ships=[2,0,0];successors=8;
	    mutations=2;mutations_selected=2;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=1;catalepsean=0;secretions=0;occulobe=0;mucranoid=1;
	    // disposition[1]=0;// Prog
	    disposition[2]=80;disposition[3]=50;disposition[4]=50;disposition[5]=50;
	    disposition[6]=60;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Kayvaan Shrike";chapter_master_melee=2;
	    chapter_master_ranged=1;chapter_master_specialty=1;
		
	    company_title[1]="The Blackwings";company_title[2]="The Shadowborne";company_title[3]="The Ghoststalkers";
		company_title[4]="The Silent";company_title[5]="The Watchful";company_title[6]="The Darkened Blades";
		company_title[7]="The Whisperclaws";company_title[8]="The Unseen";company_title[9]="The Dirgesingers";company_title[10]="The Subtle";
		for(i=100;i<=102;i++){
		role[i,5]="Shadow Captain";wep1[i,5]="Lightning Claw";
		role[i,2]="Shadow Warden";mobi[i,2]="Jump Pack";
		}
	}
	
		if (argument0="Black Templars"){founding=4;points=200;
	    selected_chapter=10;chapter=argument0;icon=10;icon_name="bt";founding=4;
	    fleet_type=3;strength=5;purity=7;stability=10;cooperation=5;
	    adv[1]="Melee Enthusiasts";adv[2]="Kings of Space";adv[3]="Reverent Guardians";adv[4]="Brothers, All";dis[1]="Psyker Intolerant";dis[2]="Suspicious";
	    homeworld_exists=0;recruiting_exists=1;
	    recruiting_name=global.name_generator.generate_star_name();
		aspirant_trial=eTrials.APPRENTICESHIP;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Black";color_to_secondary="Black";color_to_trim="Silver";
	    color_to_pauldron2="White";color_to_pauldron="White";color_to_lens="Dark Red";
	    color_to_weapon="Black";col_special=0;trim=0;
	    battle_cry="No Pity! No Remorse! No Fear";
	    equal_specialists=1;load_to_ships=[2,0,0];successors=0;
	    mutations=2;mutations_selected=2;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=1;
	    zygote=0;betchers=1;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
		hchaplain="Grimaldus"; fmaster="Jurisian"; recruiter="Emrik";
		admiral="Stenheir";hapothecary="Colber";
	   disposition[1]=50;// Prog
	    disposition[2]=60;//Imperium
		disposition[3]=40;//Admech
		disposition[4]=30;//Inquisition
		disposition[5]=80;//Ecclesiarchy
	    disposition[6]=35;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Helbrecht";chapter_master_melee=5;
	    chapter_master_ranged=2;chapter_master_specialty=2;
		role[i,5]="Marshall";wep1[i,5]="Power Sword";
		role[i,3]="Sword Brother";
	}
	
if (argument0="Minotaurs"){founding=10;points=450;
	    selected_chapter=11;chapter=argument0;icon=11;icon_name="min";founding=10;
	    fleet_type=2;strength=5;purity=10;stability=10;cooperation=2;
	    adv[1]="Paragon";adv[2]="Siege Masters";adv[3]="Boarders";adv[4]="Enemy: Fallen";dis[1]="Suspicious";
	    homeworld_exists=0;recruiting_exists=1;
	    recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_rule=0;aspirant_trial=eTrials.CHALLENGE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Lightest Brown";color_to_secondary="Lightest Brown";color_to_trim="Light Brown";
	    color_to_pauldron2="Dark Red";color_to_pauldron="Dark Red";color_to_lens="Red";
	    color_to_weapon="Dark Red";col_special=0;trim=1;
		hchaplain="Ivanus Enkomi"; 
		fmaster="Varro Crag";clibrarian="Lykos Gorgon";hapothecary="Raze Korthos"
	    recruiter="Axion Eurytos";admiral="Thoul Brontes";
	    battle_cry="...";
	    equal_specialists=0;load_to_ships=[2,0,0];successors=0;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=0;// Prog
	    disposition[2]=100;//Imperium
		disposition[3]=50;//Admech
		disposition[4]=60;//Inquisition
		disposition[5]=25;//Ecclesiarchy
	    disposition[6]=30;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Asterion Moloc";chapter_master_melee=5;
	    chapter_master_ranged=7;chapter_master_specialty=2;
	}

	
	
	if (argument0="Blood Ravens"){
		founding=10;points=100;
	    selected_chapter=12;chapter=argument0;icon=12;icon_name="br";
	    fleet_type=2;strength=5;purity=10;stability=6;cooperation=7;
	    adv[1]="Scavengers";adv[2]="Psyker Abundance";dis[1]="Suspicious";
	    hapothecary="Galan";hchaplain="Mikelus";clibrarian="Jonah Orion";fmaster="Martellus";
		honorcapt="Apollo Diomedes";watchmaster="Yriel Rikarius";marchmaster="Aramus";
		ritesmaster="Tarkus";victualler="Atanaxis";lordexec="Thaddeus";relmaster="Avitus";recruiter="Cyrus";
	    homeworld="Dead";homeworld_name="Aurelia";flagship_name="Omnis Arcanum";
	    homeworld_exists=0;recruiting_exists=1;
	    recruiting="Death";recruiting_name="Trontiux";
	    homeworld_rule=0;aspirant_trial=eTrials.KNOWLEDGE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Sanguine Red";color_to_secondary="Sanguine Red";color_to_trim="Lighter Black";
	    color_to_pauldron2="Bone";color_to_pauldron="Bone";color_to_lens="Lime";
	    color_to_weapon="Black";col_special=0;trim=1;
	    battle_cry=choose("None shall find us wanting.","Knowledge is power, guard it well");
	    equal_specialists=0;load_to_ships=[2,0,0];successors=0;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=50;// Prog
	    disposition[2]=40;disposition[3]=30;disposition[4]=45;disposition[5]=25;
	    disposition[6]=35;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Gabriel Angelos";chapter_master_melee=4;
	    chapter_master_ranged=3;chapter_master_specialty=1;
	}

if (argument0="Crimson Fists"){founding=4;points=150;
		selected_chapter=13;chapter=argument0;icon=4;icon_name="cf";fleet_type=1;strength=2;purity=7;stability=10;cooperation=8;
		adv[1]="Bolter Drilling";adv[2]="Enemy: Orks";dis[1]="Sieged";
		homeworld="Agri";homeworld_name="Rynn's World";
		homeworld_exists=1;recruiting_exists=0;homeworld_rule=1;aspirant_trial=eTrials.CHALLENGE
		color_to_main="Blue";color_to_secondary="Blue";color_to_trim="White";color_to_pauldron="Blue"
		color_to_pauldron2="Blue";color_to_lens="Red";color_to_weapon="Black"
		hapothecary="Curien Droga";hchaplain="Marqol Tomasi";clibrarian="Eustace Mendoza";fmaster="Javier Adon";
		honorcapt="Alessio Cortez";watchmaster="Steffan Hios";arsenalmaster="Faradis Anto";admiral="Isidore Haleous";
		marchmaster="Balthazar";recruiter="Ishmael Icario"
		battle_cry="There is only the Emperor!  He is our shield and our protector!";
	        equal_specialists=0;load_to_ships=[2,0,0];successors=0;
	        mutations=2;mutations_selected=2;
	        preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=1;
	        zygote=0;betchers=1;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	        disposition[1]=60;// Prog
	        disposition[2]=80;disposition[3]=50;disposition[4]=50;disposition[5]=50;
	        disposition[6]=60;// Astartes
	        disposition[7]=0;// Reserved
	        chapter_master_name="Pedro Kantor";chapter_master_melee=1;
	        chapter_master_ranged=1;chapter_master_specialty=1;

	        company_title[1]="The Righteous Crusaders";company_title[2]="The Shieldwall";company_title[3]="The Red Lightning";
	        company_title[4]="The Crimson Lancers";company_title[5]="The War Riders";company_title[6]="Iron Guardians";
	        company_title[7]="The Wardens of Rynn";company_title[8]="The Red Path";company_title[9]="The Fists of Rynn";
	        company_title[10]="The Wayfinders";

}
if (argument0="Lamenters"){founding=5;points=150;
	    selected_chapter=14;chapter=argument0;icon=14;icon_name="cd";
	    fleet_type=3;strength=5;purity=8;stability=4;cooperation=5;
	    adv[1]="Melee Enthusiasts";adv[2]="Boarders";dis[1]="Suspicious";
	    homeworld="Dead";homeworld_name="Lacrima Vex";
	    homeworld_exists=0;recruiting_exists=1;
	    recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_rule=0;aspirant_trial=eTrials.CHALLENGE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Yellow";color_to_secondary="Yellow";color_to_trim="Dark Gold";
	    color_to_pauldron2="Yellow";color_to_pauldron="Yellow";color_to_lens="Red";
	    color_to_weapon="Black";col_special=0;trim=0;
	    battle_cry="For those we cherish, we die in Glory";
	    equal_specialists=0;load_to_ships=[2,0,0];successors=0;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=60;// Prog
	    disposition[2]=15;disposition[3]=20;disposition[4]=10;disposition[5]=25;
	    disposition[6]=50;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Malakim Phoros";chapter_master_melee=3;
	    chapter_master_ranged=2;chapter_master_specialty=2;
	}
	
	if (argument0="Carcharodons"){founding=9;points=100;
	    selected_chapter=15;chapter=argument0;icon=15;icon_name="cd";
	    fleet_type=2;strength=5;purity=8;stability=4;cooperation=5;
	    adv[1]="Melee Enthusiasts";adv[2]="Boarders";adv[3]="Kings of Space";dis[1]="Splintered";dis[2]="Suspicious";
	    homeworld_exists=0;recruiting_exists=0;flagship_name="Nicor";
	    recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_rule=0;aspirant_trial=eTrials.CHALLENGE;
	    color_to_main="Codex Grey";color_to_secondary="Codex Grey";color_to_trim="Copper";
	    color_to_pauldron2="Dark Grey";color_to_pauldron="Dark Grey";color_to_lens="Red";
	    color_to_weapon="Black";col_special=0;trim=1;
		hapothecary="Tamaron";hchaplain="Niko'manu";clibrarian="Te Kahurangi";fmaster="Uthulu";
		honorcapt="Tagaloa";watchmaster="Akamu";arsenalmaster="Akia";admiral="Mannfor";marchmaster="Fa'atiu";
		ritesmaster="Mafui'e";victualler="Aleki";lordexec="Atonga";relmaster="Enele";recruiter="Bail Sharr"
	    battle_cry="Silence";
	    equal_specialists=0;load_to_ships=[2,1,1];successors=0;
	    mutations=1;mutations_selected=1;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=1;
	    disposition[1]=30;// Prog
	    disposition[2]=40;disposition[3]=40;disposition[4]=40;disposition[5]=30;
	    disposition[6]=30;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Tyberos";chapter_master_melee=2;
	    chapter_master_ranged=1;chapter_master_specialty=2;
		role[i,4]="Red Brother";
		role[i,5]="Company Master";wep1[i,5]="Eviscerator";
		role[i,19]="Veteran Strike Leader";wep1[i,19]="Power Axe";
		role[i,18]="Strike Leader";wep1[i,18]="Chainaxe";
		role[i,8]="Void Brother";wep2[i,8]="Chainaxe";
		role[i,10]="Devourer";wep1[i,10]="Chainaxe";
		
	}
	
	if (argument0="Soul Drinkers"){points=200;
	    selected_chapter=16;chapter=argument0;icon=14;icon_name="sd";founding= 4;
	    fleet_type=2;strength=2;purity=10;stability=2;cooperation=2;
	    adv[1]="Melee Enthusiasts";adv[2]="Kings of Space";adv[3]="Boarders";adv[4]="Daemon Binders";dis[1]="Suspicious";
	    homeworld="Dead";homeworld_name="Entymion";
	    homeworld_exists=0;recruiting_exists=1;
	    recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_rule=0;aspirant_trial=eTrials.CHALLENGE;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Purple";color_to_secondary="Purple";color_to_trim="Dark Gold";
	    color_to_pauldron2="Purple";color_to_pauldron="Purple";color_to_lens="Red";
	    color_to_weapon="Purple";col_special=0;trim=1;
	    battle_cry="Cold and Hard, Soul Drinkers";
	    equal_specialists=0;load_to_ships=[2,0,0];successors=0;
	    mutations=1;mutations_selected=1;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=1;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=60;// Prog
	    disposition[2]=15;disposition[3]=20;disposition[4]=10;disposition[5]=25;
	    disposition[6]=50;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Sarpedon";chapter_master_melee=8;
	    chapter_master_ranged=3;chapter_master_specialty=3;
	}


	if (argument0="Doom Benefactors"){points=100;
	    selected_chapter=135;chapter=argument0;icon=0;icon_name="eye";founding=0;scr_icon("");
	    fleet_type=1;strength=1;purity=10;stability=7;cooperation=8;
	    homeworld="Forge";homeworld_name="Ariana Prime";recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	    homeworld_exists=1;recruiting_exists=1;homeworld_rule=2;aspirant_trial=eTrials.APPRENTICESHIP;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main="Dark Red";color_to_secondary="Black";color_to_trim="Copper";
	    color_to_pauldron="Black";color_to_pauldron2="Black";color_to_lens="Sanguine Red";
	    color_to_weapon="Black";col_special=0;trim=1;
	    hapothecary="Vaylund";
	    hchaplain="Eli";
	    clibrarian="Dagoth";
	    fmaster="Mjenzi";
	    admiral=global.name_generator.generate_space_marine_name();
	    battle_cry="Death to the enemy!  DEATH";// monastery_name="Fortress of Hera";master_name=
	    equal_specialists=0;
    
	    load_to_ships=[2,0,0];
	    // load_to_ships=0;
    
	    successors=0;
	    mutations=0;mutations_selected=0;
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    disposition[1]=60;// Prog
	    disposition[2]=50;disposition[3]=40;disposition[4]=25;disposition[5]=40;
	    disposition[6]=50;// Astartes
	    disposition[7]=0;// Reserved
	    chapter_master_name="Duke Sacerdos";chapter_master_melee=7;
	    chapter_master_ranged=3;chapter_master_specialty=3;
    
	    adv[1]="Paragon";
	    adv[2]="Reverent Guardians";
	    adv[3]="Crafters";
	    dis[1]="First In, Last Out";
    
	    stage=6;
	}
	#endregion

	#region Custom Chapter
	//generates custom chapter if it exists
	if (argument0=chapter21){
		points=100;
	    selected_chapter=21;chapter=argument0;icon=icon21;icon_name=icon_name21;founding=founding21;
	    fleet_type=fleet_type21;
		strength=strength21;
		purity=purity21;
		stability=stability21;
		cooperation=cooperation21;
	    homeworld=homeworld21;
	    homeworld_name=homeworld_name21;
	    recruiting=recruiting_world21;
	    recruiting_name=recruiting_name21;
	    homeworld_exists=homeworld_rule21;
	    recruiting_exists=recruiting_exists21;
	    homeworld_rule=homeworld_rule21;
	    aspirant_trial=aspirant_trial21;
	    discipline=discipline21;
	    // Pauldron2: Left, Pauldron: Right
	    color_to_main=color_to_main21;
		color_to_secondary=color_to_secondary21;
		color_to_trim=color_to_trim21;
	    color_to_pauldron2=color_to_pauldron2_21;
	    color_to_paulrdon=color_to_pauldron21;
	    color_to_lens=color_to_lens21;
	    color_to_weapon=color_to_weapon21;
	    col_special=col_special21;trim=trim21;
	    hapothecary=hapothecary21;
	    hchaplain=hchaplain21;
	    clibrarian=clibrarian21;
	    fmaster=fmaster21;
	    admiral=admiral21
		recruiter=recruiter21
	    battle_cry=battle_cry_21
		load_to_ships=[2,0,0];
		complex_livery_data = complex_livery21;
		
		for (var i=1;i<=20;i++){
		    role[100][i] = role_21[i];
			wep1[100][i]=wep1_21[i]
			wep2[100][i]=wep2_21[i]
			armour[100][i]=armour_21[i]
			gear[100][i]=gear_21[i]
			mobi[100][i]=mobi_21[i]
		}
	
		
		//monastery_name=monastery_name21;
		//master_name=master_name21
	    equal_specialists=equal_specialists21
    
	    load_to_ships=[2,0,0];
	    // load_to_ships=0;
    
	    successors=successors;
	    mutations=mutations21;
		mutations_selected=mutations_selected21;
		
	    preomnor=preomnor21;
		voice=voice21;
		doomed=doomed21;
		lyman=lyman21;
		omophagea=omophagea21;
		ossmodula=ossmodula21;
		membrane=membrane21;
	    zygote=zygote21;
		betchers=betchers21;
		catalepsean=catalepsean21;
		secretions=secretions;
		occulobe=occulobe;
		mucranoid=mucranoid21;
	    disposition[1]=disposition21[1];// Prog
	    disposition[2]=disposition21[2];
		disposition[3]=disposition21[3];
		disposition[4]=disposition21[4];
		disposition[5]=disposition21[5];
	    disposition[6]=disposition21[6];// Astartes
	    disposition[7]=disposition21[7];// Reserved
	    chapter_master_name=chapter_master_name21;
		chapter_master_melee=chapter_master_melee21;
	    chapter_master_ranged=chapter_master_ranged21;
		chapter_master_specialty=chapter_master_specialty21;
    
		for(var i = 1; i <= 8; i++){
	    	adv[i]=adv21[i];
			dis[i]=dis21[i];
		}
	}
	#endregion



	if(obj_creation.use_chapter_object){
		
		// todo this chunk can go at the bottom of the file after the if/elses once its all working 
		
		var chapter_object = global.chapter_creation_object;
		
		// * All of this obj_creation setting is just to keep things working 
		obj_creation.founding = chapter_object.founding;
		obj_creation.successors = chapter_object.successors;
		obj_creation.homeworld_rule = chapter_object.homeworld_rule;
		obj_creation.chapter_name = chapter_object.name;

		obj_creation.icon = chapter_object.icon;
		obj_creation.icon_name = chapter_object.icon_name;
		obj_creation.fleet_type = chapter_object.fleet_type;
		obj_creation.strength = chapter_object.strength;
		obj_creation.purity = chapter_object.purity;
		obj_creation.stability = chapter_object.stability;
		obj_creation.cooperation = chapter_object.cooperation;
		obj_creation.homeworld_exists = chapter_object.homeworld_exists;
		obj_creation.recruiting_exists = chapter_object.recruiting_exists;
		obj_creation.homeworld_rule = chapter_object.homeworld_rule;
		obj_creation.aspirant_trial = trial_map(chapter_object.aspirant_trial);
		obj_creation.adv = chapter_object.advantages;
		obj_creation.dis = chapter_object.disadvantages;

		obj_creation.full_liveries = chapter_object.full_liveries;

		obj_creation.color_to_main = chapter_object.colors.main;
		obj_creation.color_to_secondary = chapter_object.colors.secondary;
		obj_creation.color_to_pauldron = chapter_object.colors.pauldron_r;
		obj_creation.color_to_pauldron2 = chapter_object.colors.pauldron_l;
		obj_creation.color_to_trim = chapter_object.colors.trim;
		obj_creation.color_to_lens = chapter_object.colors.lens;
		obj_creation.color_to_weapon = chapter_object.colors.weapon;
		obj_creation.col_special = chapter_object.colors.special;
		obj_creation.trim = chapter_object.colors.trim_on;

		obj_creation.hchaplain = chapter_object.names.hchaplain;
		obj_creation.clibrarian = chapter_object.names.clibrarian;
		obj_creation.fmaster = chapter_object.names.fmaster;
		obj_creation.hapothecary = chapter_object.names.hapothecary;
		obj_creation.honorcapt = chapter_object.names.honorcapt;
		obj_creation.watchmaster = chapter_object.names.watchmaster;
		obj_creation.arsenalmaster = chapter_object.names.arsenalmaster;
		obj_creation.admiral = chapter_object.names.admiral;
		obj_creation.marchmaster = chapter_object.names.marchmaster;
		obj_creation.ritesmaster = chapter_object.names.ritesmaster;
		obj_creation.victualler = chapter_object.names.victualler;
		obj_creation.lordexec = chapter_object.names.lordexec;
		obj_creation.relmaster = chapter_object.names.relmaster;
		obj_creation.recruiter  = chapter_object.names.recruiter;

		obj_creation.battle_cry = chapter_object.battle_cry;

		var load = chapter_object.load_to_ships;
		obj_creation.load_to_ships = [load.escort_load, load.split_scouts, load.split_vets];
		obj_creation.equal_specialists = chapter_object.equal_specialists;
		
		obj_creation.mutations = 0;
		struct_foreach(chapter_object.mutations, function(key, val){
			struct_set(obj_creation, key, val);
			if(val == 1) {
				obj_creation.mutations += 1;
			}
		});

		obj_creation.disposition = chapter_object.disposition;

		obj_creation.chapter_master = chapter_object.chapter_master;
		
		obj_creation.chapter_master_name = chapter_object.chapter_master.name;
		obj_creation.chapter_master_melee = chapter_object.chapter_master.melee;
		obj_creation.chapter_master_ranged = chapter_object.chapter_master.ranged;
		obj_creation.chapter_master_specialty = chapter_object.chapter_master.specialty;
		if(struct_exists(chapter_object, "company_titles")){
			obj_creation.company_title = chapter_object.company_titles;
		}

		if(struct_exists(chapter_object, "artifact")){
			obj_creation.artifact = chapter_object.artifact;
		}
		
		obj_creation.flagship_name = chapter_object.flagship_name;
		obj_creation.extra_ships = chapter_object.extra_ships;
		obj_creation.extra_specialists = chapter_object.extra_specialists;
		obj_creation.extra_marines = chapter_object.extra_marines;
		obj_creation.extra_vehicles = chapter_object.extra_vehicles;
		obj_creation.extra_equipment = chapter_object.extra_equipment;

		obj_creation.squad_name = chapter_object.squad_name;
		if(struct_exists(chapter_object, "custom_roles")){
			obj_creation.custom_roles = chapter_object.custom_roles;
		}
		if(struct_exists(chapter_object, "custom_squads")){
			obj_creation.custom_squads = chapter_object.custom_squads;
		}

		points = chapter_object.points;
		maxpoints=chapter_object.points;	

	}






	var i,a;i=0;a=0;
	repeat(8){a+=1;i=0;
	    repeat(40){i+=1;
	        if (adv[a]!="") and (advantage[i]=adv[a]) then adv_num[a]=i;
	        if (dis[a]!="") and (disadvantage[i]=dis[a]) then dis_num[a]=i;
	    }
	}



	maxpoints=points;
	var livery_picker = new colour_item(0,0);
	livery_picker.scr_unit_draw_data();
	full_liveries = array_create(21,DeepCloneStruct(livery_picker.map_colour));	
	return true;
}


enum FLEET_TYPE {
	NONE = 0,
	HOMEWORLD = 1,
	FLEET_BASED,
	PENITENCE,
}

enum HOMEWORLD_RULE {
	NONE = 0,
	GOVERNOR = 1,
	COUNTRY,
	PERSONAL,
}

enum CM_SPECIALTY {
	NONE = 0,
	LEADER = 1,
	CHAMPION,
	PSYKER,
}

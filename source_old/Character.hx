package;

// import sys.io.File;
import LoadSettings.Settings;
import PlayState.PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var charGlobalOffset:FlxPoint = new FlxPoint(0, 0);
	public var camOffset:FlxPoint = new FlxPoint(0, 0);

	var curBeat:Int = 0;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var isaBF:Bool = false;

	public static var customBFAnims:Array<String> = [];
	public static var customBFOffsets:Array<String> = [];
	public static var customGFAnims:Array<String> = [];
	public static var customGFOffsets:Array<String> = [];

	public function configureAnims() {
		switch(curCharacter) {
			case "gf" | "gf-christmas" | "gf-car":
				for(anim in Character.customGFAnims) {
					var data:Array<String> = anim.trim().split(":");
					if (data[0] == "dance") {
						animation.addByIndices('danceLeft', data[1], [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
						animation.addByIndices('danceRight', data[1], [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					} else if (data[0] == "sad") {
						animation.addByIndices('sad', data[1], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
					} else if (data[0] == "hairBlow") {
						animation.addByIndices('hairBlow', data[1], [0, 1, 2, 3], "", 24);
					} else if (data[0] == "hairFall") {
						animation.addByIndices('hairFall', data[1], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
					} else {
						animation.addByPrefix(data[0], data[1], 24, false);
					}
				}
			case "bf" | "bf-christmas" | "bf-car":
				for(anim in Character.customBFAnims) {
					var data:Array<String> = anim.trim().split(":");
					animation.addByPrefix(data[0], data[1], 24, data[0] == "deathLoop");
				}
		}
	}
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		isaBF = PlayState.bfList.contains(character);
		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				// tex = Paths.getCharacter('fuck_you_border'); // Goodbye Strawberry Cookie

				var gfSprite = "GF_assets";
				switch(curCharacter) {
					case 'gf-christmas':
						gfSprite = "gfChristmas";
					case 'gf-car':
						gfSprite = "gfCar";
				}
				#if sys
					// Loads the custom default GF skin
					var cGF = Settings.engineSettings.data.customGFSkin;
					var tex =  Paths.getSparrowAtlas_Custom('skins/gf/$cGF/spritesheet');
					frames = tex;
					Character.customGFOffsets = Paths.getTextOutsideAssets('skins/gf/$cGF/offsets.txt').trim().split("\n");
					Character.customGFAnims = Paths.getTextOutsideAssets('skins/gf/$cGF/anim_names.txt').trim().split("\n");
					// var color:Array<String> = Paths.getTextOutsideAssets('skins/gf/$cGF/color.txt').trim().split("\r");	//May come in use later
					configureAnims();
					for(offset in Character.customGFOffsets) {
						var data:Array<String> = offset.trim().split(" ");
						if (data[0] == "dance") {
							addOffset("danceLeft", Std.parseInt(data[1]), Std.parseInt(data[2]));
							addOffset("danceRight", Std.parseInt(data[1]), Std.parseInt(data[2]));
						} else {
							addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
						}
					}
				#else
					// Load default GF for targets that doesn't support sys
					var tex = Paths.getCharacter(gfSprite);
					frames = tex;
					animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
					animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					animation.addByPrefix('cheer', 'GF Cheer', 24, false);
					animation.addByPrefix('singLEFT', 'GF left note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
					animation.addByPrefix('singUP', 'GF Up Note', 24, false);
					animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
					animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
					animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
					animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
					animation.addByPrefix('scared', 'GF FEAR', 24);

					addOffset('cheer');
					addOffset('sad', -2, -2);
					addOffset('danceLeft', 0, -9);
					addOffset('danceRight', 0, -9);

					addOffset("singUP", 0, 4);
					addOffset("singRIGHT", 0, -20);
					addOffset("singLEFT", 0, -19);
					addOffset("singDOWN", 0, -20);
					addOffset('hairBlow', 45, -8);
					addOffset('hairFall', 0, -9);

					addOffset('scared', -2, -17);
				#end

				playAnim('danceRight');
			case 'gf-christmas':
				tex = Paths.getCharacter('gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf-car':
				tex = Paths.getCharacter('gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');
			case 'gf-pixel':
				tex = Paths.getCharacter('gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;
			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getCharacter('DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				camOffset.x = 400;
				playAnim('idle');
			case 'matto':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getCharacter('matto');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24);
				animation.addByPrefix('singLEFT', 'dad sing note right', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
				camOffset.x = 400;
			case 'spooky':
				tex = Paths.getCharacter('spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
				charGlobalOffset.y = 200;
			case 'mom':
				tex = Paths.getCharacter('Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'mom-car' | 'border-milf' | 'tilf' | 'silf' | 'matto-milf':
				tex = ('mom-car' == curCharacter) ? Paths.getCharacter('momCar') : Paths.getCharacter('' + curCharacter);

				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, isPlayer);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, isPlayer);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, isPlayer);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, isPlayer);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, isPlayer);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getCharacter('Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				charGlobalOffset.y = 100;
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getCharacter('monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				charGlobalOffset.y = 130;
				playAnim('idle');
			case 'pico':
				tex = Paths.getCharacter('Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;
				charGlobalOffset.y = 300;
				camOffset.y = 600;
			case 'shrek-pico':
				tex = Paths.getCharacter('shrek_pico');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT', 24, false);
				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singLEFT", -68, -7);
				addOffset("singRIGHT", 65, 9);
				addOffset("singDOWN", 200, -70);

				playAnim('idle');

				// flipX = true;
				charGlobalOffset.y = 300;
				charGlobalOffset.x = 300;
				camOffset.y = 600;
			case 'bf' | 'bf-christmas' | 'bf-car':
				var bfSprite = "BOYFRIEND";
				switch(curCharacter) {
					case 'bf-christmas':
						bfSprite = "bfChristmas";
					case 'bf-car':
						bfSprite = "bfCar";
				}
				#if sys
				var cBF = Settings.engineSettings.data.customBFSkin;
				var tex = (bfSprite == "BOYFRIEND" || Settings.engineSettings.data.customBFSkin != "default") ? Paths.getSparrowAtlas_Custom('skins/bf/$cBF/spritesheet') : Paths.getCharacter(bfSprite);
				#else
				var tex = Paths.getCharacter(bfSprite);
				#end
				frames = tex;
				#if sys
				if (bfSprite != "BOYFRIEND" && Settings.engineSettings.data.customBFSkin == "default") {
				#end
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					animation.addByPrefix('singDODGE', 'boyfriend dodge', 24, false);
					animation.addByPrefix('hit', 'BF hit', 24, false);
	
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
					animation.addByPrefix('scared', 'BF idle shaking', 24);
	
					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);
				#if sys
				} else {
					var offsets:Array<String> = Paths.getTextOutsideAssets('skins/bf/$cBF/offsets.txt').trim().split("\n");
					Character.customBFAnims = Paths.getTextOutsideAssets('skins/bf/$cBF/anim_names.txt').trim().split("\n");
					// trace(anim_names);
					// var color:Array<String> = Paths.getTextOutsideAssets('skins/bf/$cBF/color.txt').trim().split("\r");	//May come in use later
					configureAnims();
					for(offset in offsets) {
						var data:Array<String> = offset.trim().split(" ");
						addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
					}
				}
				#end
				

				playAnim('idle');
				charGlobalOffset.y = 350;
				flipX = true;
			// case 'bf-christmas':
			// 	var tex = Paths.getCharacter('bfChristmas');
			// 	frames = tex;
			// 	animation.addByPrefix('idle', 'BF idle dance', 24, false);
			// 	animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
			// 	animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
			// 	animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
			// 	animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
			// 	animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
			// 	animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
			// 	animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
			// 	animation.addByPrefix('hey', 'BF HEY', 24, false);

			// 	addOffset('idle', -5);
			// 	addOffset("singUP", -29, 27);
			// 	addOffset("singRIGHT", -38, -7);
			// 	addOffset("singLEFT", 12, -6);
			// 	addOffset("singDOWN", -10, -50);
			// 	addOffset("singUPmiss", -29, 27);
			// 	addOffset("singRIGHTmiss", -30, 21);
			// 	addOffset("singLEFTmiss", 12, 24);
			// 	addOffset("singDOWNmiss", -11, -19);
			// 	addOffset("hey", 7, 4);

			// 	playAnim('idle');
			// 	charGlobalOffset.y = 350;

			// 	flipX = true;
			// case 'bf-car':
			// 	var tex = Paths.getCharacter('bfCar');
			// 	frames = tex;
			// 	animation.addByPrefix('idle', 'BF idle dance', 24, false);
			// 	animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
			// 	animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
			// 	animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
			// 	animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
			// 	animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
			// 	animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
			// 	animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

			// 	addOffset('idle', -5);
			// 	addOffset("singUP", -29, 27);
			// 	addOffset("singRIGHT", -38, -7);
			// 	addOffset("singLEFT", 12, -6);
			// 	addOffset("singDOWN", -10, -50);
			// 	addOffset("singUPmiss", -29, 27);
			// 	addOffset("singRIGHTmiss", -30, 21);
			// 	addOffset("singLEFTmiss", 12, 24);
			// 	addOffset("singDOWNmiss", -11, -19);
			// 	playAnim('idle');
			// 	charGlobalOffset.y = 350;

			// 	flipX = true;
			case 'bf-pixel':
				frames = Paths.getCharacter('bfPixel');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;
				charGlobalOffset.y = 350;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getCharacter('bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;
			case 'kapi':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getCharacter('kapi');
				frames = tex;
				animation.addByIndices('idle', 'Dad idle dance', [2, 4, 6, 8, 10, 0], "", 12, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);
				animation.addByPrefix('meow', 'Dad meow', 24, false);
				animation.addByPrefix('stare', 'Dad stare', 24, false);

				addOffset('idle');

				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				addOffset("stare");
				addOffset("meow");
				playAnim('idle');
			case 'senpai':
				frames = Paths.getCharacter('senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				charGlobalOffset.x = 150;
				charGlobalOffset.y = 360;
				camOffset.x = getGraphicMidpoint().x + 300;
				camOffset.x = getGraphicMidpoint().y;

				antialiasing = false;
			case 'tankman':
				tex = Paths.getCharacter('tankmanCaptain');
				frames = tex;
				animation.addByPrefix('idle', 'Tankman Idle Dance instance 1', 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note instance 1', 24);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH');
				animation.addByPrefix('singRIGHT', 'Tankman Note Left instance 1', 24);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note instance 1', 24);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note instance 1', 24);

				playAnim('idle');
				addOffset("singRIGHT", -1, -14);
				addOffset("singLEFT", 100, -7);
				addOffset("singUP", 24, 56);
				// addOffset("singUP", 24, 56);
				// addOffset("singUP-alt", 24, 56);
				addOffset("singDOWN", 98, -90);
				// addOffset("singDOWN-alt", 98, -90);
				flipX = true;
				charGlobalOffset.y = 180;
			case 'senpai-angry':
				frames = Paths.getCharacter('senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');
				charGlobalOffset.x = 150;
				charGlobalOffset.y = 360;
				camOffset.x = getGraphicMidpoint().x + 300;
				camOffset.x = getGraphicMidpoint().y;
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'spirit':
				frames = Paths.getCharacterPacker('spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);
				charGlobalOffset.x = -150;
				charGlobalOffset.y = 100;
				camOffset.x = getGraphicMidpoint().x + 300;
				camOffset.x = getGraphicMidpoint().y;
				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
			case 'none':
				frames = Paths.getCharacter('none');
				animation.addByPrefix('idle', 'Animation', 2, false);
				animation.addByPrefix('singUP', 'singUP', 2, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 2, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 2, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 2, false);
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');
				antialiasing = false;
			case 'parents-christmas':
				frames = Paths.getCharacter('mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);
				charGlobalOffset.x = -500;
				playAnim('idle');
			case 'gfTankmen':
				// GIRLFRIEND CODE
				tex = Paths.getCharacter('gfTankmen');
				frames = tex;
				// animation.addByPrefix('idle', 'GF Dancing at Gunpoint', 48, false);
				animation.addByPrefix('sad', 'GF Crying at Gunpoint ', 24, false);
				animation.addByIndices("danceLeft", "GF Dancing at Gunpoint", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices("danceRight", "GF Dancing at Gunpoint", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset('sad', -2, -21);

				playAnim('danceLeft');
			default:
				// DAD ANIMATION LOADING CODE
				tex = Paths.getCharacter('unknown-new');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24);
				animation.addByPrefix('singRIGHT', 'dad sing note right', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				camOffset.x = 400;
				playAnim('idle');
		}

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public static function getNoteColors(character:String = "bf", altAnim:Bool = false):Array<FlxColor>
	{
		switch (character)
		{
			default:
				return [
					new FlxColor(Settings.engineSettings.data.arrowColor0),
					new FlxColor(Settings.engineSettings.data.arrowColor1),
					new FlxColor(Settings.engineSettings.data.arrowColor2),
					new FlxColor(Settings.engineSettings.data.arrowColor3)
				];
			case "dad":
				return [
					new FlxColor(0xFFAF66CE),
					new FlxColor(0xFFAF66CE),
					new FlxColor(0xFFAF66CE),
					new FlxColor(0xFFAF66CE),
					new FlxColor(0xFFAF66CE)
				];
			case "spooky":
				// Skid : 0xFFFFFFFF
				// Pump : 0xFFFFA420
				return [
					new FlxColor(0xFFFFFFFF),
					new FlxColor(0xFFFFFFFF),
					new FlxColor(0xFFFFA420),
					new FlxColor(0xFFFFA420),
					new FlxColor(0xFFFFA420)
				];
			case "monster" | "monster-christmas":
				return [
					new FlxColor(0xFFF3FF6E),
					new FlxColor(0xFFF3FF6E),
					new FlxColor(0xFFF3FF6E),
					new FlxColor(0xFFF3FF6E),
					new FlxColor(0xFFF3FF6E)
				];
			case "pico":
				return [
					new FlxColor(0xFFFD6922),
					new FlxColor(0xFF55E858),
					new FlxColor(0xFF55E858),
					new FlxColor(0xFFFD6922),
					new FlxColor(0xFFFD6922)
				];
			case "mom" | "mom-car":
				return [
					new FlxColor(0xFF2B263C),
					new FlxColor(0xFFEE1536),
					new FlxColor(0xFFEE1536),
					new FlxColor(0xFF2B263C),
					new FlxColor(0xFFEE1536)
				];
			case "parents-christmas":
				if (altAnim) // Mom
					return [
						new FlxColor(0xFFD8558E),
						new FlxColor(0xFFD8558E),
						new FlxColor(0xFFD8558E),
						new FlxColor(0xFFD8558E),
						new FlxColor(0xFFD8558E)
					];
				else // Dad
					return [
						new FlxColor(0xFFAF66CE),
						new FlxColor(0xFFAF66CE),
						new FlxColor(0xFFAF66CE),
						new FlxColor(0xFFAF66CE),
						new FlxColor(0xFFAF66CE)
					];
			case "senpai" | "senpai-angry":
				return [
					new FlxColor(0xFFFF78BF),
					new FlxColor(0xFFA7B7F5),
					new FlxColor(0xFFA7B7F5),
					new FlxColor(0xFFFF78BF),
					new FlxColor(0xFFFFAA6F)
				];
			case "spirit":
				return [
					new FlxColor(0xFFFF3C6E),
					new FlxColor(0xFFFF3C6E),
					new FlxColor(0xFFFF3C6E),
					new FlxColor(0xFFFF3C6E),
					new FlxColor(0xFFFF3C6E)
				];
			case "tilf":
				return [
					new FlxColor(0xFFFF0000),
					new FlxColor(0xFFFFFFFF),
					new FlxColor(0xFFFFFFFF),
					new FlxColor(0xFFFF0000),
					new FlxColor(0xFFFF0000)
				];
			case "silf" | "shrek-pico":
				return [
					new FlxColor(0xFFBAA52C),
					new FlxColor(0xFFBAA52C),
					new FlxColor(0xFFBAA52C),
					new FlxColor(0xFFBAA52C),
					new FlxColor(0xFFBAA52C)
				];
			case "kapi":
				return [
					new FlxColor(0xFF4E68C2),
					new FlxColor(0xFFEABC53),
					new FlxColor(0xFFEABC53),
					new FlxColor(0xFF4E68C2),
					new FlxColor(0xFF76719E)
				];
			case "tankman":
				return [
					new FlxColor(0xFF2D2D2D),
					new FlxColor(0xFFFFFFFF),
					new FlxColor(0xFFFFFFFF),
					new FlxColor(0xFF2D2D2D),
					new FlxColor(0xFF2D2D2D)
				];
			case "gf" | "gf-christmas" | "gf-pixel" | "gfTankmen":
				return [
					new FlxColor(0xFFA5004D),
					new FlxColor(0xFFA5004D),
					new FlxColor(0xFFA5004D),
					new FlxColor(0xFFA5004D),
					new FlxColor(0xFFA5004D)
				];
		}
	}

	override function update(elapsed:Float)
	{
		if (isPlayer && (lastHit <= Conductor.songPosition - 500 || lastHit == 0) && animation.curAnim.name != "idle" && !isaBF)
			playAnim('idle');
		// if (!curCharacter.startsWith('bf')) // Ok, what the fuck ?
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(left:Bool = false, down:Bool = false, up:Bool = false, right:Bool = false)
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gfTankmen':
					if (animation.curAnim != null)
					{
						if (!animation.curAnim.name.startsWith('hair'))
						{
							playAnim(danced ? 'danceRight' : 'danceLeft');
						}
					}

				case 'spooky':
					playAnim(danced ? 'danceRight' : 'danceLeft');
				case 'tankman':
					if (danced)
						playAnim('idle');
				default:
					if (isPlayer)
					{
						if (lastHit <= Conductor.songPosition - 500 || lastHit == 0)
							playAnim('idle');
					}
					else
					{
						playAnim('idle');
					}
			}
			danced = !danced;
		}
	}

	public var lastHit:Float = 0;

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) == null) {
			trace(AnimName + " doesn't exist on character " + curCharacter);
			return;
		}
		if (isPlayer && AnimName == "singLEFT" && flipX)
			AnimName = "singRIGHT";
		else if (isPlayer && AnimName == "singRIGHT" && flipX)
			AnimName = "singLEFT";
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (isPlayer && AnimName != "idle")
		{
			lastHit = Conductor.songPosition;
		}
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}

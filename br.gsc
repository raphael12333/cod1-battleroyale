main()
{
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

    level.objectiveText = "Be the last man standing.";

    level.maxClients = getCvarInt("sv_maxclients");
	level.minPlayers = 2;
	level.startBattleCountdown = 2;
    level.quickChatDelay = 0.8;
    level.planeModel = "xmodel/c47";
    level.parachuteModel = "xmodel/bx_parachute";

    level.camouflages = [];
    level.camouflages[0] = "american";
    level.camouflages[1] = "british";
    level.camouflages[2] = "german";
    level.camouflages[3] = "russian";

    if(getCvarInt("br_instantkill_bolt"))
        level.instantKill_bolt = true;
    if(getCvarInt("br_instantkill_pistol"))
		level.instantKill_pistol = true;
    if(getCvarInt("br_instantkill_melee"))
		level.instantKill_melee = true;
    if(getCvarInt("br_damagefeedback"))
        level.damageFeedback = true;

	if(!isdefined(game["state"]))
		game["state"] = "playing";

	level.mapended = false;

	setarchive(true);
}

//CALLBACKS
Callback_StartGameType()
{
    //View Map menu
    if(!isdefined(game["layoutimage"]))
		game["layoutimage"] = "default";
	layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
	precacheShader(layoutname);
	setcvar("scr_layoutimage", layoutname);
	makeCvarServerInfo("scr_layoutimage", "");

    //MENUS
    game["menu_camouflage"] = "camouflage";
	game["menu_weapon_all"] = "weapon_bolt";
    game["menu_viewmap"] = "viewmap";
    game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";
	precacheMenu(game["menu_camouflage"]);
	precacheMenu(game["menu_weapon_all"]);
    precacheMenu(game["menu_viewmap"]);
	precacheMenu(game["menu_quickcommands"]);
	precacheMenu(game["menu_quickstatements"]);
	precacheMenu(game["menu_quickresponses"]);

	precacheShader("black");
	precacheShader("hudScoreboard_mp");
	precacheShader("gfx/hud/hud@mpflag_none.tga");
	precacheShader("gfx/hud/hud@mpflag_spectator.tga");
	precacheStatusIcon("gfx/hud/hud@status_dead.tga");
	precacheStatusIcon("gfx/hud/hud@status_connecting.tga");

    precacheShader("gfx/hud/damage_feedback.dds");

    //MODELS
    precacheModel(level.planeModel);
    precacheModel(level.parachuteModel);

    //PLAYER MODELS
    mptype\american_airborne::precache();
    mptype\british_airborne::precache();
    mptype\german_wehrmacht::precache();
    mptype\russian_conscript::precache();
    game["american_model"] = mptype\american_airborne::main;
    game["british_model"] = mptype\british_airborne::main;
    game["german_model"] = mptype\german_wehrmacht::main;
    game["russian_model"] = mptype\russian_conscript::main;

    //WEAPONS
    //BOLT ACTION RIFLES
    precacheItem("springfield_mp");
    precacheItem("enfield_mp");
    precacheItem("mosin_nagant_mp");
    precacheItem("mosin_nagant_sniper_mp");
    precacheItem("kar98k_mp");
    precacheItem("kar98k_sniper_mp");
    //PISTOLS
    precacheItem("colt_mp");
    precacheItem("luger_mp");
    //GRENADES
    precacheItem("fraggrenade_mp");
    precacheItem("stielhandgranate_mp");
    precacheItem("mk1britishfrag_mp");
    precacheItem("rgd-33russianfrag_mp");

    maps\mp\gametypes\_teams::initGlobalCvars();
	maps\mp\gametypes\_teams::restrictPlacedWeapons();

	setClientNameMode("auto_change");

    thread checkBattleReady();
}
Callback_PlayerConnect()
{
    self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";

    self.pers["connected"] = true;
	iprintln(&"MPSCRIPT_CONNECTED", self);
	
	if(game["state"] == "intermission")
	{
        printLn("#### Callback_PlayerConnect: game[\"state\"] == \"intermission\"");
		//spawnIntermission();
		return;
	}

	level endon("intermission");
    
    self setClientCvar("g_scriptMainMenu", game["menu_camouflage"]);
    self setClientCvar("scr_showweapontab", "0");
	self openMenu(game["menu_camouflage"]);
    self.pers["team"] = "spectator";
    self.sessionteam = "spectator";
    spawnSpectator();

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if(response == "open" || response == "close")
			continue;

		if(menu == game["menu_camouflage"])
		{
			switch(response)
			{
            case "american":
            case "british":
            case "german":
            case "russian":
			case "random":
				if(response == "random")
				{
                    response = level.camouflages[randomInt(level.camouflages.size)];
				}

                //CHECK SELECTED SAME CAMOUFLAGE
                if (isdefined(self.pers["camouflage"]) && response == self.pers["camouflage"] && self.sessionstate == "playing")
                {
                    break;
                }
                //CHECK SELECTED SPECTATE AGAIN
                if (isdefined(self.pers["team"]) && response == self.pers["team"])
                {
                    break;
                }
                //CHECK CHANGED CAMOUFLAGE WHILE PLAYING
                if (isdefined(self.pers["camouflage"]) && response != self.pers["camouflage"] && self.sessionstate == "playing")
                {
                    self suicide();
                }

				self.pers["camouflage"] = response;
				self.pers["weapon"] = undefined;
				self.pers["savedmodel"] = undefined;

				self setClientCvar("scr_showweapontab", "1");

                self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
                self openMenu(game["menu_weapon_all"]);
				break;

			case "spectator":
				if(self.pers["team"] != "spectator")
				{
					self.pers["team"] = "spectator";
					self.pers["weapon"] = undefined;
					self.pers["savedmodel"] = undefined;

					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_camouflage"]);
					self setClientCvar("scr_showweapontab", "0");
					spawnSpectator();
				}
				break;

			case "weapon":
                self openMenu(game["menu_weapon_all"]);
				break;

            case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			}
		}
		else if(menu == game["menu_weapon_all"])
		{
			if(response == "camouflage")
			{
				self openMenu(game["menu_camouflage"]);
				continue;
			}
            else if(response == "viewmap")
			{
				self openMenu(game["menu_viewmap"]);
				continue;
			}

			if(!isdefined(self.pers["camouflage"]))
				continue;
				
			weapon = response;

			if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
				continue;

            if(!isdefined(self.pers["weapon"]))
			{
				self.pers["weapon"] = weapon;
				spawnPlayer();
			}
		}
        else if(menu == game["menu_viewmap"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_camouflage"]);
				continue;

			case "weapon":
				self openMenu(game["menu_weapon_all"]);
				break;
			}
		}
		else if(menu == game["menu_quickcommands"])
			quickcommands(response);
		else if(menu == game["menu_quickstatements"])
			quickstatements(response);
		else if(menu == game["menu_quickresponses"])
			quickresponses(response);
	}
}
Callback_PlayerDisconnect()
{
	iprintln(&"MPSCRIPT_DISCONNECTED", self);
}
Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// Make sure at least one point of damage is done
	if(iDamage < 1)
		iDamage = 1;

    if(isDefined(eAttacker) && isPlayer(eAttacker) && isAlive(eAttacker))
    {
        if(sMeansOfDeath != "MOD_FALL" && sMeansOfDeath != "MOD_MELEE")
        {
            if (isBoltWeapon(sWeapon))
            {
                if(isDefined(level.instantKill_bolt))
                    iDamage = iDamage + 100;
            }
            else if (isSecondaryWeapon(sWeapon))
            {
                if(isDefined(level.instantKill_pistol))
                    iDamage = iDamage + 100;
            }
        }
        else if(sMeansOfDeath == "MOD_MELEE")
        {
            if(isDefined(level.instantKill_melee))
                iDamage = iDamage + 100;
        }
        if(isDefined(level.damageFeedback))
            eAttacker thread showDamageFeedback();
    }
	// Apply the damage to the player
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
}
Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("spawned");

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self.sessionstate = "dead";
	self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.deaths = 1;

	attackerNum = -1;
	level.playercam = attacker getEntityNumber();

	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			attacker.score = attacker.pers["score"];
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			attacker.pers["score"]++;
			attacker.score = attacker.pers["score"];
		}
		
		lpattacknum = attacker getEntityNumber();
		lpattackname = attacker.name;
		lpattackercamouflage = attacker.pers["camouflage"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		lpattacknum = -1;
		lpattackname = "";
		lpattackerteam = "world";
	}

	// Make the player drop his weapons
    primary = self getWeaponSlotWeapon("primary");
    primaryb = self getWeaponSlotWeapon("primaryb");
    pistol = self getWeaponSlotWeapon("pistol");
    grenade = self getWeaponSlotWeapon("grenade");
    if(isDefined(primary))
        self dropItem(primary);
    if(isDefined(primaryb))
        self dropItem(primaryb);
    if(isDefined(pistol))
        self dropItem(pistol);
    if(isDefined(grenade))
        self dropItem(grenade);
    
	body = self cloneplayer();

    /*
	// TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
	if(!level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
		doKillcam = false;
    */

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

	if(doKillcam)
		self thread killcam(attackerNum, delay);
	else
	{
		currentorigin = self.origin;
		currentangles = self getPlayerAngles();

		self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
	}
}
//CALLBACKS END

spawnSpectator(origin, angles)
{
    printLn("#### spawnSpectator");

	self notify("spawned");
	
	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	if(isdefined(origin) && isdefined(angles))
		self spawn(origin, angles);
	else
	{
        connectOrigin = (-3580, 2890, 2790);
        connectAngles = (25, -35, 0);
        self spawn(connectOrigin, connectAngles);
	}

	self setClientCvar("cg_objectiveText", level.objectiveText);
}
spawnPlayer(origin, angles)
{
	self notify("spawned");

	resettimeout();

	self.sessionteam = "none";
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;

    if(isdefined(origin) && isdefined(angles))
    {
        self spawn(origin, angles);
    }
    else
    {
        spawnpointname = "mp_deathmatch_spawn";
        spawnpoints = getentarray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

        if(isdefined(spawnpoint))
            self spawn(spawnpoint.origin, spawnpoint.angles);
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }

	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;

    self.pers["score"] = 0;
	self.score = self.pers["score"];

    if(!isdefined(self.pers["savedmodel"]))
		model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);


    if (!isDefined(self.willLand))
    {
        loadout();
        self giveWeapon(self.pers["weapon"]);
        self giveMaxAmmo(self.pers["weapon"]);
        self setSpawnWeapon(self.pers["weapon"]);
    }
	
	self setClientCvar("cg_objectiveText", level.objectiveText);
}

checkBattleReady()
{
    printLn("#### checkBattleReady");

    level endon("battle_start");

	color_yellow = (1, 1, 0);
	color_red = (1, 0, 0);
	fontScale_playerCount = 1.5;

    level.hud_waitingBackground = newHudElem();
    level.hud_waitingBackground.alignX = "center";
	level.hud_waitingBackground.x = 320;
	level.hud_waitingBackground.y = 20;
    level.hud_waitingBackground.alpha = 0.65;
    level.hud_waitingBackground.sort = -1;
    level.hud_waitingBackground setShader("black", 390, 75);

	level.hud_waitingForPlayers = newHudElem();
	level.hud_waitingForPlayers.alignX = "center";
    level.hud_waitingForPlayers.alignY = "middle";
	level.hud_waitingForPlayers.x = 320;
	level.hud_waitingForPlayers.y = level.hud_waitingBackground.y + 22;
	level.hud_waitingForPlayers.color = color_yellow;
	level.hud_waitingForPlayers.fontScale = 1.5;
    level.hud_waitingForPlayers.font = "bigfixed";

    distance_ready_min = 17;

    level.hud_playersReady = newHudElem();
    level.hud_playersReady.alignX = "center";
    level.hud_playersReady.alignY = "middle";
	level.hud_playersReady.x = level.hud_waitingForPlayers.x - distance_ready_min;
	level.hud_playersReady.y = level.hud_waitingForPlayers.y + 30;
	level.hud_playersReady.color = color_yellow;
	level.hud_playersReady.fontScale = fontScale_playerCount;
    level.hud_playersReady.font = "bigfixed";
    
    level.hud_playersMin = newHudElem();
    level.hud_playersMin.alignX = "center";
    level.hud_playersMin.alignY = "middle";
	level.hud_playersMin.x = level.hud_waitingForPlayers.x + distance_ready_min;
	level.hud_playersMin.y = level.hud_playersReady.y;
	level.hud_playersMin.color = color_yellow;
	level.hud_playersMin.fontScale = fontScale_playerCount;
    level.hud_playersMin.font = "bigfixed";
    level.hud_playersMin.label = &"/";
    level.hud_playersMin setValue(level.minPlayers);

	for(;;)
	{
        numberOfConnectedPlayers = [];
		for(i = 0; i < level.maxClients; i++)
		{
			player = getEntByNum(i);
			if(isDefined(player))
			{
				if(isDefined(player.pers["connected"]))
				{
					//PLAYER IS CONNECTED
					numberOfConnectedPlayers[numberOfConnectedPlayers.size] = player;
				}
			}
		}
        level.hud_playersReady setValue(numberOfConnectedPlayers.size);

		if(numberOfConnectedPlayers.size > 0) //AT LEAST 1 READY PLAYER
		{
			if(numberOfConnectedPlayers.size < level.minPlayers) //MIN PLAYERS NOT REACHED YET
			{
				if(isDefined(level.startingBattle)) //Lost required players count, reset
				{
                    level notify("battle_cancel");
                    level.startingBattle = undefined;

                    level.hud_waitingForPlayers destroy();

                    //Recreate hud because can't clear timer
                    level.hud_waitingForPlayers = newHudElem();
                    level.hud_waitingForPlayers.alignX = "center";
                    level.hud_waitingForPlayers.alignY = "middle";
                    level.hud_waitingForPlayers.x = 320;
                    level.hud_waitingForPlayers.y = 40;
                    level.hud_waitingForPlayers.color = color_yellow;
                    level.hud_waitingForPlayers.fontScale = 1.5;
                    level.hud_waitingForPlayers.font = "bigfixed";
				}
                level.hud_waitingForPlayers setText(&"WAITING FOR PLAYERS");
			}
			else if(numberOfConnectedPlayers.size >= level.minPlayers) //MIN PLAYERS REACHED, START COUNTDOWN
			{
				if (numberOfConnectedPlayers.size <= level.maxClients && !isDefined(level.startingBattle))
				{
					level.hud_waitingForPlayers setText(&"");
                    level.hud_waitingForPlayers.color = color_red;
                    level.hud_waitingForPlayers.label = &"BATTLE STARTING ";
					level.hud_waitingForPlayers setTimer(level.startBattleCountdown);
                    thread startBattle();
				}
			}
		}

		wait .05;
	}
}
startBattle()
{
    level endon("battle_cancel");
    level.startingBattle = true;
	wait level.startBattleCountdown;
    level notify("battle_start");

    level.startingBattle = undefined;
    
    level.hud_waitingBackground destroy();
    level.hud_waitingForPlayers destroy();
    level.hud_playersReady destroy();
    level.hud_playersMin destroy();

    //using map zh_frenzy
	originPlane = (2050, -14350, 8070);
    anglesPlane = (0, 90, 0);
    level.plane = spawn("script_model", originPlane);
	level.plane setModel(level.planeModel);
    level.plane.angles = anglesPlane;

    originPlanePov =
		(level.plane.origin[0],
		level.plane.origin[1] - 700,
		level.plane.origin[2] + 400);
    anglesPlanePov =
		(level.plane.angles[0] + 25,
		level.plane.angles[1],
		level.plane.angles[2]);

    moveDistance = 30000;
	moveDelay = 22;
    level.planePov = spawn("script_origin", originPlanePov);

    //MAKE PLAYERS TO FOLLOW THE PLANE
    players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

        player.willLand = true;
        player closeMenu();

        if (!isDefined(player.pers["camouflage"]))
            player.pers["camouflage"] = level.camouflages[randomInt(level.camouflages.size)];
        if (!isDefined(player.pers["weapon"]))
            player.pers["weapon"] = "mosin_nagant_mp";

        player spawnPlayer(originPlanePov, anglesPlanePov);
        player showToPlayer(player); //TODO: use an invisible model instead
        player linkto(level.planePov);
        player thread checkPlayerJumped();
    }
    level.plane moveY(moveDistance, moveDelay);
    level.planePov moveY(moveDistance, moveDelay);

    wait moveDelay;
    
    for(i = 0; i < players.size; i++)
	{
		player = players[i];
        if (isAlive(player) && !isDefined(player.jumped))
        {
            player.forceJump = true;
        }
    }

    wait .05;
    level.plane delete();
    level.planePov delete();
}

//SKYDIVE FUNCTIONS
checkPlayerJumped()
{
    self.hud_jump_parachute = newClientHudElem(self);
    self.hud_jump_parachute.alignX = "center";
    self.hud_jump_parachute.alignY = "middle";
    self.hud_jump_parachute.x = 320;
	self.hud_jump_parachute.y = 40;
	self.hud_jump_parachute.fontScale = 1.2;
	self.hud_jump_parachute setText(&"^3Press ^1[{+activate}] ^3to jump");

	for(;;)
	{
		if (self useButtonPressed() || isDefined(self.forceJump))
		{
            self.jumped = true;
            self.hud_jump_parachute setText(&"");

			anglesBeforeSpawn = self getPlayerAngles();
            self spawnPlayer(level.planePov.origin, anglesBeforeSpawn);
            self showToPlayer(undefined);
			//self setClientCvar("cg_thirdPerson", "1"); //TODO: remove after tests

			delayExitPlane = 0.35;
			underPlaneOrigin =
				(level.planePov.origin[0],
				level.planePov.origin[1] - 100,
				(level.planePov.origin[2] - 1000));

            self.jumpPov = spawn("script_origin", level.planePov.origin);
            self linkto(self.jumpPov);
			self.jumpPov moveTo(underPlaneOrigin, delayExitPlane);
			wait delayExitPlane;

			self unlink();
			self.jumpPov delete();
			self thread checkPlayerDive();

			break;
		}
		wait .05;
	}
}
checkReleasedUseButton()
{
    self endon("disconnect");
    self endon("landed");
    while(self useButtonPressed())
    {
        wait .05;
    }
    self.blockParachuteCheck = false;
}
checkPlayerDive()
{
    self thread checkLanded();

    self.hud_jump_parachute setText(&"^3Press ^1[{+activate}] ^3to open/close parachute");

    self.parachuteEnabled = false;
    self.hudParachute_indicatorTest = newClientHudElem(self); //TODO: remove after tests
    self.hudParachute_indicatorTest.x = 70;
    self.hudParachute_indicatorTest.y = 200;
    self.hudParachute_indicatorTest.fontScale = 1.3;
    self.hudParachute_indicatorTest setText(&"^1PARACHUTE CLOSED");

    self.blockParachuteCheck = false;

    //PHYSICS VARIABLES
    //Acceleration multiplier (diagonal fall)
    acceleration_skydive_forward = 50;
    acceleration_skydive_onlyLeftRight = 35;
    acceleration_skydive_forwardLeftRight = 45;

    acceleration_parachute_forward = 70;
    acceleration_parachute_onlyLeftRight = 50;
    acceleration_parachute_forwardLeftRight = 60;

    acceleration_parachute_backward = 45;
    acceleration_parachute_backwardLeftRight = 30;

    //Air resistance multiplier (fall slowdown)
    airResistance_skydive_idle = 0.975;
    airResistance_skydive_forward = 0.995;
    airResistance_parachute_idle = 0.85;
    airResistance_parachute_forward = 0.96;

    //CHECK MOVEMENTS
	for(;;)
	{
		self endon("landed");

        //DIRECTION KEYS CHECK
        goingForward = false;
        goingBackward = false;
        goingLeft = false;
        goingRight = false;
        if (self forwardButtonPressed())
            goingForward = true;
        if (self backButtonPressed())
            goingBackward = true;
        if (self leftButtonPressed())
            goingLeft = true;
        if (self rightButtonPressed())
            goingRight = true;

        if (goingLeft && goingRight)
        {
            //left + right = neither
            goingLeft = false;
            goingRight = false;
        }
        if (goingForward && goingBackward)
        {
            //forward + backward = neither
            goingForward = false;
            goingBackward = false;
        }

        //PARACHUTE STATE CHECK
        checkParachute = false;
        if (self useButtonPressed() && !self.blockParachuteCheck)
        {
            self.blockParachuteCheck = true;
            self thread checkReleasedUseButton();
            checkParachute = true;
        }
        if (checkParachute)
        {
            if (!self.parachuteEnabled)
            {
                //OPEN
                self.hudParachute_indicatorTest setText(&"^2PARACHUTE OPENED"); //TODO: remove after tests
                self.parachuteEnabled = true;
                self attach(level.parachuteModel, "tag_belt_back");
            }
            else
            {
                //CLOSE
                self.hudParachute_indicatorTest setText(&"^1PARACHUTE CLOSED");
                self.parachuteEnabled = false;
                self detach(level.parachuteModel, "tag_belt_back");
            }
        }
        
        velocity = self getVelocity();
        angles = self getPlayerAngles();
		forwardDirection = anglesToForward(angles);
        backwardDirection = anglesToBackward(angles);
        leftDirection = anglesToLeft(angles);
        rightDirection = anglesToRight(angles);

        //printLn("### angles[0] = " + angles[0]);
        isLookingUp = false;
        isLookingDown = false;
        if (angles[0] < -30)
        {
            isLookingUp = true;
        }
        else if (angles[0] > 30)
        {
            isLookingDown = true;
        }
        
        //APPLY MOTION EFFECTS
        if (self.parachuteEnabled)
        {
            if (goingForward)
            {
                if (isLookingUp) //Prevent acceleration from pushing upward
                {
                    //AS IDLE
                    newVelocity_x = velocity[0];
                    newVelocity_y = velocity[1];
                    newVelocity_z = velocity[2];
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_idle);
                }
                else if (goingLeft)
                {
                    newVelocity_x = velocity[0] + (forwardDirection[0] + leftDirection[0]) * acceleration_parachute_forwardLeftRight;
                    newVelocity_y = velocity[1] + (forwardDirection[1] + leftDirection[1]) * acceleration_parachute_forwardLeftRight;
                    newVelocity_z = velocity[2] + (forwardDirection[2] + leftDirection[2]) * acceleration_parachute_forwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
                else if (goingRight)
                {
                    newVelocity_x = velocity[0] + (forwardDirection[0] + rightDirection[0]) * acceleration_parachute_forwardLeftRight;
                    newVelocity_y = velocity[1] + (forwardDirection[1] + rightDirection[1]) * acceleration_parachute_forwardLeftRight;
                    newVelocity_z = velocity[2] + (forwardDirection[2] + rightDirection[2]) * acceleration_parachute_forwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
                else
                {
                    //JUST FORWARD
                    newVelocity_x = velocity[0] + forwardDirection[0] * acceleration_parachute_forward;
                    newVelocity_y = velocity[1] + forwardDirection[1] * acceleration_parachute_forward;
                    newVelocity_z = velocity[2] + forwardDirection[2] * acceleration_parachute_forward;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
            }
            else if (goingBackward)
            {
                if (isLookingDown) //Prevent acceleration from pushing upward
                {
                    //AS IDLE
                    newVelocity_x = velocity[0];
                    newVelocity_y = velocity[1];
                    newVelocity_z = velocity[2];
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_idle);
                }
                else if (goingLeft)
                {
                    newVelocity_x = velocity[0] + (backwardDirection[0] + leftDirection[0]) * acceleration_parachute_backwardLeftRight;
                    newVelocity_y = velocity[1] + (backwardDirection[1] + leftDirection[1]) * acceleration_parachute_backwardLeftRight;
                    newVelocity_z = velocity[2] + (backwardDirection[2] + leftDirection[2]) * acceleration_parachute_backwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
                else if (goingRight)
                {
                    newVelocity_x = velocity[0] + (backwardDirection[0] + rightDirection[0]) * acceleration_parachute_backwardLeftRight;
                    newVelocity_y = velocity[1] + (backwardDirection[1] + rightDirection[1]) * acceleration_parachute_backwardLeftRight;
                    newVelocity_z = velocity[2] + (backwardDirection[2] + rightDirection[2]) * acceleration_parachute_backwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
                else
                {
                    //JUST BACKWARD
                    newVelocity_x = velocity[0] + backwardDirection[0] * acceleration_parachute_backward;
                    newVelocity_y = velocity[1] + backwardDirection[1] * acceleration_parachute_backward;
                    newVelocity_z = velocity[2] + backwardDirection[2] * acceleration_parachute_backward;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
            }
            else if (goingLeft)
            {
                //JUST LEFT
                newVelocity_x = velocity[0] + leftDirection[0] * acceleration_parachute_onlyLeftRight;
                newVelocity_y = velocity[1] + leftDirection[1] * acceleration_parachute_onlyLeftRight;
                newVelocity_z = velocity[2] + leftDirection[2] * acceleration_parachute_onlyLeftRight;
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
            }
            else if (goingRight)
            {
                //JUST RIGHT
                newVelocity_x = velocity[0] + rightDirection[0] * acceleration_parachute_onlyLeftRight;
                newVelocity_y = velocity[1] + rightDirection[1] * acceleration_parachute_onlyLeftRight;
                newVelocity_z = velocity[2] + rightDirection[2] * acceleration_parachute_onlyLeftRight;
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
            }
            else
            {
                //IDLE
                newVelocity_x = velocity[0];
                newVelocity_y = velocity[1];
                newVelocity_z = velocity[2];
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_idle);
            }
        }
        else //PARACHUTE DISABLED
        {
            if (goingForward)
            {
                if (isLookingUp) //Prevent acceleration from pushing upward
                {
                    //AS IDLE
                    newVelocity_x = velocity[0];
                    newVelocity_y = velocity[1];
                    newVelocity_z = velocity[2];
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_idle);
                }
                else if (goingLeft)
                {
                    newVelocity_x = velocity[0] + (forwardDirection[0] + leftDirection[0]) * acceleration_skydive_forwardLeftRight;
                    newVelocity_y = velocity[1] + (forwardDirection[1] + leftDirection[1]) * acceleration_skydive_forwardLeftRight;
                    newVelocity_z = velocity[2] + (forwardDirection[2] + leftDirection[2]) * acceleration_skydive_forwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
                }
                else if (goingRight)
                {
                    newVelocity_x = velocity[0] + (forwardDirection[0] + rightDirection[0]) * acceleration_skydive_forwardLeftRight;
                    newVelocity_y = velocity[1] + (forwardDirection[1] + rightDirection[1]) * acceleration_skydive_forwardLeftRight;
                    newVelocity_z = velocity[2] + (forwardDirection[2] + rightDirection[2]) * acceleration_skydive_forwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
                }
                else
                {
                    //JUST FORWARD
                    newVelocity_x = velocity[0] + forwardDirection[0] * acceleration_skydive_forward;
                    newVelocity_y = velocity[1] + forwardDirection[1] * acceleration_skydive_forward;
                    newVelocity_z = velocity[2] + forwardDirection[2] * acceleration_skydive_forward;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
                }
            }
            else if (goingLeft)
            {
                //JUST LEFT
                newVelocity_x = velocity[0] + leftDirection[0] * acceleration_skydive_onlyLeftRight;
                newVelocity_y = velocity[1] + leftDirection[1] * acceleration_skydive_onlyLeftRight;
                newVelocity_z = velocity[2] + leftDirection[2] * acceleration_skydive_onlyLeftRight;
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
            }
            else if (goingRight)
            {
                //JUST RIGHT
                newVelocity_x = velocity[0] + rightDirection[0] * acceleration_skydive_onlyLeftRight;
                newVelocity_y = velocity[1] + rightDirection[1] * acceleration_skydive_onlyLeftRight;
                newVelocity_z = velocity[2] + rightDirection[2] * acceleration_skydive_onlyLeftRight;
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
            }
            else
            {
                //IDLE
                newVelocity_x = velocity[0];
                newVelocity_y = velocity[1];
                newVelocity_z = velocity[2];
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_idle);
            }
        }
        
        self setVelocity(newVelocity);
        
		wait .05;
	}
}
checkLanded()
{
	for(;;)
	{
		if (self isOnGround())
		{
			self notify("landed");
            self.willLand = false;

            self.hud_jump_parachute destroy();
            self.hudParachute_indicatorTest destroy();

            if (self.parachuteEnabled)
            {
                self detach(level.parachuteModel, "tag_belt_back");
                self.parachuteEnabled = false;
            }
            //self setClientCvar("cg_thirdPerson", "0");
            
            wait .5;
            loadout();
            self giveWeapon(self.pers["weapon"]);
            self giveMaxAmmo(self.pers["weapon"]);
            self switchToWeapon(self.pers["weapon"]);

			break;
		}
		wait .05;
	}
}
//SKYDIVE FUNCTIONS END

showDamageFeedback()
{
    self endon("spawned");
    self endon("disconnect");

    if(isDefined(self.hitBlip))
        self.hitBlip destroy();

    self.hitBlip = newClientHudElem(self);
    self.hitBlip.alignX = "center";
    self.hitBlip.alignY = "middle";
    self.hitBlip.x = 320;
    self.hitBlip.y = 240;
    self.hitBlip.alpha = 1;
    self.hitBlip setShader("gfx/hud/damage_feedback.dds", 24, 24);

    self.hitBlip fadeOverTime(1);
	self.hitBlip.alpha = 0;

    wait 0.30;
    if(isDefined(self.hitBlip))
        self.hitBlip destroy();
}

//KILLCAM FUNCTIONS
killcam(attackerNum, delay)
{
	self endon("spawned");
	
	// killcam
	if(attackerNum < 0)
		return;

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
	
		return;
	}

	self.killcam = true;

	if(!isdefined(self.kc_topbar))
	{
		self.kc_topbar = newClientHudElem(self);
		self.kc_topbar.archived = false;
		self.kc_topbar.x = 0;
		self.kc_topbar.y = 0;
		self.kc_topbar.alpha = 0.5;
		self.kc_topbar setShader("black", 640, 112);
	}

	if(!isdefined(self.kc_bottombar))
	{
		self.kc_bottombar = newClientHudElem(self);
		self.kc_bottombar.archived = false;
		self.kc_bottombar.x = 0;
		self.kc_bottombar.y = 368;
		self.kc_bottombar.alpha = 0.5;
		self.kc_bottombar setShader("black", 640, 112);
	}

	if(!isdefined(self.kc_title))
	{
		self.kc_title = newClientHudElem(self);
		self.kc_title.archived = false;
		self.kc_title.x = 320;
		self.kc_title.y = 40;
		self.kc_title.alignX = "center";
		self.kc_title.alignY = "middle";
		self.kc_title.sort = 1; // force to draw after the bars
		self.kc_title.fontScale = 3.5;
	}
	self.kc_title setText(&"MPSCRIPT_KILLCAM");

	if(!isdefined(self.kc_skiptext))
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 320;
		self.kc_skiptext.y = 70;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.sort = 1; // force to draw after the bars
	}
	self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");

	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();
	self waittill("end_killcam");

	self removeKillcamElements();

	self.spectatorclient = -1;
	self.archivetime = 0;
	self.killcam = undefined;
}
waitKillcamTime()
{
	self endon("end_killcam");
	
	wait (self.archivetime - 0.05);
	self notify("end_killcam");
}
waitSkipKillcamButton()
{
	self endon("end_killcam");
	
	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;
	
	self notify("end_killcam");	
}
removeKillcamElements()
{
	if(isdefined(self.kc_topbar))
		self.kc_topbar destroy();
	if(isdefined(self.kc_bottombar))
		self.kc_bottombar destroy();
	if(isdefined(self.kc_title))
		self.kc_title destroy();
	if(isdefined(self.kc_skiptext))
		self.kc_skiptext destroy();
}
//KILLCAM FUNCTIONS END

//VSAY
quickcommands(response)
{
	if(!isdefined(self.pers["camouflage"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

    switch(self.pers["camouflage"])
    {
    case "american":
        switch(response)		
        {
        case "1":
            soundalias = "american_follow_me";
            saytext = &"QUICKMESSAGE_FOLLOW_ME";
            //saytext = "Follow Me!";
            break;

        case "2":
            soundalias = "american_move_in";
            saytext = &"QUICKMESSAGE_MOVE_IN";
            //saytext = "Move in!";
            break;

        case "3":
            soundalias = "american_fall_back";
            saytext = &"QUICKMESSAGE_FALL_BACK";
            //saytext = "Fall back!";
            break;

        case "4":
            soundalias = "american_suppressing_fire";
            saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
            //saytext = "Suppressing fire!";
            break;

        case "5":
            soundalias = "american_attack_left_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
            //saytext = "Squad, attack left flank!";
            break;

        case "6":
            soundalias = "american_attack_right_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
            //saytext = "Squad, attack right flank!";
            break;

        case "7":
            soundalias = "american_hold_position";
            saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
            //saytext = "Squad, hold this position!";
            break;

        case "8":
            temp = randomInt(2);

            if(temp)
            {
                soundalias = "american_regroup";
                saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
                //saytext = "Squad, regroup!";
            }
            else
            {
                soundalias = "american_stick_together";
                saytext = &"QUICKMESSAGE_SQUAD_STICK_TOGETHER";
                //saytext = "Squad, stick together!";
            }
            break;
        }
        break;

    case "british":
        switch(response)		
        {
        case "1":
            soundalias = "british_follow_me";
            saytext = &"QUICKMESSAGE_FOLLOW_ME";
            //saytext = "Follow Me!";
            break;

        case "2":
            soundalias = "british_move_in";
            saytext = &"QUICKMESSAGE_MOVE_IN";
            //saytext = "Move in!";
            break;

        case "3":
            soundalias = "british_fall_back";
            saytext = &"QUICKMESSAGE_FALL_BACK";
            //saytext = "Fall back!";
            break;

        case "4":
            soundalias = "british_suppressing_fire";
            saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
            //saytext = "Suppressing fire!";
            break;

        case "5":
            soundalias = "british_attack_left_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
            //saytext = "Squad, attack left flank!";
            break;

        case "6":
            soundalias = "british_attack_right_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
            //saytext = "Squad, attack right flank!";
            break;

        case "7":
            soundalias = "british_hold_position";
            saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
            //saytext = "Squad, hold this position!";
            break;

        case "8":
            temp = randomInt(2);

            if(temp)
            {
                soundalias = "british_regroup";
                saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
                //saytext = "Squad, regroup!";
            }
            else
            {
                soundalias = "british_stick_together";
                saytext = &"QUICKMESSAGE_SQUAD_STICK_TOGETHER";
                //saytext = "Squad, stick together!";
            }
            break;
        }
        break;

    case "russian":
        switch(response)		
        {
        case "1":
            soundalias = "russian_follow_me";
            saytext = &"QUICKMESSAGE_FOLLOW_ME";
            //saytext = "Follow Me!";
            break;

        case "2":
            soundalias = "russian_move_in";
            saytext = &"QUICKMESSAGE_MOVE_IN";
            //saytext = "Move in!";
            break;

        case "3":
            soundalias = "russian_fall_back";
            saytext = &"QUICKMESSAGE_FALL_BACK";
            //saytext = "Fall back!";
            break;

        case "4":
            soundalias = "russian_suppressing_fire";
            saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
            //saytext = "Suppressing fire!";
            break;

        case "5":
            soundalias = "russian_attack_left_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
            //saytext = "Squad, attack left flank!";
            break;

        case "6":
            soundalias = "russian_attack_right_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
            //saytext = "Squad, attack right flank!";
            break;

        case "7":
            soundalias = "russian_hold_position";
            saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
            //saytext = "Squad, hold this position!";
            break;

        case "8":
            soundalias = "russian_regroup";
            saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
            //saytext = "Squad, regroup!";
            break;
        }
        break;

    case "german":
        switch(response)		
        {
        case "1":
            soundalias = "german_follow_me";
            saytext = &"QUICKMESSAGE_FOLLOW_ME";
            //saytext = "Follow Me!";
            break;

        case "2":
            soundalias = "german_move_in";
            saytext = &"QUICKMESSAGE_MOVE_IN";
            //saytext = "Move in!";
            break;

        case "3":
            soundalias = "german_fall_back";
            saytext = &"QUICKMESSAGE_FALL_BACK";
            //saytext = "Fall back!";
            break;

        case "4":
            soundalias = "german_suppressing_fire";
            saytext = &"QUICKMESSAGE_SUPPRESSING_FIRE";
            //saytext = "Suppressing fire!";
            break;

        case "5":
            soundalias = "german_attack_left_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_LEFT_FLANK";
            //saytext = "Squad, attack left flank!";
            break;

        case "6":
            soundalias = "german_attack_right_flank";
            saytext = &"QUICKMESSAGE_SQUAD_ATTACK_RIGHT_FLANK";
            //saytext = "Squad, attack right flank!";
            break;

        case "7":
            soundalias = "german_hold_position";
            saytext = &"QUICKMESSAGE_SQUAD_HOLD_THIS_POSITION";
            //saytext = "Squad, hold this position!";
            break;

        case "8":
            soundalias = "german_regroup";
            saytext = &"QUICKMESSAGE_SQUAD_REGROUP";
            //saytext = "Squad, regroup!";
            break;
        }
        break;
    }

	self doQuickMessage(soundalias, saytext);

	wait level.quickChatDelay;
	self.spamdelay = undefined;
}
quickstatements(response)
{
	if(!isdefined(self.pers["camouflage"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;
	
	switch(self.pers["camouflage"])
    {
    case "american":
        switch(response)		
        {
        case "1":
            soundalias = "american_enemy_spotted";
            saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
            //saytext = "Enemy spotted!";
            break;

        case "2":
            soundalias = "american_enemy_down";
            saytext = &"QUICKMESSAGE_ENEMY_DOWN";
            //saytext = "Enemy down!";
            break;

        case "3":
            soundalias = "american_in_position";
            saytext = &"QUICKMESSAGE_IM_IN_POSITION";
            //saytext = "I'm in position.";
            break;

        case "4":
            soundalias = "american_area_secure";
            saytext = &"QUICKMESSAGE_AREA_SECURE";
            //saytext = "Area secure!";
            break;

        case "5":
            soundalias = "american_grenade";
            saytext = &"QUICKMESSAGE_GRENADE";
            //saytext = "Grenade!";
            break;

        case "6":
            soundalias = "american_sniper";
            saytext = &"QUICKMESSAGE_SNIPER";
            //saytext = "Sniper!";
            break;

        case "7":
            soundalias = "american_need_reinforcements";
            saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
            //saytext = "Need reinforcements!";
            break;

        case "8":
            soundalias = "american_hold_fire";
            saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
            //saytext = "Hold your fire!";
            break;
        }
        break;

    case "british":
        switch(response)		
        {
        case "1":
            soundalias = "british_enemy_spotted";
            saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
            //saytext = "Enemy spotted!";
            break;

        case "2":
            soundalias = "british_enemy_down";
            saytext = &"QUICKMESSAGE_ENEMY_DOWN";
            //saytext = "Enemy down!";
            break;

        case "3":
            soundalias = "british_in_position";
            saytext = &"QUICKMESSAGE_IM_IN_POSITION";
            //saytext = "I'm in position.";
            break;

        case "4":
            soundalias = "british_area_secure";
            saytext = &"QUICKMESSAGE_AREA_SECURE";
            //saytext = "Area secure!";
            break;

        case "5":
            soundalias = "british_grenade";
            saytext = &"QUICKMESSAGE_GRENADE";
            //saytext = "Grenade!";
            break;

        case "6":
            soundalias = "british_sniper";
            saytext = &"QUICKMESSAGE_SNIPER";
            //saytext = "Sniper!";
            break;

        case "7":
            soundalias = "british_need_reinforcements";
            saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
            //saytext = "Need reinforcements!";
            break;

        case "8":
            soundalias = "british_hold_fire";
            saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
            //saytext = "Hold your fire!";
            break;
        }
        break;

    case "russian":
        switch(response)		
        {
        case "1":
            soundalias = "russian_enemy_spotted";
            saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
            //saytext = "Enemy spotted!";
            break;

        case "2":
            soundalias = "russian_enemy_down";
            saytext = &"QUICKMESSAGE_ENEMY_DOWN";
            //saytext = "Enemy down!";
            break;

        case "3":
            soundalias = "russian_in_position";
            saytext = &"QUICKMESSAGE_IM_IN_POSITION";
            //saytext = "I'm in position.";
            break;

        case "4":
            soundalias = "russian_area_secure";
            saytext = &"QUICKMESSAGE_AREA_SECURE";
            //saytext = "Area secure!";
            break;

        case "5":
            soundalias = "russian_grenade";
            saytext = &"QUICKMESSAGE_GRENADE";
            //saytext = "Grenade!";
            break;

        case "6":
            soundalias = "russian_sniper";
            saytext = &"QUICKMESSAGE_SNIPER";
            //saytext = "Sniper!";
            break;

        case "7":
            soundalias = "russian_need_reinforcements";
            saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
            //saytext = "Need reinforcements!";
            break;

        case "8":
            soundalias = "russian_hold_fire";
            saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
            //saytext = "Hold your fire!";
            break;
        }
        break;
    
    case "german":
        switch(response)		
        {
        case "1":
            soundalias = "german_enemy_spotted";
            saytext = &"QUICKMESSAGE_ENEMY_SPOTTED";
            //saytext = "Enemy spotted!";
            break;

        case "2":
            soundalias = "german_enemy_down";
            saytext = &"QUICKMESSAGE_ENEMY_DOWN";
            //saytext = "Enemy down!";
            break;

        case "3":
            soundalias = "german_in_position";
            saytext = &"QUICKMESSAGE_IM_IN_POSITION";
            //saytext = "I'm in position.";
            break;

        case "4":
            soundalias = "german_area_secure";
            saytext = &"QUICKMESSAGE_AREA_SECURE";
            //saytext = "Area secure!";
            break;

        case "5":
            soundalias = "german_grenade";
            saytext = &"QUICKMESSAGE_GRENADE";
            //saytext = "Grenade!";
            break;

        case "6":
            soundalias = "german_sniper";
            saytext = &"QUICKMESSAGE_SNIPER";
            //saytext = "Sniper!";
            break;

        case "7":
            soundalias = "german_need_reinforcements";
            saytext = &"QUICKMESSAGE_NEED_REINFORCEMENTS";
            //saytext = "Need reinforcements!";
            break;

        case "8":
            soundalias = "german_hold_fire";
            saytext = &"QUICKMESSAGE_HOLD_YOUR_FIRE";
            //saytext = "Hold your fire!";
            break;
        }
        break;
    
    
    }

	self doQuickMessage(soundalias, saytext);

	wait level.quickChatDelay;
	self.spamdelay = undefined;
}
quickresponses(response)
{
	if(!isdefined(self.pers["camouflage"]) || self.pers["team"] == "spectator" || isdefined(self.spamdelay))
		return;

	self.spamdelay = true;

	switch(self.pers["camouflage"])
    {
    case "american":
        switch(response)		
        {
        case "1":
            soundalias = "american_yes_sir";
            saytext = &"QUICKMESSAGE_YES_SIR";
            //saytext = "Yes Sir!";
            break;

        case "2":
            soundalias = "american_no_sir";
            saytext = &"QUICKMESSAGE_NO_SIR";
            //saytext = "No Sir!";
            break;

        case "3":
            soundalias = "american_on_my_way";
            saytext = &"QUICKMESSAGE_ON_MY_WAY";
            //saytext = "On my way.";
            break;

        case "4":
            soundalias = "american_sorry";
            saytext = &"QUICKMESSAGE_SORRY";
            //saytext = "Sorry.";
            break;

        case "5":
            soundalias = "american_great_shot";
            saytext = &"QUICKMESSAGE_GREAT_SHOT";
            //saytext = "Great shot!";
            break;

        case "6":
            soundalias = "american_took_long_enough";
            saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
            //saytext = "Took long enough!";
            break;

        case "7":
            temp = randomInt(3);

            if(temp == 0)
            {
                soundalias = "american_youre_crazy";
                saytext = &"QUICKMESSAGE_YOURE_CRAZY";
                //saytext = "You're crazy!";
            }
            else if(temp == 1)
            {
                soundalias = "american_you_outta_your_mind";
                saytext = &"QUICKMESSAGE_YOU_OUTTA_YOUR_MIND";
                //saytext = "You outta your mind?";
            }
            else
            {
                soundalias = "american_youre_nuts";
                saytext = &"QUICKMESSAGE_YOURE_NUTS";
                //saytext = "You're nuts!";
            }
            break;
        }
        break;

    case "british":
        switch(response)		
        {
        case "1":
            soundalias = "british_yes_sir";
            saytext = &"QUICKMESSAGE_YES_SIR";
            //saytext = "Yes Sir!";
            break;

        case "2":
            soundalias = "british_no_sir";
            saytext = &"QUICKMESSAGE_NO_SIR";
            //saytext = "No Sir!";
            break;

        case "3":
            soundalias = "british_on_my_way";
            saytext = &"QUICKMESSAGE_ON_MY_WAY";
            //saytext = "On my way.";
            break;

        case "4":
            soundalias = "british_sorry";
            saytext = &"QUICKMESSAGE_SORRY";
            //saytext = "Sorry.";
            break;

        case "5":
            soundalias = "british_great_shot";
            saytext = &"QUICKMESSAGE_GREAT_SHOT";
            //saytext = "Great shot!";
            break;

        case "6":
            soundalias = "british_took_long_enough";
            saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
            //saytext = "Took long enough!";
            break;

        case "7":
            soundalias = "british_youre_crazy";
            saytext = &"QUICKMESSAGE_YOURE_CRAZY";
            //saytext = "You're crazy!";
            break;
        }
        break;

    case "russian":
        switch(response)		
        {
        case "1":
            soundalias = "russian_yes_sir";
            saytext = &"QUICKMESSAGE_YES_SIR";
            //saytext = "Yes Sir!";
            break;

        case "2":
            soundalias = "russian_no_sir";
            saytext = &"QUICKMESSAGE_NO_SIR";
            //saytext = "No Sir!";
            break;

        case "3":
            soundalias = "russian_on_my_way";
            saytext = &"QUICKMESSAGE_ON_MY_WAY";
            //saytext = "On my way.";
            break;

        case "4":
            soundalias = "russian_sorry";
            saytext = &"QUICKMESSAGE_SORRY";
            //saytext = "Sorry.";
            break;

        case "5":
            soundalias = "russian_great_shot";
            saytext = &"QUICKMESSAGE_GREAT_SHOT";
            //saytext = "Great shot!";
            break;

        case "6":
            soundalias = "russian_took_long_enough";
            saytext = &"QUICKMESSAGE_TOOK_LONG_ENOUGH";
            //saytext = "Took long enough!";
            break;

        case "7":
            soundalias = "russian_youre_crazy";
            saytext = &"QUICKMESSAGE_YOURE_CRAZY";
            //saytext = "You're crazy!";
            break;
        }
        break;
    case "german":
        switch(response)		
        {
        case "1":
            soundalias = "german_yes_sir";
            saytext = &"QUICKMESSAGE_YES_SIR";
            //saytext = "Yes Sir!";
            break;

        case "2":
            soundalias = "german_no_sir";
            saytext = &"QUICKMESSAGE_NO_SIR";
            //saytext = "No Sir!";
            break;

        case "3":
            soundalias = "german_on_my_way";
            saytext = &"QUICKMESSAGE_ON_MY_WAY";
            //saytext = "On my way.";
            break;

        case "4":
            soundalias = "german_sorry";
            saytext = &"QUICKMESSAGE_SORRY";
            //saytext = "Sorry.";
            break;

        case "5":
            soundalias = "german_great_shot";
            saytext = &"QUICKMESSAGE_GREAT_SHOT";
            //saytext = "Great shot!";
            break;

        case "6":
            soundalias = "german_took_long_enough";
            saytext = &"QUICKMESSAGE_TOOK_YOU_LONG_ENOUGH";
            //saytext = "Took you long enough!";				
            break;

        case "7":
            soundalias = "german_are_you_crazy";
            saytext = &"QUICKMESSAGE_ARE_YOU_CRAZY";
            //saytext = "Are you crazy?";
            break;
        }
        break;
    }

	self doQuickMessage(soundalias, saytext);

	wait level.quickChatDelay;
	self.spamdelay = undefined;
}
doQuickMessage(soundalias, saytext)
{
	if(self.sessionstate != "playing")
		return;

	self playSound(soundalias);
	self sayAll(saytext);
}
//VSAY END

//UTILS
model()
{
	self detachAll();
	[[game[self.pers["camouflage"] + "_model"] ]]();
	self.pers["savedmodel"] = maps\mp\_utility::saveModel();
}

isBoltWeapon(sWeapon)
{
    switch(sWeapon)
    {
        case "enfield_mp":
        case "kar98k_mp":
        case "kar98k_sniper_mp":
        case "mosin_nagant_mp":
        case "mosin_nagant_sniper_mp":
        case "springfield_mp":
        return true;
    }
    return false;
}
isSecondaryWeapon(sWeapon)
{
    switch(sWeapon)
    {
        case "colt_mp":
        case "luger_mp":
        return true;
    }
    return false;
}
loadout()
{
	switch(self.pers["camouflage"])
    {
    case "american":
        self giveWeapon("colt_mp");
        self giveMaxAmmo("colt_mp");
        self giveWeapon("fraggrenade_mp");
        self giveMaxAmmo("fraggrenade_mp");
        break;

    case "british":
        self giveWeapon("colt_mp");
        self giveMaxAmmo("colt_mp");
        self giveWeapon("mk1britishfrag_mp");
        self giveMaxAmmo("mk1britishfrag_mp");
        break;

    case "russian":
        self giveWeapon("luger_mp");
        self giveMaxAmmo("luger_mp");
        self giveWeapon("rgd-33russianfrag_mp");
        self giveMaxAmmo("rgd-33russianfrag_mp");
        break;
        
    case "german":
        self giveWeapon("luger_mp");
        self giveMaxAmmo("luger_mp");
        self giveWeapon("stielhandgranate_mp");
        self giveMaxAmmo("stielhandgranate_mp");
        break;
    }
}

anglesToLeft(angles)
{
    rightDirection = anglesToRight(angles);
    leftDirection = maps\mp\_utility::vectorScale(rightDirection, -1);
    return leftDirection;
}
anglesToBackward(angles)
{
    forwardDirection = anglesToForward(angles);
    backwardDirection = maps\mp\_utility::vectorScale(forwardDirection, -1);
    return backwardDirection;
}
//UTILS END
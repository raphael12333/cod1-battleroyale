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
	level.startBattleCountdown = 5;
    level.quickChatDelay = 0.8;
    level.planeModel = "xmodel/c47";

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
    //MENUS
    game["menu_camouflage"] = "camouflage";
	game["menu_weapon_all"] = "weapon_bolt";
    game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";
	precacheMenu(game["menu_camouflage"]);
	precacheMenu(game["menu_weapon_all"]);
	precacheMenu(game["menu_quickcommands"]);
	precacheMenu(game["menu_quickstatements"]);
	precacheMenu(game["menu_quickresponses"]);

	precacheShader("black");
	precacheShader("hudScoreboard_mp");
	precacheShader("gfx/hud/hud@mpflag_none.tga");
	precacheShader("gfx/hud/hud@mpflag_spectator.tga");
	precacheStatusIcon("gfx/hud/hud@status_dead.tga");
	precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
	precacheItem("item_health");

    precacheHeadIcon("gfx/hud/headicon@quickmessage");

    precacheShader("gfx/hud/damage_feedback.dds");

    //PLANE
    precacheModel(level.planeModel);

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

	lpselfnum = self getEntityNumber();
	logPrint("J;" + lpselfnum + ";" + self.name + "\n");
	
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
			}
		}
		else if(menu == game["menu_weapon_all"])
		{
			if(response == "camouflage")
			{
				self openMenu(game["menu_camouflage"]);
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

	lpselfnum = self getEntityNumber();
	logPrint("Q;" + lpselfnum + ";" + self.name + "\n");
}
Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    if ((self.sessionteam == "spectator") || (self.god == true))
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// Make sure at least one point of damage is done
	if(iDamage < 1)
		iDamage = 1;

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

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

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("D;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
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
	self.headicon = "";
	self.pers["deaths"]++;
	self.deaths = self.pers["deaths"];

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

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

	logPrint("K;" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

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

	colorYellow = (1, 1, 0);
	color_battleStarting = (1, 0, 0);
	fontScale_battleStarting = 1.8;
	fontScale_playerCount = 1.1;

	level.hud_waitingForPlayers = newHudElem();
	level.hud_waitingForPlayers.alignX = "center";
	level.hud_waitingForPlayers.x = 320;
	level.hud_waitingForPlayers.y = 90;
	level.hud_waitingForPlayers.color = colorYellow;
	level.hud_waitingForPlayers.fontScale = 1.5;

	level.hud_playersConnecting = newHudElem();
	level.hud_playersConnecting.x = 480;
	level.hud_playersConnecting.y = 240;
	level.hud_playersConnecting.color = colorYellow;
	level.hud_playersConnecting.fontScale = fontScale_playerCount;
	level.hud_playersConnecting.label = &"Players connecting: ";

	level.hud_playersConnected = newHudElem();
	level.hud_playersConnected.x = level.hud_playersConnecting.x;
	level.hud_playersConnected.y = level.hud_playersConnecting.y + 20;
	level.hud_playersConnected.color = colorYellow;
	level.hud_playersConnected.fontScale = fontScale_playerCount;
	level.hud_playersConnected.label = &"Players connected: ";

	for(;;)
	{
        numberOfConnectingPlayers = [];
		numberOfConnectedPlayers = [];
		for(i = 0; i < level.maxClients; i++)
		{
			player = getEntByNum(i);
			if(isDefined(player))
			{
				if(!isDefined(player.pers["connected"]))
				{
					//PLAYER IS CONNECTING
					numberOfConnectingPlayers[numberOfConnectingPlayers.size] = player;
				}
				else
				{
					//PLAYER IS CONNECTED
					numberOfConnectedPlayers[numberOfConnectedPlayers.size] = player;
				}
			}
		}
        level.hud_playersConnecting setValue(numberOfConnectingPlayers.size);
        level.hud_playersConnected setValue(numberOfConnectedPlayers.size);

		if(numberOfConnectedPlayers.size > 0) //AT LEAST 1 READY PLAYER
		{
			if(numberOfConnectedPlayers.size < level.minPlayers) //MIN PLAYERS NOT REACHED YET
			{
				if(isDefined(level.hud_startingBattle))
				{
					level.hud_startingBattle destroy();
					level notify("battle_cancel");
				}
                level.hud_waitingForPlayers setText(&"Waiting for players");
			}
			else if(numberOfConnectedPlayers.size >= level.minPlayers) //MIN PLAYERS REACHED, START COUNTDOWN
			{
				if (numberOfConnectedPlayers.size < level.maxClients)
				{
					level.hud_waitingForPlayers setText(&"Accepting more players");
				}
				else
				{
					level.hud_waitingForPlayers setText(&"Server is full");
				}
				if (!isDefined(level.hud_startingBattle))
				{
					level.hud_startingBattle = newHudElem();
					level.hud_startingBattle.x = 50;
					level.hud_startingBattle.y = level.hud_waitingForPlayers.y + 70;
					level.hud_startingBattle.color = color_battleStarting;
					level.hud_startingBattle.fontScale = fontScale_battleStarting;
					level.hud_startingBattle.label = &"Battle starting ";
					level.hud_startingBattle setTimer(level.startBattleCountdown);
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
    
	wait level.startBattleCountdown;
	printLn("#### START BATTLE");

    level notify("battle_start");
    
    level.hud_waitingForPlayers destroy();
    level.hud_playersConnecting destroy();
    level.hud_playersConnected destroy();
    level.hud_startingBattle destroy();

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

    //MAKE PLAYERS TO FOLLOW THE PLANE
    players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

        if (!isDefined(player.pers["camouflage"]))
            player.pers["camouflage"] = level.camouflages[randomInt(level.camouflages.size)];
        if (!isDefined(player.pers["weapon"]))
            player.pers["weapon"] = "mosin_nagant_mp";

        player.willLand = true;

        player spawnPlayer(originPlanePov, anglesPlanePov);
        player showToPlayer(player); //TODO: use an invisible model instead
        player closeMenu();
    }

    moveDistance = 30000;
	moveDelay = 22;

	for(i = 0; i < players.size; i++)
	{
		player = players[i];
        player.planePov = spawn("script_origin", originPlanePov);
        player linkto(player.planePov);
    }
    level.plane moveY(moveDistance, moveDelay);
    for(i = 0; i < players.size; i++)
	{
		player = players[i];
        player.planePov moveY(moveDistance, moveDelay);
        player.god = true; //TODO: remove after tests

        player thread checkPlayerJumped();
    }

    wait moveDelay;
	level.plane delete();
}

//SKYDIVE FUNCTIONS
checkPlayerJumped()
{
	for(;;)
	{
		if (self useButtonPressed())
		{
			anglesBeforeSpawn = self getPlayerAngles();

            self spawnPlayer(self.planePov.origin, anglesBeforeSpawn);
            self showToPlayer(undefined);
			//self setClientCvar("cg_thirdPerson", "1"); //TODO: remove after tests
			self linkto(self.planePov);

			delayExitPlane = 0.20;
			underPlaneOrigin =
				(self.planePOV.origin[0],
				self.planePOV.origin[1] - 100,
				(self.planePOV.origin[2] - 1000));
			self.planePOV moveTo(underPlaneOrigin, delayExitPlane);
			wait delayExitPlane;

			self unlink();
			self.planePOV delete();
			self thread checkPlayerDive();

			break;
		}
		wait .05;
	}
}








checkPlayerDive()
{
	self thread checkLanded();

	self setGravity(300);

    friction_base = 0.975; //No ButtonPressed + not using parachute

    acceleration_forward = 30;
    acceleration_onlyLeftRight = 15;
	
    g_speed = getCvar("g_speed");
    speed_base = g_speed;
    speed_forward = speed_base;
    speed_onlyLeftRight = speed_base;

	for(;;)
	{
		self endon("landed");

		velocity = self getVelocity();
		angles = self getPlayerAngles();

		forwardDirection = anglesToForward(angles);
        leftDirection = anglesToLeft(angles);
        rightDirection = anglesToRight(angles);

        goingForward = false;
        goingLeft = false;
        goingRight = false;
        if (self forwardButtonPressed())
            goingForward = true;
        if (self leftButtonPressed())
            goingLeft = true;
        if (self rightButtonPressed())
            goingRight = true;
        
        if (goingLeft && goingRight)
        {
            //left + right pressed = neither
            goingLeft = false;
            goingRight = false;
        }
        
        noKeyPressed = false;
        if (goingForward)
        {
            //GOING FORWARD
            if (goingLeft)
            {
                velocity_x = velocity[0] + (forwardDirection[0] + leftDirection[0]) * acceleration_forward;
                velocity_y = velocity[1] + (forwardDirection[1] + leftDirection[1]) * acceleration_forward;
                velocity_z = velocity[2] + (forwardDirection[2] + leftDirection[2]) * acceleration_forward;
            }
            else if (goingRight)
            {
                velocity_x = velocity[0] + (forwardDirection[0] + rightDirection[0]) * acceleration_forward;
                velocity_y = velocity[1] + (forwardDirection[1] + rightDirection[1]) * acceleration_forward;
                velocity_z = velocity[2] + (forwardDirection[2] + rightDirection[2]) * acceleration_forward;
            }
            else
            {
                //JUST FORWARD
                velocity_x = velocity[0] + forwardDirection[0] * acceleration_forward;
                velocity_y = velocity[1] + forwardDirection[1] * acceleration_forward;
                velocity_z = velocity[2] + forwardDirection[2] * acceleration_forward;
            }
        }
        else
        {
            //NOT GOING FORWARD
            if (goingLeft)
            {
                velocity_x = velocity[0] + leftDirection[0] * acceleration_onlyLeftRight;
                velocity_y = velocity[1] + leftDirection[1] * acceleration_onlyLeftRight;
                velocity_z = velocity[2] + leftDirection[2] * acceleration_onlyLeftRight;
            }
            else if (goingRight)
            {
                velocity_x = velocity[0] + rightDirection[0] * acceleration_onlyLeftRight;
                velocity_y = velocity[1] + rightDirection[1] * acceleration_onlyLeftRight;
                velocity_z = velocity[2] + rightDirection[2] * acceleration_onlyLeftRight;
            }
            else
            {
                //NO KEY PRESSED
                noKeyPressed = true;
            }
        }




        /*
        if (noKeyPressed)
        {
            speed = speed_base;
            velocity = maps\mp\_utility::vectorScale(velocity, friction_base);
        }*/
        if (!noKeyPressed)
        {
            if (goingForward)
            {
                speed = speed_forward;
            }
            else
            {
                speed = speed_onlyLeftRight;
            }
            velocity = (velocity_x, velocity_y, velocity_z);

            self setSpeed(speed);
		    self setVelocity(velocity);
        }




        
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

            g_gravity = getCvar("g_gravity");
            g_speed = getCvar("g_speed");
			self setGravity(g_gravity);
			self setSpeed(g_speed);
			//self setClientCvar("cg_thirdPerson", "0");

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
    rightVector = anglesToRight(angles);
    // Invert the right vector
    leftVector = maps\mp\_utility::vectorScale(rightVector, -1);
    return leftVector;
}
//UTILS END
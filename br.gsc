main()
{
    level.callbackStartGameType = ::Callback_StartGameType;
    level.callbackPlayerConnect = ::Callback_PlayerConnect;
    level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
    level.callbackPlayerDamage = ::Callback_PlayerDamage;
    level.callbackPlayerKilled = ::Callback_PlayerKilled;
    maps\mp\gametypes\_callbacksetup::SetupCallbacks();

    nearDistance = 0; //Distance from the camera that the fog will start
    farDistance = 20000; //Distance from the camera that full occlusion will occur
    red = 0.7;
    green = 0.7;
    blue = 0.7;
    transitionTime = 0;
    setCullFog(nearDistance, farDistance, red, green, blue, transitionTime);
    ambientPlay("ambient_mp_harbor");
    game["layoutimage"] = "zh_frenzy";

    level.connectOrigin = (-3580, 2890, 2790);
    level.connectAngles = (25, -35, 0);

    level.objectiveText = "Be the last man standing.";
    level.maxClients = getCvarInt("sv_maxclients");
    level.text_waitingPlayers = &"WAITING FOR PLAYERS";
    level.text_parachuteDeployed = &"PARACHUTE DEPLOYED";
    level.text_parachuteNotDeployed = &"PARACHUTE NOT DEPLOYED";
    level.text_zoneIsShrinking = &"ZONE SHRINKING ";
    level.text_zoneWillShrink = &"ZONE SHRINKS IN ";

    level.minPlayers = 20;
    if(getCvarInt("br_minPlayers")) {
        level.minPlayers = getCvarInt("br_minPlayers");
    }
    level.startBattleCountdown = 60;
    if(getCvarInt("br_startBattleCountdown")) {
        level.startBattleCountdown = getCvarInt("br_startBattleCountdown");
    }
    level.quickChatDelay = 1;
    if(getCvarFloat("br_quickChatDelay")) {
        level.quickChatDelay = getCvarFloat("br_quickChatDelay");
    }
    level.instantKill_bolt = true;
    if(getCvar("br_instantkill_bolt") == "0") {
        level.instantKill_bolt = false;
    }
    level.instantKill_pistol = false;
    if(getCvarInt("br_instantkill_pistol")) {
        level.instantKill_pistol = true;
    }
    level.instantKill_melee = true;
    if(getCvar("br_instantkill_melee") == "0") {
        level.instantKill_melee = false;
    }
    level.damageFeedback = true;
    if(getCvar("br_damagefeedback") == "0") {
        level.damageFeedback = false;
    }




    level.zoneDuration = 120;

    level.killcamDuration = 5;




    //MODEL PATHS
    level.model_zone = "xmodel/playerhead_default"; //TODO: create an invisible model instead
    level.model_plane = "xmodel/c47";
    level.model_parachute = "xmodel/bx_parachute";

    level.camouflages = [];
    level.camouflages[0] = "american";
    level.camouflages[1] = "british";
    level.camouflages[2] = "german";
    level.camouflages[3] = "russian";

    zoneOriginStart = (1190, -1060, -520); //~center of map (zh_frenzy)
    level.zone = spawn("script_model", zoneOriginStart);
    level.zone.angles = (270, 0, 0); //DEPENDS ON MODELS TAG
    level.zone.modelTag = "bip01 spine2";
    level.zone.objnum = 0;

    level.zone.modes = [];

    level.zone.modes[0]["id"] = "start";
    level.zone.modes[0]["fxId"] = loadfx("fx/zone-start.efx");
    level.zone.modes[0]["startSize"] = "20000";

    level.zone.modes[1]["id"] = "start_1";
    level.zone.modes[1]["fxId"] = loadfx("fx/zone-start_1.efx");
    level.zone.modes[1]["life"] = "9500";
    level.zone.modes[1]["startSize"] = level.zone.modes[1-1]["startSize"];
    level.zone.modes[1]["endSize"] = "7000";

    level.zone.modes[2]["id"] = "1";
    level.zone.modes[2]["fxId"] = loadfx("fx/zone1.efx");
    level.zone.modes[2]["startSize"] = level.zone.modes[2-1]["endSize"];

    level.zone.modes[3]["id"] = "1_2";
    level.zone.modes[3]["fxId"] = loadfx("fx/zone1_2.efx");
    level.zone.modes[3]["life"] = "6000";
    level.zone.modes[3]["startSize"] = level.zone.modes[3-1]["startSize"];
    level.zone.modes[3]["endSize"] = "3800";

    level.zone.modes[4]["id"] = "2";
    level.zone.modes[4]["fxId"] = loadfx("fx/zone2.efx");
    level.zone.modes[4]["startSize"] = level.zone.modes[4-1]["endSize"];

    level.zone.modes[5]["id"] = "2_3";
    level.zone.modes[5]["fxId"] = loadfx("fx/zone2_3.efx");
    level.zone.modes[5]["life"] = "6000";
    level.zone.modes[5]["startSize"] = level.zone.modes[5-1]["startSize"];
    level.zone.modes[5]["endSize"] = "2700";

    level.zone.modes[6]["id"] = "3";
    level.zone.modes[6]["fxId"] = loadfx("fx/zone3.efx");
    level.zone.modes[6]["startSize"] = level.zone.modes[6-1]["endSize"];

    level.zone.modes[7]["id"] = "3_4";
    level.zone.modes[7]["fxId"] = loadfx("fx/zone3_4.efx");
    level.zone.modes[7]["life"] = "6000";
    level.zone.modes[7]["startSize"] = level.zone.modes[7-1]["startSize"];
    level.zone.modes[7]["endSize"] = "1500";

    level.zone.modes[8]["id"] = "4";
    level.zone.modes[8]["fxId"] = loadfx("fx/zone4.efx");
    level.zone.modes[8]["startSize"] = level.zone.modes[8-1]["endSize"];

    level.zone.modes[9]["id"] = "4_5";
    level.zone.modes[9]["fxId"] = loadfx("fx/zone4_5.efx");
    level.zone.modes[9]["life"] = "6000";
    level.zone.modes[9]["startSize"] = level.zone.modes[9-1]["startSize"];
    level.zone.modes[9]["endSize"] = "800";

    level.zone.modes[10]["id"] = "5";
    level.zone.modes[10]["fxId"] = loadfx("fx/zone5.efx");
    level.zone.modes[10]["startSize"] = level.zone.modes[10-1]["endSize"];

    level.zone.modes[11]["id"] = "5_6";
    level.zone.modes[11]["fxId"] = loadfx("fx/zone5_6.efx");
    level.zone.modes[11]["life"] = "6000";
    level.zone.modes[11]["startSize"] = level.zone.modes[11-1]["startSize"];
    level.zone.modes[11]["endSize"] = "300";

    level.zone.modes[12]["id"] = "6";
    level.zone.modes[12]["fxId"] = loadfx("fx/zone6.efx");
    level.zone.modes[12]["startSize"] = level.zone.modes[12-1]["endSize"];

    level.zone.modes[13]["id"] = "6_end";
    level.zone.modes[13]["fxId"] = loadfx("fx/zone6_end.efx");
    level.zone.modes[13]["life"] = "6000";
    level.zone.modes[13]["startSize"] = level.zone.modes[13-1]["startSize"];
    level.zone.modes[13]["endSize"] = "0";

    level.color_red = (1, 0, 0);
    level.color_blue = (0, 0, 1);
    level.color_green = (0, 1, 0);

    if(!isDefined(game["state"]))
        game["state"] = "playing";

    level.zone.active = false;
    level.startingBattle = false;
    level.battleStarted = false;
    level.battleOver = false;
    level.checkingVictoryRoyale = false;
    level.noWinner = false;

    level.healthqueue = [];
    level.healthqueuecurrent = 0;

    setarchive(true);
}
//CALLBACKS
Callback_StartGameType()
{
    //View Map menu
    if(!isDefined(game["layoutimage"]))
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

    //SHADERS
    precacheShader("black");
    precacheShader("hudScoreboard_mp");
    precacheShader("gfx/hud/hud@mpflag_none.tga");
    precacheShader("gfx/hud/hud@mpflag_spectator.tga");
    precacheShader("gfx/hud/damage_feedback.dds");
    precacheShader("gfx/hud/zone_center.dds");

    precacheStatusIcon("gfx/hud/hud@status_dead.tga");
    precacheStatusIcon("gfx/hud/hud@status_connecting.tga");

    //OBJECT MODELS
    precacheModel(level.model_zone);
    precacheModel(level.model_plane);
    precacheModel(level.model_parachute);

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

    precacheItem("item_health");

    maps\mp\gametypes\_teams::initGlobalCvars();
    maps\mp\gametypes\_teams::restrictPlacedWeapons();

    setClientNameMode("auto_change");

    objective_add(level.zone.objnum, "current", level.zone.origin, "gfx/hud/zone_center.dds");
    objective_onEntity(level.zone.objnum, level.zone);
    objective_team(level.zone.objnum, "none");
    level.zone setModel(level.model_zone);

    thread manageZoneLifecycle();
    thread checkBattleReady();
}
Callback_PlayerConnect()
{
    self.statusicon = "gfx/hud/hud@status_connecting.tga";
    self waittill("begin");
    self.statusicon = "";

    if(game["state"] == "intermission")
    {
        spawnIntermission();
        return;
    }

    self.pers["connected"] = true;
    iprintln(&"MPSCRIPT_CONNECTED", self);

    self.fights = true;
    self.inPlane = false;
    self.jumped = false;

    level endon("intermission");
    
    self setClientCvar("g_scriptMainMenu", game["menu_camouflage"]);
    self setClientCvar("scr_showweapontab", "0");
    self openMenu(game["menu_camouflage"]);
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
            case "autoassign":
                if(self.jumped)
                    break;
                if(isDefined(self.pers["camouflage"]) && response == self.pers["camouflage"])
                    break; //SELECTED SAME CAMOUFLAGE
                if(response == "autoassign")
                    response = level.camouflages[randomInt(level.camouflages.size)];

                self.fights = true;
                if(isDefined(self.pers["camouflage"]))
                {
                    //Selected another camouflage
                    self.pers["camouflage"] = response;
                    model();
                }
                else
                {
                    self.pers["camouflage"] = response;

                    self setClientCvar("scr_showweapontab", "1");
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_all"]);
                    self openMenu(game["menu_weapon_all"]);
                }
                break;

            case "spectator":
                self.fights = false;
                if(isDefined(self.pers["camouflage"]))
                {
                    self.pers["weapon"] = undefined;
                    self.pers["camouflage"] = undefined;
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
            if(!isDefined(self.pers["camouflage"]))
                continue;
            if(self.jumped)
                break;
            
            weapon = response; //TODO: check if should verify the weapon is allowed
            if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                continue; //Selected same weapon

            if(isDefined(self.pers["weapon"]))
            {
                //Selected another weapon
                self.pers["weapon"] = weapon;
                if(!self.inPlane)
                {
                    self takeWeapon(self getWeaponSlotWeapon("primary"));
                    self giveWeapon(self.pers["weapon"]);
                    self giveMaxAmmo(self.pers["weapon"]);
                    self setSpawnWeapon(self.pers["weapon"]);
                    self switchToWeapon(self.pers["weapon"]);
                }
            }
            else
            {
                self.pers["weapon"] = weapon;
                spawnPlayer();
            }
        }
        else if(menu == game["menu_viewmap"])
        {
            switch(response)
            {
            case "camouflage":
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
    self notify("death");
    level thread checkVictoryRoyale();
}
Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    if(self.sessionteam == "spectator")
        return;
    if(level.battleOver)
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
            if(isBoltWeapon(sWeapon)) {
                if(level.instantKill_bolt)
                    iDamage = iDamage + 100;
            }
            else if(isSecondaryWeapon(sWeapon)) {
                if(level.instantKill_pistol)
                    iDamage = iDamage + 100;
            }
        }
        else if(sMeansOfDeath == "MOD_MELEE")
        {
            if(level.instantKill_melee)
                iDamage = iDamage + 100;
        }
        if(eAttacker != self && level.damageFeedback)
            eAttacker thread showDamageFeedback();
    }

    if(!level.battleStarted)
        return;

    if((self.health - iDamage) <= 0)
    {
        // Player will die
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
    }

    // Apply the damage to the player
    self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
}
Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
    level thread checkVictoryRoyale();
    self endon("spawned");

    if(self.sessionteam == "spectator")
        return;

    // If the player was killed by a head shot, let players know it was a head shot kill
    if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
        sMeansOfDeath = "MOD_HEAD_SHOT";

    // send out an obituary message to all clients about the kill
    obituary(self, attacker, sWeapon, sMeansOfDeath);
    self notify("death");

    self.sessionstate = "dead";
    self.statusicon = "gfx/hud/hud@status_dead.tga";
    self.deaths = 1;

    attackerNum = -1;
    level.playercam = attacker;// getEntityNumber();

    if(isPlayer(attacker))
    {
        if(attacker == self) // killed himself
        {
            doKillcam = false;
            attacker.score = attacker.pers["score"];
        }
        else
        {
            //attackerNum = attacker getEntityNumber();
            doKillcam = true;
            attacker.pers["score"]++;
            attacker.score = attacker.pers["score"];
        }
    }
    else
    {
        doKillcam = false;
    }

    // Make the player drop health
    self dropHealth();
    body = self cloneplayer();

    delay = 2;	// Delay the player becoming a spectator till after he's done dying
    wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute
    
    if(doKillcam && !level.battleOver)
    {
        self thread killcam(attacker, delay, false);
    }
    else
    {
        currentorigin = self.origin;
        currentangles = self getPlayerAngles();
        self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles, true);
    }
}
//CALLBACKS END

spawnSpectator(origin, angles, died)
{
    printLn("#### spawnSpectator");

    self notify("spawned");
    self notify("spawned_spectator");

    level thread checkVictoryRoyale();
    
    resettimeout();

    if(!isDefined(died))
    {
        self.statusicon = "";
        self.sessionteam = "spectator";
    }
    self.sessionstate = "spectator";
    self.spectatorclient = -1;
    self.archivetime = 0;

    if(isDefined(origin) && isDefined(angles))
        self spawn(origin, angles);
    else
    {
        self spawn(level.connectOrigin, level.connectAngles);
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

    if(isDefined(origin) && isDefined(angles))
    {
        self spawn(origin, angles);
    }
    else
    {
        spawnpointname = "mp_deathmatch_spawn";
        spawnpoints = getentarray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

        if(isDefined(spawnpoint))
            self spawn(spawnpoint.origin, spawnpoint.angles);
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }

    self.statusicon = "";
    self.maxhealth = 100;
    self.health = self.maxhealth;

    self.pers["score"] = 0;
    self.score = self.pers["score"];
    self.deaths = 0;

    model();

    if(!self.inPlane)
    {
        loadout();
        self giveWeapon(self.pers["weapon"]);
        self giveMaxAmmo(self.pers["weapon"]);
        self setSpawnWeapon(self.pers["weapon"]);
    }
    
    self setClientCvar("cg_objectiveText", level.objectiveText);
}
spawnIntermission()
{
    self notify("spawned");
    self notify("end_respawn");
    
    resettimeout();

    self.sessionstate = "intermission";
    self.spectatorclient = -1;
    self.archivetime = 0;

    self spawn(level.connectOrigin, level.connectAngles);
}

checkBattleReady()
{
    printLn("#### checkBattleReady");

    level endon("battle_start");

    fontScale_playerCount = 1.2;

    level.hud_waitingBackground = newHudElem();
    level.hud_waitingBackground.alignX = "center";
    level.hud_waitingBackground.x = 320;
    level.hud_waitingBackground.y = 20;
    level.hud_waitingBackground.alpha = 0.6;
    level.hud_waitingBackground.sort = -1;
    level.hud_waitingBackground setShader("black", 365, 66);

    level.hud_waitingForPlayers = newHudElem();
    level.hud_waitingForPlayers.alignX = "center";
    level.hud_waitingForPlayers.alignY = "middle";
    level.hud_waitingForPlayers.x = 320;
    level.hud_waitingForPlayers.y = level.hud_waitingBackground.y + 21;
    level.hud_waitingForPlayers.fontScale = 1.1;
    level.hud_waitingForPlayers.font = "bigfixed";
    level.hud_waitingForPlayers.label = level.text_waitingPlayers;

    distance_ready_min = 15;

    level.hud_playersReady = newHudElem();
    level.hud_playersReady.alignX = "center";
    level.hud_playersReady.alignY = "middle";
    level.hud_playersReady.x = level.hud_waitingForPlayers.x - distance_ready_min;
    level.hud_playersReady.y = level.hud_waitingForPlayers.y + 24;
    level.hud_playersReady.fontScale = fontScale_playerCount;
    level.hud_playersReady.font = "bigfixed";
    
    level.hud_playersMin = newHudElem();
    level.hud_playersMin.alignX = "center";
    level.hud_playersMin.alignY = "middle";
    level.hud_playersMin.x = level.hud_waitingForPlayers.x + distance_ready_min;
    level.hud_playersMin.y = level.hud_playersReady.y;
    level.hud_playersMin.fontScale = fontScale_playerCount;
    level.hud_playersMin.font = "bigfixed";
    level.hud_playersMin.label = &"/";
    level.hud_playersMin setValue(level.minPlayers);

    for(;;)
    {
        numberOfReadyPlayers = [];
        for(i = 0; i < level.maxClients; i++)
        {
            player = getEntByNum(i);
            if(isDefined(player))
            {
                if(isDefined(player.pers["connected"]))
                {
                    //PLAYER IS CONNECTED
                    if(player.fights)
                        numberOfReadyPlayers[numberOfReadyPlayers.size] = player;
                }
            }
        }
        level.hud_playersReady setValue(numberOfReadyPlayers.size);

        if(numberOfReadyPlayers.size > 0) //AT LEAST 1 READY PLAYER
        {
            if(numberOfReadyPlayers.size < level.minPlayers) //MIN PLAYERS NOT REACHED YET
            {
                if(level.startingBattle) //Lost required players count, reset
                {
                    level notify("battle_cancel");
                    level.startingBattle = false;

                    //Reset HUD
                    alignX = level.hud_waitingForPlayers.alignX;
                    alignY = level.hud_waitingForPlayers.alignY;
                    x = level.hud_waitingForPlayers.x;
                    y = level.hud_waitingForPlayers.y;
                    fontScale = level.hud_waitingForPlayers.fontScale;
                    font = level.hud_waitingForPlayers.font;

                    level.hud_waitingForPlayers reset();
                    level.hud_waitingForPlayers.alignX = alignX;
                    level.hud_waitingForPlayers.alignY = alignY;
                    level.hud_waitingForPlayers.x = x;
                    level.hud_waitingForPlayers.y = y;
                    level.hud_waitingForPlayers.fontScale = fontScale;
                    level.hud_waitingForPlayers.font = font;
                    level.hud_waitingForPlayers.label = level.text_waitingPlayers;
                }
            }
            else if(numberOfReadyPlayers.size >= level.minPlayers) //MIN PLAYERS REACHED, START COUNTDOWN
            {
                if(numberOfReadyPlayers.size <= level.maxClients && !level.startingBattle)
                {
                    level.hud_waitingForPlayers.color = level.color_red;
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
    printLn("#### startBattle");

    //setCvar("x_contents", "32"); //Prevent players from blocking each other when jumping

    level endon("battle_cancel");
    level.startingBattle = true;
    wait level.startBattleCountdown;
    level notify("battle_start");

    level.startingBattle = false;
    level.battleStarted = true;
    
    level.hud_waitingBackground destroy();
    level.hud_waitingForPlayers destroy();
    level.hud_playersReady destroy();
    level.hud_playersMin destroy();

    level.hud_numLivingPlayers = newHudElem();
    level.hud_numLivingPlayers.x = 570;
    level.hud_numLivingPlayers.y = 80;
    level.hud_numLivingPlayers.label = &"Alive: ";
    thread updateNumLivingPlayers();

    //using map zh_frenzy
    originPlane = (2050, -18000, 8070);
    anglesPlane = (0, 90, 0);
    level.plane = spawn("script_model", originPlane);
    level.plane setModel(level.model_plane);
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
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];

        if(!player.fights)
            continue;

        player.inPlane = true;
        player closeMenu();

        if(!isDefined(player.pers["camouflage"]))
            player.pers["camouflage"] = level.camouflages[randomInt(level.camouflages.size)];
        if(!isDefined(player.pers["weapon"]))
            player.pers["weapon"] = "mosin_nagant_mp";

        player spawnPlayer(originPlanePov, anglesPlanePov);
        player showToPlayer(player); //TODO: use an invisible/no model instead
        player linkto(level.planePov);
        player thread checkPlayerInZone();
        player thread checkPlayerJumped();
    }
    level.plane moveY(moveDistance, moveDelay);
    level.plane playLoopSound("in_plane");
    level.planePov moveY(moveDistance, moveDelay);

    wait moveDelay;
    for(i = 0; i < players.size; i++)
    {
        player = players[i];
        if(isAlive(player) && !player.jumped)
        {
            player.forceJump = true;
        }
    }
    wait 3;
    everyoneJumped = true;
    for(i = 0; i < players.size; i++)
    {
        player = players[i];
        if(isAlive(player) && !player.jumped)
        {
            everyoneJumped = false;
            break;
        }
    }
    if(everyoneJumped)
    {
        level.plane stopLoopSound();
        level.plane delete();
        level.planePov delete();
    }
}

//ZONE FUNCTIONS
manageZoneLifecycle()
{
    level.hud_zoneShrinkAlert = newHudElem();
    level.hud_zoneShrinkAlert.x = 450;
    level.hud_zoneShrinkAlert.y = 170;
    level.hud_zoneShrinkAlert.fontScale = 1.1;

    zoneIndex = 0; //Waiting for players
    thread setupZone(zoneIndex);

    level waittill("battle_start");
    zoneIndex++; //In plane, start zone is shrinking
    thread setupZone(zoneIndex);

    for(;;)
    {
        level waittill("zone_idle");
        wait level.zoneDuration;

        zoneIndex += 2;
        thread setupZone(zoneIndex);
        
        wait .05;
    }
}
setupZone(zoneModeIndex)
{
    //printLn("### setupZone: id = " + level.zone.modes[zoneModeIndex]["id"]);

    if(!isDefined(level.zone.modes[zoneModeIndex]["endSize"])) //STATIC ZONE
    {
        if(level.zone.active)
        {
            printLn("### ERROR: Static zone already active");
            return;
        }

        level.zone.indexMode = zoneModeIndex;
        level.zone.life = 1000;
        level.zone.currentSize = (int)level.zone.modes[zoneModeIndex]["startSize"];
        level.zone thread playZone(level.zone.modes[zoneModeIndex]["fxId"], true);

        if(zoneModeIndex != 0) //START ZONE NO COUNTDOWN
        {
            //Reset HUD
            x = level.hud_zoneShrinkAlert.x;
            y = level.hud_zoneShrinkAlert.y;
            fontScale = level.hud_zoneShrinkAlert.fontScale;
            level.hud_zoneShrinkAlert reset();
            level.hud_zoneShrinkAlert.x = x;
            level.hud_zoneShrinkAlert.y = y;
            level.hud_zoneShrinkAlert.fontScale = fontScale;
            level.hud_zoneShrinkAlert.label = level.text_zoneWillShrink;
            level.hud_zoneShrinkAlert setTimer(level.zoneDuration);

            level notify("zone_idle");
        }
    }
    else //SHRINKING ZONE
    {
        level.zone.active = false;
        level.zoneLooper delete();
        level.zone.indexMode = zoneModeIndex;
        level.zone.life = (int)level.zone.modes[zoneModeIndex]["life"];
        level.zone.startSize = (int)level.zone.modes[zoneModeIndex]["startSize"];
        level.zone.currentSize = level.zone.startSize;
        level.zone.endSize = (int)level.zone.modes[zoneModeIndex]["endSize"];
        level.zone.nextZoneIndex = level.zone.indexMode + 1;
        level.zone thread playZone(level.zone.modes[zoneModeIndex]["fxId"], false);
        level.zone thread keepZoneSizeVarUpdated();

        //Reset HUD
        x = level.hud_zoneShrinkAlert.x;
        y = level.hud_zoneShrinkAlert.y;
        fontScale = level.hud_zoneShrinkAlert.fontScale;
        level.hud_zoneShrinkAlert reset();
        level.hud_zoneShrinkAlert.x = x;
        level.hud_zoneShrinkAlert.y = y;
        level.hud_zoneShrinkAlert.fontScale = fontScale;
        level.hud_zoneShrinkAlert.color = level.color_red;
        level.hud_zoneShrinkAlert.label = level.text_zoneIsShrinking;
        level.hud_zoneShrinkAlert setTimer(level.zone.life / 1000);
    }
    level.zone.active = true;
}
playZone(fx, static)
{
    //printLn("### playZone");

    if(static)
    {
        level.zoneLooper = playLoopedFX(fx, (self.life / 1000), self.origin);
    }
    else
    {
        wait 0.5; //.05 was not enough
        playFXOnTag(fx, self, self.modelTag);
        if(self.indexMode != level.zone.modes.size - 1) //FINAL FULL SHRINKS DOESNT PLAY NEXT
        {
            wait (self.life / 1000);
            //PLAY NEXT STATIC ZONE
            level.zone.active = false;
            level thread setupZone(self.nextZoneIndex);
        }
        else
        {
            wait (self.life / 1000);
            //Destroy HUD
            level.hud_zoneShrinkAlert destroy();
        }
    }
}
/*
moveZone() //TODO: move zone while shrinking
{
    zoneX = self.origin[0];
    zoneY = self.origin[1];
    zoneZ = self.origin[2];
    destinationOrigin = (zoneX, zoneY + 800, zoneZ);
    self moveTo(destinationOrigin, (self.life / 1000));
    wait (self.life / 1000);
    self delete();
    level.zoneActive = undefined;
}
*/
keepZoneSizeVarUpdated()
{
    currentTime = getTime();
    startTime = currentTime;
    while(currentTime - startTime < self.life)
    {
        progress = (float)(currentTime - startTime) / self.life;
        currentSize = self.startSize + (int)((self.endSize - self.startSize) * progress);
        self.currentSize = currentSize;
        wait .05;
        currentTime = getTime();
    }
}
checkPlayerInZone()
{
    self endon("death");
    self endon("spawned_spectator");
    self.inZone = true;

    self.hudInStormDarkness = newClientHudElem(self);
    self.hudInStormDarkness.x = 0;
    self.hudInStormDarkness.y = 0;
    self.hudInStormDarkness setShader("black", 640, 480);
    self.hudInStormDarkness.alpha = 0;
    self.hudInStormDarkness.sort = -1;

    self.hudInStormAlert = newClientHudElem(self);
    self.hudInStormAlert.x = 460;
    self.hudInStormAlert.y = 140;
    self.hudInStormAlert.color = level.color_red;
    self.hudInStormAlert.fontScale = 1.3;

    for(;;)
    {
        if(level.zone.active)
        {
            //IGNORE Z
            selfOriginX = self.origin[0];
            selfOriginY = self.origin[1];
            selfOriginNoZ = (selfOriginX, selfOriginY, 0);

            zoneOriginX = level.zone.origin[0];
            zoneOriginY = level.zone.origin[1];
            zoneOriginNoZ = (zoneOriginX, zoneOriginY, 0);

            inZone = (distance(selfOriginNoZ, zoneOriginNoZ) < level.zone.currentSize);
            if(inZone && !self.inZone)
            {
                //ENTERED ZONE
                self.inZone = true;
                self.hudInStormDarkness.alpha = 0;
                self.hudInStormAlert setText(&"");
            }
            else if(!inZone)
            {
                if(self.inZone)
                {
                    //ENTERED STORM
                    self.inZone = false;
                    self.hudInStormDarkness.alpha = 0.3;
                    self.hudInStormAlert setText(&"You are in the storm!");
                }

                if(level.battleOver)
                {
                    wait .05;
                    continue;
                }

                damagePlayer = false;
                if(isDefined(self.lastZoneDamageTime))
                {
                    secondsPassed = (getTime() - self.lastZoneDamageTime) / 1000;
                    if(secondsPassed > 2)
                    {
                        damagePlayer = true;
                    }
                }
                else
                {
                    damagePlayer = true;
                }

                if(damagePlayer)
                {
                    eInflictor = level.zone;
                    eAttacker = level.zone;
                    iDamage = 5;
                    iDFlags = 0;
                    sMeansOfDeath = "MOD_UNKNOWN";
                    sWeapon = "none";
                    vPoint = undefined;
                    vDir = undefined;
                    sHitLoc = "none";
                    psOffsetTime = 0;
                    self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
                    self.lastZoneDamageTime = getTime();
                }
            }
        }

        wait .05;
    }
}
//ZONE FUNCTIONS END

//SKYDIVE FUNCTIONS
checkPlayerJumped()
{
    self endon("death");
    self endon("spawned_spectator");

    self.hud_jump_parachute = newClientHudElem(self);
    self.hud_jump_parachute.alignX = "center";
    self.hud_jump_parachute.alignY = "middle";
    self.hud_jump_parachute.x = 320;
    self.hud_jump_parachute.y = 40;
    self.hud_jump_parachute.fontScale = 1.2;
    self.hud_jump_parachute setText(&"Press ^1[{+activate}] ^7to jump");

    for(;;)
    {
        //FORCE STANDING
        if(self getStance() != "stand")
            self setClientCvar("cl_stance", "0");

        if(self useButtonPressed() || isDefined(self.forceJump))
        {
            self.jumped = true;

            self setClientCvar("g_scriptMainMenu", game["menu_camouflage"]);
            self setClientCvar("scr_showweapontab", "0");

            self.hud_jump_parachute setText(&"");

            anglesBeforeSpawn = self getPlayerAngles();
            self spawnPlayer(level.planePov.origin, anglesBeforeSpawn);
            self.inPlane = false;
            self showToPlayer(undefined);
            //self setClientCvar("cg_thirdPerson", "1");

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
    self endon("death");
    self endon("spawned_spectator");
    self endon("landed");

    while(self useButtonPressed())
        wait .05;
    self.blockParachuteCheck = false;
}
checkPlayerDive()
{
    self endon("death");
    self endon("spawned_spectator");
    self endon("landed");

    self thread checkLanded();

    self.hud_jump_parachute setText(&"Press ^1[{+activate}] ^7to open/close parachute");

    self.parachuteEnabled = false;

    self.hud_parachuteStateIndicator = newClientHudElem(self); //TODO: show arms/hands instead
    self.hud_parachuteStateIndicator.alignX = "center";
    self.hud_parachuteStateIndicator.alignY = "middle";
    self.hud_parachuteStateIndicator.x = 320;
    self.hud_parachuteStateIndicator.y = self.hud_jump_parachute.y + 25;
    self.hud_parachuteStateIndicator.color = level.color_red;
    self.hud_parachuteStateIndicator.fontScale = 1.3;
    self.hud_parachuteStateIndicator setText(level.text_parachuteNotDeployed);

    self.blockParachuteCheck = false;

    //PHYSICS VARIABLES
    //Acceleration multiplier (diagonal fall)
    acceleration_skydive_forward = 40;
    acceleration_skydive_onlyLeftRight = 25;
    acceleration_skydive_forwardLeftRight = 35;

    acceleration_parachute_forward = 60;
    acceleration_parachute_onlyLeftRight = 40;
    acceleration_parachute_forwardLeftRight = 50;

    acceleration_parachute_backward = 35;
    acceleration_parachute_backwardLeftRight = 20;

    //Air resistance multiplier (fall slowdown)
    airResistance_skydive_idle = 0.975;
    airResistance_skydive_forward = 0.99;
    airResistance_parachute_idle = 0.85;
    airResistance_parachute_forward = 0.925;

    //CHECK MOVEMENTS
    for(;;)
    {
        //FORCE STANDING
        if(self getStance() != "stand")
            self setClientCvar("cl_stance", "0");

        //DIRECTION KEYS CHECK
        goingForward = false;
        goingBackward = false;
        goingLeft = false;
        goingRight = false;
        if(self forwardButtonPressed())
            goingForward = true;
        if(self backButtonPressed())
            goingBackward = true;
        if(self leftButtonPressed())
            goingLeft = true;
        if(self rightButtonPressed())
            goingRight = true;

        if(goingLeft && goingRight)
        {
            //left + right = neither
            goingLeft = false;
            goingRight = false;
        }
        if(goingForward && goingBackward)
        {
            //forward + backward = neither
            goingForward = false;
            goingBackward = false;
        }

        //PARACHUTE STATE CHECK
        checkParachute = false;
        if(self useButtonPressed() && !self.blockParachuteCheck)
        {
            self.blockParachuteCheck = true;
            self thread checkReleasedUseButton();
            checkParachute = true;
        }
        if(checkParachute)
        {
            if(!self.parachuteEnabled)
            {
                //OPENED
                self.hud_parachuteStateIndicator.color = level.color_green;
                self.hud_parachuteStateIndicator setText(level.text_parachuteDeployed);
                self.parachuteEnabled = true;
                self attach(level.model_parachute, "tag_belt_back");
            }
            else
            {
                //CLOSED
                self.hud_parachuteStateIndicator.color = level.color_red;
                self.hud_parachuteStateIndicator setText(level.text_parachuteNotDeployed);
                self.parachuteEnabled = false;
                self detach(level.model_parachute, "tag_belt_back");
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
        if(angles[0] < -30)
        {
            isLookingUp = true;
        }
        else if(angles[0] > 30)
        {
            isLookingDown = true;
        }
        
        //APPLY MOTION EFFECTS
        if(self.parachuteEnabled)
        {
            if(goingForward)
            {
                if(isLookingUp) //Prevent acceleration from pushing upward
                {
                    //AS IDLE
                    newVelocity_x = velocity[0];
                    newVelocity_y = velocity[1];
                    newVelocity_z = velocity[2];
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_idle);
                }
                else if(goingLeft)
                {
                    newVelocity_x = velocity[0] + (forwardDirection[0] + leftDirection[0]) * acceleration_parachute_forwardLeftRight;
                    newVelocity_y = velocity[1] + (forwardDirection[1] + leftDirection[1]) * acceleration_parachute_forwardLeftRight;
                    newVelocity_z = velocity[2] + (forwardDirection[2] + leftDirection[2]) * acceleration_parachute_forwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
                else if(goingRight)
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
            else if(goingBackward)
            {
                if(isLookingDown) //Prevent acceleration from pushing upward
                {
                    //AS IDLE
                    newVelocity_x = velocity[0];
                    newVelocity_y = velocity[1];
                    newVelocity_z = velocity[2];
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_idle);
                }
                else if(goingLeft)
                {
                    newVelocity_x = velocity[0] + (backwardDirection[0] + leftDirection[0]) * acceleration_parachute_backwardLeftRight;
                    newVelocity_y = velocity[1] + (backwardDirection[1] + leftDirection[1]) * acceleration_parachute_backwardLeftRight;
                    newVelocity_z = velocity[2] + (backwardDirection[2] + leftDirection[2]) * acceleration_parachute_backwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
                }
                else if(goingRight)
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
            else if(goingLeft)
            {
                //JUST LEFT
                newVelocity_x = velocity[0] + leftDirection[0] * acceleration_parachute_onlyLeftRight;
                newVelocity_y = velocity[1] + leftDirection[1] * acceleration_parachute_onlyLeftRight;
                newVelocity_z = velocity[2] + leftDirection[2] * acceleration_parachute_onlyLeftRight;
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_parachute_forward);
            }
            else if(goingRight)
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
            if(goingForward)
            {
                if(isLookingUp) //Prevent acceleration from pushing upward
                {
                    //AS IDLE
                    newVelocity_x = velocity[0];
                    newVelocity_y = velocity[1];
                    newVelocity_z = velocity[2];
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_idle);
                }
                else if(goingLeft)
                {
                    newVelocity_x = velocity[0] + (forwardDirection[0] + leftDirection[0]) * acceleration_skydive_forwardLeftRight;
                    newVelocity_y = velocity[1] + (forwardDirection[1] + leftDirection[1]) * acceleration_skydive_forwardLeftRight;
                    newVelocity_z = velocity[2] + (forwardDirection[2] + leftDirection[2]) * acceleration_skydive_forwardLeftRight;
                    newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
                }
                else if(goingRight)
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
            else if(goingLeft)
            {
                //JUST LEFT
                newVelocity_x = velocity[0] + leftDirection[0] * acceleration_skydive_onlyLeftRight;
                newVelocity_y = velocity[1] + leftDirection[1] * acceleration_skydive_onlyLeftRight;
                newVelocity_z = velocity[2] + leftDirection[2] * acceleration_skydive_onlyLeftRight;
                newVelocity = maps\mp\_utility::vectorScale((newVelocity_x, newVelocity_y, newVelocity_z), airResistance_skydive_forward);
            }
            else if(goingRight)
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
    self endon("death");
    self endon("spawned_spectator");
    
    for(;;)
    {
        if(self isOnGround())
        {
            self notify("landed");

            self.hud_jump_parachute destroy();
            self.hud_parachuteStateIndicator destroy();

            //Check landed under map
            if(self.origin[2] < -600)
            {
                self suicide();
                return;
            }

            if(self.parachuteEnabled)
            {
                self detach(level.model_parachute, "tag_belt_back");
                self.parachuteEnabled = false;
            }
            //self setClientCvar("cg_thirdPerson", "0");
            
            wait .25;
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

updateNumLivingPlayers()
{
    wait .05;
    for(;;)
    {
        alivePlayers = 0;
        players = getEntArray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            player = players[i];
            if(isAlive(player) && player.sessionstate != "spectator")
            {
                alivePlayers += 1;
            }
        }
        level.hud_numLivingPlayers setValue(alivePlayers);

        wait .5; //for resource saving
        wait .05;
    }
}
checkVictoryRoyale()
{
    if (!level.battleStarted || level.battleOver)
        return;
    if(level.checkingVictoryRoyale)
        return;
    level.checkingVictoryRoyale = true;

    wait .05;

    alivePlayers = [];
    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];
        if(isAlive(player) && player.sessionstate != "spectator")
        {
            alivePlayers[alivePlayers.size] = player;
        }
        if(alivePlayers.size > 1)
            break;
    }
    if(alivePlayers.size == 1)
    {
        level.battleOver = true;

        winner = alivePlayers[0];
        winner.hud_victoryRoyale = newClientHudElem(winner);
        winner.hud_victoryRoyale.alignX = "center";
        winner.hud_victoryRoyale.alignY = "middle";
        winner.hud_victoryRoyale.x = 320;
        winner.hud_victoryRoyale.y = 100;
        winner.hud_victoryRoyale.color = level.color_blue;
        winner.hud_victoryRoyale.fontScale = 1.5;
        winner.hud_victoryRoyale.font = "bigfixed";
        winner.hud_victoryRoyale setText(&"VICTORY ROYALE!");

        level.winnerEntityNumber = winner getEntityNumber();
        level.winnerName = winner.name;

        setCvar("timescale", "0.5");
        wait 0.25;
        for(x = .5; x < 1; x+= .05)
        {
            wait (0.1 / x);
            setCvar("timescale", x);
        }
        setCvar("timescale", "1");
        wait 4;
        endMap();
    }
    else if(alivePlayers.size == 0)
    {
        level.battleOver = true;

        level.hud_victoryRoyale = newHudElem();
        level.hud_victoryRoyale.alignX = "center";
        level.hud_victoryRoyale.alignY = "middle";
        level.hud_victoryRoyale.x = 320;
        level.hud_victoryRoyale.y = 100;
        level.hud_victoryRoyale.color = level.color_red;
        level.hud_victoryRoyale.fontScale = 1.5;
        level.hud_victoryRoyale.font = "bigfixed";
        level.hud_victoryRoyale setText(&"NO ONE SURVIVED!");

        level.noWinner = true;
        wait 4;
        endMap();
    }

    level.checkingVictoryRoyale = false;
}
endMap()
{
    if(!level.noWinner)
        level setupFinalKillcam();

    game["state"] = "intermission";
    level notify("intermission");

    players = getEntArray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        player = players[i];

        player closeMenu();
        player setClientCvar("g_scriptMainMenu", "main");
        if(level.noWinner)
            player setClientCvar("cg_objectiveText", "No one survived!");
        else
            player setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", level.winnerName);
        
        player spawnIntermission();
    }
    wait 6;
    exitLevel(false);
}

showDamageFeedback()
{
    self endon("spawned");

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
setupFinalKillcam()
{
    viewers = 0;
    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++)
    {
        player = players[i];

        if (isDefined(player.killcam) || (player.archivetime > 0))
        {
            // Already running killcam, stop it
            player notify("spawned");
            wait .05;
            player.spectatorclient = -1;
            player.archivetime = 0;
        }

        player thread killcam(level.playercam, 2, true);
        viewers++;
    }
    if (viewers)
        level waittill("finalKillcam_ended");
    
    return;
}
killcam(attacker, delay, finalKillcam)
{
    if(!finalKillcam)
        self endon("spawned");

    if(!isPlayer(attacker))
        attacker = self;
    self.sessionstate = "spectator";
    self.spectatorclient = attacker getEntityNumber();
    //if(attackerNum < 0)
        //return;
    //self.sessionstate = "spectator";
    //self.spectatorclient = attackerNum;
    self.archivetime = delay + level.killcamDuration;

    // wait till the next server frame to allow code a chance to update archivetime if it needs trimming
    wait .05;

    if(self.archivetime <= delay)
    {
        printLn("### self.archivetime <= delay: return");
        self.spectatorclient = -1;
        self.archivetime = 0;
        return;
    }

    if(!finalKillcam)
        self.killcam = true;

    if(!isDefined(self.kc_topbar))
    {
        self.kc_topbar = newClientHudElem(self);
        self.kc_topbar.archived = false;
        self.kc_topbar.x = 0;
        self.kc_topbar.y = 0;
        self.kc_topbar.alpha = 0.5;
        self.kc_topbar setShader("black", 640, 112);
    }
    if(!isDefined(self.kc_bottombar))
    {
        self.kc_bottombar = newClientHudElem(self);
        self.kc_bottombar.archived = false;
        self.kc_bottombar.x = 0;
        self.kc_bottombar.y = 368;
        self.kc_bottombar.alpha = 0.5;
        self.kc_bottombar setShader("black", 640, 112);
    }
    if(!isDefined(self.kc_title))
    {
        self.kc_title = newClientHudElem(self);
        self.kc_title.archived = false;
        self.kc_title.x = 320;
        self.kc_title.y = 40;
        self.kc_title.alignX = "center";
        self.kc_title.alignY = "middle";
        self.kc_title.sort = 1; // force to draw after the bars
        self.kc_title.fontScale = 2.5;
    }
    self.kc_title setText(&"MPSCRIPT_KILLCAM");
    if(!isDefined(self.kc_skiptext) && !finalKillcam)
    {
        self.kc_skiptext = newClientHudElem(self);
        self.kc_skiptext.archived = false;
        self.kc_skiptext.x = 320;
        self.kc_skiptext.y = 70;
        self.kc_skiptext.alignX = "center";
        self.kc_skiptext.alignY = "middle";
        self.kc_skiptext.sort = 1; // force to draw after the bars
    }
    if(!finalKillcam)
        self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");

    if(!finalKillcam)
    {
        self thread waitSkipKillcamButton();
        self thread waitKillcamTime();
        self waittill("end_killcam");
        self removeKillcamElements();
    }

    if(finalKillcam)
        if(self.archivetime > delay)
            wait self.archivetime - .05;

    self.spectatorclient = -1;
    self.archivetime = 0;
    if(!finalKillcam)
        self.killcam = undefined;

    if(finalKillcam)
    {
        level notify("finalKillcam_ended");
        return;
    }
    else
    {
        currentorigin = self.origin;
        currentangles = self getPlayerAngles();
        self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles, true);
    }
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
    if(isDefined(self.kc_topbar))
        self.kc_topbar destroy();
    if(isDefined(self.kc_bottombar))
        self.kc_bottombar destroy();
    if(isDefined(self.kc_title))
        self.kc_title destroy();
    if(isDefined(self.kc_skiptext))
        self.kc_skiptext destroy();
}
//KILLCAM FUNCTIONS END

//VSAY
quickcommands(response)
{
    if(!isDefined(self.pers["camouflage"]) || isDefined(self.spamdelay))
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
    if(!isDefined(self.pers["camouflage"]) || isDefined(self.spamdelay))
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
    if(!isDefined(self.pers["camouflage"]) || isDefined(self.spamdelay))
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

dropHealth()
{
    if(isDefined(level.healthqueue[level.healthqueuecurrent]))
        level.healthqueue[level.healthqueuecurrent] delete();
    
    level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
    level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

    level.healthqueuecurrent++;
    
    if(level.healthqueuecurrent >= 16)
        level.healthqueuecurrent = 0;
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
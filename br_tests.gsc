//1. Put this file in the "codam" folder of the "main" server folder.
//2. Add the below line to "modlist.gsc":
//[[register]]("BR tests", codam\br_tests::main);

main(phase, register)
{
	switch(phase)
	{
		case "init": _init(register); break;
		case "load": _load(); break;
	}
}
_init(register)
{
	if (isdefined(level.br_tests))
		return;
	level.br_tests = true;

	zoneOriginStart = (1190, -1060, -520); //~center of map (zh_frenzy)
	level.zone = spawn("script_model", zoneOriginStart);
	level.zone.modelPath = "xmodel/playerhead_default"; //TODO: create an invisible model instead
	level.zone.modelTag = "bip01 spine2";
	level.zone.angles = (270, 0, 0); //DEPENDS ON MODELS TAG

	level.zone.modes = [];

	level.zone.modes[0]["name"] = "1";
    level.zone.modes[0]["fxId"] = loadfx("fx/zone1.efx");
	level.zone.modes[0]["startSize"] = "7000";

	level.zone.modes[1]["name"] = "1_2";
    level.zone.modes[1]["fxId"] = loadfx("fx/zone1_2.efx");
	level.zone.modes[1]["startSize"] = level.zone.modes[1-1]["startSize"];
	level.zone.modes[1]["endSize"] = "3800";
	
	level.zone.modes[2]["name"] = "2";
    level.zone.modes[2]["fxId"] = loadfx("fx/zone2.efx");
	level.zone.modes[2]["startSize"] = level.zone.modes[2-1]["endSize"];

	level.zone.modes[3]["name"] = "2_3";
    level.zone.modes[3]["fxId"] = loadfx("fx/zone2_3.efx");
	level.zone.modes[3]["startSize"] = level.zone.modes[3-1]["startSize"];
	level.zone.modes[3]["endSize"] = "2700";

	level.zone.modes[4]["name"] = "3";
    level.zone.modes[4]["fxId"] = loadfx("fx/zone3.efx");
	level.zone.modes[4]["startSize"] = level.zone.modes[4-1]["endSize"];

	level.zone.modes[5]["name"] = "3_4";
    level.zone.modes[5]["fxId"] = loadfx("fx/zone3_4.efx");
	level.zone.modes[5]["startSize"] = level.zone.modes[5-1]["startSize"];
	level.zone.modes[5]["endSize"] = "1500";

	level.zone.modes[6]["name"] = "4";
    level.zone.modes[6]["fxId"] = loadfx("fx/zone4.efx");
	level.zone.modes[6]["startSize"] = level.zone.modes[6-1]["endSize"];

	level.zone.modes[7]["name"] = "4_5";
    level.zone.modes[7]["fxId"] = loadfx("fx/zone4_5.efx");
	level.zone.modes[7]["startSize"] = level.zone.modes[7-1]["startSize"];
	level.zone.modes[7]["endSize"] = "800";

	level.zone.modes[8]["name"] = "5";
    level.zone.modes[8]["fxId"] = loadfx("fx/zone5.efx");
	level.zone.modes[8]["startSize"] = level.zone.modes[8-1]["endSize"];

	level.zone.modes[9]["name"] = "5_6";
    level.zone.modes[9]["fxId"] = loadfx("fx/zone5_6.efx");
	level.zone.modes[9]["startSize"] = level.zone.modes[9-1]["startSize"];
	level.zone.modes[9]["endSize"] = "300";

	level.zone.modes[10]["name"] = "6";
    level.zone.modes[10]["fxId"] = loadfx("fx/zone6.efx");
	level.zone.modes[10]["startSize"] = level.zone.modes[10-1]["endSize"];

	level.zone.modes[11]["name"] = "6_end";
    level.zone.modes[11]["fxId"] = loadfx("fx/zone6_end.efx");
	level.zone.modes[11]["startSize"] = level.zone.modes[11-1]["startSize"];
	level.zone.modes[11]["endSize"] = "0";

	[[register]]("spawnPlayer", ::checkPlayerInZone, "thread");
}
_load()
{
	if (isdefined(level.br_tests2))
		return;
	level.br_tests2 = true;

	precacheModel(level.zone.modelPath);
	precacheModel("xmodel/c47");

	commands(72, level.prefix + "zone", ::cmd_playzone, "Play zone. ["+ level.prefix + "zone <mode>]");
	commands(73, level.prefix + "land", ::cmd_land, "Land. ["+ level.prefix + "land]");
}

commands(id, cmd, func, desc)
{
    if(!isDefined(level.commands[cmd]))
        level.help[level.help.size]["cmd"] = cmd;

    level.commands[cmd]["func"] = func;
    level.commands[cmd]["desc"] = desc;
    level.commands[cmd]["id"]   = id;
}

cmd_playzone(args)
{
    if (args.size != 2)
	{
        self codam\_mm_mmm::message_player("^1ERROR: ^7Invalid number of arguments.");
        return;
    }
    args1 = args[1];
    if (!isDefined(args1))
	{
        self codam\_mm_mmm::message_player("^1ERROR: ^7Invalid argument.");
        return;
    }
	
	for(i = 0; i < level.zone.modes.size; i++)
	{
		if (isDefined(level.zone.modes[i]) && isDefined(level.zone.modes[i]["name"]))
		{
			if (args1 == level.zone.modes[i]["name"])
			{
				zoneModeIndex = i;
				break;
			}
		}
	}
	if (isDefined(zoneModeIndex))
	{
		self codam\_mm_mmm::message_player("^2INFO: ^7Zone mode found.");
	}
	else
	{
		self codam\_mm_mmm::message_player("^1ERROR: ^7Zone mode unrecognized.");
		return;
	}
	self setupZone(zoneModeIndex);
}

cmd_land(args)
{
    if(args.size != 1) {
        self codam\_mm_mmm::message_player("^1ERROR: ^7Invalid number of arguments.");
        return;
    }


	//Anim testing
	/*
	self setClientCvar("cg_thirdPerson", "1");
	self setAnim("pb_climbup"); //pb_climbup
	return;
	*/



	level.hudJump = newHudElem();
	level.hudJump.x = 50;
	level.hudJump.y = 130;
	level.hudJump.fontScale = 1;
	level.hudJump setText(&"^3Press [{+activate}] to jump");

	level.hudParachute = newHudElem();
	level.hudParachute.x = level.hudJump.x;
	level.hudParachute.y = level.hudJump.y + 20;
	level.hudParachute.fontScale = 1;
	level.hudParachute setText(&"^3Press [{+activate}] to open/close parachute");

	//zh_frenzy
	originPlaneTest = (2050, -14350, 8070);
	level.plane = spawn("script_model", originPlaneTest);
	level.plane setModel("xmodel/c47");
	level.plane.angles = (0, 90, 0);

	originPlanePovTest =
		(level.plane.origin[0],
		level.plane.origin[1] - 700,
		level.plane.origin[2] + 400);
	self.planePov = spawn("script_origin", originPlanePovTest);
	self.origin = self.planePov.origin;
	self linkto(self.planePov);

	planePovAngles =
		(level.plane.angles[0] + 25,
		level.plane.angles[1],
		level.plane.angles[2]);
	self setPlayerAngles(planePovAngles);

	moveDistance = 30000;
	moveDelay = 22;
	level.plane moveY(moveDistance, moveDelay);
	self.planePov moveY(moveDistance, moveDelay);

	self thread checkPlayerJumped();

	wait moveDelay;
	level.plane delete();

	//self codam\_mm_mmm::message_player("^2INFO: ^7Landing test.");
}

//SKYDIVE FUNCTIONS
checkPlayerJumped()
{
	for(;;)
	{
		if (self useButtonPressed())
		{	
			//TODO: team/weapon setup when creating gt file.
			self.pers["team"] = "allies";
			self.pers["weapon"] = "mosin_nagant_mp";
			anglesBeforeSpawn = self getPlayerAngles();
			self thread [[ level.gtd_call ]]("gt_spawnPlayer");

			//self setClientCvar("cg_thirdPerson", "1"); //TODO: remove after tests

			self.origin = self.planePov.origin;
			self linkto(self.planePov);
			self setPlayerAngles(anglesBeforeSpawn);

			delayExitPlane = 0.20;
			underPlaneOrigin =
				(self.planePOV.origin[0],
				self.planePOV.origin[1] - 500,
				(self.planePOV.origin[2] - 700));
			self.planePOV moveTo(underPlaneOrigin, delayExitPlane);
			wait delayExitPlane;

			self unlink();
			self.planePOV delete();

			self.god = true; //TODO: remove after tests

			self thread checkPlayerDive();

			break;
		}
		wait .05;
	}
}
checkPlayerDive()
{
	self thread checkLanded();

	self setGravity(200);

	acceleration = 20;
	friction = 0.975; //When not going forward/sides + not using parachute
	
	for(;;)
	{
		self endon("landed");

		velocity = self getvelocity();
		angles = self getplayerangles();
		forwardDirection = anglesToForward(angles);
		speedScale = 1;

		if (self forwardButtonPressed()) //TODO: same when diving on sides
		{
			speedScale = 1.5;
			velocity =
				(velocity[0] + forwardDirection[0] * acceleration,
                velocity[1] + forwardDirection[1] * acceleration,
                velocity[2] + forwardDirection[2] * acceleration);
		}
		else
		{
			velocity = maps\mp\_utility::vectorScale(velocity, friction);
		}

		self setMoveSpeedScale(speedScale);
		self setVelocity(velocity);
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

			self setMoveSpeedScale(1);

			g_gravity = getCvar("g_gravity");
			self setGravity(g_gravity);
			
			//self setClientCvar("cg_thirdPerson", "0");

			break;
		}
		wait .05;
	}
}
//SKYDIVE FUNCTIONS END

//ZONE FUNCTIONS
setupZone(zoneModeIndex)
{
	for(i = 0; i < level.zone.modes[zoneModeIndex]["name"].size; i++)
	{
		if (level.zone.modes[zoneModeIndex]["name"][i] == "_")
		{
			modeIsTransition = true;
			break;
		}
    }
	if (!isDefined(modeIsTransition)) //STATIC ZONE
	{
		iPrintLnBold("^2INFO: ^7Zone is a static.");
		if (isDefined(level.zone.active)) //TODO: remove after tests
		{
			iPrintLnBold("^1ERROR: ^7Static zone already active.");
			return;
		}
		level.zone.indexMode = zoneModeIndex;
		level.zone.life = 1000;
		level.zone.currentSize = (int)level.zone.modes[zoneModeIndex]["startSize"];
		level.zone thread playZone(level.zone.modes[zoneModeIndex]["fxId"], true);
	}
	else //SHRINKING ZONE
	{
		iPrintLnBold("^2INFO: ^7Zone shrinks.");
		level.zone.active = undefined;
		level.zoneLooper delete();
		level.zone.indexMode = zoneModeIndex;
		level.zone.life = 6000;
		level.zone.startSize = (int)level.zone.modes[zoneModeIndex]["startSize"];
		level.zone.currentSize = level.zone.startSize;
		level.zone.endSize = (int)level.zone.modes[zoneModeIndex]["endSize"];
		level.zone.nextZoneIndex = level.zone.indexMode + 1;
		level.zone setModel(level.zone.modelPath);
		wait .05;
		level.zone thread playZone(level.zone.modes[zoneModeIndex]["fxId"], false);
		level.zone thread keepZoneSizeVarUpdated();
	}
	level.zone.active = true;
	iPrintLnBold("^2INFO: ^7Playing zone.");
}
playZone(fx, static)
{
	if (static)
	{
		level.zoneLooper = playLoopedFX(fx, (self.life / 1000), self.origin);
	}
	else
	{
		playFXOnTag(fx, self, self.modelTag);
		if (self.indexMode != level.zone.modes.size - 1) //FINAL FULL SHRINKS DOESNT PLAY NEXT
		{
			wait (self.life / 1000);
			//PLAY NEXT STATIC ZONE
			level.zone.active = undefined;
			level thread setupZone(self.nextZoneIndex);
		}
	}
}

/*
moveZone()
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
checkPlayerInZone(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, b0, b1, b2, b2, b4, b5, b6, b7, b8, b9)
{
	self endon("death");
	self endon("disconnect");

	for(;;)
	{
		if (isDefined(level.zone.active))
		{
			if (!isDefined(self.hudInZoneCheck))
			{
				self.hudInZoneCheck = newClientHudElem(self); //TODO: improve design for release
				self.hudInZoneCheck.x = 30;
				self.hudInZoneCheck.y = 150;
				self.hudInZoneCheck.font = "bigfixed";
				self.hudInZoneCheck.fontScale = 1.5;
			}
			if (!isDefined(self.hudStorm))
			{
				self.hudStorm = newClientHudElem(self);
				self.hudStorm.x = 0;
				self.hudStorm.y = 0;
				self.hudStorm setShader("black", 640, 480);
				self.hudStorm.alpha = 0;
			}

			//IGNORE Z
			selfOriginX = self.origin[0];
			selfOriginY = self.origin[1];
			selfOriginNoZ = (selfOriginX, selfOriginY, 0);
			//---
			zoneOriginX = level.zone.origin[0];
			zoneOriginY = level.zone.origin[1];
			zoneOriginNoZ = (zoneOriginX, zoneOriginY, 0);
			
			if (distance(selfOriginNoZ, zoneOriginNoZ) < level.zone.currentSize)
			{
				//IN ZONE
				self.hudInZoneCheck setText(&"^2IN ZONE");
				self.hudStorm.alpha = 0;
			}
			else
			{
				//OUT OF ZONE
				self.hudInZoneCheck setText(&"^1OUT OF ZONE");
				self.hudStorm.alpha = 0.3;

				damagePlayer = false;
				if (isDefined(self.lastZoneDamageTime))
				{
					secondsPassed = (getTime() - self.lastZoneDamageTime) / 1000;
					if (secondsPassed > 2)
					{
						damagePlayer = true;
					}
				}
				else
				{
					damagePlayer = true;
				}

				if (damagePlayer)
				{
					if (isAlive(self))
					{
						self endon("disconnect");

						eInflictor = level.zone;
						eAttacker = level.zone;
						iDamage = 5;
						iDFlags = 0;
						sMeansOfDeath = "MOD_EXPLOSIVE";
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
		}
		else
		{
			//RESET HUD
			if (isDefined(self.hudInZoneCheck))
			{
				self.hudInZoneCheck destroy();
			}
			if (isDefined(self.hudStorm))
			{
				self.hudStorm destroy();
			}
		}

		wait .05;
	}
}
//ZONE FUNCTIONS END
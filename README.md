## Gametype under development, currently not playable

### Requirements to run the tests:
- A server running [MiscMod](https://cod.pm/guide/d0da8d/installing-and-configuring-codam-miscmod)
  - miscmod requires codextended, I suggest my [codextended-server fork](https://github.com/raphael12333/codextended-server/tree/main)
- Put the effects pk3 file in the server main folder
- Put the map pk3 file in the server main folder
- Read the comments at the beginning of *br_tests.gsc*
___
### Some TODO:
- Skydiving animations
- Add a `setGravity` and a `setAnim` GSC command to CoDExtended, like libcod
  - i started a setgravity command in my codextended fork, but it seems some `cl->ps.gravity = g_gravity` must be intercepted somewhere for it to work
- Automatize the zone cycle and randomize the locations
- Show the zone on compass
___
You can see some videos here: https://www.youtube.com/playlist?list=PLTiI1XPSd-uULSzEWCV-eEZ_eunBUiWZq

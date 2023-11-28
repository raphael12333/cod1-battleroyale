## This project is under developpement, currently not playable

### Requirements to run the tests:
- a server running [MiscMod](https://cod.pm/guide/d0da8d/installing-and-configuring-codam-miscmod)
  - it requires codextended, i suggest [my fork](https://github.com/raphael12333/codextended-server/tree/main)
- put the effects pk3 file in the server main folder
- put the map pk3 file in the server main folder
  - the zone tests were done using [zh_frenzy](https://vcodmods.com/view/zh_frenzy-by-zilch)
  - i'm doing the skydiving tests with another map, i think it's not released yet and i didn't ask permission to share it
- read the comments at the beginning of *br_tests.gsc*
___
### Some TODO:
- rotate the player character when skydiving
  - it's planned to skydive at first person but at least for other players not to see each other skydiving standing
- make a setgravity command
  - i started one in my codextended fork, but it seems some `cl->ps.gravity = g_gravity` must be intercepted for it to work
- Automatize the zone cycle and randomize the locations
- Make the plane to fly higher
- Show the zone on the compass
___
You can see some videos here: https://www.youtube.com/channel/UCiq2c23nxeMk6gcMqozrebQ

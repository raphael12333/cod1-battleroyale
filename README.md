## Gametype under development, currently not playable

### Requirements to run the tests
###### `___________________`
I started by doing tests using *br_tests.gsc* on a dm, it uses custom MiscMod commands, to try this file you would need to:
- setup [MiscMod](https://cod.pm/guide/d0da8d/installing-and-configuring-codam-miscmod)
- read the comments at the beginning
- put *___fx.pk3* in the server main folder, this file must be downloaded by the client.
###### `___________________`
Now I started to create a mod independent gametype file: *br.gsc*  
To try it you would need to put *___customizations.pk3* in the server main folder, this file must be downloaded by the client.
###### `___________________`
In all case you would need to use:
- the .pk3 map file from the map folder
- a `setGravity` GSC command
  - this [codextended-server fork](https://github.com/raphael12333/codextended-server/tree/main) has one
###### `___________________`
___
### Some TODO
- Automatize the zone cycle and randomize the locations
- Show the zone on compass
- Add a `setAnim` GSC command to CoDExtended, like libcod
- Fill some roofs/holes on the map
___
#### [Test videos](https://www.youtube.com/playlist?list=PLTiI1XPSd-uVS_saGvqfgk7hgguxHc1Y0)

## Gametype under development, currently not playable

### Requirements to run the tests

I started by doing tests using *br_tests.gsc* on a dm, it uses custom MiscMod commands, to try this file you would need to:
- setup [MiscMod](https://cod.pm/guide/d0da8d/installing-and-configuring-codam-miscmod)
- read the comments at the beginning
- put `___fx.pk3` in the server main folder, this file must be downloaded by the client.
###### `-------------`
Now I started to create a mod independent gametype file: *br.gsc*  
To try it you would need to put `___customizations.pk3` in the server main folder, this file must be downloaded by the client.
###### `-------------`
In all case you would need to use the .pk3 map file from the map folder
___
### Some TODO
- Automatize the zone cycle and randomize the locations
- Fill some roofs/holes on the map
- Show the zone on compass
- Create models and animations for skydiving
- Add a `setAnim` GSC command to CoDExtended, like libcod
___
#### [Test videos](https://www.youtube.com/playlist?list=PLTiI1XPSd-uVS_saGvqfgk7hgguxHc1Y0)

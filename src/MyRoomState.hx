// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 3.0.13
// 


import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class MyRoomState extends Schema {
	@:type("map", BPlayer)
	public var players: MapSchema<BPlayer> = new MapSchema<BPlayer>();

}

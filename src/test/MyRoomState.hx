// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 1.0.41
// 


import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class MyRoomState extends Schema {
	@:type("array", Message)
	public var messages: ArraySchema<Message> = new ArraySchema<Message>();

	@:type("map", Player)
	public var players: MapSchema<Player> = new MapSchema<Player>();

}

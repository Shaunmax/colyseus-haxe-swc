// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 1.0.41
// 

package tictactoe;
import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;
@:keep
class MyRoomState extends Schema {
	@:type("string")
	public var currentTurn: String = "";

	@:type("map", "boolean")
	public var players: MapSchema<Bool> = new MapSchema<Bool>();

	@:type("array", "number")
	public var board: ArraySchema<Dynamic> = new ArraySchema<Dynamic>();

	@:type("string")
	public var winner: String = "";

	@:type("string")
	public var winline: String = "";

	@:type("number")
	public var turnCount: Dynamic = 0;

	@:type("boolean")
	public var draw: Bool = false;

}

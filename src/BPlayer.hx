// 
// THIS FILE HAS BEEN GENERATED AUTOMATICALLY
// DO NOT CHANGE IT MANUALLY UNLESS YOU KNOW WHAT YOU'RE DOING
// 
// GENERATED USING @colyseus/schema 3.0.13
// 


import io.colyseus.serializer.schema.Schema;
import io.colyseus.serializer.schema.types.*;

class BPlayer extends Schema {
	@:type("string")
	public var id: String = "";

	@:type("string")
	public var name: String = "";

	@:type("string")
	public var flag: String = "";

	@:type("number")
	public var joinedAt: Dynamic = 0;

}

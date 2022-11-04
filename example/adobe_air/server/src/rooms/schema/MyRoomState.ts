import { Schema, type, ArraySchema, MapSchema } from "@colyseus/schema";


export class Player extends Schema {
  @type("number") x: number = 0;
  @type("number") y: number = 0;
}

export class Message extends Schema {
  @type("string") message: string;
}

export class MyRoomState extends Schema {

  @type("string") currentTurn: string;
  @type({ map: "boolean" }) players = new MapSchema<boolean>();
  @type(["number"]) board: number[] = new ArraySchema<number>(0, 0, 0, 0, 0, 0, 0, 0, 0);
  @type("string") winner: string;
  @type("string") winline: string;
  @type("number") turnCount: number = 0;
  @type("boolean") draw: boolean;

}

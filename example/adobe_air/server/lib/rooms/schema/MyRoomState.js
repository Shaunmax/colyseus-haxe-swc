"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MyRoomState = exports.Message = exports.Player = void 0;
const schema_1 = require("@colyseus/schema");
class Player extends schema_1.Schema {
    constructor() {
        super(...arguments);
        this.x = 0;
        this.y = 0;
    }
}
__decorate([
    (0, schema_1.type)("number")
], Player.prototype, "x", void 0);
__decorate([
    (0, schema_1.type)("number")
], Player.prototype, "y", void 0);
exports.Player = Player;
class Message extends schema_1.Schema {
}
__decorate([
    (0, schema_1.type)("string")
], Message.prototype, "message", void 0);
exports.Message = Message;
class MyRoomState extends schema_1.Schema {
    constructor() {
        super(...arguments);
        this.players = new schema_1.MapSchema();
        this.board = new schema_1.ArraySchema(0, 0, 0, 0, 0, 0, 0, 0, 0);
    }
}
__decorate([
    (0, schema_1.type)("string")
], MyRoomState.prototype, "currentTurn", void 0);
__decorate([
    (0, schema_1.type)({ map: "boolean" })
], MyRoomState.prototype, "players", void 0);
__decorate([
    (0, schema_1.type)(["number"])
], MyRoomState.prototype, "board", void 0);
__decorate([
    (0, schema_1.type)("string")
], MyRoomState.prototype, "winner", void 0);
__decorate([
    (0, schema_1.type)("string")
], MyRoomState.prototype, "winline", void 0);
__decorate([
    (0, schema_1.type)("boolean")
], MyRoomState.prototype, "draw", void 0);
exports.MyRoomState = MyRoomState;

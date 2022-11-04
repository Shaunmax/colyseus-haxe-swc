package {

import feathers.controls.Screen;
import feathers.controls.LayoutGroup;
import feathers.controls.ScreenNavigator;
import feathers.events.FeathersEventType;
import feathers.layout.AnchorLayout;
import feathers.layout.HorizontalLayout;
import feathers.layout.TiledColumnsLayout;
import feathers.layout.TiledRowsLayout;
import feathers.layout.VerticalLayout;

import starling.display.MovieClip;

import haxe.ds.StringMap;

import io.colyseus.Client;
import io.colyseus.Room;
import io.colyseus.error.MatchMakeError;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;
import starling.utils.Color;
import starling.utils.MathUtil;

import tictactoe.MyRoomState;

public class TicTacToe extends Screen {
    public var _main_sprite:Sprite;
    public static const linkers:Array = [AnchorLayout, LayoutGroup, HorizontalLayout, VerticalLayout, TiledRowsLayout, MovieClip, TiledColumnsLayout];
    public static var card:Card;
    private static var client:Client;
    private static var myroom:Room;
    private static var game_result:Object;
    private var myId:String;
    public var _main_layout:LayoutGroup;
    public var _opponent:PlayerSp;
    public var _you:PlayerSp;
    private var current_player:PlayerSp;
    public static var my_player_no:uint;
    private var my_turn:Boolean;
    public var _root:LayoutGroup;
    public var backGround_color:Quad;
    public static const SHOW_MENU:String = "showMenu";

    public function TicTacToe() {
        trace("Tic Tact Toe Loaded");

        addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, onTransitionInComplete);
        var stage:Stage = Starling.current.stage;

        _main_sprite = Game.uiBuilder.create(ParsedLayouts.GAME_UI, false, this) as Sprite;
        var new_scale:Number = MathUtil.min(1.0 * stage.stageWidth / _main_sprite.width, 1.0 * stage.stageHeight / _main_sprite.height);
        _main_sprite.scaleX = _main_sprite.scaleY = Game.round2(new_scale, 2);
        _main_sprite.width = stage.stageWidth;
        _main_sprite.height = stage.stageHeight;
        addChild(_main_sprite);

        card = new Card();
        card.touchable = false;
        _main_layout.addChild(card);
        backGround_color = _root.backgroundSkin as Quad;

    }

    private function onTransitionInComplete(event:Event):void {
        removeEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, onTransitionInComplete);
        //client = new Client("ws://localhost:2567"); // local server
        client = new Client("ws://rtb4zz.us-east-vin.colyseus.net:2567"); // live server
        joinServerRoom();
        Game.showToast("CONNECTING TO SERVER...", Number.POSITIVE_INFINITY);
    }

    private function removeGameScreen():void {
        Game.removeToast();
        this.dispatchEventWith(SHOW_MENU);
    }

    private function joinServerRoom():void {
        //client.joinById("FjpkKsWka",new StringMap() ,MyRoomState,function (err:MatchMakeError, room:Room):void{
        client.joinOrCreate("my_room", new StringMap(), MyRoomState, function (err:MatchMakeError, room:Room):void {
            if (err) {
                trace("Err = " + JSON.stringify(err));
            } else {

                myroom = room;
                myId = myroom.sessionId;

                trace("Room Session Id = ", myroom.sessionId);
                trace("Room Id = ", myroom.id);

                myroom.state.board.onChange = function onBoardStateChanged(value, index):void {
                    trace(" Board Changed = " + value, index);
                    var i = index - 1;
                    var x = index % 3;
                    var y = Math.floor(index / 3);

                    if (my_turn) {
                        card.updateCell(x, y, value, true);
                        my_turn = false;
                    } else {
                        card.updateCell(x, y, value, false);
                        my_turn = true;
                    }
                };

                myroom.onStateChange.push(onRoomStateChanged);
                myroom.onJoin.push(onRoomJoined);
                myroom.onLeave.push(onRoomLeft);
                myroom.onError.push(onRoomError);

                myroom.onMessage("hello", function (message) {
                    trace("data received - " + JSON.stringify(message));
                });

                myroom.onMessage("game_state", onGameStateChange);

                myroom.onMessage("data", function (message) {
                    trace("data received - " + message.current_turn);
                    trace("data turn_count - " + message.turn_count);

                    Game.removeToast();
                    stopTween();

                    if (message.current_turn == myroom.sessionId) {
                        current_player = _you;
                        card.touchable = true;
                        Starling.juggler.tween(backGround_color, 0.6, {"color": 0xFF5555});
                    } else {
                        current_player = _opponent;
                        card.touchable = false;
                        Starling.juggler.tween(backGround_color, 0.6, {"color": 0x5589FF});
                    }

                    current_player.startTimer();
                });

                myroom.onMessage("result", function (message) {
                    trace("result received - " + message.winner);
                    trace("result win line - " + message.line);
                    game_result = message;
                    stopTween();

                    if (game_result.winner == myroom.sessionId) {
                        if (Number(game_result.status) == 1) {
                            Game.showToast("OPPONENT LEFT - YOU WIN!", Number.POSITIVE_INFINITY);
                        } else {
                            card.showLine(message.line, Color.RED);
                        }
                    } else {
                        card.showLine(message.line, Color.BLUE);
                    }

                });

                myroom.onMessage("broadcast", function (message) {
                    trace("broadcast received - " + message.ball);
                });

                myroom.state.players.onAdd = function onPlayerAdded(player, key:String):void {
                    trace("Player Added @ " + key);
                }

                myroom.state.players.onChange = function onPlayerChange(player, key:String):void {
                    trace(key + " Player Changed @ ");
                }

                myroom.state.players.onRemove = function onPlayerRemove(player, key:String):void {
                    trace(key + " Removed");
                }
            }
        });
    }

    public static function displayResult():void {
        if (game_result.winner == myroom.sessionId) {
            if (Number(game_result.status) == 0) {
                Game.showToast("GAME OVER - YOU WON!", Number.POSITIVE_INFINITY);
            } else {
                Game.showToast("OPPONENT LEFT - YOU WIN!", Number.POSITIVE_INFINITY);
            }

        } else {
            Game.showToast("GAME OVER - YOU LOST!", Number.POSITIVE_INFINITY);
        }
    }

    private function onGameStateChange(message):void {
        trace("game_state change received - " + JSON.stringify(message.state));

        switch (Number(message.state)) {
            case 0:
                Game.showToast("WAITING FOR OPPONENT", Number.POSITIVE_INFINITY);
                break;

            case 1:
                //Game.showToast("MATCH WILL BEGIN SHORTLY", Number.POSITIVE_INFINITY);
                if (message.starting_player == myroom.sessionId) {
                    my_turn = true;
                    my_player_no = 2;
                } else {
                    my_player_no = 1;
                }
                trace("My player number = ", my_player_no);
                break;

            case 2:
                stopTween();
                Game.showToast("DRAW MATCH", Number.POSITIVE_INFINITY);
                break;
            case 3:
                trace("Room Closed!");
                Starling.juggler.delayCall(removeGameScreen, 1);
                break;

            default:
                Game.showToast("OOPS! SOMETHING WENT WRONG", Number.POSITIVE_INFINITY);
        }
    }

    public static function checkDaub(pos:Object):void {
        myroom.send("action", {"x": pos.x, "y": pos.y});
    }

    private function onRoomJoined():void {
        trace("Joined Room");
    }

    private function onRoomLeft():void {
        trace("Left Room");
    }

    private function onRoomError(code:int, message:String):void {
        trace("ROOM ERROR: " + code + " => " + message);
    }

    private function onRoomStateChanged(changes):void {
        trace(" State Changed = " + changes.toString());

        //trace(" State Changed = " + JSON.stringify(state));
    }

    private function stopTween():void {
        if (current_player) {
            current_player.stopTimer();
        }
    }
}
}

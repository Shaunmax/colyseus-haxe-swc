package  {

import feathers.controls.LayoutGroup;

import flash.geom.Point;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.Color;
import starling.utils.deg2rad;

public class Card extends Sprite{
    private var _main_sprite:Sprite;
    public var _main_layout:LayoutGroup;
    public var _cell_1:CellSp;
    public var _cell_2:CellSp;
    public var _cell_3:CellSp;
    public var _cell_4:CellSp;
    public var _cell_5:CellSp;
    public var _cell_6:CellSp;
    public var _cell_7:CellSp;
    public var _cell_8:CellSp;
    public var _cell_9:CellSp;
    public var _line_1:Image;
    public var cell_array:Array;

    public function Card() {
        cell_array = new Array();

        _main_sprite = Game.uiBuilder.create(ParsedLayouts.CARD_UI, true, this) as Sprite;
        addChild(_main_sprite);

        cell_array.push([_cell_1, _cell_2, _cell_3]);
        cell_array.push([_cell_4, _cell_5, _cell_6]);
        cell_array.push([_cell_7, _cell_8, _cell_9]);

        _cell_1.setPos(0,0);
        _cell_2.setPos(0,1);
        _cell_3.setPos(0,2);

        _cell_4.setPos(1,0);
        _cell_5.setPos(1,1);
        _cell_6.setPos(1,2);

        _cell_7.setPos(2,0);
        _cell_8.setPos(2,1);
        _cell_9.setPos(2,2);

        _line_1.visible = false;

        addEventListener(TouchEvent.TOUCH, onTrigDaub);
    }

    public function updateCell(xp:uint, yp:uint , value:uint, you:Boolean):void{
        cell_array[xp][yp].daub(value, you);
    }

    public function showLine(line:String, col:uint, scale:Number = 5):void{

        switch (line) {
            case "h0":
                _line_1.x = _cell_2.x;
                _line_1.y = _cell_2.y;
                break;

            case "h1":
                _line_1.x = _cell_5.x;
                _line_1.y = _cell_5.y;
                break;

            case "h2":
                _line_1.x = _cell_8.x;
                _line_1.y = _cell_8.y;
                break;
            case "v0":
                _line_1.x = _cell_4.x;
                _line_1.y = _cell_4.y;
                _line_1.rotation = deg2rad(90);
                break;

            case "v1":
                _line_1.x = _cell_5.x;
                _line_1.y = _cell_5.y;
                _line_1.rotation = deg2rad(90);
                break;

            case "v2":
                _line_1.x = _cell_6.x;
                _line_1.y = _cell_6.y;
                _line_1.rotation = deg2rad(90);
                break;
            case "d0":
                _line_1.x = _cell_5.x;
                _line_1.y = _cell_5.y;
                _line_1.rotation = deg2rad(135);
                scale = 6;
                break;

            case "d2":
                _line_1.x = _cell_5.x;
                _line_1.y = _cell_5.y;
                _line_1.rotation = deg2rad(45);
                scale = 6;
                break;

            default:
                trace ("None of the above cases were met")
        }

        _line_1.visible = true;

        Starling.juggler.tween(_line_1, 0.5, { "scaleX": scale , "color" : col});
        Starling.juggler.delayCall(TicTacToe.displayResult, 2);
    }

    private function onTrigDaub(event:TouchEvent):void {
        var touch_ended:Touch = event.getTouch(stage, TouchPhase.ENDED);
        var touched_cell:CellSp = event.target as CellSp;

        if (touch_ended != null) {

            if (touched_cell as CellSp && touched_cell.daubed == false) {
                TicTacToe.checkDaub(touched_cell.getPos());
                touched_cell.daub(TicTacToe.my_player_no, true);
            }
        }
    }
}
}

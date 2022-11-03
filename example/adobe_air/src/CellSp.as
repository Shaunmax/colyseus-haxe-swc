package  {
import flash.geom.Point;

import starling.display.Image;

import starling.display.MovieClip;
import starling.display.Sprite;
import starling.utils.Color;

import starlingbuilder.engine.iCustomClass;

public class CellSp extends Sprite implements iCustomClass{
    private var x_pos:uint;
    private var y_pos:uint;
    private var cell_anim:MovieClip;
    private var cell_bg:Image;
    public var daubed:Boolean = false;
    public function CellSp() {
    }

    public function init():void {

        touchGroup = true;
        cell_anim = getChildByName("cell_anim") as MovieClip;
        cell_bg = getChildByName("cell_bg") as Image;
    }

    public function setPos(xp:int, yp:int):void{
        x_pos = xp;
        y_pos = yp;
    }
    public function getPos():Object{
        return {"x":x_pos , "y" : y_pos};
    }

    public function daub(frame:uint, you:Boolean = false ):void{
        if(!daubed){
            daubed = true;
            if(you){
                cell_anim.currentFrame = frame + 2;
            }else{
                cell_anim.currentFrame = frame;
            }
        }
    }
}
}

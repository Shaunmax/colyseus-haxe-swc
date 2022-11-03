package  {
import feathers.controls.Screen;
import feathers.layout.AnchorLayout;
import feathers.layout.HorizontalLayout;
import feathers.layout.TiledColumnsLayout;
import feathers.layout.TiledRowsLayout;
import feathers.layout.VerticalLayout;

import starling.core.Starling;
import starling.display.Button;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;
import starling.utils.MathUtil;

public class Menu extends Screen{
    public var _main_sprite:Sprite;
    public static const linkers:Array = [AnchorLayout, feathers.controls.LayoutGroup, HorizontalLayout, VerticalLayout,TiledRowsLayout,MovieClip,TiledColumnsLayout];
    public var _play_btn:Button;
    public static const SHOW_GAME:String = "showGame";
    public function Menu() {
        var stage:Stage = Starling.current.stage;

        _main_sprite = Game.uiBuilder.create(ParsedLayouts.MENU_UI, false, this) as Sprite;
        var new_scale:Number = MathUtil.min(1.0 * stage.stageWidth / _main_sprite.width, 1.0 * stage.stageHeight / _main_sprite.height);
        _main_sprite.scaleX = _main_sprite.scaleY = Game.round2(new_scale, 2);
        _main_sprite.width = stage.stageWidth;
        _main_sprite.height = stage.stageHeight;
        addChild(_main_sprite);

        _play_btn.addEventListener(Event.TRIGGERED, onTrigPlay);
    }

    private function onTrigPlay(event:Event):void {

        this.dispatchEventWith( SHOW_GAME );

    }
}
}

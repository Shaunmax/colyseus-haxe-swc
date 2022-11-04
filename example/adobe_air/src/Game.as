package  {
import feathers.controls.AutoSizeMode;
import feathers.controls.LayoutGroup;

import feathers.controls.StackScreenNavigator;
import feathers.controls.StackScreenNavigatorItem;
import feathers.controls.Toast;
import feathers.controls.ToastQueueMode;
import feathers.events.FeathersEventType;
import feathers.layout.VerticalAlign;
import feathers.layout.VerticalLayout;
import feathers.motion.Slide;

import starling.assets.AssetManager;
import starling.core.Starling;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;
import starling.text.TextFormat;
import starling.utils.Color;

import starlingbuilder.engine.DefaultAssetMediator;

import starlingbuilder.engine.IAssetMediator;
import starlingbuilder.engine.IUIBuilder;
import starlingbuilder.engine.LayoutLoader;
import starlingbuilder.engine.UIBuilder;

public class Game extends LayoutGroup{

    public static var assetManager:AssetManager;
    private var _assetMediator:IAssetMediator;
    public static var uiBuilder:IUIBuilder;
    public static var layout_loader:LayoutLoader;
    private var navigator:StackScreenNavigator;
    private static const MAIN_MENU:String = "menu";
    private static const GAME_SCREEN:String = "game";
    public static var toast_container:LayoutGroup;
    private static var toast:Toast;

    public function Game() {

        toast_container = new LayoutGroup();
        layout_loader = new LayoutLoader(EmbeddedLayouts,ParsedLayouts);
        assetManager = new AssetManager();
        _assetMediator = new DefaultAssetMediator(assetManager);
        uiBuilder = new UIBuilder(_assetMediator);

        assetManager.enqueue("assets/textures/atlas.png");
        assetManager.enqueue("assets/textures/atlas.xml");
        assetManager.enqueue("assets/textures/bitmapfont/ArialRound.fnt");
        assetManager.enqueue(EmbeddedAssets);
        assetManager.loadQueue(onComplete);

        function onComplete():void {
            trace("Global Assets Done Loading");
           init();
        }
    }

    private function init():void
    {
        Toast.containerFactory = function():DisplayObjectContainer
        {
            trace("containerFactory");
            toast_container.autoSizeMode = AutoSizeMode.STAGE;
            toast_container.backgroundSkin = new Quad(stage.width,stage.height, Color.BLACK);
            toast_container.backgroundSkin.alpha = 0.5;
            var layout:VerticalLayout = new VerticalLayout();
            layout.verticalAlign = VerticalAlign.MIDDLE;
            toast_container.layout = layout;
            return toast_container;
        };

        Toast.toastFactory = function skinnedToastFactory():Toast {
            trace("skinnedToastFactory");
            var toast:Toast = new Toast();
            toast.backgroundSkin = new Quad(Starling.current.stage.width, Starling.current.stage.height / 10, Color.YELLOW);
            toast.fontStyles = new TextFormat("ArialRound", 32, Color.BLACK);
            toast.close();
            return toast;
        }

        Toast.queueMode = ToastQueueMode.WAIT_FOR_TIMEOUT;
        Toast.maxVisibleToasts = 1;

        navigator = new StackScreenNavigator();
        //navigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, navigator_transitionCompleteHandler );

        navigator.pushTransition = Slide.createSlideLeftTransition();
        navigator.popTransition = Slide.createSlideRightTransition();

        var item_menu:StackScreenNavigatorItem = new StackScreenNavigatorItem(Menu);
        item_menu.setScreenIDForPushEvent(Menu.SHOW_GAME, GAME_SCREEN);
        navigator.addScreen(MAIN_MENU, item_menu);

        var item_game:StackScreenNavigatorItem = new StackScreenNavigatorItem(TicTacToe);
        item_game.addPopEvent(TicTacToe.SHOW_MENU);
        navigator.addScreen(GAME_SCREEN, item_game);

        navigator.rootScreenID = MAIN_MENU;

        addChild(navigator);

        //addChild(new Menu());
        //addChild(new TicTacToe());
    }

    /*private function navigator_transitionCompleteHandler( event:Event ):void
    {
        trace("navigator_transitionCompleteHandler = ",navigator.activeScreenID);
        if(navigator.activeScreenID == "game"){

        }
    }*/

    public static function showToast(text:String, delay:Number = 0):void {
        trace("Show Toast Called");
        if(toast) {
            toast.close();
        }

        toast_container.visible = true;
        toast = Toast.showMessage(text.toUpperCase(), delay);

    }

    public static function removeToast():void{
        if(toast){
            toast.close();
           toast_container.visible = false;
        }
    }

    public static function round2(num:Number, decimals:int):Number
    {
        var m:int = Math.pow(10, decimals);
        return Math.round(num * m) / m;
    }

}
}

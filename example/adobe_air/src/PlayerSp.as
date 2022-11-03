package  {

import starling.filters.CRTFilter;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;
import starling.filters.GlowFilter;
import starling.utils.Color;

import starlingbuilder.engine.iCustomClass;

public class PlayerSp extends Sprite implements iCustomClass {

    private var progress_bar:QuadSection;
    private var breath_tween:Tween;
    private var scale_tween:Tween;
    private var pb_tween:Tween;
    private var glow_filter:GlowFilter;

    public function PlayerSp() {
    }

    public function init():void {
        progress_bar = QuadSection.fromTexture(Game.assetManager.getTexture("radial_progress_bar"));
        progress_bar.ratio = 0; // between 0 and 1
        progress_bar.color = Color.YELLOW;
        addChild(progress_bar);

        this.scaleX = 0.8;
        this.scaleY = 0.8;

        glow_filter = new GlowFilter(Color.YELLOW,0,2);
    }

    public function stopTimer():void {
        progress_bar.ratio = 0;
        glow_filter.alpha  = 0;
        Starling.juggler.purge();

        scale_tween = new Tween(this, 0.5, Transitions.EASE_OUT);
        scale_tween.animate("scaleX", 0.8);
        scale_tween.animate("scaleY", 0.8);
        Starling.juggler.add(scale_tween);
    }
    public function startTimer():void {
        progress_bar.ratio = 1;
        progress_bar.filter = glow_filter;
        progress_bar.color = glow_filter.color = Color.YELLOW;
        scale_tween = new Tween(this, 0.5, Transitions.EASE_OUT);
        scale_tween.animate("scaleX", 1);
        scale_tween.animate("scaleY", 1);
        scale_tween.onComplete = startProgress;
        Starling.juggler.add(scale_tween);

        glow_filter.alpha  = 1;

        breath_out();
    }

    public function startProgress():void {

        pb_tween = new Tween(progress_bar, 9, Transitions.LINEAR);
        pb_tween.animate("ratio", 0);
        pb_tween.onComplete = disableCard;
        Starling.juggler.add(pb_tween);
    }

    private function disableCard():void{
        TicTacToe.card.touchable = false;
    }

    public function breath_out():void {
        breath_tween = new Tween(glow_filter,0.4, Transitions.LINEAR);
        breath_tween.animate("blur", 1);
        breath_tween.onComplete = breath_in;
        Starling.juggler.add(breath_tween);
    }
    public function breath_in():void {
        breath_tween = new Tween(glow_filter, 0.6, Transitions.LINEAR);
        breath_tween.animate("blur", 2);
        breath_tween.onComplete = breath_out;
        Starling.juggler.add(breath_tween);
    }
}
}

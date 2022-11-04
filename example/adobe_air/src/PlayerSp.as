package  {

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Mesh;
import starling.display.Sprite;
import starling.filters.GlowFilter;
import starling.utils.Color;
import starling.utils.deg2rad;

import starlingbuilder.engine.iCustomClass;

public class PlayerSp extends Sprite implements iCustomClass {

    private var breath_tween:Tween;
    private var rotate_tween:Tween;
    private var pb_tween:Tween;
    private var glow_filter:GlowFilter;
    private var progress_bar:QuadSectionArc;

    public function PlayerSp() {
    }

    public function init():void {

        progress_bar = QuadSectionArc.fromTexture(Game.assetManager.getTexture("new_radial_progress_bar"));

        progress_bar.clockwise = false;
        progress_bar.ratio = 0; // between 0 and 1
        progress_bar.color = Color.YELLOW;
        addChild(progress_bar);

        this.rotation = deg2rad(180);
        glow_filter = new GlowFilter(Color.YELLOW,0,2);
    }

    public function stopTimer():void {
        resetProgressBar();
        glow_filter.alpha = 0;
        Starling.juggler.purge();

        rotate_tween = new Tween(this, 0.5, Transitions.LINEAR);
        rotate_tween.animate("rotation", deg2rad(180));
        Starling.juggler.add(rotate_tween);
    }

    public function startTimer():void {

        updateProgressBar();

        rotate_tween = new Tween(this, 0.5, Transitions.LINEAR);
        rotate_tween.animate("rotation", deg2rad(360));
        rotate_tween.onComplete = startProgress;
        Starling.juggler.add(rotate_tween);

        glow_filter.alpha = 1;

        breath_out();
    }

    public function disableCard():void {
        TicTacToe.card.touchable = false;
    }

    public function breath_out():void {
        breath_tween = new Tween(glow_filter, 0.4, Transitions.LINEAR);
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

    public function startProgress():void {

        pb_tween = new Tween(progress_bar, 9, Transitions.LINEAR);
        pb_tween.animate("ratio", 0);
        pb_tween.onComplete = disableCard;
        Starling.juggler.add(pb_tween);
    }

    public function resetProgressBar():void {
        progress_bar.ratio = 0;
    }

    public function updateProgressBar():void {
        progress_bar.ratio = 1;
        progress_bar.filter = glow_filter;
        progress_bar.color = glow_filter.color = Color.YELLOW;
    }
}

}

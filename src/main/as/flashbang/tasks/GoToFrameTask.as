//
// Flashbang

package flashbang.tasks {

import flash.display.MovieClip;

import flashbang.GameObject;
import flashbang.ObjectTask;

public class GoToFrameTask extends MovieTask
{
    public function GoToFrameTask (frame :Object, scene :String = null,
        gotoAndPlay :Boolean = true, movie :MovieClip = null)
    {
        super(0, null, movie);
        _frame = frame;
        _scene = scene;
        _gotoAndPlay = gotoAndPlay;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (_gotoAndPlay) {
            getTarget(obj).gotoAndPlay(_frame, _scene);
        } else {
            getTarget(obj).gotoAndStop(_frame, _scene);
        }

        return true;
    }

    override public function clone () :ObjectTask
    {
        return new GoToFrameTask(_frame, _scene, _gotoAndPlay, _movie);
    }

    protected var _frame :Object;
    protected var _scene :String;
    protected var _gotoAndPlay :Boolean;
}

}

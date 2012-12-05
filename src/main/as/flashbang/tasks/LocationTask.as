//
// Flashbang

package flashbang.tasks {

import starling.display.DisplayObject;

import aspire.util.Preconditions;

import flashbang.GameObject;
import flashbang.ObjectTask;
import flashbang.components.LocationComponent;

public class LocationTask extends DisplayObjectTask
{
    public function LocationTask (x :Number, y :Number, time :Number = 0,
        easingFn :Function = null, disp :DisplayObject = null)
    {
        super(time, easingFn, disp);
        _toX = x;
        _toY = y;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _lc = getLocationTarget(obj);
            _fromX = _lc.x;
            _fromY = _lc.y;
        }

        _elapsedTime += dt;

        _lc.x = interpolate(_fromX, _toX);
        _lc.y = interpolate(_fromY, _toY);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new LocationTask(_toX, _toY, _totalTime, _easingFn, _display);
    }

    protected function getLocationTarget (obj :GameObject) :LocationComponent
    {
        var display :DisplayObject = super.getTarget(obj);
        if (display != null) {
            return new DisplayObjectWrapper(display);
        }
        var lc :LocationComponent = obj as LocationComponent;
        Preconditions.checkState(lc != null, "obj does not implement LocationComponent");
        return lc;
    }

    protected var _toX :Number;
    protected var _toY :Number;
    protected var _fromX :Number;
    protected var _fromY :Number;

    protected var _lc :LocationComponent;
}

}

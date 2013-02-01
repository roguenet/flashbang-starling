//
// flashbang

package flashbang.tasks {

import aspire.util.Preconditions;

import flashbang.components.LocationComponent;
import flashbang.core.GameObject;

import starling.display.DisplayObject;

public class YTask extends DisplayObjectTask
{
    public function YTask (y :Number, time :Number = 0, easingFn :Function = null,
        disp :DisplayObject = null) {
        super(time, easingFn, disp);
        _toY = y;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean {
        if (0 == _elapsedTime) {
            _lc = getLocationTarget(obj);
            _fromY = _lc.y;
        }

        _elapsedTime += dt;
        _lc.y = interpolate(_fromY, _toY);
        return (_elapsedTime >= _totalTime);
    }

    protected function getLocationTarget (obj :GameObject) :LocationComponent {
        var display :DisplayObject = super.getTarget(obj);
        if (display != null) {
            return new DisplayObjectWrapper(display);
        }
        var lc :LocationComponent = obj as LocationComponent;
        Preconditions.checkState(lc != null, "obj does not implement LocationComponent");
        return lc;
    }

    protected var _toY :Number;
    protected var _fromY :Number;

    protected var _lc :LocationComponent;
}
}


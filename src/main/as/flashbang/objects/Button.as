//
// flashbang

package flashbang.objects {

import flash.geom.Point;

import flashbang.components.Disableable;
import flashbang.input.Input;
import flashbang.input.PointerListener;
import flashbang.tasks.FunctionTask;
import flashbang.tasks.SerialTask;
import flashbang.tasks.TimedTask;

import react.Registration;
import react.UnitSignal;

import starling.display.Sprite;
import starling.events.Touch;

/**
 * A button base class. Abstract.
 */
public class Button extends SpriteObject
    implements Disableable
{
    /** Fired when the button is clicked */
    public const clicked :UnitSignal = new UnitSignal();

    public function Button (sprite :Sprite = null) {
        super(sprite);
    }

    public function get enabled () :Boolean {
        return (_state != DISABLED);
    }

    public function set enabled (val :Boolean) :void {
        if (val != this.enabled) {
            setState(val ? UP : DISABLED);
        }
    }

    /**
     * Simulates a click on the button. If it's not disabled, the button will fire the
     * clicked signal and show a short down-up animation.
     */
    public function click () :void {
        if (this.enabled) {
            this.clicked.emit();

            if (_state != DOWN) {
                addObject(new SerialTask(
                    new FunctionTask(function () :void { showState(DOWN); }),
                    new TimedTask(0.25),
                    new FunctionTask(function () :void { showState(_state); })));
            }
        }
    }

    /** Subclasses must override this to display the appropriate state */
    protected function showState (state :int) :void {
        throw new Error("abstract");
    }

    override protected function added () :void {
        showState(_state);

        this.hoverBegan.connect(onHoverBegan);
        this.hoverEnded.connect(onHoverEnded);
        this.touchBegan.connect(onTouchBegan);
    }

    protected function onHoverBegan () :void {
        if (_state != DISABLED) {
            this.pointerOver = true;
        }
    }

    protected function onHoverEnded () :void {
        if (_state != DISABLED) {
            this.pointerOver = false;
        }
    }

    protected function onTouchBegan () :void {
        if (this.enabled && _captureReg == null) {
            if (_pointerListener == null) {
                _pointerListener = Input.newPointerListener()
                    .onPointerMove(this.onPointerMove)
                    .onPointerEnd(this.onPointerEnd)
                    .build();
            }
            _captureReg = this.regs.add(this.mode.touchInput.registerListener(_pointerListener));
            _pointerDown = true;
            _pointerOver = true;
            updateState();
        }
    }

    protected function cancelCapture () :void {
        if (_captureReg != null) {
            _captureReg.close();
            _captureReg = null;
        }
    }

    protected function onPointerMove (touch :Touch) :void {
        this.pointerOver = hitTest(touch);
    }

    protected function onPointerEnd (touch :Touch) :void {
        _pointerDown = false;
        _pointerOver = hitTest(touch);
        updateState();
        cancelCapture();
        // emit the signal after doing everything else, because a signal handler could change
        // our state
        if (_pointerOver) {
            this.clicked.emit();
        }
    }

    protected function set pointerDown (val :Boolean) :void {
        if (_pointerDown != val) {
            _pointerDown = val;
            updateState();
        }
    }

    protected function set pointerOver (val :Boolean) :void {
        if (_pointerOver != val) {
            _pointerOver = val;
            updateState();
        }
    }

    protected function updateState () :void {
        if (_state == DISABLED) {
            return;
        }

        if (_pointerDown) {
            setState(_pointerOver ? DOWN : UP);
        } else {
            setState(_pointerOver ? OVER : UP);
        }
    }

    protected function setState (val :int) :void {
        if (_state != val) {
            _state = val;
            if (_state == DISABLED) {
                cancelCapture();
            }
            showState(_state);
        }
    }

    protected function hitTest (touch :Touch) :Boolean {
        P.setTo(touch.globalX, touch.globalY);
        return (_sprite.hitTest(_sprite.globalToLocal(P, P), true) != null);
    }

    protected var _state :int = 0;
    protected var _pointerOver :Boolean;
    protected var _pointerDown :Boolean;
    protected var _captureReg :Registration;
    protected var _pointerListener :PointerListener;

    protected static const UP :int = 0;
    protected static const DOWN :int = 1;
    protected static const OVER :int = 2;
    protected static const DISABLED :int = 3;

    protected static const P :Point = new Point();
}
}

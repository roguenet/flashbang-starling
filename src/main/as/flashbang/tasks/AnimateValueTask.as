//
// Flashbang - a framework for creating Flash games
// Copyright (C) 2008-2012 Three Rings Design, Inc., All Rights Reserved
// http://github.com/threerings/flashbang
//
// This library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library.  If not, see <http://www.gnu.org/licenses/>.

package flashbang.tasks {

import flashbang.Easing;
import flashbang.GameObject;
import flashbang.ObjectTask;
import flashbang.util.BoxedNumber;

public class AnimateValueTask extends InterpolatingTask
{
    public function AnimateValueTask (value :BoxedNumber, targetValue :Number, time :Number = 0,
        easingFn :Function = null)
    {
        super(time, easingFn);

        if (null == value) {
            throw new Error("value must be non null");
        }

        _to = targetValue;
        _value = value;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _from = _value.value;
        }

        _elapsedTime += dt;
        _value.value = interpolate(_from, _to);
        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new AnimateValueTask(_value, _to, _totalTime, _easingFn);
    }

    protected var _to :Number;
    protected var _from :Number;
    protected var _value :BoxedNumber;
}

}

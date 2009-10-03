// Whirled contrib library - tools for developing whirled games
// http://www.whirled.com/code/contrib/asdocs
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
//
// Copyright 2008 Three Rings Design
//
// $Id: RepeatingTask.as 6032 2008-10-07 01:48:02Z tim $

package com.whirled.contrib.simplegame.tasks {

import com.whirled.contrib.simplegame.ObjectTask;

public class RepeatingTask extends TaskContainer
{
    public function RepeatingTask (...subtasks)
    {
        super(TaskContainer.TYPE_REPEATING, subtasks);
    }
}

}

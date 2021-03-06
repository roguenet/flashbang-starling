//
// Flashbang

package flashbang.tasks {

import flashbang.core.ObjectTask;

/**
 * A Task that repeats.
 *
 * @param taskCreator a function that takes 0 parameters and returns an ObjectTask, or null.
 * When the RepeatingTask completes its task, it will call taskCreator to regenerate the task.
 * If taskCreator returns null, the RepeatingTask will complete; else it will keep running.
 */
public class RepeatingTask extends ObjectTask
{
    /** Creates a RepeatingTask that will call the taskCreator function 'count' times */
    public static function xTimes (count :int, taskCreator :Function) :RepeatingTask {
        return new RepeatingTask(function () :ObjectTask {
            return (count-- > 0 ? taskCreator() : null);
        });
    }

    public function RepeatingTask (taskCreator :Function) {
        _taskCreator = taskCreator;
    }

    override protected function added () :void {
        restart();
    }

    override protected function removed () :void {
        if (_curTask != null) {
            _curTask.destroySelf();
            _curTask = null;
        }
    }

    protected function restart () :void {
        if (!this.isLiveObject || !this.parent.isLiveObject) {
            return;
        }

        _curTask = _taskCreator();
        if (_curTask == null) {
            destroySelf();
            return;
        }
        this.regs.add(_curTask.destroyed.connect(restart));
        this.parent.addObject(_curTask);
    }

    protected var _taskCreator :Function;
    protected var _curTask :ObjectTask;
}

}

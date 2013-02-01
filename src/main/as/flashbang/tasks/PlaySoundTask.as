//
// Flashbang

package flashbang.tasks {

import flashbang.core.Flashbang;
import flashbang.core.GameObject;
import flashbang.core.ObjectTask;
import flashbang.audio.AudioChannel;
import flashbang.audio.AudioControls;

public class PlaySoundTask
    implements ObjectTask
{
    public function PlaySoundTask (soundName :String, waitForComplete :Boolean = false,
        parentControls :AudioControls = null) {
        _soundName = soundName;
        _waitForComplete = waitForComplete;
        _parentControls = parentControls;
    }

    public function update (dt :Number, obj :GameObject) :Boolean {
        if (null == _channel) {
            _channel = Flashbang.audio.playSoundNamed(_soundName, _parentControls);
        }

        return (!_waitForComplete || !_channel.isPlaying);
    }

    protected var _soundName :String;
    protected var _waitForComplete :Boolean;
    protected var _parentControls :AudioControls;
    protected var _channel :AudioChannel;
}

}

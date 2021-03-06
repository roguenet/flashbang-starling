//
// Flashbang

package flashbang.core {

import aspire.util.Preconditions;

import flashbang.audio.AudioManager;
import flashbang.resource.ResourceManager;

import starling.core.Starling;

public class Flashbang
{
    public static function get app () :FlashbangApp { return _app; }
    public static function get rsrcs () :ResourceManager { return _app._rsrcs; }
    public static function get audio () :AudioManager { return _app._audio; }
    public static function get starling () :Starling { return _app.starling; }
    public static function get stageWidth () :int { return _app.starling.stage.stageWidth; }
    public static function get stageHeight () :int { return _app.starling.stage.stageHeight; }

    public static function onFatalError (err :*) :void { _app.onFatalError(err); }

    internal static function registerApp (app :FlashbangApp) :void {
        Preconditions.checkState(_app == null, "A FlashbangApp has already been registered");
        _app = app;
    }

    internal static var _app :FlashbangApp;
}
}

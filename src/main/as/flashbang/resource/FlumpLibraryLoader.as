//
// flashbang

package flashbang.resource {

import flash.utils.ByteArray;

import aspire.util.ClassUtil;

import flump.display.Library;
import flump.display.LibraryLoader;
import flump.executor.Executor;
import flump.executor.Future;

public class FlumpLibraryLoader extends ResourceLoader
{
    /** The name of the Library (required) */
    public static const NAME :String = "name";

    /**
     * a String containing a URL to load the Library from OR
     * a ByteArray containing the Library OR
     * an [Embed]ed class containing the Library data
     * (required)
     */
    public static const DATA :String = "data";

    /**
     * A Boolean indicating if mipmaps should be generated for the flump textures loaded with
     * this loader. The default is false.
     */
    public static const MIPMAPS :String = "mipmaps";

    /**
     * An optional function parameter that will receive progress updates in the flump loading
     * process. The signature should be function (progress :flash.events.ProgressEvent) :void {}.
     * Will only receive updates for URL loads (when the data parameter is an URL instead of a
     * ByteArray).
     */
    public static const ON_PROGRESS :String = "onProgress";

    public function FlumpLibraryLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        _name = requireLoadParam(NAME, String);
        var data :Object = requireLoadParam(DATA, Object);
        if (data is Class) {
            var clazz :Class = Class(data);
            data = ByteArray(new clazz());
        }
        _mipmaps = getLoadParam(MIPMAPS, false) as Boolean;

        var loader :LibraryLoader = createLibraryLoader();
        loader.setExecutor(_exec = new Executor());

        var f :Future;
        if (data is ByteArray) {
            f = loader.loadBytes(ByteArray(data));

        } else if (data is String) {
            var progress :Function = getLoadParam(ON_PROGRESS);
            if (progress != null) {
                loader.urlLoadProgressed.connect(progress);
            }
            f = loader.loadURL(data as String);

        } else {
            throw new Error("Unrecognized Flump Library data source: '" +
                ClassUtil.tinyClassName(data) + "'");
        }

        f.succeeded.connect(libraryLoaded);
        f.failed.connect(fail);
    }

    protected function createLibraryLoader () :LibraryLoader {
        return new LibraryLoader().setGenerateMipMaps(_mipmaps);
    }

    protected function libraryLoaded (library :Library) :void {
        var resources :Vector.<Resource> = new <Resource>[];

        // create a (private) resource for the library itself
        resources.push(new LibraryResource(_name, library));

        // create individual resources for each symbol in the library
        for each (var movieName :String in library.movieSymbols) {
            resources.push(new MovieResource(library, _name, movieName));
        }
        for each (var imageName :String in library.imageSymbols) {
            resources.push(new ImageResource(library, _name, imageName));
        }

        succeed(resources);
    }

    override protected function onCanceled () :void {
        if (_exec != null) {
            _exec.shutdownNow();
            _exec = null;
        }
    }

    protected var _name :String;
    protected var _mipmaps :Boolean;
    protected var _exec :Executor;
}
}

import flump.display.Library;

import flashbang.resource.Resource;

class LibraryResource extends Resource {
    public function LibraryResource (name :String, lib :Library) {
        super(name);
        _lib = lib;
    }

    override protected function dispose () :void {
        _lib.dispose();
        _lib = null;
    }

    protected var _lib :Library;
}

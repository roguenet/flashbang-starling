//
// flashbang

package flashbang.resource {

import flashbang.loader.XmlLoader;

public class XmlResourceLoader extends ResourceLoader
{
    /** Load params */

    /** The name of the XML resource (required) */
    public static const NAME :String = "name";

    /**
     * a String containing a URL to load the XML from OR
     * a ByteArray containing the XML OR
     * an [Embed]ed class containing the XML
     * (required)
     */
    public static const DATA :String = "data";

    public function XmlResourceLoader (params :Object) {
        super(params);
    }

    override protected function doLoad () :void {
        var name :String = requireLoadParam(NAME, String);

        _loader = new XmlLoader(requireLoadParam(DATA, Object));
        _loader.load().onSuccess(function (result :XML) :void {
            succeed(new XmlResource(name, result));
        }).onFailure(fail);
    }

    override protected function onCanceled () :void {
        if (_loader != null) {
            _loader.close();
            _loader = null;
        }
    }

    protected var _loader :XmlLoader;
}
}

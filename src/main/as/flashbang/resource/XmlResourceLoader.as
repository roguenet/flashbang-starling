//
// flashbang

package flashbang.resource {

import aspire.util.ClassUtil;
import aspire.util.XmlUtil;

import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

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
        var data :Object = requireLoadParam(DATA, Object);
        if (data is Class) {
            var clazz :Class = Class(data);
            data = ByteArray(new clazz());
        }

        if (data is String) {
            loadFromURL(data as String);
        } else if (data is ByteArray) {
            var ba :ByteArray = ByteArray(data);
            onDataLoaded(ba.readUTFBytes(ba.length));
        } else {
            throw new Error("Unrecognized XML data source: '" +
                ClassUtil.tinyClassName(data) + "'");
        }
    }

    protected function loadFromURL (urlString :String) :void {
        _loader = new URLLoader();
        _loader.dataFormat = URLLoaderDataFormat.TEXT;
        _loader.addEventListener(Event.COMPLETE, function (..._) :void {
            var data :* = _loader.data;
            _loader.close();
            onDataLoaded(data);
        });

        _loader.addEventListener(IOErrorEvent.IO_ERROR, function (e :IOErrorEvent) :void {
            fail(new IOError(e.text, e.errorID));
        });

        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
            function (e :SecurityErrorEvent) :void {
                fail(new SecurityError(e.text, e.errorID));
            });

        _loader.load(new URLRequest(urlString));
    }

    protected function onDataLoaded (data :*) :void {
        // override the default XML settings, so we get the full text content
        var settings :Object = XML.defaultSettings();
        settings["ignoreWhitespace"] = false;
        settings["prettyPrinting"] = false;
        onXmlLoaded(XmlUtil.newXML(data, settings));
    }

    protected function onXmlLoaded (xml :XML) :void {
        succeed(new XmlResource(requireLoadParam(NAME, String), xml));
    }

    override protected function onLoadCanceled () :void {
        if (_loader != null) {
            try {
                _loader.close();
            } catch (e :Error) {
                // swallow
            }
            _loader = null;
        }
    }

    protected var _loader :URLLoader;
}
}
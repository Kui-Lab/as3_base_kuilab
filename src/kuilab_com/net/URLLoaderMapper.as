package kuilab_com.net
{
	import flash.net.URLLoader;
	import flash.utils.Dictionary;

	public class URLLoaderMapper
	{
		public function URLLoaderMapper()
		{
		}
		
		public static const MAP:* = new Dictionary( true ) ;
		
		public static function note( loader:URLLoader, url:* ):void
		{
			MAP[ loader ] = url ;
		}
		
		public static function seek( loader:URLLoader ):*
		{
			return MAP[ loader ] ;
		}
	}
}
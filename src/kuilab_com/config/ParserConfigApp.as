package kuilab_com.config
{
	import kuilab_com.util.Map_applicationDomain;
	import kuilab_com.util.Util_Xml;

	public class ParserConfigApp implements IParseCfgApp
	{
		public function ParserConfigApp()
		{
		}
		
		protected var keyInterface:Object = '' ;
		protected var keyClass:Object = '~' ;
		protected var keyPath:Object = 'path' ;
		/**
		 * <x interface >
		 * @param data
		 * 
		 */		
		public function set dataConfig( data:Object):void
		{
			if( data is XML )
			{}else if( data is String )
				data = XML( data ) ;
			for each( var n:XML in XML( data ).children() )
			{
				var itf:* = Util_Xml.getAttOrChild( n, keyInterface ) ;
				var imp:* = keyClass == '~' ? 
									n.toString()
									: Util_Xml.getAttOrChild( n, keyClass ) ;
				var pth:* = Util_Xml.getAttOrChild( n, keyPath ) ;
			}
			var domain:Map_applicationDomain 
			
		}
		
		public function getValue( key:Object, type:uint=uint.MAX_VALUE ):Object
		{
			return null;
		}
		
	}
}
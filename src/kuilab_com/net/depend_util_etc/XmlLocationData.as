package kuilab_com.net.depend_util_etc
{
	import flash.debugger.enterDebugger;
	import flash.utils.Dictionary;
	
	import kuilab_com.util.Util_Xml;

	public class XmlLocationData extends LocationData
	{
		public static const MAP_packageKeyObject:Object = new Dictionary( true ) ;//{ info:'the map to indexing the pakageName object' } ;
		
		public function XmlLocationData( doc:XML, packag:*=null )
		{
			super() ;
			this.doc = doc ;
			this.packag_ = packag ;
		}
		
		protected var doc:XML ;
		
		public override function get name():*
		{
			var ret:Object = Util_Xml.getAttOrChild( doc, 'key' ) ;
			if( ret == null )
				return null ;
			if( ret is XML )
				return ret.toString() ;
			return ret ;
		}
		
		public override function get packag():*
		{
			if( packag_ != null )//多数情况下，是检索时请求者提供的，隐含有口令的用意。
				return packag_ ;
				
			var ns:Namespace = doc.namespace( 'package' ) ;
			if( ns )
				return ns.uri ;
			var ret:Object = Util_Xml.getAttOrChild( doc, 'name' ) ;
			if( ret == null )
				return null ;
			if( ret is XML )
				return ret.toString() ;
			return ret ;
		}
		
		public override function get locP():*
		{
			var ret:Object = Util_Xml.getAttOrChild( doc, 'loc' ) ;
			if( ret == null )
				return null ;
			if( ret is XML )
				return ret.toString() ;
			return ret ;
		}
		
		public override function get udid():*
		{
			var ret:Object = Util_Xml.getAttOrChild( doc, 'udid' ) ;
			if( ret == null )
				return null ;
			if( ret is XML )
				return ret.toString() ;
			return ret ;
		}
		
		public override function get url():*
		{
			var ret:Object = Util_Xml.getAttOrChild( doc, 'url' ) ;
			if( ret == null )
				return null ;
			if( ret is XML )
				return ret.toString() ;
			return ret ;
		}
	}
}
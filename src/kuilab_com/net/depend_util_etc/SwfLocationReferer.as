package kuilab_com.net.depend_util_etc
{
	import kuilab_com.util.Util_Vector;
	
	public class SwfLocationReferer implements ILocationRefer
	{
		/*ILocationRefer不应当在RTL内部，因为有可能获取的地址是网络地址。
		不应当在SrvGetAsset实现逻辑，违反职责单一原则。
		但是如何对应swf与ILocationRefer？*/
		
		public function SwfLocationReferer()
		{
		}
		
		/**
		 * 对于以[Embed]嵌入swf的资源，是以类的形式存在的，而类名称不能带有斜杠。于是制作时都用下划线替换了斜杠。
		 */		
		protected var hyphen:String = '_' ;
		
		public function refer( tar:Object, packagee:Object ):Object
		{
			var ret:* ;
			if( Util_Vector.isVectorOrArray( tar ) ){
				ret = Array( tar ).join( hyphen ) ;
			}
			if( ret is String ){//给出的可能是混杂着斜杠的字符串数组，所以再处理一次。
				ret = convertSpt( ret ) ;
			}
			return ret;
		}
		
		protected function convertSpt( src:String ):String
		{
			if( src.indexOf( '/' ) != -1 )
				src = src.split( '/' ).join( hyphen ) ;
			if( src.indexOf( '\\' ) != -1 )
				src = src.split( '\\' ).join( hyphen ) ;
			return src ;
		}
	}
}
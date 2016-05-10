package kuilab_com.util
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	use namespace flash_proxy ;

	public class Map_fixkey extends Proxy
	{
		public function Map_fixkey()
		{
			super();
		}
		
		protected var map:Object = Dictionary ;
		
		public function set vFuncFixKey( v:Array ):void
		{
			
		}
		
		flash_proxy override function getProperty(name:*):*
		{
			 return 
		}
		
	}
}
function t1( key:Object ):Object
{
	if( key is String )
	if( ( key as String ).charAt( 0 ) == 'J' )
		return ( key as String ).substr( 1 ) ;
	return null ;
}
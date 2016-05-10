package kuilab_com.util
{
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	public class Util_timer
	{
		public function Util_timer()
		{
		}
		
		public static function setTimeout( f:Function, delay:uint, thisObj:Object=null, ...paramaters ):uint
		{
			var id:uint = flash.utils.setTimeout( timeout, delay ) ;
			function timeout():void
			{
				clearInterval( id ) ;
				if( paramaters.length == 0 )
					paramaters = null ;
				( f as Function ).apply( thisObj, paramaters ) ;
			}
			return id ;
		}

	}
}
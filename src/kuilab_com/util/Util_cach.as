package kuilab_com.util
{
	import flash.utils.Dictionary;

	public class Util_cach
	{
		public static const ALREADY_EXIST:Object = new AlreadyExist ;
		
		public function Util_cach()
		{
		}
		
		protected var map:Dictionary = new Dictionary( true ) ;
		
		/*public function store( key:Object, value:Object, overrideOrReturnException:Boolean=true ):*{
			map[ key ] = value ;
		}*/
		public function storeWithOverride( key:Object, value:Object ):*{
			map[ key ] = value ;
		}
		public function storeIfNull( key:Object, value ):*{
			if( map.hasOwnProperty( key ) )
				return ALREADY_EXIST ;
			map[ key ] = value ;
		}
		public function remove( key:* ):*{
			delete map[ key ] ;
		}
		public function exist( key:* ):Boolean{
			return map.hasOwnProperty( key ) ;
		}
		
		public function obtain( key:Object ):*{
			return map[ key ] ;
		}
	}
}
class AlreadyExist{}
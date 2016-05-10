package kuilab_com.lang
{
	public class Util_lang
	{
		public function Util_lang()
		{
		}
		
		public static function getGlobal():Object
		{
			return function():*{
				return this ;
			}() ;
		}
		
		//protected static var primitiveTypes:Array = [ Number, Boolean ] ;
	}
}
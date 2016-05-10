package kuilab_com.util
{
	public class Util_Number
	{
		public function Util_Number()
		{
		}
		
		public static function bitEqual( a:int, b:uint ):Boolean
		{
			return ( a^b ) == 0 ;
		}
	}
}
package kuilab_com.util
{
	public class Util_color
	{
		public static const REDD:uint = 0xFF0000;
		public static const GREN:uint = 0xFF00;
		public static const BLUE:uint = 0XFF ;
		
		public function Util_color()
		{
		}
		/**底片/反相效果**/
		public static function negative( color:uint ):uint
		{
			return  ~( color  ) ;
		}
			
	}
}
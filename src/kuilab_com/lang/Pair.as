package kuilab_com.lang
{
	/**
	 * 如果不喜欢用QName可以用这个类。
	 */	
	public class Pair
	{
		public function Pair( prop1:*, prop2:*=null )
		{
			this.prop1 = prop1 ;
			this.prop2 = prop2 ;
		}
		
		public var prop1:* ;
		public var prop2:* ;
		
		public function toString():String
		{
			return 'kuilab.com[as3]Pair ['+prop1+','+prop2+']' ;
		}
	}
}
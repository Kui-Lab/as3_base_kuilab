package kuilab_com.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Format
	{
		public function Format()
		{
		}
		
		public static function preferredHeightWithLine( n:uint = 1, tf:TextField=null, textFormat:TextFormat=null ):int
		{//%%改成用单行乘以行数？
			if( tf == null )
				tf = new TextField ;
			tf.defaultTextFormat = textFormat ;
			var str:String = '?' ;
			while( n-- )
			{
				str += '\n?' ;
			}
			tf.text = str ;
			return tf.textHeight ;
		}
		//public static function pre
	}
}
package kuilab_com.util
{
	public class Util_RegExp
	{
		/**
		 * @param str
		 * @param wholeWord 整个字符，如果设置为false将匹配包含这个字符串的词。<br/>也可以自己在字符首尾加“^”或“$”达到同样效果，但此时再使用这个参数就冲突了。
		 * @param keepBackSlash 保持“\”不变，也就是阻止“\n”这类字符进行转义。
		 * @return 
		 */		
		public static function createIgnoreCase( str:String, wholeWord:Boolean, keepBackSlash:Boolean=false ):RegExp
		{
			if( keepBackSlash )
				str = str.replace( '\\', '\\\\' ) ; 
			if( wholeWord ){
				str = '^{?}$'.replace( '{?}', str ) ;
			}else{
			}
			return new RegExp( str, 'i' ) ;
		}
	}
}
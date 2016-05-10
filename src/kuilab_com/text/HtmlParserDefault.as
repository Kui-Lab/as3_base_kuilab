package kuilab_com.text
{
	public class HtmlParserDefault extends HtmlParser
	{
		public function HtmlParserDefault()
		{
			super();
			mapTag_[ 'pre' ] = function( node:XML, str:String ):String
			{
				str = str.split( '\r\n' ).join( '\n' ) ;
				str = str.split( '\t' ).join( '    ' ) ;
				return str ;
			}
		}
	}
}
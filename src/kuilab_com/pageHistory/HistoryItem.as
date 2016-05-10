package kuilab_com.pageHistory
{
	import kuilab_com.KuilabERROR;
	import kuilab_com.util.Util_Vector;

	/**
	 * 改叫HistoryNote?HistoryNoteItem
	 */
	public class HistoryItem
	{
		public function HistoryItem( uri:*, label:* )
		{
			if( ! validate( uri ) )
				throw new Error( '第一个参数 '+KuilabERROR.argsIncorrect( 10 ) ) ;
			if( ! validate( label ) )
				throw new Error( '第二个参数'+KuilabERROR.argsIncorrect( 10 ) ) ;
			this.label = label ;
			this.uri = uri ;
		}
		
		public var label:*
		public var uri:*
			
		public function get title():*
		{
			if( Util_Vector.isEmpty( label ) )
				return '无标题文档/页面\nA doc or page without title' ;
			return Util_Vector.last( label ) ;
		}
		
		public function get pathRump():*{
			return Util_Vector.last( uri ) ;
		}
		
		protected function validate( tar:* ):Boolean
		{
			if( Util_Vector.isVectorOrArray( tar ) )
			{
				for each( var item:* in tar ){
					if( item == null )
						return false ;
				}
				return true ;
			}//其它类型未做检验。
			return true ;
		}
		
		public function equal( other:HistoryItem, ignoreLable:Boolean=false ):Boolean
		{
			if( ( other.label is Array ) && ( label is Array ) )
			{}else return false ;
			if( ( other.uri is Array ) && ( uri is Array ) )
			{}else return false ;
			if( Util_Vector.compare( other.uri, uri ) )
			{}else
				return false ;
			if( !ignoreLable ){
				if( Util_Vector.compare( other.label, label ) )
				{}else return false ;
			}
			return true ;
		}
			
	}
}
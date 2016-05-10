package kuilab_com
{
	import kuilab_com.util.Util_String;

	public class KuilabERROR
	{
		/**
		 * @param type <pre>
		 * null:'方法未实现。'
		 * 1:写入访问器未实现（字段是只读的）。
		 * 2: '逻辑未实现。'
		 * 3:'抽象方法未被具象（子类）类实现。' ;
		 */		
		public static function methodDoesNotImplement( type:*=null ):String{
			if( type == 1 )
				return '写入访问器未实现（字段是只读的）。' ;
			if( type == 2 )
				return '逻辑未实现。' ;
			if( type ==3 )
				return '抽象方法未被具象（子类）类实现。' ;
			if( type == 4 )
				return '禁止调用的方法。' ;
			return '方法未实现。' ;
		}
		
		public static function mapBindStringOnly():String
		{
			return '对不起，目前只支持以字符串为键进行绑定' ;
		}
		
		public static function recyclePool( type:uint=0 ):String
		{
			
			return '' ;
		}
		
		/**
		 * 
		 * @param detail
		 * 1:不接受的参数类型。
		 * 5:索引超出范围。
		 * 如果是其它类型则直接输出其内容。
		 * 10:参数的具体内容不能正常使用。
		 * 15:参数的类型正确，但值不合理。
		 * @return 
		 */		
		public static function argsIncorrect( detail:*=null ):String
		{
			var ret:String = '参数使用不正确。' ;
			if( detail == 1 )
				detail = '不接受的参数类型。' ;
			if( detail == 5 )
				detail = '索引超出范围。';
			if( detail == 10 )
				detail = '参数的具体内容不能正常使用。' ;
			if( detail == 15 )
				detail = '参数的类型正确，但值不合理。' ;
			if( Util_String.isEmptyStrOrNull( detail ) )
				return ret ;
			return [ ret, detail ].join( ':' ) ;
		}
		
		public static function valueDoNotBeNull( detal:String=null ):String
		{
			return '值不能为空' ;
		}
		
		public static function swfSetupFail( ):String
		{
			return 'swf文件没有正常解析（通常应为AVM漏洞）。'
		}
		
		public static function programingLogicMistak( detail:Object=null ):String
		{
			var ret:String = '程序内部逻辑错误。' ;
			if( detail == null )
				return ret ;
			return [ ret, '（', detail ,'）' ].join( '' ) ;
		}
		/**
		 * @param detail 1:没有正确初始化或输入数据
		 * @return 
		 */		
		public static function unableWork( detail:* = null ):String
		{
			var ret:String = '对象无法正常工作。' ;
			if( detail == 1 )
				ret += '没有正确初始化或输入数据。' ;
			else if( Util_String.isEmptyStrOrNull( detail ) )
				return ret ;
			return [ ret, detail ].join( ':' ) ;
		}
		
		public static function seeDocs( detail:* = '' ):String
		{
			var ret:String = '发生了错误，相关的说明请查看文档。' ;
			if( Util_String.isNotEmptyOrNull( detail ) )
				ret = ret+'(信息：{?})'.replace( '{?}', detail ) ;
			return ret ;
		}
	}
}
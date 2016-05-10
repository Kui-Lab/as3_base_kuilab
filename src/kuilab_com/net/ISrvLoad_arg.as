package kuilab_com.net
{
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	/**
	 * as3不支持接口中定义常量，所以要另外写类定义接口参数常量。
	 * @author kui。
	 */
	public class ISrvLoad_arg
	{
		
		public static const ARG_null:ISrvLoad_arg = new ISrvLoad_arg ;
		
		/**
		 * 将发给侦听函数的原生事件用EventBoost封装。
		 */		
		/*public static function addARG_wrapEvent( value:Boolean, addToArgObj:ISrvLoad_arg=null ):ISrvLoad_arg
		{
			if( addToArgObj == null )
				addToArgObj = new ISrvLoad_arg ;
			addToArgObj[ ARG_wrapEvent ] = value ;
			return addToArgObj ;
		}	
			public static const ARG_wrapEvent:Object = 'kuilab_com.net.ISrvLoad::load() 将原生事件用EventBoost封装#P2IihXRL' ;*/
		public function setWrapEvent( value:Boolean ):ISrvLoad_arg
		{
			wrapEvent = value ;
			return this ;
		}
			public var wrapEvent:Boolean = false ;
				
				
		/*public static function addARG_timeout( seconds:int, addToArgObj:ISrvLoad_arg=null ):ISrvLoad_arg
		{
			if( addToArgObj == null )
				addToArgObj = new ISrvLoad_arg ;
			addToArgObj[ ARG_timeout ] = seconds ;
			return addToArgObj ;
		}
		public static const ARG_timeout:Object = 'kuilab_com.net.ISrvLoad::load() 超时错误' ;*/
		public function setTimeout( seconds:int ):ISrvLoad_arg
		{
			timeoutSecd = seconds
			return this ;
		}
			public var timeoutSecd:uint = uint.MAX_VALUE ;
				
				
		/*public static function addARG_context( context:LoaderContext, addToArgObj:ISrvLoad_arg=null ):ISrvLoad_arg
		{
			if( addToArgObj == null )
				addToArgObj = new ISrvLoad_arg ;
			addToArgObj[ ARG_context ] = context ;
			return addToArgObj ;
		}
			public static const ARG_context:Object = 'kuilab_com.net.ISrvLoad::load() LoaderContext参数' ;*/
		public function setContext( context:LoaderContext ):ISrvLoad_arg
		{
			this.context = context ;
			return this ;
		}
		public var context:LoaderContext ;
		
		
		public function setSolveBug():ISrvLoad_arg
		{
			solveBug = true ;
			return this ;
		}
		public var solveBug:Boolean = false ;
		
		
		public static function doNew():ISrvLoad_arg
		{
			return new ISrvLoad_arg ;
		}
			
		function ISrvLoad_arg( )
		{
			//super( false ) ;
		}
		
	}
}
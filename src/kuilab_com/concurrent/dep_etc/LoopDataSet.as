package kuilab_com.concurrent.dep_etc
{
	import kuilab_com.concurrent.DaemonLoop;
	import kuilab_com.nameSpaceKuilab;

	/**
	 * 作为添加子级循环体的方法参数之一，这个类用来描述嵌套的子级循环体从上级获取数据的手段。
	 */	
	public class LoopDataSet
	{
		/**
		 * 
		 * @param propPathOrGainFunc 
		 * @see kuilab_com.concurrent.DaemonLoop#reset() DaemonLoop#reset
		 */
		public function LoopDataSet( propPathOrGainFunc:* )
		{
			super( ) ;
			this.propPathOrGainFunc_ = propPathOrGainFunc ;
		}
		
		protected var propPathOrGainFunc_:* ;
		
		//nameSpaceKuilab var loopBody:DaemonLoop ;

		public function get propPathOrGainFunc():*
		{
			return propPathOrGainFunc_;
		}

		public function set propPathOrGainFunc(value:*):void
		{
			propPathOrGainFunc_ = value;
		}

	}
}
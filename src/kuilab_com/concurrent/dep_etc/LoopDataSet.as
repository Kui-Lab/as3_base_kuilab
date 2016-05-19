package kuilab_com.concurrent.dep_etc
{

	/**<pre>
	 * 作为添加子级循环体的方法参数之一，这个类用来描述嵌套的子级循环体从上级获取数据的手段。
	 * 子级每次执行完毕（从开始到最后一次的迭代），也就是上级每一次迭代，下级都会reset()。
	 * reset时会从上级更新自己的数据集，具体其实是从上级的LoopProps来获取。
	 * 即：<ul>
	 * <li>如果LoopDataSet的参数是个类，将会在每次重置时被调用，实参是上级的LoopProps，它应当返回一个对象，
	 * 		当前（子级）循环体会用这个对象作为数据集来。
	 * <li>如果LoopDataSet的参数是个数组或字符串，将会从上级的LoopProps上以这个参数为成员名路径来取得数据集。
	 * 		实际是调用Util_object/getPropByPath。
	 * </ul>
	 * </pre>
	 * @see kuilab_com.concurrent.DaemonLoop#reset() 具体逻辑见DaemonLoop#reset的代码。
	 * @see kuilab_com.util.Util_object#getPropByPath() Util_object#getPropByPath()。
	 */	
	public class LoopDataSet
	{
		/**
		 * 
		 * @param propPathOrGainFunc 
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
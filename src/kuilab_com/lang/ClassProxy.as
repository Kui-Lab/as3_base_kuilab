package kuilab_com.lang
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/**
	 * 未实现，要用AOP才能实现。
	 * @author kui.
	 */
	public dynamic class ClassProxy extends Proxy
	{
		public function ClassProxy()
		{
		}
		
		protected var principal:Class ;
		
		flash_proxy override function callProperty(name:*, ...parameters):*
		{
			
		}
	}
}
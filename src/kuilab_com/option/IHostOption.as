package kuilab_com.option
{
	public interface IHostOption
	{
		/**
		 * 添加委托人。
		 */
		function clientAdd( client:IClientOption ):void
		
		/**
		 * 移除委托人。 
		 */
		function clientRem( client:IClientOption ):void
	}
}
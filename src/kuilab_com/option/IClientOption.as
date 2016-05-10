package kuilab_com.option
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 在程序运行时，某些组件或其它对象被设计成根据选项来改变自己行为或状态的机制。
	 * 让组件实现此接口，并且被注册到管理者（IHostOption）实例上来实现此机制。
	 * 它们被称作“委托人”。
	 * @author Skull.
	 */
	public interface IClientOption
	{
		
		/**
		 * 管理者通过调用此方法通知委托对象更新。
		 * @param arg
		 */
		function onOptionUpdate( ...arg ):void
		
		/**
		 * 管理者通过调用此访问器获知委托人关心哪些选项。
		 */
		function get vNameOption():Array
		
				
		/**
		 * 调用此方法通知管理者自己要释放或有其它事务。
		 */
		function set fNotifyHost( v:Function ):void
	}
}
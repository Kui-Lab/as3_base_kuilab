package kuilab_com.message
{
	/**
	 * 目前没有再开发使用。
	 * @author kui.
	 */
	public interface IMessageSend
	{
		/**
		 * 发送消息。
		 */
		function send( message:Message ):void ;
		
		/**
		 * 添加侦听器。
		 * @param listener 作为侦听器的函数。
		 * @param priority 优先级，数字越大越优先。
		 * 但默认的实现中，为了提高程序效率，实际上当目前已经有N个侦听器的情况下，新加的侦听器优先级只要大于N，都会被当作N+1。
		 * @param once 消息发送一次之后自动移除这个侦听器。
		 */
		function listenerAdd( type:String, listener:Function, priority:uint =0, once:Boolean =false ):void ;
		
		/**
		 * 移除侦听器。
		 * @param listener
		 * @param once
		 */
		function listenerRem( type:String, listener:Function, once:Boolean =false ):void ;
		
		/**
		 * 检查某个函数是否在侦听自己。
		 * 注意：在AS3语言中，假设A函数调用B函数，通过B函数的arguments.callee得到的A函数引用与直接获取的A函数引用不是同一个对象。
		 * 		这种情况下使用此方法会失效。
		 * @param listener 用来做侦听器的函数。
		 * @return 默认的实现情况是：
		 * 如果有此侦听器，返回的数大于0。
		 * 如果此侦听器是一次性的，返回2，不是一次性的返回1。
		 * 如果两者都有返回。
		 */
		function listenerCheck( listener:Function ):uint
	}
}
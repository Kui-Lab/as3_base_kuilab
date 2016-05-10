package kuilab_com.event
{
	/**
	 * 在#-{@see kuilab_com.util.Map_bindable}和#-{@see kuilab_com.util.Map_enhanced}中使用。
	 * %%应改将data参数放在第一个。
	 * @author kui.
	 */
	public class EventUpdate extends EventBoost
	{
		public static const TYPE:String = '::.update'
		private static var EventUpdate_TYPE
		
		public function EventUpdate( type:String=TYPE, data:Object=null, oldValue:*=undefined, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, data, bubbles, cancelable );
			this.oldValue = oldValue ;
		}
		
		public var oldValue:* ;
		
	}
}